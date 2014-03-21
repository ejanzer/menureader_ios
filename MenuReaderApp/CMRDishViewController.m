//
//  CMRDishViewController.m
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/21/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRDishViewController.h"

@interface CMRDishViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *dishName;
@property (weak, nonatomic) IBOutlet UITextView *dishText;

@end

@implementation CMRDishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
