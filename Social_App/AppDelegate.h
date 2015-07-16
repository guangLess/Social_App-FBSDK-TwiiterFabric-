//
//  AppDelegate.h
//  Social_App
//
//  Created by Aditya Narayan on 4/7/15.
//  Copyright (c) 2015 Guang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>




@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) MainViewController *viewController;

@property (strong, nonatomic) UIWindow *window;


@end

