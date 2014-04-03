//
//  CMRSearchTableViewController.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/3/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMRSearchTableViewController : UITableViewController

@property (copy, readonly) NSArray *sections;

-(instancetype)initWithSections:(NSArray *)sections;

@end
