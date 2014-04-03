//
//  CMRViewController.m
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/18/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRViewController.h"
#import "CMRTableViewController.h"
#import "CMRRectView.h"

@interface CMRViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) CMRRectView *rectView;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) NSString *dishString;
@property (nonatomic) NSData *dishData;

@property (nonatomic) CGRect rect;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *uploadButton;

@property (nonatomic) UILabel *helperLabel;
@property (nonatomic) UIImage *croppedImage;

@end

@implementation CMRViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //custom initialization here
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rect = CGRectMake(0, 150, 320, 100);

    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        [toolbarItems removeObjectAtIndex:2];
        [self.toolBar setItems:toolbarItems animated:NO];
    }
    
    // If there's no image in the view, disable the upload button and add helper text.
    if (!self.imageView) {
        [self.uploadButton setEnabled:NO];
        
        self.helperLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, self.scrollView.frame.size.width - 100, 150)];
        self.helperLabel.text = @"Take a picture of a menu.";
        self.helperLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.helperLabel.numberOfLines = 0;
        self.helperLabel.textAlignment = NSTextAlignmentCenter;
        self.helperLabel.textColor = [UIColor lightGrayColor];
        self.helperLabel.font = [UIFont systemFontOfSize:25.0f];
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

- (IBAction)showImagePickerForCamera:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)showImagePickerForPhotoPicker:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    // Set the source type for the imagePickerController as Photo Library or Camera.
    imagePickerController.sourceType = sourceType;
    
    // Allow editing.
    //imagePickerController.allowsEditing = YES;
    imagePickerController.allowsEditing = NO;

    // Sets self as the delegate.
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        // If I make a custom overlay I can switch this to NO.
        imagePickerController.showsCameraControls = YES;
        
        // TODO: Set up overlay view here. (see tutorial)
    }
    
    // Set self's imagePickerController to the one we just created.
    self.imagePickerController = imagePickerController;
    // Display the imagePickerController.
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)uploadImage:(id)sender {
    
    [self.uploadButton setEnabled:NO];
 
    
    CGRect cropRect;
    float scale = 1.0 / self.scrollView.zoomScale;
    float xOffset = self.rectView.frame.origin.x - self.scrollView.frame.origin.x;
    float yOffset = self.rectView.frame.origin.y - self.scrollView.frame.origin.y;
    cropRect.origin.x = scale * (self.scrollView.contentOffset.x + xOffset);
    cropRect.origin.y = scale * (self.scrollView.contentOffset.y + yOffset);
    cropRect.size.width = self.rectView.frame.size.width * scale;
    cropRect.size.height = self.rectView.frame.size.height * scale;
     
     
    // Fix the orientation of the image before uploading.
    UIImage *image = [self fixImageOrientation:self.imageView.image];
    //UIImage *image = self.imageView.image;


    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    self.croppedImage = croppedImage;
    CGImageRelease(imageRef);
    
    
    // Get the image from the UIView
    NSData *imageData = UIImagePNGRepresentation(croppedImage);
    //NSData *imageData = UIImagePNGRepresentation(image);
    
    // Put it into a URL request
    NSString *url = @"http://7558c64f.ngrok.com/upload";
    
    // Create request object.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // Set request method.
    [request setHTTPMethod: @"POST"];
    
    // And the content-type
    [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    
    // Create session object with default configurations.
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    // Commenting out for offline development.
    // Create upload task.
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        self.dishData = data;
        
        // queue push segue
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"dishSegue" sender:self];
        });
        
        [self.uploadButton setEnabled:YES];
    }];
    
    [uploadTask resume];
    
    // Adding for offline development. Delete or comment out later.
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"dishSegue" sender:self];
    });
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"dishSegue"]) {
        CMRTableViewController *dishVC = [segue destinationViewController];
        dishVC.dishJSONData = self.dishData;
        dishVC.searchImage = self.croppedImage;
    }
}

- (UIImage *)fixImageOrientation:(UIImage *)image {
    NSLog(@"Original image orientation: %ld", image.imageOrientation);
    NSLog(@"Original image height: %f width: %f", image.size.height, image.size.width);
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"New image orientation: %ld", normalizedImage.imageOrientation);
    NSLog(@"New image height: %f width: %f", normalizedImage.size.height, normalizedImage.size.width);
    if (normalizedImage.imageOrientation == UIImageOrientationUp) {
        NSLog(@"New image is right side up.");
    }
    return normalizedImage;
}

#pragma mark – UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Remove all existing subviews from scrollview.
    if (self.rectView) {
        [self.rectView removeFromSuperview];
    }
    if (self.imageView) {
        [self.imageView removeFromSuperview];
    }
    
    //UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // Changing orientation. Move this step to uploadImage later.
    //image = [self fixImageOrientation:image];
    
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

    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.zoomScale = minScale;
    
    [self.uploadButton setEnabled:YES];
    self.imagePickerController = nil;
    
    if (!self.rectView) {
        CMRRectView *rectView = [[CMRRectView alloc] initWithFrame:self.rect];
        self.rectView = rectView;
    }

    [self.helperLabel removeFromSuperview];
    self.helperLabel = nil;
    self.helperLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 250, self.scrollView.frame.size.width - 100, 300)];
    self.helperLabel.text = @"Crop image around dish name.";
    self.helperLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.helperLabel.numberOfLines = 0;
    self.helperLabel.textAlignment = NSTextAlignmentCenter;
    self.helperLabel.textColor = [UIColor whiteColor];
    self.helperLabel.shadowOffset = CGSizeZero;
    self.helperLabel.shadowColor = [UIColor blackColor];
    self.helperLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:25.0f];
    [self.mainView addSubview:self.helperLabel];
    
    [self.mainView addSubview:self.rectView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
