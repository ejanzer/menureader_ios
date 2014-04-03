//
//  CMRReviewTableViewCell.m
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/29/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRReviewTableViewCell.h"

@implementation CMRReviewTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.reviewTextView.editable = NO;
        self.reviewTextView.scrollEnabled = NO;
        self.reviewTextView.textContainer.maximumNumberOfLines = 0;
        self.reviewTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
