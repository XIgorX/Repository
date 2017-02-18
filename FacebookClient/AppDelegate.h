//
//  AppDelegate.h
//  FacebookClient
//
//  Created by Igor on 16.02.17.
//  Copyright © 2017 Igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LoginViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
    
@property (strong, nonatomic) LoginViewController *viewController;
@property (strong, nonatomic) UINavigationController *nav;
    
- (void)saveContext;


@end

