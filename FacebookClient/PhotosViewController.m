//
//  PhotosViewController.m
//  FacebookClient
//
//  Created by Igor on 17.02.17.
//  Copyright © 2017 Igor. All rights reserved.
//

//#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>

#import "PhotosViewController.h"
#import "PhotosTableViewCell.h"
#import "PhotoViewController.h"

@interface PhotosViewController ()

@end

@implementation PhotosViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil albumID:(NSString *)albumID bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.albumID = albumID;
    
    return self;
}
    

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *strPathForAlbumID = [NSString stringWithFormat:@"/%@/photos",self.albumID];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:strPathForAlbumID
                                  parameters:@{@"fields": @"id, picture, name, created_time"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        self.photosData = [result valueForKey:@"data"];
        
        self.photosDataOffline = [NSMutableArray array];
        
        [self.tableView reloadData];
        
        //saving to cash
        for (int i=0; i<[self.photosData count]; i++)
        {
            NSURL *photoURL = [NSURL URLWithString:[self.photosData[i] objectForKey:@"picture"]];
            UIImage *photoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
        
            //saving image to file
        
            NSData *pngData = UIImagePNGRepresentation(photoImage);
        
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
            NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.png", self.albumID, i]]; //Add the file name
            [pngData writeToFile:filePath atomically:YES]; //Write the file
                           
            NSString *name = [[self.photosData objectAtIndex:i] valueForKey:@"name"];
            NSString *date = [[self.photosData objectAtIndex:i] valueForKey:@"created_time"];
            
            NSDictionary *photoData = @{
                                        @"name" : (name!=nil) ? name : @"",
                                        @"date" : (date!=nil) ? date : @"",
                                        };

            [self.photosDataOffline addObject:photoData];
        }
        
        // pointer to standart user defaults
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject :self.photosDataOffline forKey:[NSString stringWithFormat:@"photos%@", self.albumID]];
        
        // do not forget to save changes
        [defaults synchronize];
    }];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.photosData)
        return [self.photosData count];
    else
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        self.photosDataOffline = [defaults objectForKey:[NSString stringWithFormat: @"photos%@", self.albumID]];
        
        return [self.photosDataOffline count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    return 100;
        
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        NSString *cellIdentifier = @"PhotosTableViewCell";
        
        PhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Add this line in your code
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PhotosTableViewCell" owner:self options:nil]objectAtIndex:0];
        
        if (!cell)
        {
            cell = [[PhotosTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        //cell.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",(long)indexPath.row+1]];
        
        NSString *stringDate;
        
        if (self.photosData)
        {
            stringDate = [[self.photosData objectAtIndex:indexPath.row] valueForKey:@"created_time"];
            
            cell.nameLabel.text = [[self.photosData objectAtIndex:indexPath.row] valueForKey:@"name"];
            cell.dateLabel.text = stringDate;
            NSString *pathToPicture = [[self.photosData objectAtIndex:indexPath.row] valueForKey:@"picture"];
            NSURL *pictureURL = [NSURL URLWithString:pathToPicture];
            NSData *pictureData = [NSData dataWithContentsOfURL:pictureURL];
        
            [cell.picture setImage:[UIImage imageWithData:pictureData] forState:UIControlStateNormal];
        }
        else
        {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            self.photosDataOffline = [defaults objectForKey:[NSString stringWithFormat: @"photos%@", self.albumID]];
                
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%ld.png", self.albumID, (long)indexPath.row]];
                
            NSData *pngData = [NSData dataWithContentsOfFile:imagePath];
            UIImage *image = [UIImage imageWithData:pngData];
            
            stringDate = [self.photosDataOffline[indexPath.row] valueForKey:@"date"];
            
            cell.nameLabel.text = [self.photosDataOffline[indexPath.row] valueForKey:@"name"];
            cell.dateLabel.text = stringDate;
            [cell.picture setImage:image forState:UIControlStateNormal];
            
        }
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        NSDate *date = [dateFormat dateFromString:stringDate];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        stringDate = [dateFormat stringFromDate:date];
        cell.dateLabel.text = stringDate;
        
        
        
        return cell;
        
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoViewController *photoViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" photoID:[[self.photosData objectAtIndex:indexPath.row] valueForKey:@"id"]  bundle:nil];
    [self.navigationController pushViewController:photoViewController animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
