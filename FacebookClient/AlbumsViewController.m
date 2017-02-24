//
//  AlbumsViewController.m
//  FacebookClient
//
//  Created by Igor on 17.02.17.
//  Copyright © 2017 Igor. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
//#import <FBSDKLoginKit/FBSDKLoginManager.h>

#import "AlbumsViewController.h"
#import "AlbumsTableViewCell.h"
#import "PhotosViewController.h"

@interface AlbumsViewController ()

@end

@implementation AlbumsViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    //[loginManager logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends", @"user_photos"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    
     //{
    
         [[[FBSDKGraphRequest alloc]
           initWithGraphPath:@"me/albums"
           parameters: @{@"fields": @"id, name, cover_photo"}
           HTTPMethod:@"GET"]
          startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
              if (!error) {
                  
                  //  NSLog("%@",result);
                  
                  self.albumsData = [result valueForKey:@"data"];
                  self.coverPaths = [NSMutableArray array];
                  
                  self.albumsOffline = [NSMutableArray array];
                  
                  for (int i=0; i<[self.albumsData count]; i++)
                  {
                      [self.coverPaths addObject:@""];
                      
                      NSString *coverid = [NSString stringWithFormat:@"%@?fields=source",[[[self.albumsData objectAtIndex:i] valueForKey:@"cover_photo"] valueForKey: @"id"]];
                      
                      [[[FBSDKGraphRequest alloc]
                        initWithGraphPath:coverid
                        parameters: nil
                        HTTPMethod:@"GET"]
                       startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                           if (!error) {
                               
                               self.coverPaths[i] = [result valueForKey:@"source"];
                               
                               //[self.tableView reloadData];
                               
                               //saving to cash
                               
                               NSURL *coverURL = [NSURL URLWithString:self.coverPaths[i]];
                               UIImage *coverImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:coverURL]];
                               
                               //saving image to file
                               
                               NSData *pngData = UIImagePNGRepresentation(coverImage);
                               
                               NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                               NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
                               NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",i]]; //Add the file name
                               [pngData writeToFile:filePath atomically:YES]; //Write the file
                               
                               NSDictionary *album = @{
                                                          @"id" : [[self.albumsData objectAtIndex:i] valueForKey:@"name"],                                                   @"label" : [[self.albumsData objectAtIndex:i] valueForKey:@"name"],
                                                       };
                               
                               [self.albumsOffline addObject:album];
                               
                               // pointer to standart user defaults
                               NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

                               [defaults setObject :self.albumsOffline forKey:@"albums"];
                               
                               // do not forget to save changes
                               [defaults synchronize];
                           }
                           
                       }];
                  }
                  
              }
              
          }];
    
        [self.tableView reloadData];
    //}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
//table delegate methods
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}
    
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.albumsData)
        return [self.albumsData count];
    else
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        self.albumsOffline = [defaults objectForKey:@"albums"];
        
        return [self.albumsOffline count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"AlbumsTableViewCell";
        
    AlbumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    // Add this line in your code
    cell = [[[NSBundle mainBundle]loadNibNamed:@"AlbumsTableViewCell" owner:self options:nil]objectAtIndex:0];
        
    if (!cell)
    {
        cell = [[AlbumsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    if (self.albumsData)
    {
        cell.label.text = [[self.albumsData objectAtIndex:indexPath.row] valueForKey:@"name"];
    
        NSURL *coverURL = [NSURL URLWithString:self.coverPaths[indexPath.row]];
        [cell.picture setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:coverURL]]];
    }
    else
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        self.albumsOffline = [defaults objectForKey:@"albums"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.png",indexPath.row]];
        
        NSData *pngData = [NSData dataWithContentsOfFile:imagePath];
        UIImage *image = [UIImage imageWithData:pngData];
        
        cell.label.text = [self.albumsOffline[indexPath.row] valueForKey:@"label"];
        cell.picture.image = image;
        
    }
    
    
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.albumsData)
    {
        PhotosViewController *photosViewController = [[PhotosViewController alloc] initWithNibName:@"PhotosViewController" albumID:[[self.albumsData         objectAtIndex:indexPath.row] valueForKey:@"id"] bundle:nil];
        [self.navigationController pushViewController:photosViewController animated:YES];
    }
    else
    {
        PhotosViewController *photosViewController = [[PhotosViewController alloc] initWithNibName:@"PhotosViewController" albumID:[[self.albumsOffline         objectAtIndex:indexPath.row] valueForKey:@"id"] bundle:nil];
        [self.navigationController pushViewController:photosViewController animated:YES];
    }
    
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
