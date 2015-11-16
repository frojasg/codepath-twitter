//
//  MenuViewController.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/14/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MenuViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MenuViewController ()
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIViewController *timeline;
@property (strong, nonatomic) UIViewController *profile;
@property (strong, nonatomic) UIViewController *mentions;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.timeline = [[UINavigationController alloc] initWithRootViewController: [[TweetsViewController alloc] init]];

    TweetsViewController *mentions = [[TweetsViewController alloc] init];
    mentions.showMentions = YES;
    self.mentions =[[UINavigationController alloc] initWithRootViewController: mentions];

    ProfileViewController *profileView = [[ProfileViewController alloc] init];

    [profileView setUser:[User currentUser]];
    profileView.showMenuItem = YES;
    self.profile = [[UINavigationController alloc] initWithRootViewController:profileView];

    [self.profileImageView setImageWithURL:[User currentUser].profileImageUrl];
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
    UITapGestureRecognizer *homeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHome:)];
    homeTap.numberOfTapsRequired = 1;
    [self.profileImageView setUserInteractionEnabled:YES];
    [self.profileImageView addGestureRecognizer:homeTap];
}

- (void)viewWillAppear:(BOOL)animated {
    self.hamburgerViewController.contentViewController = self.timeline;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Actions

- (IBAction)onHome:(id)sender {
    self.hamburgerViewController.contentViewController = self.timeline;
}

- (IBAction)onProfile:(id)sender {
    self.hamburgerViewController.contentViewController = self.profile;
}
- (IBAction)onMentions:(id)sender {
    self.hamburgerViewController.contentViewController = self.mentions;
}
- (IBAction)onLogout:(id)sender {
    [User logout];
}


@end
