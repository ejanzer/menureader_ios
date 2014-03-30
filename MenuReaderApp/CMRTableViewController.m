//
//  CMRTableViewController.m
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/27/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRTableViewController.h"
#import "CMRReviewTableViewCell.h"
#import "CMRAppDelegate.h"

@interface CMRTableViewController ()

@property (nonatomic) NSMutableArray *data;

@property NSMutableArray *sections;
@property NSMutableArray *cellIds;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

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
            if ([[self.sections objectAtIndex:0] isEqualToString:@"Dish"]) {
                self.navItem.title = @"Dish";
            } else {
                self.navItem.title = @"Search";
            }
        } else {
            // Do something
        }
        
    }
}

- (void)parseJSON {
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.dishJSONData options:NSJSONReadingMutableContainers error:&error];
    
    if (!jsonObject) {
        NSLog(@"jsonObject does not exist. Error is %@", error);
    } else {
        self.data = [[NSMutableArray alloc] init];
        self.cellIds = [[NSMutableArray alloc] init];
        self.sections = [[NSMutableArray alloc] init];
        
        if ([jsonObject objectForKey:@"dish"] && [jsonObject objectForKey:@"dish"] != (id)[NSNull null]) {
            [self.data addObject: [jsonObject objectForKey:@"dish"]];
            [self.sections addObject: @"Dish"];
            [self.cellIds addObject:@"DishCell"];
        }
        if ([jsonObject objectForKey:@"reviews"] && [jsonObject objectForKey:@"reviews"] != (id)[NSNull null]) {
            [self.data addObject: [jsonObject objectForKey:@"reviews"]];
            [self.sections addObject: @"Reviews"];
            [self.cellIds addObject:@"ReviewCell"];

        }
        if ([jsonObject objectForKey:@"tags"] && [jsonObject objectForKey:@"tags"] != (id)[NSNull null]) {
            [self.data addObject: [jsonObject objectForKey:@"tags"]];
            [self.sections addObject: @"Tags"];
            [self.cellIds addObject:@"TagCell"];

        }
        if ([jsonObject objectForKey:@"translation"] && [jsonObject objectForKey:@"translation"] != (id)[NSNull null]) {
            [self.data addObject: [jsonObject objectForKey:@"translation"]];
            [self.sections addObject: @"Translation"];
            [self.cellIds addObject:@"TranslationCell"];

        }
        if ([[jsonObject objectForKey:@"similar"] count] > 0 && [jsonObject objectForKey:@"similar"] != (id)[NSNull null]) {
            [self.data addObject: [jsonObject objectForKey:@"similar"]];
            [self.sections addObject: @"Similar Dishes"];
            [self.cellIds addObject:@"SimilarCell"];

        }
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
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // How will I know how many rows to make for each section? Get the length of the list at that index?

    return [[self.data objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = nil;
    NSArray *data = [self.data objectAtIndex:indexPath.section];
    NSDictionary *item = [data objectAtIndex:indexPath.row];
    
    CellIdentifier = [self.cellIds objectAtIndex:indexPath.section];
    
    if ([CellIdentifier isEqual:@"ReviewCell"]) {
        CMRReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CMRReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReviewCell"];
        }
        cell.reviewUsernameLabel.text = [item objectForKey:@"username"];
        cell.reviewDateLabel.text = [item objectForKey:@"date"];
        cell.reviewTextView.text = [item objectForKey:@"text"];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BasicCell"];
    }
    
    // TODO: Fix these so they actually display things correctly. Just placeholders.
    if ([CellIdentifier isEqual:@"DishCell"]) {
        cell.textLabel.text = [item objectForKey:@"title"];
        cell.detailTextLabel.text = [item objectForKey:@"data"];
    } else if ([CellIdentifier isEqual:@"TagCell"]) {
        cell.textLabel.text = [item objectForKey:@"tag"];
        cell.detailTextLabel.text = [item objectForKey:@"count"];
    } else if ([CellIdentifier isEqual:@"TranslationCell"]) {
        cell.textLabel.text = [item objectForKey:@"char"];
        cell.detailTextLabel.text = [item objectForKey:@"english"];
    } else if ([CellIdentifier isEqual:@"SimilarCell"]) {
        cell.textLabel.text = [item objectForKey:@"title"];
        cell.detailTextLabel.text = [item objectForKey:@"data"];
    }

    if ([CellIdentifier isEqual:@"SimilarCell"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 50.0f;
    
    if ([[self.cellIds objectAtIndex:indexPath.section] isEqualToString:@"ReviewCell"]) {
        NSString *text = [[[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ] objectForKey:@"text"];
        UITextView *textView = [[UITextView alloc] init];
        textView.text = text;
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
        
        if (size.height > 100.0f) {
            height = size.height;
        } else {
            height = 100.0f;
        }
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sections objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *searchString = cell.textLabel.text;
    // Put it into a URL request
    NSString *urlString = [NSString stringWithFormat:@"http://14a65481.ngrok.com/search/%@", searchString];
    NSString *url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create session task.
    [[session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // set response data
        
        //CMRTableViewController *newDishVC = [[CMRTableViewController alloc]init];
        
        UIStoryboard *storyboard = self.storyboard;
        
        CMRTableViewController *newDishVC = [storyboard instantiateViewControllerWithIdentifier:@"tableViewController"];
        
        newDishVC.dishJSONData = data;
        
        UINavigationController *navController = self.navigationController;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [navController pushViewController:newDishVC animated:YES];
            
        });
    }] resume];
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
