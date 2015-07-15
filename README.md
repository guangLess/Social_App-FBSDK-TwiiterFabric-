-facebook user login
-FBSDK graph api getting data

-Twitter Fabric frameworks guest login
-Twitter APIClient with tweetID

-Populate UICollectionView with facebook data.


FBSDK login to get access of the "like" data, however it is called @"inspirational_people" for graph.facebook api. 
Get the path to access user's data. (User needs to authorize the APP)

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

Twiiter log in (easier documentation)

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

//getting the tweet as logInGuest. loginGuest does not require authorization.

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
    
