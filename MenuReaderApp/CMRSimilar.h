//
//  CMRSimilar.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMRSimilar : NSObject

@property (copy, readonly) NSString *chinese;
@property (copy, readonly) NSString *english;
@property (copy, readonly) NSNumber *idNumber;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(instancetype)initWithChinese:(NSString *)chinese english:(NSString *)english idNumber:(NSNumber *)idNumber;
@end
