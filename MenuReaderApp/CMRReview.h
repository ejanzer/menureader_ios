//
//  CMRReview.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRSection.h"

@interface CMRReview : NSObject

@property (copy, readonly) NSString *text;
@property (copy, readonly) NSString *restaurant;
@property (copy, readonly) NSString *username;
@property (copy, readonly) NSString *date;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(instancetype)initWithUsername:(NSString *)username text:(NSString *)text restaurant:(NSString *)restaurant date:(NSString *)date;

@end
