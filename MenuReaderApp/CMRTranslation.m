//
//  CMRTranslation.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRTranslation.h"

@implementation CMRTranslation

-(id)initWithData:(NSDictionary *)data {
    self.chinese = [data objectForKey:@"char"];
    self.english = [data objectForKey:@"english"];
    return self;
}

@end
