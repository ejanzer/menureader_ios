//
//  CMRSearchTableViewController.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/3/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRSearchTableViewController.h"
#import "Server.h"
#import "CMRTableViewController.h"
#import "CMRImage.h"
#import "CMRSection.h"
#import "CMRSimilar.h"
#import "CMRTranslation.h"
#import "CMRJSONParser.h"

@interface CMRSearchTableViewController ()

@property (readwrite) NSMutableArray *sections;
@property (copy, readwrite) UIImage *searchImage;
@property (readwrite) NSString *errorMessage;
@property (readwrite) NSArray *nextControllerSections;
@property (readwrite) NSString *nextControllerErrorMessage;

@end

@implementation CMRSearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithSections:(NSArray *)sections image:(UIImage *)searchImage {
    if (self = [self init]) {
        self.sections = [[NSMutableArray alloc] initWithArray:sections];
        self.searchImage = searchImage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self) {
        if (self.nextControllerErrorMessage) {
            // do stuff
        }
        if (self.sections) {
            self.navigationItem.title = @"Search";
            
            // If searchImage exists, add it to sections as a CMRImage section with the section title of "Search".
            if (self.searchImage) {
                CMRImage *searchImage = [[CMRImage alloc] initWithImage:self.searchImage];
                NSArray *images = [NSArray arrayWithObject:searchImage];
                
                CMRSection *imageSection = [[CMRSection alloc] initWithCells:images section:@"Search" cellId:@"ImageCell" type:CMRCellTypeImage];
                
                [self.sections insertObject:imageSection atIndex:0];
            }
        } else {
            NSString *labelText = @"No data received from server.";
            UILabel *errorLabel = [self createErrorLabel:labelText frame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height/2) color:[UIColor grayColor]];
            [self.tableView addSubview:errorLabel];
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
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sections objectAtIndex:section]getNumberOfRows];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMRSection *section = [self.sections objectAtIndex:indexPath.section];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:section.cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section.cellIdentifier];
    }
    
    switch (section.type) {
        case CMRCellTypeImage: {
            CMRImage *image = (CMRImage *)[section cellForRow:indexPath.row];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image.image];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            [cell.contentView addSubview:imageView];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case CMRCellTypeTranslation: {
            CMRTranslation *translation = (CMRTranslation *)[section cellForRow:indexPath.row];
            cell.textLabel.text = translation.chinese;
            cell.detailTextLabel.text = translation.english;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case CMRCellTypeSimilar: {
            CMRSimilar *similar = (CMRSimilar *)[section cellForRow:indexPath.row];
            cell.textLabel.text = similar.chinese;
            cell.detailTextLabel.text = similar.english;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        }
        case CMRCellTypeTag:
        case CMRCellTypeReview:
        case CMRCellTypeDish:
            break;
    }
    return cell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height;
    
    //TODO: Calculate height based on size of content.
    CMRSection *sectionObj = [self.sections objectAtIndex:indexPath.section];
    switch (sectionObj.type) {
        case CMRCellTypeImage: {
            if ([sectionObj.sectionTitle isEqualToString:@"Search"]) {
                height = 100.0f;
            } else {
                CMRImage *image = (CMRImage *)[sectionObj.cells objectAtIndex:indexPath.row];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image.image];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                //imageView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, cell.frame.size.height);
                height = image.image.size.height;
            }
            
            break;
            
        }
        case CMRCellTypeSimilar:
        case CMRCellTypeTranslation:
            height = 50.0f;
            break;
        case CMRCellTypeDish:
        case CMRCellTypeReview:
        case CMRCellTypeTag:
            height = 0.0f;
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
            CMRSimilar *similarDish = (CMRSimilar *)[section cellForRow:indexPath.row];
            NSString *urlString = [NSString stringWithFormat:@"%@/dish/%@", kBaseURL, similarDish.idNumber];
            [self loadNextDishViewController:urlString];
            break;
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
        
        if (data && response) {
            NSError *jsonError = nil;
            CMRJSONParser *jsonParser = [[CMRJSONParser alloc] init];
            NSArray *sections = [jsonParser parseJSONData:data error:&jsonError];
            
            if (sections) {
                self.nextControllerSections = sections;
                CMRSection *firstSection = [sections objectAtIndex:0];
                if ([firstSection.sectionTitle isEqualToString:@"Dish"]) {
                    // queue dish segue
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:@"similarDishSegue" sender:self];
                    });
                    
                } else {
                    // If it's not a dish, it's another search VC.
                    // Initialize another search VC and push onto nav view controller.
                    [self queueNewSearchTableViewControllerWithSections:sections errorMessage:nil];
                }

            } else if (error) {
                NSLog(@"Error parsing JSON data: %@, error: %@", data, jsonError);
                [self queueNewSearchTableViewControllerWithSections:nil errorMessage:@"No results found"];
            } else {
                NSLog(@"NSJSONSerialization did not return JSON data or an error. Data: %@", data);
                [self queueNewSearchTableViewControllerWithSections:nil errorMessage:@"No results found."];
            }

        } else if (error) {
            NSLog(@"There was an error with the HTTP request. Error: %@", error);
            [self queueNewSearchTableViewControllerWithSections:nil errorMessage:@"Unable to reach server."];
        } else {
            NSLog(@"There was a problem with the HTTP request but no error was returned. Data: %@, response: %@", data, response);
            [self queueNewSearchTableViewControllerWithSections:nil errorMessage:@"Unable to reach server."];
        }
        
    }] resume];
         
}

- (void)queueNewSearchTableViewControllerWithSections:(NSArray *)sections errorMessage:(NSString *)errorMessage {
    UIStoryboard *storyboard = self.storyboard;
    CMRTableViewController *newSearchVC = [storyboard instantiateViewControllerWithIdentifier:@"searchTableViewController"];
    
    if (sections) {
        [newSearchVC setSections:[self.nextControllerSections mutableCopy]];
    }
    
    if (errorMessage) {
        [newSearchVC setErrorMessage:errorMessage];
    }
    
    UINavigationController *navController = self.navigationController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [navController pushViewController:newSearchVC animated:YES];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"similarDishSegue"]) {
        
        CMRTableViewController *dishVC = [segue destinationViewController];
        
        [dishVC setSections:[self.nextControllerSections mutableCopy]];
        if (self.nextControllerErrorMessage) {
            [dishVC setErrorMessage:self.nextControllerErrorMessage];
        }
    }
}

@end
