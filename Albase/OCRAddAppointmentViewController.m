//
//  OCRAddAppointmentViewController.m
//  Albase
//
//  Created by Mac on 27/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

typedef enum {
    AppointmentTypeNormalHour,
    AppointmentTypeFullDay
} AppointmentType;

typedef enum {
    DateSelectionModeNone,
    DateSelectionModeStartDate,
    DateSelectionModeEndDate
} DatePickerDateSelectionMode;


#import "OCRAddAppointmentViewController.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"
#import "OCRDataObjectModel.h"
#import "OCRAppointmentCalenderViewController.h"

@interface OCRAddAppointmentViewController ()

@property (assign) AppointmentType MyAppontmentType;
@property (assign) DatePickerDateSelectionMode DateSelectionMode;
@property (nonatomic,retain) NSDate *StartDate;
@property (nonatomic,retain) NSDate *EndDate;
@property (nonatomic,retain) UITableView *AddApponimentTable;
@property (nonatomic,retain) UILabel *StartDateLabel;
@property (nonatomic,retain) UILabel *EndDateLabel;
@property (nonatomic,retain) UILabel *InviteLabel;
@property (nonatomic,retain) UITextField *TitleTextField;
@property (nonatomic,retain) UITextView *DescriptionTextView;
@property (nonatomic,retain) NSString *InvitedUserName;
@property (nonatomic,retain) NSString *InvitedUserId;

@end

