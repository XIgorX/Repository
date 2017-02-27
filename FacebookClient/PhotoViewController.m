//
//  PhotoViewController.m
//  FacebookClient
//
//  Created by Igor on 17.02.17.
//  Copyright © 2017 Igor. All rights reserved.
//

//#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <FBSDKShareKit/FBSDKShareButton.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKHashtag.h>


#import "PhotoViewController.h"
#import "MapViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil photoID:(NSString *)photoID bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.photoID = photoID;
    
    return self;
}

- (IBAction)buttonPhoto_Click:(id)sender
{
    MapViewController *partitionViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" photoID:self.photoID bundle:nil];
    [self.navigationController pushViewController:partitionViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:self.photoID
                                  parameters:@{@"fields": @"picture"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        NSString *pathToPicture = [result valueForKey:@"picture"];
        NSURL *pictureURL = [NSURL URLWithString:pathToPicture];
        NSData *pictureData = [NSData dataWithContentsOfURL:pictureURL];

        [self.photo setImage:[UIImage imageWithData:pictureData]];
        //self.photoURL = pictureURL;
        
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.imageURL = pictureURL;
        content.hashtag = [FBSDKHashtag hashtagWithString:@"#TestingMyApp"];
        
        FBSDKShareButton *shareButton = [[FBSDKShareButton alloc] init];
        shareButton.shareContent = content;
        shareButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 50);
        //shareButton.center.y = self.view.center.y;
        [self.view addSubview:shareButton];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
