//
//  CMRReviewTableViewCell.h
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/29/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMRReviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *reviewUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UILabel *reviewRestaurantLabel;


@end
