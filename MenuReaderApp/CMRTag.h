//
//  CMRTag.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMRTag : NSObject

@property NSString *name;
@property NSString *count;
@property NSNumber *idNumber;

-(id)initWithData:(NSDictionary *)data;



@end
