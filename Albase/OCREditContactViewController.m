//
//  OCREditContactViewController.m
//  Albase
//
//  Created by Mac on 09/12/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCREditContactViewController.h"
#import "GlobalStaticData.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"
#import "NSString+PJR.h"
#import "RMPickerViewController.h"
#import "RMDateSelectionViewController.h"
#import "OCRAppDelegate.h"
#import "Person.h"
#import "OCRContactListViewController.h"

@interface OCREditContactViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,RMPickerViewControllerDelegate,RMDateSelectionViewControllerDelegate>
@property (nonatomic,retain) NSString *FirstName;
@property (nonatomic,retain) UILabel *FirstnameLabel;
@property (nonatomic,retain) UITextField *FirstnameTextField;

@property (nonatomic,retain) NSString *LastName;
@property (nonatomic,retain) UILabel *LastNameLabel;
@property (nonatomic,retain) UITextField *LastnameTextField;

@property (nonatomic,retain) NSString *UserDateOfBirth;
@property (nonatomic,retain) UILabel *UserDateOfBirthLabel;
@property (nonatomic,retain) UITextField *DateOfBirthTextField;

@property (nonatomic,retain) NSString *Gender;
@property (nonatomic,retain) UILabel *GenderLabel;
@property (nonatomic,retain) UITextField *GenderTextField;

@property (nonatomic,retain) NSString *Email;
@property (nonatomic,retain) UILabel *EmailLabel;
@property (nonatomic,retain) UITextField *EmailTextField;

@property (nonatomic,retain) NSString *UserProfileImage;
@property (nonatomic,retain) UILabel *UserProfileImageLabel;
@property (nonatomic,retain) UIImageView *UserProfileImageView;

@property (nonatomic,retain) NSString *PhoneNumber;
@property (nonatomic,retain) UILabel *PhoneNumberLabel;
@property (nonatomic,retain) UITextField *PhoneNumberTextField;

@property (nonatomic,retain) UIScrollView *mainScrollView;

@property (nonatomic,retain) UITableView *AddContactTableView;
@end

