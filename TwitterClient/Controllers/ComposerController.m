//
//  ComposerController.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/7/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "ComposerController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"

@interface ComposerController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIImageView *closeImageView;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) Tweet *tweet;
@end

@implementation ComposerController

- (id) initWithTweet: (Tweet*) tweet {
    self = [super init];
    if (self) {
        self.tweet = tweet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClose:)];
    singleTap.numberOfTapsRequired = 1;

    [self.closeImageView setUserInteractionEnabled:YES];
    [self.closeImageView addGestureRecognizer:singleTap];
    [self.inputTextField becomeFirstResponder];
    [self.profileImageView setImageWithURL: [User currentUser].profileImageUrl];
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;

    self.inputTextField.placeholder = @"What's happening?";

    if (self.tweet) {
        self.inputTextField.text =[[NSString alloc] initWithFormat:@"%@ ", self.tweet.user.screenname];
    }

    self.tweetButton.layer.cornerRadius = 5;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];

    self.bottomConstraint.constant = keyboardFrameBeginRect.size.height;
    [self.view layoutIfNeeded];
}
- (IBAction)onChange:(id)sender {
    self.limitLabel.text = [[NSString alloc] initWithFormat:@"%ld", 140 - self.inputTextField.text.length];
    if (self.inputTextField.text.length < 130) {
        self.limitLabel.textColor = [UIColor colorWithRed:204/255.0f green:214/255.0f blue:221/255.0f alpha:1];
    } else if(self.inputTextField.text.length < 140) {
        self.limitLabel.textColor = [UIColor colorWithRed:255/255.0f green:204/255.0f blue:0/255.0f alpha:1];
    } else {
        self.limitLabel.textColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    }
}

- (IBAction)onTweet:(id)sender {
    NSLog(@"on Tweet");
    if (self.tweet) {
        [[TwitterClient sharedInstance] tweetWithParams:@{@"status": self.inputTextField.text, @"in_reply_to_status_id": self.tweet.tweetId} completion:^(Tweet *tweet, NSError *error) {
            [self onClose:self];
        }];
    } else {
        [[TwitterClient sharedInstance] tweetWithParams:@{@"status": self.inputTextField.text} completion:^(Tweet *tweet, NSError *error) {
            [self onClose:self];
        }];
    }
}
- (IBAction)onClose:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
