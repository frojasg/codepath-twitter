//
//  ProfileViewController.h
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/14/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) User *user;
@property (assign, nonatomic) BOOL showMenuItem;


@end
