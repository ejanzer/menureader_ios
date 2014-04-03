//
//  CMRDish.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRSection.h"

@interface CMRDish : NSObject

@property (copy, readonly) NSString *chineseName;
@property (copy, readonly) NSString *englishName;
@property (copy, readonly) NSString *pinyin;
@property (copy, readonly) NSString *dishDescription;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(instancetype)initWithChineseName:(NSString *)chineseName englishName:(NSString *)englishName pinyin:(NSString *)pinyin description:(NSString *)dishDescription;

@end
