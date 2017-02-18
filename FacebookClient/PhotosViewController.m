//
//  PhotosViewController.m
//  FacebookClient
//
//  Created by Igor on 17.02.17.
//  Copyright © 2017 Igor. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKAccessToken.h>
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
        
        [self.tableView reloadData];
        
    }];
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
    return [self.photosData count];
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
        cell.nameLabel.text = [[self.photosData objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.dateLabel.text = [[self.photosData objectAtIndex:indexPath.row] valueForKey:@"created_time"];
        
        NSString *pathToPicture = [[self.photosData objectAtIndex:indexPath.row] valueForKey:@"picture"];
        NSURL *pictureURL = [NSURL URLWithString:pathToPicture];
        NSData *pictureData = [NSData dataWithContentsOfURL:pictureURL];
        
        [cell.picture setImage:[UIImage imageWithData:pictureData] forState:UIControlStateNormal];
        
        return cell;
        
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoViewController *partitionViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
    [self.navigationController pushViewController:partitionViewController animated:YES];
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
