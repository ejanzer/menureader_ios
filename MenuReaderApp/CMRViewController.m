//
//  CMRViewController.m
//  MenuReaderApp
//
//  Created by Emily Janzer on 3/18/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRViewController.h"
#import "CMRDishViewController.h"

@interface CMRViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) NSString *dishString;
@property (nonatomic) NSData *dishData;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *uploadButton;

@end

@implementation CMRViewController


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
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        [toolbarItems removeObjectAtIndex:2];
        [self.toolBar setItems:toolbarItems animated:NO];
    }
    
    // TODO: If there is no image in the UIImageView, disable the upload button.
    if (!self.imageView.image) {
        [self.uploadButton setEnabled:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
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
    
    // What does this line do?
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
    
    
    // Get the image from the UIView
    NSData *imageData = UIImagePNGRepresentation([self.imageView image]);
    
    NSString *imageString = [imageData base64EncodedStringWithOptions:NSUTF8StringEncoding];

    NSData *b64data = [imageString dataUsingEncoding:NSDataBase64DecodingIgnoreUnknownCharacters];

    
    // Put it into a URL request
    NSString *url = @"http://77ffa208.ngrok.com/upload";
    
    // Create request object.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // Set request method.
    [request setHTTPMethod: @"POST"];
    
    // And the content-type
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"base64" forHTTPHeaderField:@"Content-transfer-encoding"];
    
    // Create session object with default configurations.
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    // Create upload task.
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:b64data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"dishSegue"]) {
        CMRDishViewController *dishVC = [segue destinationViewController];
        dishVC.dishNameString = @"Dish Name";
        dishVC.dishTextString = self.dishString;
        dishVC.dishJSONData = self.dishData;
    } else if ([segue.identifier isEqualToString:@"searchSegue"]) {
        // do something else.
    }
}

#pragma mark – UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:YES completion:NULL]; // why null instead of nil?
    [self.imageView setImage:image];
    [self.uploadButton setEnabled:YES];
    self.imagePickerController = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
