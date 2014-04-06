//
//  CMRImageOverlayDarkRectView.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/6/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRImageOverlayDarkRectView.h"

@implementation CMRImageOverlayDarkRectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5f;
        self.userInteractionEnabled = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
