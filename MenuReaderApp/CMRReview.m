//
//  CMRReview.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRReview.h"

@interface CMRReview()

@end

@implementation CMRReview

-(id)initWithData:(NSDictionary *)data {
    self.text = data[@"text"];
    self.username = [data objectForKey:@"username"];
    self.date = [data objectForKey:@"date"];
    self.restaurant = [data objectForKey:@"restaurant"];
    return self;
}

@end
