//
//  FABUserTimelineViewController.m
//  Social_App
//
//  Created by Aditya Narayan on 4/15/15.
//  Copyright (c) 2015 Guang. All rights reserved.
//

#import "FABUserTimelineViewController.h"

@interface FABUserTimelineViewController ()

@end

@implementation FABUserTimelineViewController

- (instancetype)init {
    TWTRAPIClient *APIClient = [[Twitter sharedInstance] APIClient];
    TWTRUserTimelineDataSource *userTimelineDataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:@"fabric" APIClient:APIClient];
    return [super initWithDataSource:userTimelineDataSource];
}

@end
