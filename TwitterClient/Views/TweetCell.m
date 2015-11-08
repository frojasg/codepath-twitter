//
//  TweetCell.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/7/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "Tweet.h"

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *tweetImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@end

@implementation TweetCell

- (void)awakeFromNib {
    UITapGestureRecognizer *replayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onReply:)];
    replayTap.numberOfTapsRequired = 1;

    [self.replyImageView setUserInteractionEnabled:YES];
    [self.replyImageView addGestureRecognizer:replayTap];

    UITapGestureRecognizer *retweetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRetweet:)];
    retweetTap.numberOfTapsRequired = 1;

    [self.retweetImageView setUserInteractionEnabled:YES];
    [self.retweetImageView addGestureRecognizer:retweetTap];

    UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLike:)];
    likeTap.numberOfTapsRequired = 1;

    [self.likeImageView setUserInteractionEnabled:YES];
    [self.likeImageView addGestureRecognizer:likeTap];
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

#pragma mark - Actions
- (IBAction)onRetweet:(id)sender {
    NSLog(@"on retweet");
    [self.delegator retweet:self];
}

- (IBAction)onReply:(id)sender {
    NSLog(@"on reply");
    [self.delegator reply:self];
}

- (IBAction)onLike:(id)sender {
    NSLog(@"on like");
    [self.delegator like:self];
}

@end
