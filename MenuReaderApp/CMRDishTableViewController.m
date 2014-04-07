//
//  CMRTableViewController.m
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/27/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "Server.h"
#import "CMRDishTableViewController.h"
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
#import "CMRHelperLabel.h"

@interface CMRDishTableViewController ()

@property (nonatomic) NSMutableArray *data;

@property (readwrite) NSMutableArray *sections;
@property (readwrite) NSArray *nextControllerSections;

@property (copy, readwrite) UIImage *searchImage;
@property (readwrite) NSString *errorMessage;
@property (readwrite) NSString *nextControllerErrorMessage;

@end

@implementation CMRDishTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    return self;
}

- (instancetype)initWithSections:(NSArray *)sections image:(UIImage *)searchImage {
    if (self = [self init]) {
        self.sections = [sections mutableCopy];
        self.searchImage = searchImage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self) {
        if (self.errorMessage) {
            // do stuff
        }
        if (self.sections) {
            self.navigationItem.title = @"Dish";
            
            // If searchImage exists, add it to sections as a CMRImage section with the section title of "Search".
            if (self.searchImage) {
                CMRImage *searchImage = [[CMRImage alloc] initWithImage:self.searchImage];
                NSArray *images = [NSArray arrayWithObject:searchImage];
                
                CMRSection *imageSection = [[CMRSection alloc] initWithCells:images section:@"Search" cellId:@"ImageCell" type:CMRCellTypeImage];
                
                [self.sections insertObject:imageSection atIndex:0];
            }
        } else {
            CMRHelperLabel *errorLabel = [[CMRHelperLabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height/2) text:@"No data received from server." color:[UIColor grayColor]];
            [self.tableView addSubview:errorLabel];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation methods


- (void)queueNextSearchTableViewControllerWithSections:(NSArray *)sections errorMessage:(NSString *)errorMessage {
    // Initialize another searchTableViewController and push it onto the navViewController
    
    UIStoryboard *storyboard = self.storyboard;
    CMRDishTableViewController *newSearchVC = [storyboard instantiateViewControllerWithIdentifier:@"searchTableViewController"];
    
    if (sections) {
        [newSearchVC setSections:[sections mutableCopy]];
    }
    
    if (errorMessage) {
        [newSearchVC setErrorMessage:errorMessage];
    }
    
    UINavigationController *navController = self.navigationController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [navController pushViewController:newSearchVC animated:YES];
    });
}

- (void)queueNextDishTableViewControllerWithSections:(NSArray *)sections errorMessage:(NSString *)errorMessage {
    // Initialize another dishTableViewController and push it onto the navViewController
    
    UIStoryboard *storyboard = self.storyboard;
    CMRDishTableViewController *newDishVC = [storyboard instantiateViewControllerWithIdentifier:@"dishTableViewController"];
    
    if (sections) {
        [newDishVC setSections:[sections mutableCopy]];
    }
    if (errorMessage) {
        [newDishVC setErrorMessage:errorMessage];
    }
    
    UINavigationController *navController = self.navigationController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [navController pushViewController:newDishVC animated:YES];
    });
}