@implementation OCRAddAppointmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self=(IsIphone5)?[super initWithNibName:@"OCRAddAppointmentViewController" bundle:nil]:[super initWithNibName:@"OCRAddAppointmentViewController4s" bundle:nil];
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRAddAppointmentViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRAddAppointmentViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRAddAppointmentViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRAddAppointmentViewController6s" bundle:nil];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Add Appointment"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    _AddApponimentTable = (UITableView *)[self.view viewWithTag:445];
    [_AddApponimentTable setDelegate:self];
    [_AddApponimentTable setDataSource:self];
    
    _StartDateLabel = [[UILabel alloc] init];
    _EndDateLabel = [[UILabel alloc] init];
    _InviteLabel = [[UILabel alloc] init];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateNormal];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateHighlighted];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateSelected];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateApplication];
    
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _MyAppontmentType = AppointmentTypeNormalHour;
    _DateSelectionMode = DateSelectionModeNone;
    
    _TitleTextField = [[UITextField alloc] init];
    [_TitleTextField setDelegate:self];
    
    _DescriptionTextView = [[UITextView alloc] init];
    [_DescriptionTextView setDelegate:self];
    
    UIButton *DoneButton = (UIButton *)[self.view viewWithTag:145];
    [DoneButton addTarget:self action:@selector(DoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _StartDate = [NSDate date];
    
    NSDate *mydate = [NSDate date];
    NSTimeInterval secondsInEightHours = 1 * 60 * 60;
    NSDate *dateEightHoursAhead = [mydate dateByAddingTimeInterval:secondsInEightHours];
    _EndDate = dateEightHoursAhead;
    
    _InvitedUserName = nil;
    _InvitedUserId   = nil;
}

- (void)HandleDataObject:(OCRInvitesViewController *)myObj ObjectCarrier:(id)ObjectCarrier
{
    OCRUserDataObjectModel *UserDataObjectModel = ObjectCarrier;
    NSLog(@"user Data -- %@ ---- %@ ------ %@",[UserDataObjectModel Firstname],[UserDataObjectModel Lastname],[UserDataObjectModel UserId]);
    
    [_InviteLabel setText:[NSString stringWithFormat:@"%@ %@",[UserDataObjectModel Firstname],[UserDataObjectModel Lastname]]];
    
    _InvitedUserName =[NSString stringWithFormat:@"%@ %@",[UserDataObjectModel Firstname],[UserDataObjectModel Lastname]];
    _InvitedUserId = [UserDataObjectModel UserId];
    
}
-(IBAction)DoneButtonClicked:(id)sender
{
    NSLog(@"DoneButtonClicked ---- ");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd hh:mm aa"];
    
    NSDateFormatter *dateFormattergetdate = [[NSDateFormatter alloc] init];
    [dateFormattergetdate setDateFormat:@"yyyy-mm-dd"];
    
    NSDateFormatter *dateFormattergettime = [[NSDateFormatter alloc] init];
    [dateFormattergettime setDateFormat:@"HH:mm"];
    
    NSArray *SplitStartdate = [[NSString stringWithFormat:@"%@",_StartDate] componentsSeparatedByString:@" "];
    NSArray *SplitEnddate = [[NSString stringWithFormat:@"%@",_EndDate] componentsSeparatedByString:@" "];
    
    NSString *AppointmentStartDate      = [SplitStartdate objectAtIndex:0];
    NSString *AppointmentEndDate        = [SplitEnddate objectAtIndex:0];
    
    NSString *AppointmentStartTime      = [dateFormattergettime stringFromDate:_StartDate];
    NSString *AppointmentEndTime        = [dateFormattergettime stringFromDate:_EndDate];
    
    NSTimeInterval timeDifference = [_EndDate timeIntervalSinceDate:_StartDate];
    
    if ([self CleanTextField:[_TitleTextField text]].length == 0) {
        ShowAlert(@"Credential Error", @"Please add title");
    } else if (_InvitedUserName == nil) {
        ShowAlert(@"Credential Error", @"Please Select User to invite");
    } else {
        NSLog(@"Evertything looking fine");
        [self startSpin];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=AddAppointment&AppointmentTitle=%@&AppointmentStartDate=%@&AppointmentEndDate=%@&AppointmentStartTime=%@&AppointmentEndTime=%@&AppointmentWith=%@&AppointmentNote=%@&AppointmentDurationStatus=%@&AppointmentDuration=%@",[[self CleanTextField:[_TitleTextField text]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],AppointmentStartDate,AppointmentEndDate,AppointmentStartTime,AppointmentEndTime,_InvitedUserId,[[self CleanTextField:[_DescriptionTextView text]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"",[NSString stringWithFormat:@"%f",timeDifference]];
            NSLog(@"URL : %@", url);
            
            NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
            if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            [self stopSpin];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if ([[results objectForKey:@"status"] isEqualToString:@"success"]) {
                    UIAlertView *Alertview = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Appointment Added Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [Alertview setTag:4512];
                    [Alertview show];
                } else {
                    UIAlertView *Alertview = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There is some issue, try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [Alertview setTag:4513];
                    [Alertview show];
                }
            });
        });
        //[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4512) {
        OCRAppointmentCalenderViewController *ApponitmentList = [[OCRAppointmentCalenderViewController alloc] initWithNibName:@"OCRAppointmentCalenderViewController" bundle:nil];
        [self.navigationController pushViewController:ApponitmentList animated:YES];
    }
}
- (void)leftSideMenuButtonPressed:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        NSLog(@"Menu bar button prassed..");
    }];
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
        [TitleLabel setText:@"Title"];
    } else if (section == 1) {
        [TitleLabel setText:@"Appoinment Details"];
    } else if (section == 2) {
        [TitleLabel setText:@"Invites"];
    } else if (section == 3) {
        [TitleLabel setText:@"Notes"];
    }
    return Headerview;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([indexPath section] == 3)?200:50.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [[UITableViewCell alloc] init];
    [Cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [Cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyy hh:mm aa"];
    
    NSDateFormatter *dateFormatterallday = [[NSDateFormatter alloc] init];
    [dateFormatterallday setDateFormat:@"EEE,dd MMM yyy"];
    
    if ([indexPath section] == 0)
    {
        [_TitleTextField setFrame:CGRectMake(15, 0, 300, 50)];
        [_TitleTextField setPlaceholder:@"Title"];
        [Cell.contentView addSubview:_TitleTextField];
    }
    else if ([indexPath section] == 1)
    {
        if([indexPath row] == 0)
        {
            [Cell.textLabel setText:@"All-Day"];
            UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(260, 10, 150, 50)];
        
            if (_MyAppontmentType == AppointmentTypeFullDay) {
                [mySwitch setOn:YES];
            }
            [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            [Cell.contentView addSubview:mySwitch];
        }
        else if([indexPath row] == 1)
        {
            [Cell.textLabel setText:@"Starts"];
            [_StartDateLabel setFrame:CGRectMake(100, 0, 210, 50)];
            [_StartDateLabel setTextColor:[UIColor darkGrayColor]];
            [_StartDateLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
            [_StartDateLabel setTextAlignment:NSTextAlignmentRight];
            [_StartDateLabel setText:@"Select Starttime"];
            [Cell.contentView addSubview:_StartDateLabel];
            
            [_StartDateLabel setText:( _MyAppontmentType == AppointmentTypeFullDay)?[dateFormatterallday stringFromDate:_StartDate]:[dateFormatter stringFromDate:_StartDate]];
        }
        else if([indexPath row] == 2)
        {
            [Cell.textLabel setText:@"Ends"];
            [_EndDateLabel setFrame:CGRectMake(100, 0, 210, 50)];
            [_EndDateLabel setTextAlignment:NSTextAlignmentRight];
            [_EndDateLabel setTextColor:[UIColor darkGrayColor]];
            [_EndDateLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
            [_EndDateLabel setText:@"Select Endtime"];
            [Cell.contentView addSubview:_EndDateLabel];
            
            [_EndDateLabel setText:( _MyAppontmentType == AppointmentTypeFullDay)?[dateFormatterallday stringFromDate:_EndDate]:[dateFormatter stringFromDate:_EndDate]];
        }
    }
    else if ([indexPath section] == 2)
    {
        [Cell.textLabel setText:@"Invites"];
        [_InviteLabel setFrame:CGRectMake(100, 0, 210, 50)];
        [_InviteLabel setTextColor:[UIColor darkGrayColor]];
        [_InviteLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
        [_InviteLabel setTextAlignment:NSTextAlignmentRight];
        [_InviteLabel setText:@"Select Person"];
        [Cell.contentView addSubview:_InviteLabel];
    }
    else if ([indexPath section] == 3)
    {
        [_DescriptionTextView setFrame:CGRectMake(15, 5, 300, 190)];
        [Cell.contentView addSubview:_DescriptionTextView];
    }
    return Cell;
}
- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        _MyAppontmentType = AppointmentTypeFullDay;
    } else{
        _MyAppontmentType = AppointmentTypeNormalHour;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:1.0 animations:^(void){
        [_AddApponimentTable setContentOffset:CGPointMake(0, 320)];
    } completion:^(BOOL finished){
    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:1.0 animations:^(void){
        [_AddApponimentTable setContentOffset:CGPointMake(0, 0)];
    } completion:^(BOOL finished){
    }];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:1.0 animations:^(void){
        [_AddApponimentTable setContentOffset:CGPointMake(0, 320)];
    } completion:^(BOOL finished){
    }];
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:1.0 animations:^(void){
        [_AddApponimentTable setContentOffset:CGPointMake(0, 0)];
    } completion:^(BOOL finished){
    }];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (BOOL) textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath section] == 1) {
        if([indexPath row] == 1)
        {
            [self openDateSelectionControllerStartDate:nil];
        }
        else if([indexPath row] == 2)
        {
            [self openDateSelectionControllerEndDate:nil];
        }
    } else if ([indexPath section] == 2) {
        
        OCRInvitesViewController *InviteView = [[OCRInvitesViewController alloc] init];
        [InviteView setDelegate:self];
        [self presentViewController:InviteView animated:YES completion:nil];
        
    }
}

