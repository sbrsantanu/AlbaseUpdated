//
//  OCRSMSuserListViewController.m
//  OCRScanner
//
//  Created by Mac on 29/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRSMSuserListViewController.h"
#import "UIColor+HexColor.h"
#import "OCRDataObjectModel.h"
#import <MessageUI/MessageUI.h>
#import "OCRCallUserListViewController.h"

@interface OCRSMSuserListViewController ()<UITextViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>
@property (nonatomic,retain) UITextView *SmsTypeTextView;
@property (nonatomic,retain) UILabel    *SmsTypeUserLabel;

@end

@implementation OCRSMSuserListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self=(IsIphone5)?[super initWithNibName:@"OCRSMSuserListViewController" bundle:nil]:[super initWithNibName:@"OCRSMSuserListViewController4s" bundle:nil];
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRSMSuserListViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRSMSuserListViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRSMSuserListViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRSMSuserListViewController6s" bundle:nil];
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
    [Titlelabel setText:@"Send SMS"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    
    [SetButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateHighlighted];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateSelected];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateApplication];
    
    [SetButton addTarget:self action:@selector(GoBackToMainPage:) forControlEvents:UIControlEventTouchUpInside];
    
    OCRUserDataObjectModel *UserDataObjectModel = self.ContentObject;
    NSLog(@"UserDataObjectModel --- %@",UserDataObjectModel);
    
    /*
     */
    
    _SmsTypeUserLabel = (UILabel *)[self.view viewWithTag:171];
    [_SmsTypeUserLabel setText:[NSString stringWithFormat:@"To : %@ %@",[UserDataObjectModel Firstname],[UserDataObjectModel Lastname]]];
    [_SmsTypeUserLabel setTextColor:[UIColor darkGrayColor]];
    [_SmsTypeUserLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
    
    
    _SmsTypeTextView = (UITextView *)[self.view viewWithTag:172];
    [_SmsTypeTextView setTextColor:[UIColor darkGrayColor]];
    [_SmsTypeTextView setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
    [_SmsTypeTextView setDelegate:self];
    [_SmsTypeTextView becomeFirstResponder];
    
    /*
     Send button Configuration
     */
    
    UIButton *SendSMSButton = (UIButton *)[self.view viewWithTag:444];
    [SendSMSButton addTarget:self action:@selector(SendSmsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}
-(IBAction)SendSmsButtonClicked:(id)sender
{
    NSString *SMSString = [self CleanTextField:[_SmsTypeTextView text]];
    if ([SMSString length]==0) {
        ShowAlert(@"Blank Text", @"Please text Something");
    } else {
        if(![MFMessageComposeViewController canSendText]) {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Go Back", nil];
            [warningAlert setTag:1205];
            [warningAlert show];
            return;
        }
        OCRUserDataObjectModel *UserDataObjectModel = self.ContentObject;
        NSArray *recipents = [[NSArray alloc] initWithObjects:[UserDataObjectModel UserPhoneNumber], nil];
        NSString *message = [self CleanTextField:[_SmsTypeTextView text]];
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setRecipients:recipents];
        [messageController setBody:message];
        
        // Present message view controller on screen
        [self presentViewController:messageController animated:YES completion:nil];
    }
}
-(NSString *)CleanTextField:(NSString *)TextfieldName
{
    NSString *Cleanvalue = [TextfieldName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return Cleanvalue;
}
-(IBAction)GoBackToMainPage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma uitextview protocol delegate declearation

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Go Back", nil];
            [warningAlert setTag:1204];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"SMS send!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert setTag:1203];
            [warningAlert show];
            break;
        }
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1203)
    {
        OCRCallUserListViewController *CallView = [[OCRCallUserListViewController alloc] init];
        [self.navigationController pushViewController:CallView animated:YES];
    }
    else if (alertView.tag == 1204)
    {
        OCRCallUserListViewController *CallView = [[OCRCallUserListViewController alloc] init];
        [self.navigationController pushViewController:CallView animated:YES];
    }
    else if (alertView.tag == 1205)
    {
        OCRCallUserListViewController *CallView = [[OCRCallUserListViewController alloc] init];
        [self.navigationController pushViewController:CallView animated:YES];
    }
}
@end
