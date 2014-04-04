//
//  CMRSearchTableViewController.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/3/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMRSearchTableViewController : UITableViewController <NSURLSessionDelegate>

@property (readonly) NSMutableArray *sections;
@property (copy, readonly) UIImage *searchImage;
@property (readonly) NSString *errorMessage;

-(instancetype)initWithSections:(NSArray *)sections image:(UIImage *)searchImage;

-(void)setSections:(NSMutableArray *)sections;

-(void)setSearchImage:(UIImage *)searchImage;

-(void)setErrorMessage:(NSString *)errorMessage;

@end
