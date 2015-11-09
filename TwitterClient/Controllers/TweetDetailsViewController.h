//
//  ReplyViewController.h
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/8/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetDelegate.h"


@interface TweetDetailsViewController : UIViewController

@property (weak, nonatomic) id<TweetDelegate> delegator;

- (id) initWithTweet: (Tweet*) tweet;


@end
