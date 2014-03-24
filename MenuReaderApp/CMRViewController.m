//
//  CMRViewController.m
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/18/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRViewController.h"
#import "CMRDishViewController.h"
#import "CMRScrollView.h"
#import "CMRRectView.h"

@interface CMRViewController ()

@property (weak, nonatomic) IBOutlet CMRScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) CMRRectView *rectView;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) NSString *dishString;
@property (nonatomic) NSData *dishData;

@property (nonatomic) CGRect rect;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *uploadButton;

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
    
    // TODO: If there is no image in the UIImageView, disable the upload button.
    if (!self.imageView) {
        [self.uploadButton setEnabled:NO];
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
    imagePickerController.allowsEditing = YES;

    // Sets self as the delegate.
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        // Once I have an overlay I can switch this to NO.
        imagePickerController.showsCameraControls = YES;
        
        // TODO: Set up overlay view here. (see tutorial)
    }
    
    // Set self's imagePickerController to the one we just created.
    self.imagePickerController = imagePickerController;
    // Display the imagePickerController.
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)uploadImage:(id)sender {
    
    // TODO: Crop the image.
    
    CGRect cropRect;
    float scale = 1.0 / self.scrollView.zoomScale;
    
    cropRect.origin.x = self.scrollView.contentOffset.x + self.rectView.frame.origin.x* scale;
    cropRect.origin.y = self.scrollView.contentOffset.y + self.rectView.frame.origin.y* scale;
    cropRect.size.width = self.rectView.frame.size.width * scale;
    cropRect.size.height = self.rectView.frame.size.height * scale;
    
    
    
    CGRect visibleRect = [self.scrollView convertRect:self.rectView.bounds toView:self.imageView];
    
    NSLog(@"Visible rectangle: x: %f, y: %f, width: %f, height: %f", visibleRect.origin.x, visibleRect.origin.y, visibleRect.size.width, visibleRect.size.height);
    
    UIImage *image = self.imageView.image;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    // Get the image from the UIView
    NSData *imageData = UIImagePNGRepresentation(croppedImage);
    
    
    // Put it into a URL request
    NSString *url = @"http://51f11fa4.ngrok.com/upload";
    
    // Create request object.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // Set request method.
    [request setHTTPMethod: @"POST"];
    
    // And the content-type
    [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    
    // Create session object with default configurations.
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    // Create upload task.
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // capture the response from the server as a string
//        self.dishString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        self.dishData = data;
        
        
        // queue push segue
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"dishSegue" sender:self];
        });
    }];
    
    [uploadTask resume];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"dishSegue"]) {
        CMRDishViewController *dishVC = [segue destinationViewController];
        dishVC.dishJSONData = self.dishData;
    }
}

#pragma mark – UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView = imageView;
    [self.scrollView addSubview:imageView];
    self.scrollView.contentSize = imageView.frame.size;
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
        
        [self.scrollView addSubview:rectView];
    }
    
    NSLog(@"Scroll view X: %f", self.scrollView.frame.origin.x);
    NSLog(@"Scroll view Y: %f", self.scrollView.frame.origin.y);
    NSLog(@"Scroll view height: %f", self.scrollView.frame.size.height);
    NSLog(@"Scroll view width: %f", self.scrollView.frame.size.width);
    NSLog(@"Rect view X: %f", self.rectView.frame.origin.x);
    NSLog(@"Rect view Y: %f", self.rectView.frame.origin.y);
    NSLog(@"Rect view height: %f", self.rectView.frame.size.height);
    NSLog(@"Rect view width: %f", self.rectView.frame.size.width);
    NSLog(@"Image view X: %f", self.imageView.frame.origin.x);
    NSLog(@"Image view Y: %f", self.imageView.frame.origin.y);
    NSLog(@"Image view height: %f", self.imageView.frame.size.height);
    NSLog(@"Image view width: %f", self.imageView.frame.size.width);
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
