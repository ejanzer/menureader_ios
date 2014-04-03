//
//  CMRTableViewController.h
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/27/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMRTableViewController : UITableViewController <NSURLSessionDelegate>

@property(nonatomic) NSData *dishJSONData;
@property(nonatomic) NSArray *testData;
@property(nonatomic) UIImage *searchImage;

@end
