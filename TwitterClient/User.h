//
//  User.h
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/6/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSNumber *tweetCount;
@property (nonatomic, strong) NSNumber *followersCount;
@property (nonatomic, strong) NSNumber *followingCount;
@property (nonatomic, strong) NSURL *coverImageUrl;
@property (nonatomic, strong) NSURL *url;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (void) setCurrentUser: (User*) currentUser;
+ (User *) currentUser;
+ (void) logout;

//- (NSString) 

@end
