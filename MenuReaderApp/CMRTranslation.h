//
//  CMRTranslation.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMRTranslation : NSObject

@property (copy, readonly) NSString *chinese;
@property (copy, readonly) NSString *english;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
