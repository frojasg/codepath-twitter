//
//  HamburgerViewController.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/13/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "HamburgerViewController.h"

@interface HamburgerViewController ()
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;
@property (assign, nonatomic) float originalLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;
@end

@implementation HamburgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Setters

- (void) setMenuViewController:(UIViewController *)menuViewController {
    _menuViewController = menuViewController;
    [self.view layoutIfNeeded];
    [self.menuView addSubview:menuViewController.view];
}

- (void) setContentViewController:(UIViewController *)contentViewController {
    [self.view layoutIfNeeded];

    if (_contentViewController) {
        [_contentViewController willMoveToParentViewController:nil];
        [_contentViewController.view removeFromSuperview];
        [_contentViewController didMoveToParentViewController:nil];
    }

    [self.contentViewController willMoveToParentViewController:self];
    [self.contentView addSubview:contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];

    [UIView animateWithDuration:0.3 animations:^{
        self.leftMarginConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}


#pragma mark Actions

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];

    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalLeftMargin = self.leftMarginConstraint.constant;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.leftMarginConstraint.constant = self.originalLeftMargin + translation.x;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            if (velocity.x > 0) {
                self.leftMarginConstraint.constant = self.view.frame.size.width - 100;
            } else {
                self.leftMarginConstraint.constant = 0;
            }
            [self.view layoutIfNeeded];
        }];

    }
}


@end
