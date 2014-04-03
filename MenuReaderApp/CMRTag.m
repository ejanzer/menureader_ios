//
//  CMRTag.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRTag.h"

@implementation CMRTag

-(id)initWithData:(NSDictionary *)data {
    self.name = [data objectForKey:@"name"];
    self.count = [data objectForKey:@"count"];
    self.idNumber = [data objectForKey:@"id"];
    return self;
}

@end
