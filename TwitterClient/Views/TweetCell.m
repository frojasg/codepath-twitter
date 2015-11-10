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
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIView *retweetView;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (assign, nonatomic) BOOL retweeted;
@property (assign, nonatomic) BOOL liked;
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

    self.retweetCountLabel.text = [[NSString alloc] initWithFormat:@"%ld", [tweet.retweeted integerValue]];
    self.retweeted = tweet.didIRetweeted;

    self.retweetCountLabel.hidden = [tweet.retweeted integerValue] <= 0;
    self.likeCountLabel.text = [[NSString alloc] initWithFormat:@"%ld", [tweet.likes integerValue]];
    self.liked = tweet.didILikeIt;
    self.likeCountLabel.hidden = [tweet.likes integerValue] <= 0;

    if (tweet.didIRetweeted) {
        self.retweetImageView.image = [UIImage imageNamed:@"retweeted"];
    } else {
        self.retweetImageView.image = [UIImage imageNamed:@"retweet"];
    }

    if (tweet.didILikeIt) {
        self.likeImageView.image = [UIImage imageNamed:@"liked"];
    } else {
        self.likeImageView.image = [UIImage imageNamed:@"like"];
    }

    if (tweet.retweetedBy) {
        self.topConstraint.constant = 30;
        self.retweetView.hidden = NO;
        self.retweetLabel.text = [[NSString alloc] initWithFormat:@"%@ Retweeted", tweet.retweetedBy.name];
    } else {
        self.topConstraint.constant = 5;
        self.retweetView.hidden = YES;
    }
}

#pragma mark - Actions
- (IBAction)onRetweet:(id)sender {
    if (self.retweeted) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.retweetImageView.image = [UIImage imageNamed:@"retweet"];
            self.retweetCountLabel.hidden = ([self.retweetCountLabel.text integerValue] - 1) <= 0;
            self.retweetCountLabel.text = [[NSString alloc] initWithFormat:@"%ld", ([self.retweetCountLabel.text integerValue] - 1)];
        } completion:nil];
        [self.delegator unretweet:self];
    } else {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.retweetImageView.image = [UIImage imageNamed:@"retweeted"];
            self.retweetCountLabel.hidden = FALSE;
            self.retweetCountLabel.text = [[NSString alloc] initWithFormat:@"%ld", ([self.retweetCountLabel.text integerValue] + 1)];
        } completion:nil];
        [self.delegator retweet:self];
    }
    self.retweeted = !self.retweeted;
}

- (IBAction)onReply:(id)sender {
    [self.delegator reply:self];
}

- (IBAction)onLike:(id)sender {
    if (self.liked) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.likeImageView.image = [UIImage imageNamed:@"like"];
            self.likeCountLabel.hidden = ([self.likeCountLabel.text integerValue] - 1) <= 0;
            self.likeCountLabel.text = [[NSString alloc] initWithFormat:@"%ld", ([self.likeCountLabel.text integerValue] - 1)];
        } completion:nil];

        [self.delegator unlike:self];
    } else {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.likeImageView.image = [UIImage imageNamed:@"liked"];
            self.likeCountLabel.hidden = ([self.likeCountLabel.text integerValue] + 1) <= 0;
            self.likeCountLabel.text = [[NSString alloc] initWithFormat:@"%ld", ([self.likeCountLabel.text integerValue] + 1)];
        } completion:nil];

        [self.delegator like:self];
    }
    self.liked = !self.liked;
}

@end
