//
//  MainViewController.m
//  Social_App
//
//  Copyright (c) 2015 Guang. All rights reserved.

    //->The SLComposeServiceViewController class provides a standard compose view you can present for social sharing extensions on both platforms.
    //->The SLComposeSheetConfigurationItem class helps you give users ways to configure the properties of a post before posting it.

#import "MainViewController.h"
#import "FABUserTimelineViewController.h"

@interface MainViewController ()

@end

//Need to set permission for FaceBook by .readPermission mehtod.
@implementation MainViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self loginNormal];
    //twitter logIn
    [self tweetData];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdated:) name:FBSDKProfileDidChangeNotification object:nil];
    //FBloginButton.readPermissions = @[@"public_profile", @"email", @"user_friends", @"user_likes"];
    [self.collectionViewController registerNib:[UINib nibWithNibName:@"FBCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
}


-(void)loginNormal{
    
    if ([FBSDKAccessToken currentAccessToken]) {
        self.userString = [[FBSDKAccessToken currentAccessToken] userID];
        self.faceName.text = [NSString stringWithFormat:@"Hi %@ ?",[FBSDKProfile currentProfile].name];
        self.faceName.textColor = [UIColor grayColor];
        
    } else {
        
        FBSDKLoginButton *FBloginButton = [[FBSDKLoginButton alloc] init];
        FBloginButton.delegate = self;
        FBloginButton.center = CGPointMake(self.view.frame.size.width/4, self.view.frame.size.height/2 + FBloginButton.frame.size.height);
        [self.view addSubview:FBloginButton];
    }
    
}


-(void)profileUpdated:(NSNotification *) notification{
    NSLog(@"User name: %@",[FBSDKProfile currentProfile].name);
    NSLog(@"User ID: %@",[FBSDKProfile currentProfile].userID);
    self.faceName.text = [NSString stringWithFormat:@"Hi %@ ?",[FBSDKProfile currentProfile].name];
    self.faceName.textColor = [UIColor grayColor];
}

- (void)FBloginButton:(FBSDKLoginButton *)FBloginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
}
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)FBloginButton{
}



- (IBAction)faceBookLog:(id)sender {
    NSLog(@"pressed ");
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController * fbsheetOBJ = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
        [fbsheetOBJ setInitialText:@"TurnToTech-NYC"];
        //[fbsheetOBJ addURL:[NSURL URLWithString:@"http://turntotech.io"]];
        [fbsheetOBJ addImage:[UIImage imageNamed:@"face.jpg"]];
        [self presentViewController:fbsheetOBJ animated:YES completion:Nil];
    }
}

/*
- (IBAction)twitterLog:(id)sender {

    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheetOBJ setInitialText:@"TurnToTech_Tweet"];
        [tweetSheetOBJ addURL:[NSURL URLWithString:@"http://turntotech.io"]];
        [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
        
    }
}



}
  */

- (IBAction)getSomeData:(id)sender {
    [self friendRequest];

}

-(void)friendRequest{
   //http://graph.facebook.com/id/picture?type=large
    //Request for portfile picture.
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id resultM, NSError *error) {
             if (!error) {
                 //NSLog(@"fetched user:%@", resultM);
                 self.userString = [resultM objectForKey:@"id"];
                 self.myInspired = [resultM objectForKey:@"inspirational_people"];;
                 NSLog(@" result 2 = %@", self.userString);
                 //NSLog(@" inspirational_people = %@", self.myInspired);
                 
                 NSString * path =  [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",self.userString];
                 //NSString * path = @"http://graph.facebook.com/10152707186505976/picture?type=large";
                 
                 NSURL *url = [NSURL URLWithString:path];
                 NSData *data = [NSData dataWithContentsOfURL:url];
                 self.myImage.image = [UIImage imageWithData:data];
                 NSLog(@" inspirated people are here ====== %@", [self.myInspired[3] objectForKey:@"name"]);
                 [self.collectionViewController reloadData];
             }
         }];
    }
}

-(void)tweetData{
    
    TWTRLogInButton *TWlogInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        //load user
        if (session){
            //NSLog(@"Twitter signed in as %@", [session userName]);
            
            self.twitterName.text = [NSString stringWithFormat:@"Hi, %@",[session userName]];
            self.tweetID = [session userID];
            
        }else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
        //load profile image
        [[[Twitter sharedInstance] APIClient] loadUserWithID:session.userID completion:^(TWTRUser *user, NSError *error) {
            
            //NSLog(@"User image %@", user.profileImageURL);
            self.twitterImage.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:user.profileImageLargeURL]]];
        }];
    }];
    
    TWlogInButton.frame = CGRectMake(self.view.frame.size.width - 190, self.view.frame.size.height/2,190,TWlogInButton.frame.size.height);
    [self.view addSubview:TWlogInButton];
    
}


- (IBAction)getTweet:(id)sender {
    // load tweet

    [TwitterKit logInGuestWithCompletion:^(TWTRGuestSession *session, NSError *error) {
        if (session) {
            // Loading public Tweets do not require user auth
            //[[[Twitter sharedInstance] APIClient] loadUserWithID:session.userID completion:^(TWTRUser *user, NSError *error) {
            
            
            [[[Twitter sharedInstance] APIClient]   loadTweetWithID:@"587810102922637312" completion:^(TWTRTweet *tweet, NSError *error) {
                if (tweet) {
                    //self.tweetView = [[TWTRTweetView alloc] initWithTweet:tweet];
                    //[self.tweetView configureWithTweet:tweet];
                    
                    TWTRTweetView *tweetViewTW = [[TWTRTweetView alloc]initWithTweet:tweet];
                    tweetViewTW.delegate = self;
                    tweetViewTW.frame = CGRectMake(60, 550, 280, 90);
                    [TWTRTweetView appearance].linkTextColor = [UIColor redColor];
                    [self.view addSubview:tweetViewTW];
                    
                    NSLog(@"tweetView == %@", tweet.text);
                } else {
                    NSLog(@"Failed to load tweet: %@", [error localizedDescription]);
                }
            }];
        } else {
            NSLog(@"Unable to log in as guest: %@", [error localizedDescription]);
        }
    }];
    

    /*
     
     TWTRTweet *tweet = [[TWTRTweet alloc] initWithJSONDictionary:dictionary];
     
     // Create an array of tweet model objects from a JSON array
     NSArray *tweets = [TWTRTweet tweetsWithJSONArray:array];
     */

}

-(void)tweetView:(TWTRTweetView *)tweetView didTapURL:(NSURL *)url{
    UIViewController *webViewController = [[UIViewController alloc] init];
    UIWebView * webview = [[UIWebView alloc] initWithFrame:webViewController.view.bounds];
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
    webViewController.view = webview;
    [self.navigationController pushViewController:webViewController animated:YES];
}



//CollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.myInspired.count;
}

-(FBCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FBCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    //this method for collectionView,No need to init any objects for an array!
    //adding movie names
    
    cell.cellContent.text = [NSString stringWithFormat:@">%@", [self.myInspired[indexPath.row] objectForKey:@"name"]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
