//
//  LoginViewController.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/6/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "LoginViewController.h"
#import "TweetsViewController.h"
#import "HamburgerViewController.h"
#import "MenuViewController.h"
#import "TwitterClient.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *twitter =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    twitter.image=[UIImage imageNamed:@"twitter"];
    self.navigationItem.titleView = twitter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)onLogin:(id)sender {

    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user) {
            NSLog(@"Welcome User: %@", user.name);
            HamburgerViewController *hamburgerViewController = [[HamburgerViewController alloc] init];
            MenuViewController *menuViewController = [[MenuViewController alloc] init];
            menuViewController.hamburgerViewController = hamburgerViewController;
            hamburgerViewController.menuViewController = menuViewController;

            [self presentViewController:hamburgerViewController animated:YES completion:nil];
        } else {
            // present error view
        }
    }];
}

@end