- (void)loadNextDishViewController: (NSString *)urlString {
    
    NSString *url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create session task.
    [[session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data && response) {
            self.nextControllerSections = nil;
            self.nextControllerErrorMessage = nil;
            CMRJSONParser *jsonParser = [[CMRJSONParser alloc] init];
            NSError *jsonError = nil;
            NSArray *sections = [jsonParser parseJSONData:data error:&jsonError];
            if (sections) {
                CMRSection *firstSection = [sections objectAtIndex:0];
                if ([firstSection.sectionTitle isEqualToString:@"Dish"]) {
                    // Initialize another dish VC and push onto nav view controller.
                    [self queueNextDishTableViewControllerWithSections:sections errorMessage:nil];
                } else {
                    // If it's not a dish, it's another search VC.
                    // Initialize another search VC and push onto nav view controller.
                    [self queueNextSearchTableViewControllerWithSections:sections errorMessage:nil];
                }
            } else if (jsonError) {
                NSLog(@"There was an error parsing JSON data %@: %@", data, error);
            } else {
                NSLog(@"NSJSONSerialization did not return JSON data or an error. Data: %@", data);
            }
        } else if (error) {
            NSLog(@"There was an error with the HTTP request: %@", error);
        } else {
            NSLog(@"There was a problem with the HTTP request, but no error was returned. Data: %@, response: %@", data, response);
        }
    }] resume];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sections objectAtIndex:section]getNumberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CMRSection *section = [self.sections objectAtIndex:indexPath.section];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:section.cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        // I subclassed tableviewcell for review and dish objects.
        // Initialize the tableviewcell that corresponds to the section type.
        switch (section.type) {
            case CMRCellTypeDish: {
                cell = [[CMRDishTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section.cellIdentifier];
                break;
            }
            case CMRCellTypeReview: {
                cell = [[CMRReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section.cellIdentifier];
                break;
            }
            case CMRCellTypeImage:
            case CMRCellTypeTag:
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section.cellIdentifier];
                break;
                
            // Dish view controller should never have translation or similar data.
            case CMRCellTypeTranslation:
            case CMRCellTypeSimilar:
                break;
        }
        
       
    }
    
    switch (section.type) {
        // Format the cell based on the section type.
        case CMRCellTypeImage: {
            CMRImage *image = (CMRImage *)[section cellForRow:indexPath.row];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image.image];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            [cell.contentView addSubview:imageView];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case CMRCellTypeDish: {
            CMRDishTableViewCell *dishCell = (CMRDishTableViewCell *)cell;
            CMRDish *dish = (CMRDish *)[section cellForRow:indexPath.row];
            dishCell.dishChineseLabel.text = dish.chineseName;
            dishCell.dishEnglishLabel.text = dish.englishName;
            dishCell.dishPinyinLabel.text = dish.pinyin;
            
            if (dish.dishDescription) {
                UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(0, 75, cell.frame.size.width, 30)];
                descriptionView.text = dish.dishDescription;
                descriptionView.textAlignment = NSTextAlignmentCenter;
                descriptionView.font = [UIFont systemFontOfSize:14.0f];
                dishCell.dishDescriptionTextView = descriptionView;
                [dishCell.contentView addSubview:descriptionView];
            }
            dishCell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell = dishCell;
            break;
        }
        case CMRCellTypeReview: {
            CMRReviewTableViewCell *reviewCell = (CMRReviewTableViewCell *)cell;
            if (reviewCell == nil) {
                reviewCell = [[CMRReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section.cellIdentifier];
            }
            CMRReview *review = (CMRReview *)[section cellForRow:indexPath.row];
            reviewCell.reviewUsernameLabel.text = review.username;
            reviewCell.reviewTextView.text = review.text;
            reviewCell.reviewDateLabel.text = review.date;
            reviewCell.reviewRestaurantLabel.text = [NSString stringWithFormat:@"@%@", review.restaurant];
            reviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            reviewCell.reviewTextView.editable = NO;
            reviewCell.reviewTextView.scrollEnabled = NO;
            reviewCell.reviewTextView.textContainer.maximumNumberOfLines = 0;
            reviewCell.reviewTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;

            cell = reviewCell;
            break;
        }
        case CMRCellTypeTag: {
            CMRTag *tag = (CMRTag *)[section cellForRow:indexPath.row];
            cell.textLabel.text = tag.name;
            cell.detailTextLabel.text = tag.count;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        }
        case CMRCellTypeSimilar:
        case CMRCellTypeTranslation:
            break;
    }
    return cell;
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get the height for a certain cell in the tableview.
    
    CGFloat height;
    
    CMRSection *sectionObj = [self.sections objectAtIndex:indexPath.section];
    switch (sectionObj.type) {
        case CMRCellTypeReview: {
            height = 120.0f;
            break;
       }
        case CMRCellTypeDish: {
            CMRDish *dish = (CMRDish *)[sectionObj cellForRow:indexPath.row];
            if (dish.dishDescription) {
                height = 130.0f;
                
            } else {
                height = 100.0f;
            }
            break;
        }
            
        case CMRCellTypeImage: {
            if ([sectionObj.sectionTitle isEqualToString:@"Search"]) {
                height = 100.0f;
            } else {
                CMRImage *image = (CMRImage *)[sectionObj.cells objectAtIndex:indexPath.row];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image.image];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                // Set the cell height to the image height or 150.0f, whichever is smaller.
                if (image.image.size.height > 150.0f) {
                    height = 150.0f;
                } else {
                    height = image.image.size.height;
                }
            }
            
            break;
            
        }
        case CMRCellTypeTag:
            height = 50.0f;
            break;
        case CMRCellTypeTranslation:
        case CMRCellTypeSimilar:
            // Similar and translation should not appear here.
            height = 0.0f;
            break;
    }
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CMRSection *sectionObj = [self.sections objectAtIndex:section];
    return sectionObj.sectionTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Function called when user taps a cell.
    
    CMRSection *section = [self.sections objectAtIndex:indexPath.section];
    switch (section.type) {
        // On the dish view, only tags are selectable.
        case CMRCellTypeTag: {
            CMRTag *tag = (CMRTag *)[section cellForRow:indexPath.row];
            NSString *urlString = [NSString stringWithFormat:@"%@/tag/%@", kBaseURL, tag.idNumber];
            [self loadNextDishViewController:urlString];
        }
        default:
            break;
    }
}

@end