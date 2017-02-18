//
//  PhotosTableViewCell.h
//  FacebookClient
//
//  Created by Igor on 17.02.17.
//  Copyright © 2017 Igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosTableViewCell : UITableViewCell
    
@property (strong, nonatomic) IBOutlet UIButton *picture;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
