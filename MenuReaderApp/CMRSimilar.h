//
//  CMRSimilar.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMRSimilar : NSObject

@property NSString *chinese;
@property NSString *english;
@property NSNumber *idNumber;

-(id)initWithData:(NSDictionary *)data;

@end
