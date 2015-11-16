//
//  User.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/6/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.screenname = dict[@"screen_name"];

        if (dict[@"profile_banner_url"]) {
            self.coverImageUrl = [NSURL URLWithString:dict[@"profile_banner_url"]];
        } else {
            self.coverImageUrl = [NSURL URLWithString:dict[@"profile_background_image_url"]];
        }
        self.profileImageUrl = [NSURL URLWithString: dict[@"profile_image_url"]];
        self.tagline = dict[@"description"];
        self.tweetCount = dict[@"statuses_count"];
        self.followersCount = dict[@"followers_count"];
        self.followingCount = dict[@"friends_count"];
        self.dictionary = dict;
    }
    return self;
}

static User * _currentUser = nil;
NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (User *) currentUser {
    if (_currentUser == nil) {
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void) setCurrentUser: (User*) currentUser {
    _currentUser = currentUser;

    if (_currentUser) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (void)logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];

    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

- (NSString*) screenname {
    return [NSString stringWithFormat:@"@%@", _screenname];
}




@end
