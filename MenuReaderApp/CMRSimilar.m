//
//  CMRSimilar.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRSimilar.h"

@interface CMRSimilar()

@property (copy, readwrite) NSString *chinese;
@property (copy, readwrite) NSString *english;
@property (copy, readwrite) NSNumber *idNumber;

@end

@implementation CMRSimilar

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        self.chinese = dictionary[@"chinese"];
        self.english = dictionary[@"english"];
        self.idNumber = dictionary[@"id"];
    }
    return self;
}

-(instancetype)initWithChinese:(NSString *)chinese english:(NSString *)english idNumber:(NSNumber *)idNumber {
    if (self = [self init]) {
        self.chinese = chinese;
        self.english = english;
        self.idNumber = idNumber;
    }
    return self;
}

@end
