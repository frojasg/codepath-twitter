//
//  TweetCell.h
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/7/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void) retweet: (TweetCell *) cell;
- (void) unretweet: (TweetCell *) cell;
- (void) like: (TweetCell *) cell;
- (void) unlike: (TweetCell *) cell;
- (void) reply: (TweetCell *) cell;

@end


@interface TweetCell : UITableViewCell

@property (weak, nonatomic) id<TweetCellDelegate> delegator;
-(void) setTweet:(Tweet*) tweet;

@end
