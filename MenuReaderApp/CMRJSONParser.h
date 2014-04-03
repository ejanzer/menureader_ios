//
//  CMRJSONParser.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMRJSONParser : NSObject

-(NSMutableArray *)parseJSON:(id)jsonObject withImage:(UIImage *)image;

@end
