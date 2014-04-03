//
//  CMRImage.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRImage.h"

@interface CMRImage()

@end

@implementation CMRImage

- (id)initWithImage:(UIImage *)image {
    if (self = [self init]) {
        self.image = image;
    }
    
    return self;
}
@end
