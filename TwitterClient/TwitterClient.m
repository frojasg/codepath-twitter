//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/6/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"pwOlUNz9EkdFwIIrHdseNfQlb";
NSString * const kTwitterConsumerSecret = @"0wEVEFumwQMruGWLdx9iK2yzL6rv6q6ma6cApo7WFwmCRn47wG";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient ()

@property (nonatomic, strong) void (^loginCompletation) (User *user, NSError *error);

@end

@implementation TwitterClient

// Singleton
+ (instancetype)sharedInstance {
    static TwitterClient *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL: [NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}

- (void) loginWithCompletion:(void (^) (User *user, NSError *error)) completation {
    self.loginCompletation = completation;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"frojasg-twitter://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Yey!");
        NSURL *authURL = [NSURL URLWithString: [NSString stringWithFormat: @"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        self.loginCompletation(nil, error);
        NSLog(@"Error");
    }];
}

- (void) openURL: (NSURL *) url {

    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString: url.query] success:^(BDBOAuth1Credential *accessToken) {

        NSLog(@" Got the Acess token %@", accessToken.token);
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user %@", user.name);
            self.loginCompletation(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
            NSLog(@"failed getting current user");
            self.loginCompletation(nil, error);
        }];
    } failure:^(NSError * error) {
        NSLog(@"Error");
    }];
}

- (void) homeTimelineWithParams:(NSDictionary*) params completion:(void (^)(NSArray *tweets, NSError *error)) completation {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completation(tweets, nil);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completation(nil, error);
    }];
}

@end
