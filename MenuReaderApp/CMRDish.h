//
//  CMRDish.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRSection.h"

@interface CMRDish : NSObject

@property NSString *chinName;
@property NSString *engName;
@property NSString *pinyin;
@property NSString *description;

-(id)initWithData:(NSDictionary *)data;

@end
