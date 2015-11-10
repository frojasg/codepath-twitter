//
//  Tweet.h
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/6/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Tweet* responseTo;
@property (nonatomic, strong) NSNumber *retweeted;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, assign) BOOL didILikeIt;
@property (nonatomic, assign) BOOL didIRetweeted;
@property (nonatomic, strong) User* retweetedBy;
@property (nonatomic, strong) NSString* retweetedIn;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (NSArray *) tweetsWithArray: (NSArray *) array;

- (NSString *) since;

@end
