//
//  User.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/6/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.screenname = dict[@"screen_name"];
        self.profileImageUrl = dict[@"profile_image_url"];
        self.tagline = dict[@"description"];
    }
    return self;
}
@end
