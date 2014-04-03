//
//  CMRTag.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMRTag : NSObject

@property (copy, readonly) NSString *name;
@property (copy, readonly) NSString *count;
@property (copy, readonly) NSNumber *idNumber;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(instancetype)initWithName:(NSString *)name countString:(NSString *)count idNumber:(NSNumber *)idNumber;

@end
