//
//  CMRTableViewController.h
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/27/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMRDishTableViewController : UITableViewController <NSURLSessionDelegate>

@property (nonatomic) NSData *dishJSONData;
@property (nonatomic) NSArray *testData;
@property (copy, readonly) UIImage *searchImage;
@property (readonly) NSMutableArray *sections;
@property (readonly) NSString *errorMessage;

-(instancetype)initWithSections:(NSArray *)sections image:(UIImage *)searchImage;

-(void)setSections:(NSMutableArray *)sections;

-(void)setSearchImage:(UIImage *)searchImage;

-(void)setErrorMessage:(NSString *)errorMessage;

@end
