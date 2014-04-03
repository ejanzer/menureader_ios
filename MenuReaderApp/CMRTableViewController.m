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
#import "CMRJSONParser.h"
#import "CMRSection.h"
#import "CMRDish.h"
#import "CMRImage.h"
#import "CMRReview.h"
#import "CMRTag.h"
#import "CMRTranslation.h"
#import "CMRSimilar.h"
#import "CMRDishTableViewCell.h"

@interface CMRTableViewController ()

@property (nonatomic) NSMutableArray *data;

@property NSArray *sections;
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
            NSError *error = nil;

            id jsonObject = [NSJSONSerialization JSONObjectWithData:self.dishJSONData options:NSJSONReadingMutableContainers error:&error];
            
            if (!jsonObject) {
                // TODO: Create function that creates a label given some text.
                NSLog(@"jsonObject does not exist. Error is %@", error);
                NSString *labelText = @"No data received from server.";
                UILabel *errorLabel = [self createErrorLabel:labelText frame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height/2) color:[UIColor grayColor]];
                [self.tableView addSubview:errorLabel];
            } else if ([jsonObject objectForKey:@"error"]) {
                NSLog(@"Error received from server.");

                NSString *labelText = [jsonObject objectForKey:@"error"];
                UILabel *errorLabel = [self createErrorLabel:labelText frame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height/2) color:[UIColor whiteColor]];
                [self.tableView addSubview:errorLabel];

            } else {
                CMRJSONParser *jsonParser = [[CMRJSONParser alloc] init];
                self.sections = [jsonParser parseJSON:jsonObject withImage:self.searchImage];
            }
            
            if (self.sections) {
                CMRSection *first = [self.sections objectAtIndex:0];
                if ([self.sections count] > 1 && [first.sectionTitle isEqualToString:@"Search"]) {
                    CMRSection *second = [self.sections objectAtIndex:1];
                    if ([second.sectionTitle isEqualToString:@"Dish"]) {
                        self.navItem.title = second.sectionTitle;
                    } else {
                        self.navItem.title = first.sectionTitle;
                    }
                } else {
                    self.navItem.title = first.sectionTitle;
                }
            }
        } else {
            self.navItem.title = @"Search";
        }
        
    }
}