- (IBAction)openDateSelectionControllerStartDate:(id)sender {
    
    for(id aSubView in [self.view subviews])
    {
        if([aSubView isKindOfClass:[UITextField class]])
        {
            UITextField *textField=(UITextField*)aSubView;
            [textField resignFirstResponder];
        }
    }
    
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    dateSelectionVC.titleLabel.text = @"Please choose a date and press 'Select' or 'Cancel'.";
    dateSelectionVC.datePicker.datePickerMode = (_MyAppontmentType == AppointmentTypeNormalHour)?UIDatePickerModeDateAndTime:UIDatePickerModeDate;
    [dateSelectionVC.datePicker setMinimumDate:[NSDate date]];
    dateSelectionVC.datePicker.minuteInterval = 5;
    dateSelectionVC.datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    dateSelectionVC.datePicker.timeZone = [NSTimeZone systemTimeZone];
    _DateSelectionMode = DateSelectionModeStartDate;
    [dateSelectionVC show];
}

- (IBAction)openDateSelectionControllerEndDate:(id)sender {
    
    for(id aSubView in [self.view subviews])
    {
        if([aSubView isKindOfClass:[UITextField class]])
        {
            UITextField *textField=(UITextField*)aSubView;
            [textField resignFirstResponder];
        }
    }
    
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    dateSelectionVC.titleLabel.text = @"Please choose a date and press 'Select' or 'Cancel'.";
    dateSelectionVC.datePicker.datePickerMode = (_MyAppontmentType == AppointmentTypeNormalHour)?UIDatePickerModeDateAndTime:UIDatePickerModeDate;
    [dateSelectionVC.datePicker setMinimumDate:[NSDate date]];
    dateSelectionVC.datePicker.minuteInterval = 5;
    dateSelectionVC.datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    dateSelectionVC.datePicker.timeZone = [NSTimeZone systemTimeZone];
    _DateSelectionMode = DateSelectionModeEndDate;
    [dateSelectionVC show];
}

