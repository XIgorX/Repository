//
//  AlbumsViewController.h
//  FacebookClient
//
//  Created by Igor on 17.02.17.
//  Copyright © 2017 Igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumsViewController : UIViewController
    
@property (strong, nonatomic) IBOutlet UITableView *tableView;
    
@property (retain, nonatomic) NSArray *albumsData;
@property (retain, nonatomic) NSMutableArray *coverPaths;

@property (retain, nonatomic) NSMutableArray *albumsOffline;

@end
