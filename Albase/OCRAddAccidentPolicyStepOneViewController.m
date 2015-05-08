//
//  OCRAddAccidentPolicyStepOneViewController.m
//  Albase
//
//  Created by Mac on 27/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRAddAccidentPolicyStepOneViewController.h"
#import "GlobalStaticData.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"
#import "OCRAddAccidentPolicyStepTwoViewController.h"
#import "NSString+PJR.h"
#import "RMPickerViewController.h"
#import "RMDateSelectionViewController.h"

@interface OCRAddAccidentPolicyStepOneViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,RMPickerViewControllerDelegate,RMDateSelectionViewControllerDelegate>
{
    CGRect mainFrame;
}

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

@property (nonatomic,retain) NSString *PolicyNumber;
@property (nonatomic,retain) UILabel *PolicyNumberLabel;
@property (nonatomic,retain) UITextField *PolicyNumberTextField;

@property (nonatomic,retain) UIScrollView *mainScrollView;

@property (nonatomic,retain) UITableView *AddContactTableView;
@end

@implementation OCRAddAccidentPolicyStepOneViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // self=[super initWithNibName:GlobalViewControllerData.ScanAccidentPolicyStepOne bundle:nil];
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRAddAccidentPolicyStepOneViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRAddAccidentPolicyStepOneViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRAddAccidentPolicyStepOneViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRAddAccidentPolicyStepOneViewController6s" bundle:nil];
        }
    }
    mainFrame = [[UIScreen mainScreen] bounds];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Add Contact"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *NextButton = (UIButton *)[self.view viewWithTag:564];
    [NextButton addTarget:self action:@selector(RightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //    _AddContactTableView = (UITableView *)[self.view viewWithTag:752];
    //    [_AddContactTableView setDelegate:self];
    //    [_AddContactTableView setDataSource:self];
    
    _PolicyNumber = [self CleanTextField:[_DataModel AccidentPolicyNumber]];
    
    /**
     *
     */
    
    @try {
        NSString *UserFullName = [self CleanTextField:[_DataModel AccidentName]];
        NSString *newString = [UserFullName stringByReplacingOccurrencesOfString:@": " withString:@"" options: NSRegularExpressionSearch range:NSMakeRange(0, UserFullName.length)];
        
        NSArray *NameSplit      = [newString componentsSeparatedByString:@" "];
        _FirstName = [NameSplit objectAtIndex:0];
    }
    @catch (NSException *exception) {
        _FirstName = nil;
        NSLog(@"first name Split exception");
    }
    
    /**
     *
     */
    
    @try {
        
        NSString *UserFullName = [self CleanTextField:[_DataModel AccidentName]];
        NSLog(@"username ===== %@",[_DataModel AccidentName]);
        
        NSString *newString = [UserFullName stringByReplacingOccurrencesOfString:@": " withString:@"" options: NSRegularExpressionSearch range:NSMakeRange(0, UserFullName.length)];
        
        NSArray *NameSplit      = [newString componentsSeparatedByString:@" "];
        NSLog(@"NameSplit ---- %@",NameSplit);
        NSArray *SecondndNameSplit = [UserFullName componentsSeparatedByString:[NameSplit objectAtIndex:0]];
        _LastName = [SecondndNameSplit objectAtIndex:1];
        
    }
    @catch (NSException *exception) {
        
        _LastName = nil;
        NSLog(@"second name Split exception");
    }
    
    /**
     *
     */
    
    _PhoneNumber = nil;
    
    /**
     *
     */
    
    _Email = nil;
    
    /**
     *
     */
    
    @try {
        NSString *CleanedString = [self RemoveSpecialCharacterFromString:[self CleanTextField:[_DataModel AccidentDOB]]];
        NSLog(@"CleanedString ===== %@",CleanedString);
        NSArray *DOBArray = [CleanedString componentsSeparatedByString:@"-"];
        NSLog(@"DOBArray ===== %@",DOBArray);
        NSString *DateOfBirth = nil;
        
        if ([[DOBArray objectAtIndex:1] rangeOfString:@"Jan"
                                              options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
            != NSNotFound)
        {
            DateOfBirth = @"01";
        } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Feb"
                                                     options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                   != NSNotFound)
        {
            DateOfBirth = @"02";
        } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"March"
                                                     options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                   != NSNotFound)
        {
            DateOfBirth = @"03";
        } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"April"
                                                     options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                   != NSNotFound)
        {
            DateOfBirth = @"04";
        } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"May"
                                                     options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                   != NSNotFound)
        {
            DateOfBirth = @"05";
        } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"June"
                                                     options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                   != NSNotFound)
        {
            DateOfBirth = @"06";
        } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"July"
                                                     options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                   != NSNotFound)
        {
            DateOfBirth = @"07";
        } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Aug"
                                                     options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                   != NSNotFound)
        {
            DateOfBirth = @"08";
        } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Sep"
                                                     options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                   != NSNotFound)
        {
            DateOfBirth = @"09";
        } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Oct"
                                                     options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                   != NSNotFound)
        {
            DateOfBirth = @"10";
        } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Nov"
                                                     options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                   != NSNotFound)
        {
            DateOfBirth = @"11";
        } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Dec"
                                                     options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                   != NSNotFound)
        {
            DateOfBirth = @"12";
        } else {
            DateOfBirth = @"00";
        }
        
        NSString *SplitedYear = [self CleanTextField:[DOBArray objectAtIndex:2]];
        /*
        NSString *yeardata = nil;
        if ([SplitedYear intValue]<30) {
            yeardata = [NSString stringWithFormat:@"20%d",[SplitedYear intValue]];
        } else {
            yeardata = [NSString stringWithFormat:@"19%d",[SplitedYear intValue]];
        }
        */
        
        NSString *FullDateOfBirth = [NSString stringWithFormat:@"%@-%@-%@",SplitedYear,DateOfBirth,[DOBArray objectAtIndex:0]];
        _UserDateOfBirth = FullDateOfBirth;
    }
    @catch (NSException *exception) {
        _UserDateOfBirth = @"0000-00-00";
    }
    
    /**
     *
     */
    
    _Gender = [self CharaterRecognizer:[_DataModel AccidentGender]];
    
    _mainScrollView = (UIScrollView *)[self.view viewWithTag:586];
    [_mainScrollView setBackgroundColor:[UIColor colorFromHex:0xededf2]];
    [_mainScrollView setUserInteractionEnabled:YES];
    [_mainScrollView setContentSize:CGSizeMake(mainFrame.size.width, 2000)];
    
    NSLog(@"_mainScrollView ======== %f",_mainScrollView.layer.frame.size.height);
    
    float NextTextfieldYcord = 50;
    float NextlabelfieldYcord = 20;
    
    _PolicyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, NextlabelfieldYcord, mainFrame.size.width-20, 20)];
    [_PolicyNumberLabel setText:@"Policy Number"];
    [_mainScrollView addSubview:_PolicyNumberLabel];
    
    NextlabelfieldYcord = NextlabelfieldYcord + 100;
    
    _PolicyNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, NextTextfieldYcord, mainFrame.size.width+2, 40)];
    [_PolicyNumberTextField setTag:52144];
    [_PolicyNumberTextField setText:_PolicyNumber];
    [_PolicyNumberTextField setDelegate:self];
    [_mainScrollView addSubview:_PolicyNumberTextField];
    
    NextTextfieldYcord = NextTextfieldYcord + 100;
    
    _FirstnameTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, NextTextfieldYcord, mainFrame.size.width+2, 40)];
    [_FirstnameTextField setTag:52145];
    [_FirstnameTextField setText:_FirstName];
    [_FirstnameTextField setDelegate:self];
    [_mainScrollView addSubview:_FirstnameTextField];
    
    NextTextfieldYcord = NextTextfieldYcord + 100;
    
    _FirstnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, NextlabelfieldYcord, mainFrame.size.width-20, 20)];
    [_FirstnameLabel setText:@"First Name"];
    [_mainScrollView addSubview:_FirstnameLabel];
    
     NextlabelfieldYcord = NextlabelfieldYcord + 100;
    
    _LastnameTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, NextTextfieldYcord, mainFrame.size.width+2, 40)];
    [_LastnameTextField setTag:52146];
    [_LastnameTextField setText:_LastName];
    [_mainScrollView addSubview:_LastnameTextField];
    
    NextTextfieldYcord = NextTextfieldYcord + 100;
    
    _LastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, NextlabelfieldYcord, mainFrame.size.width, 20)];
    [_LastNameLabel setText:@"last Name"];
    [_mainScrollView addSubview:_LastNameLabel];
    
     NextlabelfieldYcord = NextlabelfieldYcord + 100;
    
    _PhoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, NextTextfieldYcord, mainFrame.size.width+2, 40)];
    [_PhoneNumberTextField setTag:52147];
    [_PhoneNumberTextField setText:_PhoneNumber];
    [_mainScrollView addSubview:_PhoneNumberTextField];
    
    NextTextfieldYcord = NextTextfieldYcord + 100;
    
    _PhoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, NextlabelfieldYcord, mainFrame.size.width, 20)];
    [_PhoneNumberLabel setText:@"Phone Number"];
    [_mainScrollView addSubview:_PhoneNumberLabel];
    
     NextlabelfieldYcord = NextlabelfieldYcord + 100;
    
    _DateOfBirthTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, NextTextfieldYcord,mainFrame.size.width+2, 40)];
    [_DateOfBirthTextField setTag:52148];
    [_DateOfBirthTextField setText:_UserDateOfBirth];
    [_mainScrollView addSubview:_DateOfBirthTextField];
    
    NextTextfieldYcord = NextTextfieldYcord + 100;
    
    _UserDateOfBirthLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, NextlabelfieldYcord, mainFrame.size.width, 20)];
    [_UserDateOfBirthLabel setText:@"Date of Birth"];
    [_mainScrollView addSubview:_UserDateOfBirthLabel];
    
     NextlabelfieldYcord = NextlabelfieldYcord + 100;
    
    _EmailTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, NextTextfieldYcord, mainFrame.size.width+2, 40)];
    [_EmailTextField setTag:52149];
    [_EmailTextField setText:_Email];
    [_mainScrollView addSubview:_EmailTextField];
    
    NextTextfieldYcord = NextTextfieldYcord + 100;
    
    _EmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, NextlabelfieldYcord, mainFrame.size.width, 20)];
    [_EmailLabel setText:@"Email"];
    [_mainScrollView addSubview:_EmailLabel];
    
     NextlabelfieldYcord = NextlabelfieldYcord + 100;
    
    _GenderTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, NextTextfieldYcord, mainFrame.size.width+2, 40)];
    [_GenderTextField setTag:52149];
    [_GenderTextField setText:_Gender];
    [_GenderTextField setDelegate:self];
    [_mainScrollView addSubview:_GenderTextField];
    
    NextTextfieldYcord = NextTextfieldYcord + 100;
    
    _GenderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, NextlabelfieldYcord, mainFrame.size.width, 20)];
    [_GenderLabel setText:@"Gender"];
    [_mainScrollView addSubview:_GenderLabel];
    
     NextlabelfieldYcord = NextlabelfieldYcord + 100;
    
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
    
    [_mainScrollView setContentSize:CGSizeMake(self.view.layer.frame.size.width, NextTextfieldYcord)];
    
}
-(NSString *)CharaterRecognizer:(NSString *)DataString
{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@":"];
    return [self CleanTextField:[[DataString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""]];
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
    
    if ([self CleanTextField:[_PolicyNumberTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Policy Number can't be blank");
        isValidate = NO;
    }
    else if ([self CleanTextField:[_FirstnameTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"First name can't be blank");
        isValidate = NO;
    }
    else if ([self CleanTextField:[_LastnameTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Last name can't be blank");
        isValidate = NO;
    }
    /*
    else if ([self CleanTextField:[_PhoneNumberTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Phone Number can't be blank");
        isValidate = NO;
    } 
    */
    else if ([self CleanTextField:[_DateOfBirthTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Date of Birth can't be blank");
        isValidate = NO;
    }
    /*
    else if ([self CleanTextField:[_EmailTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Email can't be blank");
        isValidate = NO;
    }
    */
    else if ([self CleanTextField:[_GenderTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Gender can't be blank");
        isValidate = NO;
    }
    /*
    else if (![[self CleanTextField:[_EmailTextField text]] isEmail]) {
        ShowAlert(@"Validation Error", @"Email is not valied");
        isValidate = NO;
    }  else if (![[self CleanTextField:[_PhoneNumberTextField text]] isPhoneNumber]) {
        ShowAlert(@"Validation Error", @"Phone number not valied");
        isValidate = NO;
    }
    */
    if (isValidate) {
        
        EditableUserData *EditeData = [[EditableUserData alloc] initWithUserFirstName:[self CleanTextField:_FirstnameTextField.text] UserlastName:[self CleanTextField:_LastnameTextField.text] UsersEmail:[self CleanTextField:_EmailTextField.text] UserPhoneNumber:[self CleanTextField:_PhoneNumberTextField.text] UserDateOfBirth:_DateOfBirthTextField.text UserGender:_GenderTextField.text UserPolicyNumber:[self CleanTextField:_PolicyNumberTextField.text]];

        OCRAddAccidentPolicyStepTwoViewController *RedirectView = [[OCRAddAccidentPolicyStepTwoViewController alloc] init];
        RedirectView.DataModel = self.DataModel;
        RedirectView.UserEditedData = EditeData;
        [self.navigationController pushViewController:RedirectView animated:YES];
    }
}
#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 6;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
-(NSString *)CleanTextField:(NSString *)TextfieldName
{
    NSString *Cleanvalue = [TextfieldName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return Cleanvalue;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0 || section == 1 || section == 3 || section == 5) {
        return 44;
    } else {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *viewFotter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.layer.frame.size.width, 44)];
    [viewFotter setBackgroundColor:[UIColor clearColor]];
    
    /*
     */
    
    UILabel *Footerlabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 40)];
    [Footerlabel setBackgroundColor:[UIColor clearColor]];
    [Footerlabel setTextColor:[UIColor darkGrayColor]];
    [Footerlabel setTextAlignment:NSTextAlignmentRight];
    [Footerlabel setNumberOfLines:0];
    [Footerlabel setFont:[UIFont fontWithName:@"Helvetica" size:11.0f]];
    [viewFotter addSubview:Footerlabel];
    switch (section) {
        case 0:
            [Footerlabel setText:@"Select switch if Firstname isn't right"];
            break;
        case 1:
            [Footerlabel setText:@"Select switch if Lastname isn't right"];
            break;
        case 3:
            [Footerlabel setText:@"Select switch if Date of Birth isn't right"];
            break;
        case 5:
            [Footerlabel setText:@"Switch is green for male and white for female"];
            break;
        default:
            [Footerlabel setText:@""];
            break;
    }
    /*
     */
    
    return viewFotter;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _GenderTextField || textField == _DateOfBirthTextField) {
        
        [self.view endEditing:YES];
        
        if (textField == _GenderTextField) {
            [self openPickerController:nil];
        } else if (textField == _DateOfBirthTextField) {
            [self openDateSelectionController:nil];
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
    [UIView animateWithDuration:1.0 animations:^(void){
        switch (textField.tag) {
            case 52146:
                [_mainScrollView setContentOffset:CGPointMake(0, 150)];
                break;
            case 52147:
                [_mainScrollView setContentOffset:CGPointMake(0, 180)];
                break;
            case 52148:
                [_mainScrollView setContentOffset:CGPointMake(0, 200)];
                break;
            case 52149:
                [_mainScrollView setContentOffset:CGPointMake(0, 330)];
                break;
            case 52150:
                [_mainScrollView setContentOffset:CGPointMake(0, 280)];
                break;
            case 52151:
                [_mainScrollView setContentOffset:CGPointMake(0, 320)];
                break;
        }
    } completion:nil];
    
  /**  if (textField == _DateOfBirthTextField) {
        [textField resignFirstResponder];
        [self openDateSelectionController:nil];
    }
    if (textField == _GenderTextField) {
        [textField resignFirstResponder];
        [self openPickerController:nil];
    }
   */
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    [textField resignFirstResponder];
}
- (BOOL) textFieldShouldReturn:(UITextField*)textField {
   
    [textField resignFirstResponder];
    NSLog(@"textFieldShouldReturn");
    return YES;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[ContactList Firstname],[ContactList Lastname]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 3) {
        
        UISwitch *dataSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(260, 10, 70, 30)];
        [dataSwitch setBackgroundColor:[UIColor clearColor]];
        [dataSwitch setTag:(12546+indexPath.section)];
        [dataSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
        [dataSwitch setUserInteractionEnabled:YES];
        [cell.contentView addSubview:dataSwitch];
    }
    
    if (indexPath.section == 0) {
        
        _FirstnameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
        [_FirstnameTextField setBackgroundColor:[UIColor whiteColor]];
        [_FirstnameTextField setEnabled:NO];
        [_FirstnameTextField setTag:52145];
        [_FirstnameTextField setTextColor:[UIColor darkGrayColor]];
        [_FirstnameTextField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [_FirstnameTextField setDelegate:self];
        [cell.contentView addSubview:_FirstnameTextField];
        
        NSLog(@"user name ---- %@",[_DataModel AccidentName]);
        
        @try {
            NSString *UserFullName = [self CleanTextField:[_DataModel AccidentName]];
            NSString *newString = [UserFullName stringByReplacingOccurrencesOfString:@": " withString:@"" options: NSRegularExpressionSearch range:NSMakeRange(0, UserFullName.length)];
            
            NSArray *NameSplit      = [newString componentsSeparatedByString:@" "];
            [_FirstnameTextField setText:[NameSplit objectAtIndex:0]];
        }
        @catch (NSException *exception) {
            NSLog(@"first name Split exception");
        }
        
    } else if (indexPath.section == 1) {
        
        _LastnameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
        [_LastnameTextField setBackgroundColor:[UIColor whiteColor]];
        [_LastnameTextField setEnabled:NO];
        [_LastnameTextField setTag:52146];
        [_LastnameTextField setTextColor:[UIColor darkGrayColor]];
        [_LastnameTextField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [_LastnameTextField setDelegate:self];
        [cell.contentView addSubview:_LastnameTextField];
        
        @try {
            NSString *UserFullName = [self CleanTextField:[_DataModel AccidentName]];
            NSLog(@"username ===== %@",[_DataModel AccidentName]);
            
            NSString *newString = [UserFullName stringByReplacingOccurrencesOfString:@": " withString:@"" options: NSRegularExpressionSearch range:NSMakeRange(0, UserFullName.length)];
            
            NSArray *NameSplit      = [newString componentsSeparatedByString:@" "];
            NSLog(@"NameSplit ---- %@",NameSplit);
            NSArray *SecondndNameSplit = [UserFullName componentsSeparatedByString:[NameSplit objectAtIndex:0]];
            [_LastnameTextField setText:[SecondndNameSplit objectAtIndex:1]];
            
        }
        @catch (NSException *exception) {
            NSLog(@"second name Split exception");
        }
        
    } else if (indexPath.section == 2) {
        
        _PhoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
        [_PhoneNumberTextField setBackgroundColor:[UIColor whiteColor]];
        [_PhoneNumberTextField setEnabled:YES];
        [_PhoneNumberTextField setDelegate:self];
        [_PhoneNumberTextField setTag:52147];
        [_PhoneNumberTextField setPlaceholder:@"Add Phonenumber"];
        [_PhoneNumberTextField setTextColor:[UIColor darkGrayColor]];
        [_PhoneNumberTextField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [cell.contentView addSubview:_PhoneNumberTextField];
        
    } else if (indexPath.section == 3) {
        
        _DateOfBirthTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
        [_DateOfBirthTextField setBackgroundColor:[UIColor whiteColor]];
        [_DateOfBirthTextField setEnabled:NO];
        [_DateOfBirthTextField setTag:52148];
        [_DateOfBirthTextField setTextColor:[UIColor darkGrayColor]];
        [_DateOfBirthTextField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [cell.contentView addSubview:_DateOfBirthTextField];
        
        @try {
            NSString *CleanedString = [self RemoveSpecialCharacterFromString:[self CleanTextField:[_DataModel AccidentDOB]]];
            NSLog(@"CleanedString ===== %@",CleanedString);
            NSArray *DOBArray = [CleanedString componentsSeparatedByString:@"-"];
            NSLog(@"DOBArray ===== %@",DOBArray);
            NSString *DateOfBirth = nil;
            
            if ([[DOBArray objectAtIndex:1] rangeOfString:@"Jan"
                                                  options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                != NSNotFound)
            {
                DateOfBirth = @"01";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Feb"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"02";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"March"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"03";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"April"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"04";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"May"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"05";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"June"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"06";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"July"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"07";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Aug"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"08";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Sep"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"09";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Oct"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"10";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Nov"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"11";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Dec"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"12";
            } else {
                DateOfBirth = @"00";
            }
            
            NSString *SplitedYear = [self CleanTextField:[DOBArray objectAtIndex:2]];
            NSString *yeardata = nil;
            if ([SplitedYear intValue]<30) {
                yeardata = [NSString stringWithFormat:@"20%d",[SplitedYear intValue]];
            } else {
                yeardata = [NSString stringWithFormat:@"19%d",[SplitedYear intValue]];
            }
            
            NSString *FullDateOfBirth = [NSString stringWithFormat:@"%@-%@-%@",[DOBArray objectAtIndex:0],DateOfBirth,yeardata];
            
            [_DateOfBirthTextField setDelegate:self];
            [_DateOfBirthTextField setText:FullDateOfBirth];
        }
        @catch (NSException *exception) {
            [_DateOfBirthTextField setText:@"00-00-0000"];
        }
        
    } else if (indexPath.section ==4) {
        
        _EmailTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
        [_EmailTextField setBackgroundColor:[UIColor whiteColor]];
        [_EmailTextField setTextColor:[UIColor darkGrayColor]];
        [_EmailTextField setPlaceholder:@"Add Email"];
        [_EmailTextField setEnabled:YES];
        [_EmailTextField setTag:52149];
        [_EmailTextField setDelegate:self];
        [_EmailTextField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [cell.contentView addSubview:_EmailTextField];
        
    } else if (indexPath.section == 5) {
        
        _GenderTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
        [_GenderTextField setBackgroundColor:[UIColor whiteColor]];
        [_GenderTextField setEnabled:NO];
        [_GenderTextField setTag:52150];
        [_GenderTextField setTextColor:[UIColor darkGrayColor]];
        [_GenderTextField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [_GenderTextField setDelegate:self];
        [_GenderTextField setText:[_DataModel AccidentGender]];
        [cell.contentView addSubview:_GenderTextField];
        
    }
    
    return cell;
}
-(NSString *)RemoveSpecialCharacterFromString:(NSString *)DataString
{
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    NSString *resultString = [[DataString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    return resultString;
    
}
-(IBAction)switchIsChanged:(UISwitch *)sender
{
    if (sender.tag == 12546) {
        if ([sender isOn]){
            [_FirstnameTextField setEnabled:YES];
        } else {
            [_FirstnameTextField setEnabled:NO];
        }
    } else if (sender.tag == 12547) {
        if ([sender isOn]){
            [_LastnameTextField setEnabled:YES];
        } else {
            [_LastnameTextField setEnabled:NO];
        }
    } else if (sender.tag == 12548) {
        if ([sender isOn]){
            [_PhoneNumberTextField setEnabled:YES];
        } else {
            [_PhoneNumberTextField setEnabled:NO];
        }
    } else if (sender.tag == 12549) {
        if ([sender isOn]){
            [_DateOfBirthTextField setEnabled:YES];
        } else {
            [_DateOfBirthTextField setEnabled:NO];
        }
    } else if (sender.tag == 12550) {
        if ([sender isOn]){
            [_EmailTextField setEnabled:YES];
        } else {
            [_EmailTextField setEnabled:NO];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
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
        [TitleLabel setText:@"First name"];
    } else if (section == 1) {
        [TitleLabel setText:@"Last name"];
    } else if (section == 2) {
        [TitleLabel setText:@"Phone Number"];
    } else if (section == 3) {
        [TitleLabel setText:@"Date of Birth"];
    } else if (section == 4) {
        [TitleLabel setText:@"Email"];
    }
    return Headerview;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)leftSideMenuButtonPressed:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        NSLog(@"Menu bar button prassed..");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma Add calenderview

- (IBAction)openDateSelectionController:(id)sender {
    
    for(id aSubView in [self.view subviews])
    {
        if([aSubView isKindOfClass:[UITextField class]])
        {
            UITextField *textField=(UITextField*)aSubView;
            [textField resignFirstResponder];
        }
    }
    [self.view endEditing:YES];
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    dateSelectionVC.titleLabel.text = @"Please choose a date and press 'Select' or 'Cancel'.";
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
   // dateSelectionVC.datePicker.maximumDate = [NSDate date];
    dateSelectionVC.datePicker.minuteInterval = 5;
    [dateSelectionVC show];
}

#pragma mark - RMDAteSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    
    NSArray *SelectedDate = [[NSString stringWithFormat:@"%@",aDate] componentsSeparatedByString:@" "];
    [self.view endEditing:YES];
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
    [self.view endEditing:YES];
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.delegate = self;
    pickerVC.titleLabel.text = @"Please choose a row and press 'Select' or 'Cancel'.";
    [pickerVC show];
}

- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows {
    
    NSLog(@"Successfully selected rows: %@", [selectedRows objectAtIndex:0]);
    [self.view endEditing:YES];
    [_GenderTextField setText:([[selectedRows objectAtIndex:0] intValue] == 0)?@"Male":@"Female"];
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc {
    NSLog(@"Selection was canceled");
    [self.view endEditing:YES];
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

@end
