//
//  CMRImage.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRImage.h"

@interface CMRImage()

@property (copy, readwrite) UIImage *image;

@end

@implementation CMRImage

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [self init]) {
        self.image = image;
    }
    return self;
}
@end
