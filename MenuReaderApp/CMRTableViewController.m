//
//  CMRTableViewController.m
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/27/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRTableViewController.h"

@interface CMRTableViewController ()

@property (nonatomic) NSArray *dish;
@property (nonatomic) NSArray *translation;
@property (nonatomic) NSArray *reviews;
@property (nonatomic) NSArray *similar;
@property (nonatomic) NSArray *tags;


@end

@implementation CMRTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self) {
        if (self.dishJSONData) {
            [self parseJSON];
            NSLog(@"Parsed JSON!");
        } else {
            NSLog(@"No JSON data!");
            NSDictionary *chars = [[NSDictionary alloc] initWithObjectsAndKeys:@"宫爆鸡丁", @"Chinese", nil];
            NSDictionary *pinyin = [[NSDictionary alloc] initWithObjectsAndKeys:@"gongbaojiding", @"Pinyin", nil];
            NSDictionary *english = [[NSDictionary alloc] initWithObjectsAndKeys:@"Kung Pao chicken", @"English", nil];
            NSDictionary *description = [[NSDictionary alloc] initWithObjectsAndKeys:@"Spicy chicken with peanuts", @"Description", nil];
            
            self.testData = [[NSArray alloc] initWithObjects:chars, pinyin, english, description, nil];
        }
        
    }
}

- (void)parseJSON {
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.dishJSONData options:NSJSONReadingMutableContainers error:&error];
    
    if (!jsonObject) {
        NSLog(@"jsonObject does not exist. Error is %@", error);
    } else {
        
        self.dish = [jsonObject objectForKey:@"dish"];
        NSLog(@"Set self.dish to the jsonObject for dish");
        
        self.reviews = [jsonObject objectForKey:@"reviews"];
        NSLog(@"Set self.reviews to the jsonObject reviews");
        
        self.tags = [jsonObject objectForKey:@"tags"];
    
        //self.translation = [jsonObject objectForKey:@"translation"];
//        self.similar = [jsonObject objectForKey:@"similar"];
        
        //NSMutableString *contents = [[NSMutableString alloc] init];
        
        
        // Get dish information, if it exists.
        /*
        NSDictionary *dish = [jsonObject objectForKey:@"dish"];
        if (dish) {
            [contents appendString:@"Dish: \n"];
            NSString *chinName = [dish objectForKey:@"chin_name"];
            NSString *engName = [dish objectForKey:@"eng_name"];
            [contents appendString:chinName];
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
        if (translation && translation != (id)[NSNull null]) {
            NSLog(@"Translation is a %@", NSStringFromClass([translation class]));
            [contents appendString:@"Translation: \n"];
            for (NSDictionary *word in translation) {
                NSString *character = [word objectForKey:@"char"];
                NSString *pinyin = [word objectForKey:@"pinyin"];
                NSString *english = [word objectForKey:@"english"];
                [contents appendFormat:@"%@ (%@): %@\n", character, pinyin, english];
            }
        }
        
        // Get similar dishes.
        NSArray *similar = [jsonObject objectForKey:@"similar"];
        if (similar) {
            [contents appendString:@"Similar dishes:\n"];
            for (NSDictionary *dish in similar) {
                NSString *chinName = [dish objectForKey:@"chin_name"];
                NSString *engName = [dish objectForKey:@"eng_name"];
                [contents appendFormat:@"%@: %@\n", chinName, engName];
            }
        }
        NSLog(@"Contents: %@", contents);
         */
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // This will be the length of the JSON dictionary - 1 section for dish, 1 for translation, etc.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // How will I know how many rows to make for each section? Get the length of the list at that index?
    
    if (section == 0) {
        return [self.dish count];
    }
    if (section == 1) {
        return [self.reviews count];
    }

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *dict = nil;
    
    NSLog(@"Index path section: %li, row: %li", (long)indexPath.section, (long)indexPath.row);
    
    if (indexPath.section == 0) {
        dict = [self.dish objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        dict = [self.reviews objectAtIndex:indexPath.row];
    }
    NSString *key = [[dict allKeys] objectAtIndex:0];
    NSLog(@"key: %@", key);
    cell.textLabel.text = key;
    NSLog(@"object: %@", [dict objectForKey:key]);
    cell.detailTextLabel.text = [dict objectForKey:key];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
