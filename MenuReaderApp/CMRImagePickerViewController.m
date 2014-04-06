//
//  CMRViewController.m
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/18/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRImagePickerViewController.h"
#import "CMRDishTableViewController.h"
#import "CMRCropRectView.h"
#import "Server.h"
#import "CMRJSONParser.h"
#import "CMRImage.h"
#import "CMRDish.h"
#import "CMRSearchTableViewController.h"
#import "CMRHelperLabel.h"
#import "CMRImageOverlayDarkRectView.h"

@interface CMRImagePickerViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) CMRCropRectView *rectView;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) NSArray *sections;
@property (nonatomic) NSString *errorMessage;

@property (nonatomic) CGRect rect;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *uploadButton;

@property (nonatomic) UILabel *helperLabel;
@property (nonatomic) UIImage *croppedImage;
@property (nonatomic) UIView *topOverlay;
@property (nonatomic) UIView *bottomOverlay;

@end

@implementation CMRImagePickerViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //custom initialization here
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: If I want this to scale horizontally this shouldn't be hard-coded.
    self.rect = CGRectMake(0, 150, 320, 100);

    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // There is not a camera on this device, so don't show the camera button.
        NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        [toolbarItems removeObjectAtIndex:2];
        [self.toolBar setItems:toolbarItems animated:NO];
    }
    
    // If there's no image in the view, disable the upload button and add helper text.
    if (!self.imageView) {
        [self.uploadButton setEnabled:NO];
        
        self.helperLabel = [[CMRHelperLabel alloc] initWithFrame:CGRectMake(50, 150, self.scrollView.frame.size.width - 100, 150) text:@"Take a picture of a menu." color:[UIColor lightGrayColor]];
        
        [self.mainView addSubview:self.helperLabel];
        
    } else {
        [self.uploadButton setEnabled:YES];
    }
    
    self.scrollView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Function called when a segue is about to take place.
    
    // If the next VC is a dish, set sections data and/or error message on that VC.
    if ([segue.identifier isEqualToString:@"dishSegue"]) {
        CMRDishTableViewController *dishVC = [segue destinationViewController];
        if (self.sections) {
            [dishVC setSections:[self.sections mutableCopy]];
        }
        if (self.croppedImage) {
            [dishVC setSearchImage:self.croppedImage];
        }
        if (self.errorMessage) {
            [dishVC setErrorMessage:self.errorMessage];
        }
        
        // If the next VC is a search, set sections and/or error message on that VC.
    } else if ([segue.identifier isEqualToString:@"searchSegue"]) {
        CMRSearchTableViewController *searchVC = [segue destinationViewController];
        if (self.sections) {
            [searchVC setSections:[self.sections mutableCopy]];
        }
        if (self.croppedImage) {
            [searchVC setSearchImage:self.croppedImage];
        }
        if (self.errorMessage) {
            [searchVC setErrorMessage:self.errorMessage];
        }
    }
}

#pragma mark - Methods for loading imagePickerController

- (IBAction)showImagePickerForCamera:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)showImagePickerForPhotoPicker:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {
    // Show the imagePickerController that corresponds to the button that the user tapped (Photo Library or Camera)
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    // Set the source type for the imagePickerController as Photo Library or Camera.
    imagePickerController.sourceType = sourceType;
    
    // Allow editing.
    imagePickerController.allowsEditing = NO;

    // Sets self as the delegate so we can get the images later.
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        // If I make a custom overlay I can switch this to NO.
        imagePickerController.showsCameraControls = YES;
    }
    
    // Set self's imagePickerController to the one we just created.
    self.imagePickerController = imagePickerController;
    
    // Display the imagePickerController.
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}


#pragma mark - Methods for manipulating images


- (UIImage *)fixImageOrientation:(UIImage *)image {
    // Fix the orientation of the image, if it's not right-side up.
    // Images taken in portrait mode appear right-side up in the UIImageView but are actually stored horizontally.
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}

