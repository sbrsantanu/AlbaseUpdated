#import "ImageViewController.h"
#import "OCRAppDelegate.h"
#import "RecognitionViewController.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"
#import "PECropViewController.h"
#import "OCRAddAccidentPolicyStepOneViewController.h"
#import "OCRAddContactFromOCRViewController.h"

typedef enum {
    ScannerTypeNone,
    ScannerTypePersonalPolicy,
    ScannerTypeAccidentPolicy
} ScannerSelectedType;

@interface ImageViewController()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, PECropViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (assign) ScannerSelectedType ScannerType;
@property (nonatomic) UIPopoverController *popover;
@property (nonatomic,retain) UITableView *DataTableView;
@property (nonatomic, strong) NSArray* descStrings;

@end
@implementation ImageViewController
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self=(IsIphone5)?[super initWithNibName:@"ImageViewController" bundle:nil]:[super initWithNibName:@"ImageViewController4s" bundle:nil];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"ImageViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"ImageViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"ImageViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"ImageViewController6s" bundle:nil];
        }
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Disable edit button if there is no selected image.
    [self updateEditButtonEnabled];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    self.imageView.image = croppedImage;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self updateEditButtonEnabled];
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self updateEditButtonEnabled];
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Action methods

- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = self.imageView.image;
    
    /*  UIImage *imageone = self.imageView.image;
     CGFloat width = imageone.size.width;
     CGFloat height = imageone.size.height;
     CGFloat length = MIN(width, height);
     controller.imageCropRect = CGRectMake((width - length) / 2,
     (height - length) / 2,
     length,
     length);
     controller.cropAspectRatio = 1.0f / 1.0f;
     
     */
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)cameraButtonAction:(id)sender
{
    if (self.ScannerType == ScannerTypeNone) {
        ShowAlert(@"Type Error", @"Please select what type of document you want to scan Personal Policy or Accident Policy");
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"Camera", nil), nil];
        
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //[actionSheet showFromBarButtonItem:self.cameraButton animated:YES];
        } else {
            [actionSheet showFromToolbar:self.navigationController.toolbar];
        }
    }
}

#pragma mark - Private methods

- (void)showCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.popover presentPopoverFromBarButtonItem:self.cameraButton
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

- (void)openPhotoAlbum
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.popover presentPopoverFromBarButtonItem:self.cameraButton
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

- (void)updateEditButtonEnabled
{
    self.editButton.enabled = !!self.imageView.image;
}

#pragma mark - UIActionSheetDelegate methods

/*
 Open camera or photo album.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Camera", nil)]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showCamera];
        } else {
            ShowAlert(@"Core Device Error", @"Your device doesnot support camera");
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageone = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = imageone;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        [self updateEditButtonEnabled];
        
        [self openEditor:nil];
    } else {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self openEditor:nil];
        }];
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateNormal];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateHighlighted];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateSelected];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateApplication];
    
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *ShadowBGView = [[UIView alloc] init];
    [ShadowBGView setFrame:(IsIphone5)?CGRectMake(0, 65, self.view.layer.frame.size.width, 462):CGRectMake(0, 65, self.view.layer.frame.size.width, 500)];
    
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    
    self.DataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.layer.frame.size.width, 300) style:UITableViewStyleGrouped];
    [self.DataTableView setDelegate:self];
    [self.DataTableView setDataSource:self];
    [self.DataTableView setBackgroundColor:[UIColor clearColor]];
    self.ScannerType = ScannerTypeNone;
    [self.view addSubview:self.DataTableView];
}


- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        NSLog(@"Menu bar button prassed..");
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)Recognize:(id)sender
{
   /** if (self.ScannerType == ScannerTypePersonalPolicy) {
        self.imageView.image = [UIImage imageNamed:@"OCRSCANNERSAN.jpg"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"FullSizeRenderone.jpg"];
    }
    **/
    
    if (self.imageView.image == nil) {
        ShowAlert(@"Image Processing Error", @"Need to capture an image to scan");
    } else {
        [(OCRAppDelegate*)[[UIApplication sharedApplication] delegate] setImageToProcess:self.imageView.image];
        RecognitionViewController *Recognition = [[RecognitionViewController alloc] init];
        [self.navigationController pushViewController:Recognition animated:YES];
    }
    
    /**
     * This is for temporary data save purpose
     */
    
    /*
     
     OCRAppDelegate *MainDelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
     if (MainDelegate.InsurenceScanType == ScanTypePersonalAccidentPolicy) {
     OCRAddAccidentPolicyStepOneViewController *AddContact = [[OCRAddAccidentPolicyStepOneViewController alloc] initWithNibName:@"OCRAddAccidentPolicyStepOneViewController" bundle:nil];
     [AddContact setDataModel:nil];
     [self.navigationController pushViewController:AddContact animated:YES];
     } else {
     OCRAddContactFromOCRViewController *AddContact = [[OCRAddContactFromOCRViewController alloc] initWithNibName:@"OCRAddContactFromOCRViewController" bundle:nil];
     [AddContact setDataadtionstatus:DataAditionStatusOcr];
     [AddContact setDataModel:nil];
     [self.navigationController pushViewController:AddContact animated:YES];
     }
     */
}

#pragma UITableView Datasource Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *TableCell = [[UITableViewCell alloc] init];
    TableCell.textLabel.text = (indexPath.row == 0)?@"Life Policy/ Health Policy":@"Personal Accident Policy";
    TableCell.textLabel.textColor = [UIColor darkGrayColor];
    return TableCell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma UITableView Delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *Headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.layer.frame.size.width, 50)];
    [Headerview setBackgroundColor:[UIColor clearColor]];
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, Headerview.frame.size.width, 15)];
    [TitleLabel setBackgroundColor:[UIColor clearColor]];
    [TitleLabel setTextColor:[UIColor darkGrayColor]];
    [TitleLabel setText:@"SELECT SCAN DOCUMENT TYPE"];
    [TitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [Headerview addSubview:TitleLabel];
    return Headerview;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *FooterView = [[UIView alloc] init];
    return FooterView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /**
     *  Remove Last Selected Cell
     */
    NSIndexPath *DataIndexPath = [NSIndexPath indexPathForRow:(indexPath.row == 0)?1:0 inSection:0];
    UITableViewCell * dataCellOne = [self.DataTableView cellForRowAtIndexPath:DataIndexPath];
    [dataCellOne setAccessoryType:UITableViewCellAccessoryNone];
    
    /**
     *  Assign New Cell
     */
    UITableViewCell * dataCell = [self.DataTableView cellForRowAtIndexPath:indexPath];
    [dataCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    /**
     *  Assign Scanner Data value and app delegate scanner value
     */
    
    OCRAppDelegate *MainDelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.row == 0) {
        
        // Local Variable data
        
        self.ScannerType = ScannerTypePersonalPolicy;
        
        // App Delegate Data
        
        MainDelegate.InsurenceScanType = ScanTypeLifePolicy;
        
    } else {
        
        // Local Variable data
        
        self.ScannerType = ScannerTypeAccidentPolicy;
        
        // App Delegate Data
        
        MainDelegate.InsurenceScanType = ScanTypePersonalAccidentPolicy;
    }
}

@end
