//
//  CMRTranslation.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRTranslation.h"

@interface CMRTranslation()

@property (copy, readwrite) NSString *chinese;
@property (copy, readwrite) NSString *english;

@end

@implementation CMRTranslation

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        self.chinese = dictionary[@"char"];
        self.english = dictionary[@"english"];
    }
    return self;
}

-(instancetype)initWithChinese:(NSString *)chinese english:(NSString *)english {
    if (self = [self init]) {
        self.chinese = chinese;
        self.english = english;
    }
    return self;
}

@end
