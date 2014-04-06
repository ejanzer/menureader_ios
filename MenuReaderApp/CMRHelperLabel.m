//
//  CMRHelperLabel.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/6/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRHelperLabel.h"

@implementation CMRHelperLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color {
    
    if (self = [self initWithFrame:frame]) {
        self.text = text;
        self.textColor = color;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont fontWithName:@"Helvetica Neue" size:25.0f];
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
