//
//  CMRDish.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRDish.h"

@interface CMRDish()

@end

@implementation CMRDish

-(id)initWithData:(NSDictionary *)data {
    self.engName = [data objectForKey:@"eng_name"];
    self.chinName = [data objectForKey:@"chin_name"];
    self.pinyin = [data objectForKey:@"pinyin"];
    self.description = [data objectForKey:@"desc"];
    return self;
}

@end
