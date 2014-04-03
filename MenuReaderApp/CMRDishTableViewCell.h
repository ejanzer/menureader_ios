//
//  CMRDishTableViewCell.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMRDishTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dishChineseLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishEnglishLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishPinyinLabel;
@property (nonatomic) IBOutlet UITextView *dishDescriptionTextView;

@end
