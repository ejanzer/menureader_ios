//
//  CMRSimilar.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRSimilar.h"

@implementation CMRSimilar

-(id)initWithData:(NSDictionary *)data {
    
    self.chinese = [data objectForKey:@"chinese"];
    self.english = [data objectForKey:@"english"];
    self.idNumber = [data objectForKey:@"id"];
    return self;
}

@end
