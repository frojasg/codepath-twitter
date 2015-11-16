//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/6/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"


@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (instancetype) sharedInstance;

- (void) loginWithCompletion:(void (^) (User *user, NSError *error)) completation;
- (void) openURL: (NSURL *) url;

- (void) homeTimelineWithParams:(NSDictionary*) params completion:(void (^)(NSArray *tweets, NSError *error)) completation;
- (void) userTimelineWithParams:(NSDictionary*) params completion:(void (^)(NSArray *tweets, NSError *error)) completation;
- (void) tweetWithParams: (NSDictionary*) params completion: (void (^) (Tweet *tweet, NSError * error)) completation;
- (void) retweetWithId: (NSString*) tweetId completion: (void (^) (Tweet *tweet, NSError * error)) completation;
- (void) likeWithId: (NSString*) tweetId completion: (void (^) (Tweet *tweet, NSError * error)) completation;
- (void) unretweetWithId: (NSString*) tweetId completion: (void (^) (Tweet *tweet, NSError * error)) completation;
- (void) unlikeWithId: (NSString*) tweetId completion: (void (^) (Tweet *tweet, NSError * error)) completation;
@end