@implementation OCREditContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self=((([[UIScreen mainScreen] bounds].size.height)>500))?[super initWithNibName:@"OCREditContactViewController" bundle:nil]:[super initWithNibName:@"OCREditContactViewController4s" bundle:nil];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCREditContactViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCREditContactViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCREditContactViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCREditContactViewController6s" bundle:nil];
        }
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Edit Contact"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *NextButton = (UIButton *)[self.view viewWithTag:564];
    [NextButton addTarget:self action:@selector(RightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _mainScrollView = (UIScrollView *)[self.view viewWithTag:586];
    [_mainScrollView setBackgroundColor:[UIColor colorFromHex:0xededf2]];
    [_mainScrollView setUserInteractionEnabled:YES];
    [_mainScrollView setContentSize:CGSizeMake(self.view.layer.frame.size.width, self.view.layer.frame.size.height+300)];
    
    _FirstnameTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 50, _mainScrollView.layer.frame.size.width+2, 40)];
    [_FirstnameTextField setTag:52145];
    [_FirstnameTextField setText:[_UserDataObject Firstname]];
    [_FirstnameTextField setDelegate:self];
    [_mainScrollView addSubview:_FirstnameTextField];
    
    _FirstnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 300, 20)];
    [_FirstnameLabel setText:@"First Name"];
    [_mainScrollView addSubview:_FirstnameLabel];
    
    _LastnameTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 150, _mainScrollView.layer.frame.size.width+2, 40)];
    [_LastnameTextField setTag:52146];
    [_LastnameTextField setText:[_UserDataObject Lastname]];
    [_mainScrollView addSubview:_LastnameTextField];
    
    _LastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 120, 300, 20)];
    [_LastNameLabel setText:@"last Name"];
    [_mainScrollView addSubview:_LastNameLabel];
    
    _PhoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 250, _mainScrollView.layer.frame.size.width+2, 40)];
    [_PhoneNumberTextField setTag:52147];
    [_PhoneNumberTextField setText:[_UserDataObject UserPhoneNumber]];
    [_mainScrollView addSubview:_PhoneNumberTextField];
    
    _PhoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 220, 300, 20)];
    [_PhoneNumberLabel setText:@"Phone Number"];
    [_mainScrollView addSubview:_PhoneNumberLabel];
    
    _DateOfBirthTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 350, _mainScrollView.layer.frame.size.width+2, 40)];
    [_DateOfBirthTextField setTag:52148];
    [_DateOfBirthTextField setText:[_UserDataObject DateOfBirth]];
    [_mainScrollView addSubview:_DateOfBirthTextField];
    
    _UserDateOfBirthLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 320, 300, 20)];
    [_UserDateOfBirthLabel setText:@"Date of Birth"];
    [_mainScrollView addSubview:_UserDateOfBirthLabel];
    
    _EmailTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 450, _mainScrollView.layer.frame.size.width+2, 40)];
    [_EmailTextField setTag:52149];
    [_EmailTextField setText:[_UserDataObject Usersemail]];
    [_mainScrollView addSubview:_EmailTextField];
    
    _EmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 420, 300, 20)];
    [_EmailLabel setText:@"Email"];
    [_mainScrollView addSubview:_EmailLabel];
    
    _GenderTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 550, _mainScrollView.layer.frame.size.width+2, 40)];
    [_GenderTextField setTag:52149];
    [_GenderTextField setText:[_UserDataObject Gender]];
    [_GenderTextField setDelegate:self];
    [_mainScrollView addSubview:_GenderTextField];
    
    _GenderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 520, 300, 20)];
    [_GenderLabel setText:@"Gender"];
    [_mainScrollView addSubview:_GenderLabel];
    
    for (id DataSubView in _mainScrollView.subviews) {
        
        if ([DataSubView isKindOfClass:[UITextField class]]) {
            
            UITextField *textField=(UITextField*)DataSubView;
            [textField setDelegate:self];
            [textField setBackgroundColor:[UIColor whiteColor]];
            [textField setEnabled:YES];
            [textField.layer setBorderWidth:1.0f];
            [textField.layer setBorderColor:[UIColor colorFromHex:0xc9c8cc].CGColor];
            [textField setTextColor:[UIColor darkGrayColor]];
            [textField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
            [textField setDelegate:self];
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
            [textField setLeftView:paddingView];
            [textField setLeftViewMode:UITextFieldViewModeAlways];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
    }
    
    for (id Globallabel in _mainScrollView.subviews) {
        
        if ([Globallabel isKindOfClass:[UILabel class]]) {
            
            [Globallabel setBackgroundColor:[UIColor clearColor]];
            [Globallabel setTextColor:[UIColor colorFromHex:0x5e5e5e]];
            [Globallabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
            [Globallabel setTextAlignment:NSTextAlignmentLeft];
        }
    }
}
-(IBAction)RightSideMenuButtonPressed:(id)sender
{
    for(id aSubView in [self.view subviews])
    {
        if([aSubView isKindOfClass:[UITextField class]])
        {
            UITextField *textField=(UITextField*)aSubView;
            [textField resignFirstResponder];
        }
    }
    
    BOOL isValidate = YES;
    
    if ([self CleanTextField:[_FirstnameTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"First name can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_LastnameTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Last name can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_DateOfBirthTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Date of Birth can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_GenderTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Gender can't be blank");
        isValidate = NO;
    }
    if (isValidate) {
        
        for (id AllTextView in [self.view subviews]) {
            if ([AllTextView isKindOfClass:[UITextView class]]) {
                UITextView *MycustomTextView = (UITextView *)AllTextView;
                [MycustomTextView resignFirstResponder];
            }
        }
        NSLog(@"save note data");
            [self startSpin];
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                
                NSString *url = nil;
                url = [NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=EditUserDetails&Firstname=%@&Lastname=%@&DateOfBirth=%@&UserPhoneNumber=%@&Useremail=%@&Gender=%@&userID=%@",[[self CleanTextField:[_FirstnameTextField text]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[self CleanTextField:[_LastnameTextField text]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[self CleanTextField:[_DateOfBirthTextField text]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[self CleanTextField:[_PhoneNumberTextField text]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[self CleanTextField:[_EmailTextField text]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[self CleanTextField:[_GenderTextField text]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_UserDataObject UserId]];
                
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
                        NSArray *result = [context executeFetchRequest:request error:&error];
                        for (Person *person in result) {
                            
                            person.dateOfBirth                              =  [self CleanTextField:[_DateOfBirthTextField text]];
                            person.firstname                                =   [self CleanTextField:[_FirstnameTextField text]];
                            person.gender                                   =   [self CleanTextField:[_GenderTextField text]];
                            person.lastname                                 =   [self CleanTextField:[_LastnameTextField text]];
                            person.useremail                                =   [self CleanTextField:[_EmailTextField text]];
                            person.userPhoneNumber                          =   [self CleanTextField:[_PhoneNumberTextField text]];
                            
                        }
                        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Contact saved successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [Alert setTag:11452];
                        [Alert show];
                    } else {
                        ShowAlert(@"Error", @"Unable to save contact details, please try again later");
                    }
                });
            });
    }
}
-(NSString *)CleanTextField:(NSString *)TextfieldName
{
    NSString *Cleanvalue = [TextfieldName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return Cleanvalue;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing --- %ld",(long)textField.tag);
    
    [UIView animateWithDuration:1.0 animations:^(void){
        switch (textField.tag) {
            case 52146:
                [_mainScrollView setContentOffset:CGPointMake(0, 180) animated:YES];
                break;
            case 52147:
                [_mainScrollView setContentOffset:CGPointMake(0, 220) animated:YES];
                break;
            case 52148:
                [_mainScrollView setContentOffset:CGPointMake(0, 260) animated:YES];
                break;
            case 52149:
                [_mainScrollView setContentOffset:CGPointMake(0, 300) animated:YES];
                break;
        }
    } completion:nil];
    
    if (textField == _DateOfBirthTextField) {
        [textField resignFirstResponder];
        [self openDateSelectionController:nil];
    }
    if (textField == _GenderTextField) {
        [textField resignFirstResponder];
        [self openPickerController:nil];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (BOOL) textFieldShouldReturn:(UITextField*)textField {
    
    [UIView animateWithDuration:1.0 animations:^(void){
        [_AddContactTableView setContentOffset:CGPointMake(0, 0)];
    } completion:nil];
    [textField resignFirstResponder];
    return YES;
    
}
-(NSString *)RemoveSpecialCharacterFromString:(NSString *)DataString
{
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    NSString *resultString = [[DataString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    return resultString;
    
}
- (void)leftSideMenuButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma Add calenderview

- (IBAction)openDateSelectionController:(id)sender {
    
    for(id aSubView in [_mainScrollView subviews])
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
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
    //dateSelectionVC.datePicker.maximumDate = [NSDate date];
    dateSelectionVC.datePicker.minuteInterval = 5;
    [dateSelectionVC show];
    
    for(id aSubView in [_mainScrollView subviews])
    {
        if([aSubView isKindOfClass:[UITextField class]])
        {
            UITextField *textField=(UITextField*)aSubView;
            [textField resignFirstResponder];
        }
    }
}

#pragma mark - RMDAteSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    
    NSArray *SelectedDate = [[NSString stringWithFormat:@"%@",aDate] componentsSeparatedByString:@" "];
    
    [_DateOfBirthTextField setText:[SelectedDate objectAtIndex:0]];
    NSLog(@"Successfully selected date: %@", aDate);
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    NSLog(@"Date selection was canceled");
}

#pragma mark - RMPickerViewController Delegates

- (IBAction)openPickerController:(id)sender {
    
    for(id aSubView in [self.view subviews])
    {
        if([aSubView isKindOfClass:[UITextField class]])
        {
            UITextField *textField=(UITextField*)aSubView;
            [textField resignFirstResponder];
        }
    }
    
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.delegate = self;
    pickerVC.titleLabel.text = @"Please choose a row and press 'Select' or 'Cancel'.";
    [pickerVC show];
}

- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows {
    
    NSLog(@"Successfully selected rows: %@", [selectedRows objectAtIndex:0]);
    
    [_GenderTextField setText:([[selectedRows objectAtIndex:0] intValue] == 0)?@"Male":@"Female"];
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc {
    NSLog(@"Selection was canceled");
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"Male";
    } else {
        return @"Female";
    }
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11452) {
        OCRContactListViewController *ContactList = [[OCRContactListViewController alloc] init];
        [self.navigationController pushViewController:ContactList animated:YES];
    }
}

#pragma match scrollview dragging

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for(id aSubView in [_mainScrollView subviews])
    {
        if([aSubView isKindOfClass:[UITextField class]])
        {
            UITextField *textField=(UITextField*)aSubView;
            [textField resignFirstResponder];
        }
    }
}

@end