- (UILabel *)createErrorLabel: (NSString *)text frame:(CGRect)frame color:(UIColor *)color {
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:frame];
    errorLabel.textColor = [UIColor lightGrayColor];
    errorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    errorLabel.numberOfLines = 0;
    errorLabel.font = [UIFont systemFontOfSize:30.0f];
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.text = text;
    
    return errorLabel;
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
    NSLog(@"Sections: %lu", [self.sections count]);
    for (int i = 0; i < [self.sections count]; i++) {
        CMRSection *section = [self.sections objectAtIndex:i];
        NSLog(@"Section name: %@, Rows: %lu", section.sectionTitle, [section getNumberOfRows]);
    }
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sections objectAtIndex:section]getNumberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CMRSection *section = [self.sections objectAtIndex:indexPath.section];
    NSLog(@"Section: %@, Type: %lu", section.sectionTitle, section.type);

    switch (section.type) {
        case CMRCellTypeImage: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:section.cellIdentifier forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section.cellIdentifier];
            }
            NSLog(@"Creating an image cell. Section name: %@, cell identifier: %@", section.sectionTitle, section.cellIdentifier);
            CMRImage *image = (CMRImage *)[section getCellForRow:indexPath.row];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image.image];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            [cell.contentView addSubview:imageView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case CMRCellTypeDish: {
            NSLog(@"Creating a dish cell. Section name: %@, cell identifier: %@", section.sectionTitle, section.cellIdentifier);
            CMRDishTableViewCell *dishCell = [tableView dequeueReusableCellWithIdentifier:section.cellIdentifier forIndexPath:indexPath];
            
            if (dishCell == nil) {
                dishCell = [[CMRDishTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section.cellIdentifier];
            }
            
            CMRDish *dish = (CMRDish *)[section getCellForRow:indexPath.row];
            dishCell.dishChineseLabel.text = dish.chinName;
            dishCell.dishEnglishLabel.text = dish.engName;
            dishCell.dishPinyinLabel.text = dish.pinyin;
            
            if (dish.description) {
                UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(0, 75, dishCell.frame.size.width, dishCell.frame.size.height/2)];
                descriptionView.text = dish.description;
                descriptionView.textAlignment = NSTextAlignmentCenter;
                descriptionView.font = [UIFont systemFontOfSize:12.0f];
                
                dishCell.dishDescriptionTextView = descriptionView;
                [dishCell.contentView addSubview:descriptionView];
            }
            dishCell.selectionStyle = UITableViewCellSelectionStyleNone;

            return dishCell;
        }
        case CMRCellTypeReview: {
            NSLog(@"Creating a review cell. Section name: %@, cell identifier: %@", section.sectionTitle, section.cellIdentifier);
            CMRReviewTableViewCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:section.cellIdentifier forIndexPath:indexPath];
            
            if (reviewCell == nil) {
                reviewCell = [[CMRReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section.cellIdentifier];
            }
            CMRReview *review = (CMRReview *)[section getCellForRow:indexPath.row];
            reviewCell.reviewUsernameLabel.text = review.username;
            reviewCell.reviewTextView.text = review.text;
            reviewCell.reviewDateLabel.text = review.date;
            reviewCell.reviewRestaurantLabel.text = review.restaurant;
            reviewCell.selectionStyle = UITableViewCellSelectionStyleNone;

            return reviewCell;
        }
        case CMRCellTypeTag: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:section.cellIdentifier forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section.cellIdentifier];
            }
            NSLog(@"Creating a tag cell. Section name: %@, cell identifier: %@", section.sectionTitle, section.cellIdentifier);
            CMRTag *tag = (CMRTag *)[section getCellForRow:indexPath.row];
            NSLog(@"tag name: %@", tag.name);
            cell.textLabel.text = tag.name;
            cell.detailTextLabel.text = tag.count;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            return cell;
        }
        case CMRCellTypeTranslation: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:section.cellIdentifier forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section.cellIdentifier];
            }
            NSLog(@"Creating a translation cell. Section name: %@, cell identifier: %@", section.sectionTitle, section.cellIdentifier);
            CMRTranslation *translation = (CMRTranslation *)[section getCellForRow:indexPath.row];
            cell.textLabel.text = translation.chinese;
            cell.detailTextLabel.text = translation.english;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
        case CMRCellTypeSimilar: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:section.cellIdentifier forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section.cellIdentifier];
            }
            NSLog(@"Creating a similar cell. Section name: %@, cell identifier: %@", section.sectionTitle, section.cellIdentifier);
            CMRSimilar *similar = (CMRSimilar *)[section getCellForRow:indexPath.row];
            cell.textLabel.text = similar.chinese;
            cell.detailTextLabel.text = similar.english;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            return cell;
        }
        default:
            break;
    }
    
    return nil;
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 50.0f;
    
    //TODO: Calculate height based on size of content.
    CMRSection *sectionObj = [self.sections objectAtIndex:indexPath.section];
    switch (sectionObj.type) {
        case CMRCellTypeReview: {
            CMRReview *review = (CMRReview *)[sectionObj getCellForRow:indexPath.row];
            NSString *text = review.text;
            height = [self getTextHeight:text min:100.0];
        }
        case CMRCellTypeDish: {
            CMRDish *dish = (CMRDish *)[sectionObj getCellForRow:indexPath.row];
            CGFloat minHeight = 130.0f;
            if (dish.description) {
                minHeight = 200.0f;
            }
            NSString *text = dish.description;
            height = [self getTextHeight:text min:130.0];

        }
            
        case CMRCellTypeImage: {
            height = 100.0f;
            
            // Do I want to size cell based on image, or image based on cell?
            /*
            CMRImage *image = (CMRImage *)[sectionObj getCellForRow:indexPath.row];
            height = image.image.size.height;
             */
            
        }
        default:
            break;
    }
    return height;
}

- (CGFloat)getTextHeight:(NSString *)text min:(CGFloat)minHeight {
    CGFloat height = minHeight;
    UITextView *textView = [[UITextView alloc] init];
    textView.text = text;
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    
    if (size.height > minHeight) {
        height = size.height;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CMRSection *sectionObj = [self.sections objectAtIndex:section];
    return sectionObj.sectionTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CMRSection *section = [self.sections objectAtIndex:indexPath.section];
    switch (section.type) {
        case CMRCellTypeSimilar: {
            CMRSimilar *similarDish = (CMRSimilar *)[section getCellForRow:indexPath.row];
            NSString *urlString = [NSString stringWithFormat:@"http://7558c64f.ngrok.com/dish/%@", similarDish.idNumber];
            [self loadNextDishViewController:urlString];
            break;
        }
        case CMRCellTypeTag: {
            CMRTag *tag = (CMRTag *)[section getCellForRow:indexPath.row];
            NSString *urlString = [NSString stringWithFormat:@"http://7558c64f.ngrok.com/tag/%@", tag.idNumber];
            [self loadNextDishViewController:urlString];
        }
        default:
            break;
    }
}

- (void)loadNextDishViewController: (NSString *)urlString {
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

@end