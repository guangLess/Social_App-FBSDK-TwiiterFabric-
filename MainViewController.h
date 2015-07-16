//
//  MainViewController.h
//  Social_App
//
//  Created by Aditya Narayan on 4/7/15.
//  Copyright (c) 2015 Guang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>
//#import <TWTRTweetTableViewCell.h>
//#import <TWTRTweet.h>

#import "FBCell.h"

@interface MainViewController : UIViewController <FBSDKLoginButtonDelegate,FBSDKGraphRequestConnectionDelegate,UICollectionViewDataSource, TWTRTweetViewDelegate>

- (IBAction)getSomeData:(id)sender;
//- (IBAction)twitterLog:(id)sender;
- (IBAction)faceBookLog:(id)sender;
- (IBAction)getTweet:(id)sender;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewController;
@property (strong, nonatomic) IBOutlet UIImageView *myImage;
@property (strong, nonatomic) IBOutlet UILabel *faceName;
@property (strong, nonatomic) IBOutlet UILabel *twitterName;
@property (strong, nonatomic) IBOutlet UIImageView *twitterImage;
//@property (weak, nonatomic) IBOutlet UIView *tweetView;
@property (strong, nonatomic) IBOutlet UILabel *tweetView;

@property (nonatomic, strong, readonly) TWTRUser * tweetauthor;
//@property (strong, nonatomic) IBOutlet UIView *tweetView2;


//@property (nonatomic, strong) TWTRTweetView *tweetView;
@property (strong, nonatomic) NSString * userString;
@property (strong, nonatomic) NSString * myMovies;
@property (strong, nonatomic) NSArray * myInspired;
@property (strong, nonatomic) NSString * tweetID;




@end
