//
//  CMRDish.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRSection.h"

@interface CMRDish : NSObject

@property (copy, readonly) NSString *chinName;
@property (copy, readonly) NSString *engName;
@property (copy, readonly) NSString *pinyin;
@property (copy, readonly) NSString *description;

-(id)initWithData:(NSDictionary *)data;

@end
