//
//  CMRReview.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRReview.h"

@interface CMRReview()

@property (copy, readwrite) NSString *text;
@property (copy, readwrite) NSString *restaurant;
@property (copy, readwrite) NSString *username;
@property (copy, readwrite) NSString *date;

@end

@implementation CMRReview

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        self.text = dictionary[@"text"];
        self.username = dictionary[@"username"];
        self.date = dictionary[@"date"];
        self.restaurant = dictionary[@"restaurant"];
    }
    
    return self;
}

-(instancetype)initWithUsername:(NSString *)username text:(NSString *)text restaurant:(NSString *)restaurant date:(NSString *)date {
    if (self = [self init]) {
        self.username = username;
        self.text = text;
        self.restaurant = restaurant;
        self.date = date;
    }
    return self;
}

@end
