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
        NSDictionary* tweet;
        if (dict[@"retweeted_status"]) {
            tweet = dict[@"retweeted_status"];
            self.retweetedIn = dict[@"id"];
            self.retweetedBy = [[User alloc] initWithDictionary:dict[@"user"]];
        } else {
            tweet = dict;
        }
        self.tweetId = tweet[@"id"];
        self.text = tweet[@"text"];
        self.likes = tweet[@"favorite_count"];
        self.retweeted = tweet[@"retweet_count"];
        self.user = [[User alloc] initWithDictionary:tweet[@"user"]];
        self.didILikeIt = [tweet[@"favorited"] integerValue] > 0;
        self.didIRetweeted = [tweet[@"retweeted"] integerValue] > 0;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString: tweet[@"created_at"]];
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
