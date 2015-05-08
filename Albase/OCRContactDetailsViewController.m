//
//  OCRContactDetailsViewController.m
//  OCRScanner
//
//  Created by Mac on 23/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRContactDetailsViewController.h"
#import "OCRContactListViewController.h"
#import "UIColor+HexColor.h"
#import <CoreTelephony/CTCarrier.h>
#import <MessageUI/MessageUI.h>
#import "OCREditContactViewController.h"
#import "OCRAppDelegate.h"
#import "OCRSMSuserListViewController.h"

@interface OCRContactDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic,retain) UITableView *ContactDetailsTable;
@property(readonly, retain) CTCarrier *subscriberCellularProvider;
@end

@implementation OCRContactDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self=(IsIphone5)?[super initWithNibName:@"OCRContactDetailsViewController" bundle:nil]:[super initWithNibName:@"OCRContactDetailsViewController4s" bundle:nil];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRContactDetailsViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRContactDetailsViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRContactDetailsViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRContactDetailsViewController6s" bundle:nil];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Contact Details"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];    
    [SetButton addTarget:self action:@selector(BackviewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *EditButton = (UIButton *)[self.view viewWithTag:122];
    [EditButton addTarget:self action:@selector(EditButtonviewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _ContactDetailsTable = (UITableView *)[self.view viewWithTag:752];
    [_ContactDetailsTable setDelegate:self];
    [_ContactDetailsTable setDataSource:self];
    
    UIButton *CallUser = (UIButton *)[self.view viewWithTag:321];
    [CallUser addTarget:self action:@selector(GoForCall:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *SMSUser = (UIButton *)[self.view viewWithTag:322];
    [SMSUser addTarget:self action:@selector(GoForSMS:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *MailUser = (UIButton *)[self.view viewWithTag:323];
    [MailUser addTarget:self action:@selector(GoForMail:) forControlEvents:UIControlEventTouchUpInside];

}

-(IBAction)EditButtonviewClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select the operation to proceed" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit",@"Delete", nil];
    [actionSheet showInView:self.view];
}

-(IBAction)GoForSMS:(id)sender
{
    OCRSMSuserListViewController *SmsView = [[OCRSMSuserListViewController alloc] initWithNibName:@"OCRSMSuserListViewController" bundle:nil];
    SmsView.ContentObject = _UserDataObject;
    [self.navigationController pushViewController:SmsView animated:YES];
}

-(IBAction)GoForMail:(id)sender
{
    MFMailComposeViewController *comp=[[MFMailComposeViewController alloc]init];
    [comp setMailComposeDelegate:self];
    if([MFMailComposeViewController canSendMail]) {
        NSLog(@"useremail --- %@",[_UserDataObject Usersemail]);
        [comp setToRecipients:[NSArray arrayWithObjects:[_UserDataObject Usersemail], nil]];
        [comp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:comp animated:YES completion:nil];
    }
    else {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Your device havn't capable to send mail." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alrt show];
    }
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(IBAction)GoForCall:(id)sender
{
   /* NSString *mnc = [_subscriberCellularProvider mobileNetworkCode];
    if ([mnc length] == 0) {
        
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support Call!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        
    } else {
    */
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[_UserDataObject UserPhoneNumber]]]];
   /* } */
}
-(IBAction)leftSideMenuButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *Headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.layer.frame.size.width, 50)];
    [Headerview setBackgroundColor:[UIColor clearColor]];
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Headerview.frame.size.width, 15)];
    [TitleLabel setBackgroundColor:[UIColor clearColor]];
    [TitleLabel setTextColor:[UIColor darkGrayColor]];
    [TitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [Headerview addSubview:TitleLabel];
    if (section == 0) {
        [TitleLabel setText:@"Basic Information"];
    } else if (section == 1) {
        [TitleLabel setText:@"Email"];
    } else if (section == 2) {
        [TitleLabel setText:@"Phone Number"];
    } else if (section == 3) {
        [TitleLabel setText:@"Date of Birth"];
    } else if (section == 4) {
        [TitleLabel setText:@"Gender"];
    }
    return Headerview;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100.0f;
    } else {
        return 50.0f;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *TableCell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        UIImageView *ProfileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 65, 65)];
        [ProfileImageView setImage:[UIImage imageNamed:@"noimageprof.png"]];
        [TableCell addSubview:ProfileImageView];
        
        UILabel *UserNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 220, 30)];
        [UserNamelabel setTextAlignment:NSTextAlignmentLeft];
        [UserNamelabel setTextColor:[UIColor darkGrayColor]];
        [UserNamelabel setText:[NSString stringWithFormat:@"%@ %@",[_UserDataObject Firstname],[_UserDataObject Lastname]]];
        [UserNamelabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
        [TableCell addSubview:UserNamelabel];
    } else if (indexPath.section == 1) {
        [TableCell.textLabel setText:[_UserDataObject Usersemail]];
    } else if (indexPath.section == 2) {
        [TableCell.textLabel setText:[_UserDataObject UserPhoneNumber]];
    } else if (indexPath.section == 3) {
        [TableCell.textLabel setText:[_UserDataObject DateOfBirth]];
    } else if (indexPath.section == 4) {
        [TableCell.textLabel setText:[_UserDataObject Gender]];
    }
    [TableCell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [TableCell.textLabel setTextColor:[UIColor darkGrayColor]];
    return TableCell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)BackviewClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        OCREditContactViewController *EditContact = [[OCREditContactViewController alloc] initWithNibName:@"OCREditContactViewController" bundle:nil];
        EditContact.UserDataObject = _UserDataObject;
        [self.navigationController pushViewController:EditContact animated:YES];
    }
    else if (buttonIndex == 1)
    {
        UIAlertView *mainAlertView = [[UIAlertView alloc] initWithTitle:@"Caution" message:@"Are you sure to delete the contact?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [mainAlertView setTag:5689];
        [mainAlertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5689) {
        for (id AllTextView in [self.view subviews]) {
            if ([AllTextView isKindOfClass:[UITextView class]]) {
                UITextView *MycustomTextView = (UITextView *)AllTextView;
                [MycustomTextView resignFirstResponder];
            }
        }
        [self startSpin];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            NSString *url = nil;
            url = [NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=DeleteUserDetails&userID=%@",[_UserDataObject UserId]];
            
            NSLog(@"URL : %@", url);
            
            NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
            if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self stopSpin];
                if([[results objectForKey:@"status"] isEqualToString:@"success"])
                {
                    OCRAppDelegate *MaindataDelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
                    NSManagedObjectContext *context = [MaindataDelegate managedObjectContext];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id like[cd] %@",[_UserDataObject UserId]];
                    NSFetchRequest * request = [[NSFetchRequest alloc] init];
                    [request setEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:context]];
                    [request setPredicate:predicate];
                    
                    NSError *error = nil;
                    NSArray *result = [[MaindataDelegate managedObjectContext] executeFetchRequest:request error:&error];
                    
                    if (!error && result.count > 0) {
                        for(NSManagedObject *managedObject in result){
                            [[MaindataDelegate managedObjectContext] deleteObject:managedObject];
                        }
                        [[MaindataDelegate managedObjectContext] save:nil];
                    } else {
                        NSLog(@"data Deletion Error");
                    }
                    
                    UIAlertView *mainAlertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Contact deleted Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [mainAlertView setTag:1356];
                    [mainAlertView show];
                    
                    
                } else {
                    UIAlertView *mainAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Contact Can't be delete, please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [mainAlertView setTag:1256];
                    [mainAlertView show];
                }
            });
        });
    } else if (alertView.tag == 1356)
    {
        OCRContactListViewController *ContactList = [[OCRContactListViewController alloc] init];
        [self.navigationController pushViewController:ContactList animated:YES];
    }
}
@end
