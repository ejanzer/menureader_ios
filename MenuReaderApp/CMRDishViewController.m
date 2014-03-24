//
//  CMRDishViewController.m
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/21/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRDishViewController.h"

@interface CMRDishViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *dishNavItem;
@property (weak, nonatomic) IBOutlet UITextView *dishTextView;
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
    
    // Set the dish name and dish text to the values passed in with the segue
    //self.dishNavItem.title = self.dishNameString;

    //self.dishTextView.text = self.dishTextString;
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.dishJSONData options:NSJSONReadingMutableContainers error:&error];
    
    if (!jsonObject) {
        NSLog(@"jsonObject does not exist. Error is %@", error);
    }
    
    NSMutableString *contents = [[NSMutableString alloc] init];
    
    // Get dish information, if it exists.
    NSDictionary *dish = [jsonObject objectForKey:@"dish"];
    if (dish) {
        [contents appendString:@"Dish: \n"];
        NSString *chinName = [dish objectForKey:@"chin_name"];
        self.dishNavItem.title = chinName;
        NSString *engName = [dish objectForKey:@"eng_name"];
        [contents appendString:engName];
        [contents appendString:@"\n"];
        NSDictionary *tags = [dish objectForKey:@"tags"];
        if (tags) {
            [contents appendString:@"Tags:"];
            for (NSString *tag in tags) {
                [contents appendFormat:@"%@: %@, ", tag, [tags objectForKey:tag]];
            }
        }
        [contents appendString:@"\n"];
        NSArray *reviews = [dish objectForKey:@"reviews"];
        if (reviews) {
            [contents appendString:@"Reviews:\n"];
            for (NSDictionary *review in reviews) {
                NSString *username = [review objectForKey:@"username"];
                NSString *date = [review objectForKey:@"date"];
                NSString *text = [review objectForKey:@"text"];
                [contents appendFormat:@"%@ %@\n%@", username, date, text];
            }
        }
        [contents appendString:@"\n"];
    } else {
        [contents appendString:@"No dish found.\n------------"];
    }
    
    // Show translation information.
    NSArray *translation = [jsonObject objectForKey:@"translation"];
    if (translation) {
        [contents appendString:@"Translation: \n"];
        for (NSDictionary *word in translation) {
            NSString *character = [word objectForKey:@"char"];
            NSString *pinyin = [word objectForKey:@"pinyin"];
            NSString *english = [word objectForKey:@"english"];
            [contents appendFormat:@"%@ (%@): %@\n", character, pinyin, english];
        }
    }

    NSArray *similar = [jsonObject objectForKey:@"similar"];
    if (similar) {
        [contents appendString:@"Similar dishes:\n"];
        for (NSDictionary *dish in similar) {
            NSString *chinName = [dish objectForKey:@"chin_name"];
            NSString *engName = [dish objectForKey:@"eng_name"];
            [contents appendFormat:@"%@: %@\n", chinName, engName];
        }
    }
    self.dishTextView.text = contents;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
