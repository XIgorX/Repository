//
//  PhotoViewController.h
//  FacebookClient
//
//  Created by Igor on 17.02.17.
//  Copyright © 2017 Igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *photo;

@property (retain, nonatomic) NSString *photoID;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil photoID:(NSString *)photoID bundle:(NSBundle *)nibBundleOrNil;

- (IBAction)buttonPhoto_Click:(id)sender;

@end