#pragma mark - RMDAteSelectionViewController Delegates

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyy hh:mm aa"];
    
    NSDateFormatter *dateFormatterallday = [[NSDateFormatter alloc] init];
    [dateFormatterallday setDateFormat:@"EEE,dd MMM yyy"];
    
    NSDateFormatter *dateFormatterTest = [[NSDateFormatter alloc] init];
    [dateFormatterTest setDateFormat:@"yyyy"];
    
    if (_DateSelectionMode == DateSelectionModeStartDate) {
        
        NSLog(@"Successfully selected start date: %@",[dateFormatter stringFromDate:aDate]);
        
        if ([[dateFormatterTest stringFromDate:aDate] isEqualToString:@"2001"]) {
            
            aDate = [NSDate date];
        }
        _StartDate = aDate;
        [_StartDateLabel setText:( _MyAppontmentType == AppointmentTypeFullDay)?[dateFormatterallday stringFromDate:aDate]:[dateFormatter stringFromDate:aDate]];
        
    } else {
        
        NSLog(@"Successfully selected end date: %@",[dateFormatter stringFromDate:aDate]);
        
        NSComparisonResult result = [_StartDate compare:_EndDate];
        
        if ([[dateFormatterTest stringFromDate:aDate] isEqualToString:@"2001"]) {
            
            aDate = [NSDate date];
        }
        
        [_EndDateLabel setText:( _MyAppontmentType == AppointmentTypeFullDay)?[dateFormatterallday stringFromDate:aDate]:[dateFormatter stringFromDate:aDate]];
        _EndDate = aDate;
        switch (result)
        {
            case NSOrderedAscending: NSLog(@"%@ is in future from %@", _StartDate, _EndDate); break;
            case NSOrderedDescending: NSLog(@"%@ is in past from %@", _StartDate, _EndDate); break;
            case NSOrderedSame: NSLog(@"%@ is the same as %@", _StartDate, _EndDate); break;
            default: NSLog(@"erorr dates %@, %@", _StartDate, _EndDate); break;
        }
    }
    _DateSelectionMode = DateSelectionModeNone;
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    NSLog(@"Date selection was canceled");
    _DateSelectionMode = DateSelectionModeNone;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _DateSelectionMode = DateSelectionModeNone;
}
-(NSString *)CleanTextField:(NSString *)TextfieldName
{
    NSString *Cleanvalue = [TextfieldName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return Cleanvalue;
}
@end
