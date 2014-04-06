//
//  CMRRectView.m
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/24/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRCropRectView.h"

@implementation CMRCropRectView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {

//}


@end
