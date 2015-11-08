//
//  Tweet.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/6/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.tweetId = dict[@"id"];
        self.text = dict[@"text"];
        self.user = [[User alloc] initWithDictionary:dict[@"user"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString: dict[@"created_at"]];
    }
    return self;
}

+ (NSArray *) tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];

    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

- (NSString *)since {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.createdAt];

    if ( interval < 60 ) {
        return [[NSString alloc] initWithFormat:@"%0.fs", interval];
    } else if (interval < 60 * 60) {
        return [[NSString alloc] initWithFormat:@"%0.fm", interval/60.0];
    } else if ( interval < 60 * 60 * 24) {
        return [[NSString alloc] initWithFormat:@"%0.fh", interval/(60.0 * 60.0)];
    } else {
        return [[NSString alloc] initWithFormat:@"%0.fd", interval/(60.0 * 60.0 * 24)];
    }
}

@end
