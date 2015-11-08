//
//  TweetCell.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/7/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *tweetImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@end

@implementation TweetCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) setTweet:(Tweet*) tweet {
    self.tweetImageView.image = nil;
    [self.tweetImageView setImageWithURL: tweet.user.profileImageUrl];
    self.tweetImageView.layer.cornerRadius = 5;
    self.tweetImageView.clipsToBounds = YES;
    self.userNameLabel.text = tweet.user.name;
    self.screennameLabel.text = tweet.user.screenname;
    self.tweetLabel.text = tweet.text;
    self.sinceLabel.text = tweet.since;
}

@end
