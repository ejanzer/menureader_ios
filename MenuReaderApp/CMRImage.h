//
//  CMRImage.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRSection.h"

@interface CMRImage : NSObject

@property (copy, readonly) UIImage *image;

-(instancetype)initWithImage:(UIImage *)image;

@end
