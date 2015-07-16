.facebook user login -> FBSDK graph api getting data

.twitter Fabric frameworks guest login -> twitter APIClient with tweetID

.populate UICollectionView with facebook graph api data.

<img src="./images/iOS Simulator Screen Shot Jul 15, 2015, 2.18.48 PM.png" width="290"> <img src="./images/iOS Simulator Screen Shot Jul 15, 2015, 2.17.02 PM.png" width="290">

//FBSDK block to get data-> 
````
-(void)friendRequest{
    //Request for portfile picture from /graph.facebook
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id resultM, NSError *error) {
             if (!error) {
                 //NSLog(@"fetched user:%@", resultM);
                 self.userString = [resultM objectForKey:@"id"];
                 self.myInspired = [resultM objectForKey:@"inspirational_people"];
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

````
//populate the collectionView
````

-(FBCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FBCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.cellContent.text = [NSString stringWithFormat:@">%@", [self.myInspired[indexPath.row] objectForKey:@"name"]];
    return cell;
}
````
//twiiter api 
````
 [TwitterKit logInGuestWithCompletion:^(TWTRGuestSession *session, NSError *error) {
        if (session) {
            // Loading public Tweets do not require user auth
            [[[Twitter sharedInstance] APIClient]   loadTweetWithID:@"587810102922637312" completion:^(TWTRTweet *tweet, NSError *error) {
                if (tweet) {
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
````







