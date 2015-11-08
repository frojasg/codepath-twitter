//
//  TweetCell.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/7/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "TweetCell.h"

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
}



@end
