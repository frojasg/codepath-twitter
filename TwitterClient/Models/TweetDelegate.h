//
//  TweetDelegate.h
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/8/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@protocol TweetDelegate <NSObject>
- (void) retweetTweet: (Tweet *) tweet;
- (void) likeTweet: (Tweet *) tweet;
- (void) replyTweet: (Tweet *) tweet;
- (void) unretweetTweet: (Tweet *) tweet;
- (void) unlikeTweet: (Tweet *) tweet;

@end

