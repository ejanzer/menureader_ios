//
//  CMRTag.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRTag.h"

@interface CMRTag()

@property (copy, readwrite) NSString *name;
@property (copy, readwrite) NSString *count;
@property (copy, readwrite) NSNumber *idNumber;

@end
@implementation CMRTag

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        self.name = [dictionary objectForKey:@"name"];
        self.count = [dictionary objectForKey:@"count"];
        self.idNumber = [dictionary objectForKey:@"id"];
    }
    return self;
}

@end
