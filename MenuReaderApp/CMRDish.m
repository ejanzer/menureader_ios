//
//  CMRDish.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRDish.h"

@interface CMRDish()
@property (copy, readwrite) NSString *chineseName;
@property (copy, readwrite) NSString *englishName;
@property (copy, readwrite) NSString *pinyin;
@property (copy, readwrite) NSString *dishDescription;
@end

@implementation CMRDish

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        self.englishName = dictionary[@"eng_name"];
        self.chineseName = dictionary[@"chin_name"];
        self.pinyin = dictionary[@"pinyin"];
        self.dishDescription = dictionary[@"desc"];
    }
    return self;
}

-(instancetype)initWithChineseName:(NSString *)chineseName englishName:(NSString *)englishName pinyin:(NSString *)pinyin description:(NSString *)dishDescription {
    if (self = [self init]) {
        self.chineseName = chineseName;
        self.englishName = englishName;
        self.pinyin = pinyin;
        self.dishDescription = dishDescription;
    }
    return self;
}

@end
