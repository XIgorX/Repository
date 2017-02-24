//
//  PhotosViewController.h
//  FacebookClient
//
//  Created by Igor on 17.02.17.
//  Copyright © 2017 Igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosViewController : UIViewController
    
@property (strong, nonatomic) IBOutlet UITableView *tableView;
   
@property (retain, nonatomic) NSString *albumID;
@property (retain, nonatomic) NSArray *photosData;

@property (retain, nonatomic) NSMutableArray *photosDataOffline;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil albumID:(NSString *)albumID bundle:(NSBundle *)nibBundleOrNil;

@end
