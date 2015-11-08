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

@interface ComposerController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIImageView *closeImageView;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation ComposerController

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

    NSLog(@"x: %f y: %f height %f", keyboardFrameBeginRect.origin.x, keyboardFrameBeginRect.origin.y, keyboardFrameBeginRect.size.height);
    self.bottomConstraint.constant = keyboardFrameBeginRect.size.height;
    [self.view layoutIfNeeded];
}

- (IBAction)onTweet:(id)sender {
    NSLog(@"on Tweet");
}
- (IBAction)onClose:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
