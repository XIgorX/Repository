//
//  AlbumsTableViewCell.m
//  FacebookClient
//
//  Created by Igor on 17.02.17.
//  Copyright © 2017 Igor. All rights reserved.
//

#import "AlbumsTableViewCell.h"

@implementation AlbumsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.picture.layer.cornerRadius = self.picture.frame.size.width / 2;
    self.picture.clipsToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
