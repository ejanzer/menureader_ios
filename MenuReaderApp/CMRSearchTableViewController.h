//
//  CMRSearchTableViewController.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/3/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMRSearchTableViewController : UITableViewController <NSURLSessionDelegate>

@property (copy, readonly) NSMutableArray *sections;
@property(copy, readonly) UIImage *searchImage;

-(instancetype)initWithSections:(NSArray *)sections image:(UIImage *)searchImage;

-(void)setSections:(NSMutableArray *)sections;

-(void)setSearchImage:(UIImage *)searchImage;


@end
