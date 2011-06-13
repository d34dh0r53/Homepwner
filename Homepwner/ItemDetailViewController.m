//
//  ItemDetailViewController.m
//  Homepwner
//
//  Created by Dave Wilde on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "Possession.h"
#import "ImageCache.h"


@implementation ItemDetailViewController

@synthesize editingPossession=_editingPossession;

- (id)init
{
    [super initWithNibName:@"ItemDetailViewController" bundle:nil];
    
    // Create a UIBarButtonItem with a camera icon, will send
    // takePicture: to our ItemDetailViewController when tapped
    UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture:)];
    
    // Place this image on our navigation bar when this viewController is on top of the navigation stack
    [[self navigationItem] setRightBarButtonItem:cameraBarButtonItem];
    
    // cameraBarButton is retained by the navigation item
    [cameraBarButtonItem release];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [nameField release];
    [serialNumberField release];
    [valueField release];
    [dateLabel release];
    [imageView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)takePicture:(id)sender
{
    [[self view] endEditing:YES];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise we just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // image picker needs a delegate so we can respond to it's messages
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    [self presentModalViewController:imagePicker animated:YES];
    
    // The image picker will be retained by ItemDetailVewController until it has been dismissed
    [imagePicker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [self.editingPossession imageKey];
    
    // Did the possession already have an image?
    if (oldKey) {
        // Delete the old image
        [[ImageCache sharedImageCache] deleteImageForKey:oldKey];
    }
    
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Create a CFUUID object - it knows how to create unique identifiers
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    // Create a string from unique identifier
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    // Use that unique ID to set out possessions imageKey
    [self.editingPossession setImageKey:(NSString *)newUniqueIDString];
    
    // We used "Create" in the functions to make objects, we need to release them
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    // Store image in the ImageCache with this key
    [[ImageCache sharedImageCache] setImage:image forKey:[self.editingPossession imageKey]];
    
    // Put that image onto the screen in our image view
    [imageView setImage:image];
    
    // Take image picker off the screen -
    // you must call this dismiss method
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:[self.editingPossession possessionName]];
    [serialNumberField setText:[self.editingPossession serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [self.editingPossession valueInDollars]]];
    
    // Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Use filtered NSDate object to set dateLabel contents
    [dateLabel setText:[dateFormatter stringFromDate:[self.editingPossession dateCreated]]];
    
    // Change the navidation item to display name of possessions
    [[self navigationItem] setTitle:[self.editingPossession possessionName]];
    
    NSString *imageKey = [self.editingPossession imageKey];
    
    if (imageKey) {
        // Get the image for image key from image cache
        UIImage *imageToDisplay = [[ImageCache sharedImageCache] imageForKey:imageKey];
        
        // Use that image to put on the screen in imageView
        [imageView setImage:imageToDisplay];
    } else {
        // Clear the imageView
        [imageView setImage:nil];
    }
}

- (BOOL)textFieldShouldREturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [nameField resignFirstResponder];
    [serialNumberField resignFirstResponder];
    [valueField resignFirstResponder];
    
    // "Save" changes to editingPossession
    [self.editingPossession setPossessionName:[nameField text]];
    [self.editingPossession setSerialNumber:[serialNumberField text]];
    [self.editingPossession setValueInDollars:[[valueField text] intValue]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [nameField release];
    nameField = nil;
    
    [serialNumberField release];
    serialNumberField = nil;
    
    [valueField release];
    valueField = nil;
    
    [dateLabel release];
    dateLabel = nil;
    
    [imageView release];
    imageView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