- (UIImage *)getImageInCropRectangle {
    // Crop the image around what's currently within the crop rectangle.
    
    // Fix the orientation of the image, if it's not right-side up.
    UIImage *image = [self fixImageOrientation:self.imageView.image];
    
    // We need to map the current location of the crop rectangle to the image's own coordinate system. To do that we'll create another rectangle.
    CGRect cropRect;
    
    // Adjust the size of the rectangle according to the scrollView's zoom scale.
    // If the scrollView is zoomed in 3x, then the crop rectangle needs to be 1/3 the size in each direction.
    float scale = 1.0 / self.scrollView.zoomScale;
    
    // Find the crop rectangle's origin in the image's coordinate system based on the scrollview's content offset and the distance between the scrollview's origin and the cropping box's.
    float xOffset = self.rectView.frame.origin.x - self.scrollView.frame.origin.x;
    float yOffset = self.rectView.frame.origin.y - self.scrollView.frame.origin.y;
    cropRect.origin.x = scale * (self.scrollView.contentOffset.x + xOffset);
    cropRect.origin.y = scale * (self.scrollView.contentOffset.y + yOffset);
    
    // Determine the height & width of crop rectangle in image's coordinate system by multiplying the crop box's dimensions * 1/scale.
    cropRect.size.width = self.rectView.frame.size.width * scale;
    cropRect.size.height = self.rectView.frame.size.height * scale;
    
    // Create a new image from the crop rectangle & the existing image.
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

#pragma mark - Navigation methods

- (IBAction)uploadImage:(id)sender {
    // Function called when user taps "Search" after choosing an image.
    // Uploads the image within the crop box to the server, receives data in response, and tells the storyboard which view controller to load next based on whether or not it contains a dish.
    
    // Disable the Search button to prevent multiple requests to the server with the same image.
    [self.uploadButton setEnabled:NO];
    
    // Crop the image based on the location of the crop box.
    UIImage *croppedImage = [self getImageInCropRectangle];
    
    // Save this to send to the next view controller.
    self.croppedImage = croppedImage;
    
    
    // Get data from cropped image
    NSData *imageData = UIImagePNGRepresentation(croppedImage);
    
    // Create URL
    NSString *url = [NSString stringWithFormat:@"%@/upload", kBaseURL];
    
    // Create request object.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // Set request method.
    [request setHTTPMethod: @"POST"];
    
    // And the content-type - important so that Flask knows where to find the data.
    [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    
    // Create session object with default configurations.
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    // Create upload task.
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data && response) {
            CMRJSONParser *jsonParser = [[CMRJSONParser alloc] init];
            NSError *jsonError = nil;
            self.sections = [jsonParser parseJSONData:data error:&jsonError];
            
            if (self.sections) {
                // If the response data contains data about a dish, request the dish segue.
                CMRSection *firstSection = [self.sections objectAtIndex:0];
                if ([firstSection.sectionTitle isEqualToString:@"Dish"]) {
                    // queue dish segue
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:@"dishSegue" sender:self];
                    });
                    
                } else {
                    // Otherwise, request a search segue.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:@"searchSegue" sender:self];
                    });
                }
                
            } else if (jsonError) {
                // If there is no response data, request the search segue.
                NSLog(@"Error parsing JSON data: %@, error: %@", data, jsonError);
                self.errorMessage = @"No results found.";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"searchSegue" sender:self];
                });
            } else {
                NSLog(@"There was a problem parsing JSON data. No data or error returned. Data: %@, error: %@", data, jsonError);
                self.errorMessage = @"No results found.";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"searchSegue" sender:self];
                });
            }
            
            
        } else if (error) {
            NSLog(@"There was an error with the upload task. Error: %@", error);
            self.errorMessage = @"Unable to reach server.";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"searchSegue" sender:self];
            });
        } else {
            NSLog(@"There was a problem with the upload task, but no error was returned. Data: %@, response: %@", data, response);
            self.errorMessage = @"Unable to reach server.";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"searchSegue" sender:self];
            });
        }
        [self.uploadButton setEnabled:YES];
    }];
    
    [uploadTask resume];
    
}

#pragma mark – UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Function called when user taps "Done" in image picker.
    
    // Remove all existing subviews from scrollview.
    if (self.rectView) {
        [self.rectView removeFromSuperview];
    }
    if (self.imageView) {
        [self.imageView removeFromSuperview];
    }
    if (self.topOverlay) {
        [self.topOverlay removeFromSuperview];
    }
    if (self.bottomOverlay) {
        [self.bottomOverlay removeFromSuperview];
    }
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Create image view from image and add to scrollview.
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView = imageView;
    [self.scrollView addSubview:self.imageView];
    
    // Set min and max scale for scrollview
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.maximumZoomScale = 3.0f;
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;

    // Set zoomScale to minScale so that the image fits within scrollView's frame on load.
    // Default zoomScale is 1, which appears really zoomed in.
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.zoomScale = minScale;
    
    [self.uploadButton setEnabled:YES];
    self.imagePickerController = nil;
    
    if (!self.rectView) {
        // Initialize cropping rectangle if it's not already there.
        CMRCropRectView *rectView = [[CMRCropRectView alloc] initWithFrame:self.rect];
        self.rectView = rectView;
    }

    // I want to "dim" the rest of the image outside the cropping rectangle.
    // I did this by putting two black rectangles with 0.5 alpha above and below the cropping rectangle.
    // This won't work well for landscape mode.
    // TODO: Research a better way to have an overlay around an object.
    self.topOverlay = [[CMRImageOverlayDarkRectView alloc] initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, self.rectView.frame.origin.y)];
    CGFloat cropRectangleBottomLeftYValue = self.rectView.frame.origin.y + self.rectView.frame.size.height;
    CGFloat scrollViewBottomLeftYValue = self.scrollView.frame.origin.y + self.scrollView.frame.size.height;
    self.bottomOverlay = [[CMRImageOverlayDarkRectView alloc] initWithFrame:CGRectMake(0, cropRectangleBottomLeftYValue, self.mainView.frame.size.width, scrollViewBottomLeftYValue - cropRectangleBottomLeftYValue)];
    
    [self.mainView addSubview:self.topOverlay];
    [self.mainView addSubview:self.bottomOverlay];

    [self.helperLabel removeFromSuperview];
    
    self.helperLabel = [[CMRHelperLabel alloc] initWithFrame:CGRectMake(50, 250, self.scrollView.frame.size.width - 100, 300) text:@"Crop image around dish name." color:[UIColor whiteColor]];
    [self.mainView addSubview:self.helperLabel];
    
    [self.mainView addSubview:self.rectView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // Function called when user taps "Cancel" in image picker.
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Tell the scrollView which of its subviews should be scrolling & zooming.
    return self.imageView;
}

@end
