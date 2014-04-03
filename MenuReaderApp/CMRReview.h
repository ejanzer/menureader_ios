//
//  CMRReview.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRSection.h"

@interface CMRReview : NSObject

@property NSString *text;
@property NSString *restaurant;
@property NSString *username;
@property NSString *date;

-(id)initWithData:(NSDictionary *)data;


@end
