//
//  OCRAddInsuranceViewController.m
//  AlbaseNew
//
//  Created by Mac on 03/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRAddInsuranceViewController.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"
#import "NSString+PJR.h"
#import "OCRContactListViewController.h"
#import "OCRAppDelegate.h"
#import "Person.h"

typedef enum {
    dateFieldTypeNone,
    dateFieldTypePolicyDate,
    dateFieldTypePaidTodate,
    dateFieldTypePayUpDate,
    dateFieldTypeMaturityDate,
    dateFieldTypeBillTodate
} DateTextFieldType;

typedef enum {
    OptionSelectionTypeNone,
    OptionSelectionTypeStatus,
    OptionSelectionTypeIssueAge,
    OptionSelectionTypePaymentMode,
    OptionSelectionTypePaymentMethod
} OptionSelectionType;

@interface OCRAddInsuranceViewController ()
{
    CGRect mainFrame;
}

@property (nonatomic,retain) UITableView *InsurenceDataTable;
@property (nonatomic,retain) NSMutableDictionary *InsurenceData;

@property (nonatomic,retain) NSString *Status;
@property (nonatomic,retain) UILabel *StatusLabel;
@property (nonatomic,retain) UITextField *StatusTextField;

@property (nonatomic,retain) NSString *PolicyDate;
@property (nonatomic,retain) UILabel *PolicyDateLabel;
@property (nonatomic,retain) UITextField *PolicyDateTextField;

@property (nonatomic,retain) NSString *PaidToDate;
@property (nonatomic,retain) UILabel *PaidToDateLabel;
@property (nonatomic,retain) UITextField *PaidToDateTextField;

@property (nonatomic,retain) NSString *ModalPremium;
@property (nonatomic,retain) UILabel *ModalPremiumLabel;
@property (nonatomic,retain) UITextField *ModalPremiumTextField;

@property (nonatomic,retain) NSString *NextModalPremium;
@property (nonatomic,retain) UILabel *NextModalPremiumLabel;
@property (nonatomic,retain) UITextField *NextModalPremiumTextField;

@property (nonatomic,retain) NSString *PayUpDate;
@property (nonatomic,retain) UILabel *PayUpDateLabel;
@property (nonatomic,retain) UITextField *PayUpDateTextField;

@property (nonatomic,retain) NSString *MaturityDate;
@property (nonatomic,retain) UILabel *MaturityDateLabel;
@property (nonatomic,retain) UITextField *MaturityDateTextField;

@property (nonatomic,retain) NSString *InsuredAddress;
@property (nonatomic,retain) UILabel *InsuredAddressLabel;
@property (nonatomic,retain) UITextField *InsuredAddressTextField;

@property (nonatomic,retain) NSString *AdjustedPremium;
@property (nonatomic,retain) UILabel *AdjustedPremiumLabel;
@property (nonatomic,retain) UITextField *AdjustedPremiumTextField;

@property (nonatomic,retain) NSString *NRIC;
@property (nonatomic,retain) UILabel *NRICLabel;
@property (nonatomic,retain) UITextField *NRICTextField;

@property (nonatomic,retain) NSString *IssueAge;
@property (nonatomic,retain) UILabel *IssueAgeLabel;
@property (nonatomic,retain) UITextField *IssueAgeTextField;

@property (nonatomic,retain) NSString *Owner;
@property (nonatomic,retain) UILabel *OwnerLabel;
@property (nonatomic,retain) UITextField *OwnerTextField;

@property (nonatomic,retain) NSString *PaymentMode;
@property (nonatomic,retain) UILabel *PaymentModeLabel;
@property (nonatomic,retain) UITextField *PaymentModeTextField;

@property (nonatomic,retain) NSString *PaymentMothod;
@property (nonatomic,retain) UILabel *PaymentMothodLabel;
@property (nonatomic,retain) UITextField *PaymentMothodTextField;

@property (nonatomic,retain) NSString *BillToDate;
@property (nonatomic,retain) UILabel *BillToDateLabel;
@property (nonatomic,retain) UITextField *BillToDateTextField;

@property (assign) DateTextFieldType OpenDateType;

@property (assign) OptionSelectionType OpenSelectionType;

@property (nonatomic,retain) UIScrollView *mainScrollView;

@end

@implementation OCRAddInsuranceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self=(IsIphone5)?[super initWithNibName:@"OCRAddInsuranceViewController" bundle:nil]:[super initWithNibName:@"OCRAddInsuranceViewController4s" bundle:nil];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRAddInsuranceViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRAddInsuranceViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRAddInsuranceViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRAddInsuranceViewController6s" bundle:nil];
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
    [Titlelabel setText:@"Add Insurance Data"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveButton = (UIButton *)[self.view viewWithTag:112];
    [saveButton addTarget:self action:@selector(RightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"------- %@------- %@------- %@------- %@------- %@------- %@",[_UserEditedData UserFirstName],[_UserEditedData UserlastName],[_UserEditedData UsersEmail],[_UserEditedData UserDateOfBirth],[_UserEditedData UserGender],[_UserEditedData UserPhoneNumber]);
    
    /*
    _InsurenceDataTable = (UITableView *)[self.view viewWithTag:752];
    [_InsurenceDataTable setDelegate:self];
    [_InsurenceDataTable setDataSource:self];
     */
    
    _OpenDateType = dateFieldTypeNone;
    _OpenSelectionType = OptionSelectionTypeNone;
    
    _mainScrollView = (UIScrollView *)[self.view viewWithTag:586];
    [_mainScrollView setBackgroundColor:[UIColor colorFromHex:0xededf2]];
    [_mainScrollView setUserInteractionEnabled:YES];
    [_mainScrollView setDelegate:self];
    [_mainScrollView setContentSize:CGSizeMake(mainFrame.size.width, 1620)];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _StatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, mainFrame.size.width, 20)];
    [_StatusLabel setText:@"Status"];
    [_mainScrollView addSubview:_StatusLabel];
    
    _StatusTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 50, mainFrame.size.width+2, 40)];
    [_StatusTextField setTag:52149];
    [_StatusTextField setText:[self RemoveSpecialCharacter:[_DataModel Status]]];
    [_mainScrollView addSubview:_StatusTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _PolicyDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 120, mainFrame.size.width, 20)];
    [_PolicyDateLabel setText:@"Policy Date"];
    [_mainScrollView addSubview:_PolicyDateLabel];
    
    _PolicyDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 150, mainFrame.size.width+2, 40)];
    [_PolicyDateTextField setTag:52150];
    [_PolicyDateTextField setText:[self ChangedateFormat:[self RemoveSpecialCharacter:[_DataModel PolicyDate]]]];
    [_mainScrollView addSubview:_PolicyDateTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _PaidToDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 220, mainFrame.size.width, 20)];
    [_PaidToDateLabel setText:@"Paid to Date"];
    [_mainScrollView addSubview:_PaidToDateLabel];
    
    _PaidToDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 250, mainFrame.size.width+2, 40)];
    [_PaidToDateTextField setTag:52151];
    [_PaidToDateTextField setText:[self ChangedateFormat:[self RemoveSpecialCharacter:[_DataModel PaidToDate]]]];
    [_mainScrollView addSubview:_PaidToDateTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _ModalPremiumLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 320, mainFrame.size.width, 20)];
    [_ModalPremiumLabel setText:@"Modal Premium"];
    [_mainScrollView addSubview:_ModalPremiumLabel];
    
    _ModalPremiumTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 350, mainFrame.size.width+2, 40)];
    [_ModalPremiumTextField setTag:52152];
    [_ModalPremiumTextField setText:[self RemoveSpecialCharacter:[_DataModel ModalPremium]]];
    [_mainScrollView addSubview:_ModalPremiumTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _NextModalPremiumLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 420, mainFrame.size.width, 20)];
    [_NextModalPremiumLabel setText:@"Next Modal Premium"];
    [_mainScrollView addSubview:_NextModalPremiumLabel];
    
    _NextModalPremiumTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 450, mainFrame.size.width+2, 40)];
    [_NextModalPremiumTextField setTag:52153];
    [_NextModalPremiumTextField setText:[self RemoveSpecialCharacter:[_DataModel NextModalPremium]]];
    [_mainScrollView addSubview:_NextModalPremiumTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _PayUpDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 520, mainFrame.size.width, 20)];
    [_PayUpDateLabel setText:@"Pay Up Date"];
    [_mainScrollView addSubview:_PayUpDateLabel];
    
    _PayUpDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 550, mainFrame.size.width+2, 40)];
    [_PayUpDateTextField setTag:52154];
    [_PayUpDateTextField setText:[self ChangedateFormat:[self RemoveSpecialCharacter:[_DataModel PayUpDate]]]];
    [_mainScrollView addSubview:_PayUpDateTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _MaturityDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 620, mainFrame.size.width, 20)];
    [_MaturityDateLabel setText:@"Maturity Date"];
    [_mainScrollView addSubview:_MaturityDateLabel];
    
    _MaturityDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 650, mainFrame.size.width+2, 40)];
    [_MaturityDateTextField setTag:52155];
    [_MaturityDateTextField setText:[self ChangedateFormat:[self RemoveSpecialCharacter:[_DataModel MaturityDate]]]];
    [_mainScrollView addSubview:_MaturityDateTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _InsuredAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 720, mainFrame.size.width, 20)];
    [_InsuredAddressLabel setText:@"Insured Address"];
    [_mainScrollView addSubview:_InsuredAddressLabel];
    
    _InsuredAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 750, mainFrame.size.width+2, 40)];
    [_InsuredAddressTextField setTag:52156];
    [_InsuredAddressTextField setText:[self RemoveSpecialCharacter:[_DataModel InsuredAddress]]];
    [_mainScrollView addSubview:_InsuredAddressTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AdjustedPremiumLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 820, mainFrame.size.width, 20)];
    [_AdjustedPremiumLabel setText:@"Adjusted Premium"];
    [_mainScrollView addSubview:_AdjustedPremiumLabel];
    
    _AdjustedPremiumTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 850, mainFrame.size.width+2, 40)];
    [_AdjustedPremiumTextField setTag:52157];
    [_AdjustedPremiumTextField setText:[self RemoveSpecialCharacter:[_DataModel AdjustedPremium]]];
    [_mainScrollView addSubview:_AdjustedPremiumTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _NRICLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 920, mainFrame.size.width, 20)];
    [_NRICLabel setText:@"NRIC Number"];
    [_mainScrollView addSubview:_NRICLabel];
    
    _NRICTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 950, mainFrame.size.width+2, 40)];
    [_NRICTextField setTag:52158];
    [_NRICTextField setText:[self RemoveSpecialCharacter:[_DataModel NRIC]]];
    [_mainScrollView addSubview:_NRICTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _IssueAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1020, mainFrame.size.width, 20)];
    [_IssueAgeLabel setText:@"Issue Age"];
    [_mainScrollView addSubview:_IssueAgeLabel];
    
    _IssueAgeTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 1050, mainFrame.size.width+2, 40)];
    [_IssueAgeTextField setTag:52159];
    [_IssueAgeTextField setText:[self RemoveSpecialCharacter:[_DataModel IssueAge]]];
    [_mainScrollView addSubview:_IssueAgeTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _OwnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1120, mainFrame.size.width, 20)];
    [_OwnerLabel setText:@"Owner"];
    [_mainScrollView addSubview:_OwnerLabel];
    
    _OwnerTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 1150, mainFrame.size.width+2, 40)];
    [_OwnerTextField setTag:52160];
    [_OwnerTextField setText:[self RemoveSpecialCharacter:[_DataModel Owner]]];
    [_mainScrollView addSubview:_OwnerTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _PaymentModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1220, mainFrame.size.width, 20)];
    [_PaymentModeLabel setText:@"Payment Mode"];
    [_mainScrollView addSubview:_PaymentModeLabel];
    
    _PaymentModeTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 1250, mainFrame.size.width+2, 40)];
    [_PaymentModeTextField setTag:52161];
    [_PaymentModeTextField setText:[self RemoveSpecialCharacter:[_DataModel PaymentMode]]];
    [_mainScrollView addSubview:_PaymentModeTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _PaymentMothodLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1320, mainFrame.size.width, 20)];
    [_PaymentMothodLabel setText:@"Payment Method"];
    [_mainScrollView addSubview:_PaymentMothodLabel];
    
    _PaymentMothodTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 1350, mainFrame.size.width+2, 40)];
    [_PaymentMothodTextField setTag:52162];
    [_PaymentMothodTextField setText:[self RemoveSpecialCharacter:[_DataModel PaymentMothod]]];
    [_mainScrollView addSubview:_PaymentMothodTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _BillToDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1420, mainFrame.size.width, 20)];
    [_BillToDateLabel setText:@"Bill To Date"];
    [_mainScrollView addSubview:_BillToDateLabel];
    
    _BillToDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 1450, mainFrame.size.width+2, 40)];
    [_BillToDateTextField setTag:52163];
    [_BillToDateTextField setText:[self ChangedateFormat:[self RemoveSpecialCharacter:[_DataModel BillToDate]]]];
    [_mainScrollView addSubview:_BillToDateTextField];
    
    
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

-(NSString *)ChangedateFormat:(NSString *)NoramlDate
{
    NSString *Returneddata = nil;
    @try {
        NSString *CleanedString = [self RemoveSpecialCharacter:[self CleanTextField:NoramlDate]];
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
        Returneddata = FullDateOfBirth;
    }
    @catch (NSException *exception) {
        Returneddata = @"0000-00-00";
    }
    return Returneddata;
}
-(NSString *)FilterdataWithString:(NSString *)DataString
{
    return [[self CleanTextField:DataString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    
    if ([self CleanTextField:[_StatusTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Status can't be blank");
        isValidate = NO;
    }
    /*else if ([self CleanTextField:[_PolicyDateTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Policy Date can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_PaidToDateTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Paid To Date can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_ModalPremiumTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Modal Premium can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_NextModalPremiumTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Next Modal Premium can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_PayUpDateTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Pay Up Date can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_MaturityDateTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Maturity Date is not valied");
        isValidate = NO;
    } else if ([self CleanTextField:[_InsuredAddressTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Insured Address not valied");
        isValidate = NO;
    }  else if ([self CleanTextField:[_AdjustedPremiumTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Adjusted Premium not valied");
        isValidate = NO;
    }  
     */
    else if ([self CleanTextField:[_NRICTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"NRIC Number not valied");
        isValidate = NO;
    }
    /* else if ([self CleanTextField:[_IssueAgeTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Issue Age not valied");
        isValidate = NO;
    }  else if ([self CleanTextField:[_OwnerTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Owner not valied");
        isValidate = NO;
    }  else if ([self CleanTextField:[_PaymentModeTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Payment Mode not valied");
        isValidate = NO;
    } else if ([self CleanTextField:[_PaymentMothodTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Payment Method not valied");
        isValidate = NO;
    }  else if ([self CleanTextField:[_BillToDateTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Bill To Date not valied");
        isValidate = NO;
    }
     */
    
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
                
            url = [NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=AddInsurenceDetails&UserFirstName=%@&UserlastName=%@&UserEmail=%@&UserDateOfBirth=%@&UserGender=%@&UserPhoneNumber=%@&StatusTextField=%@&PolicyDateTextField=%@&PaidToDateTextField=%@&ModalPremiumTextField=%@&NextModalPremiumTextField=%@&PayUpDateTextField=%@&MaturityDateTextField=%@&InsuredAddressTextField=%@&AdjustedPremiumTextField=%@&NRICTextField=%@&IssueAgeTextField=%@&OwnerTextField=%@&PaymentModeTextField=%@&PaymentMothodTextField=%@&BillToDateTextField=%@&PolicyNumber=%@",
                   [self FilterdataWithString:[_UserEditedData UserFirstName]],
                   [self FilterdataWithString:[_UserEditedData UserlastName]],
                   [self FilterdataWithString:[_UserEditedData UsersEmail]],
                   [self FilterdataWithString:[_UserEditedData UserDateOfBirth]],
                   [self FilterdataWithString:[_UserEditedData UserGender]],
                   [self FilterdataWithString:[_UserEditedData UserPhoneNumber]],
                   [self FilterdataWithString:[_StatusTextField text]],
                   [self FilterdataWithString:[_PolicyDateTextField text]],
                   [self FilterdataWithString:[_PaidToDateTextField text]],
                   [self FilterdataWithString:[_ModalPremiumTextField text]],
                   [self FilterdataWithString:[_NextModalPremiumTextField text]],
                   [self FilterdataWithString:[_PayUpDateTextField text]],
                   [self FilterdataWithString:[_MaturityDateTextField text]],
                   [self FilterdataWithString:[_InsuredAddressTextField text]],
                   [self FilterdataWithString:[_AdjustedPremiumTextField text]],
                   [self FilterdataWithString:[_NRICTextField text]],
                   [self FilterdataWithString:[_IssueAgeTextField text]],
                   [self FilterdataWithString:[_OwnerTextField text]],
                   [self FilterdataWithString:[_PaymentModeTextField text]],
                   [self FilterdataWithString:[_PaymentMothodTextField text]],
                   [self FilterdataWithString:[_BillToDateTextField text]],
                   [self FilterdataWithString:[_UserEditedData UserPolicyNumber]]];
            
            NSLog(@"URL : %@", url);
            
            NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
            if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self stopSpin];
                
                NSLog(@"web result data ----- %@",results);
                
                for (id AllTextView in [self.view subviews]) {
                    if ([AllTextView isKindOfClass:[UITextView class]]) {
                        UITextView *MycustomTextView = (UITextView *)AllTextView;
                        [MycustomTextView resignFirstResponder];
                    }
                }
                
                if([[results objectForKey:@"status"] isEqualToString:@"success"])
                {
                    
                    /**
                     *  data Save into Local Databse Code Start
                     */
                        if ([[results objectForKey:@"userId"] intValue] > 0) {
                            OCRAppDelegate *MainDelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
                            NSManagedObjectContext *context = [MainDelegate managedObjectContext];
                            Person *person = [NSEntityDescription
                                              insertNewObjectForEntityForName:@"Person"
                                              inManagedObjectContext:context];
                            
                            person.dateOfBirth                              =   [_UserEditedData UserDateOfBirth];
                            person.firstname                                =   [_UserEditedData UserFirstName];
                            person.gender                                   =   [_UserEditedData UserGender];
                            person.id                                       =   [NSString stringWithFormat:@"%@",[results objectForKey:@"userId"]];
                            person.lastname                                 =   [_UserEditedData UserlastName];
                            person.useremail                                =   [_UserEditedData UsersEmail];
                            person.userimage                                =   @"";
                            person.userPhoneNumber                          =   [_UserEditedData UserPhoneNumber];
                            
                            NSError *error;
                            if (![context save:&error]) {
                                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                            } else {
                                NSLog(@"data saved into databse");
                            }
                        }
                        
                        /**
                         *  data Save into Local Databse Code end
                         */
                    
                    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"User saved successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [Alert setTag:11452];
                    [Alert show];
                } else {
                    ShowAlert(@"Error", @"Unable to save data, please try again later");
                }
            });
        });
    }
}
-(NSString *)RemoveSpecialCharacter:(NSString *)DataString
{
    NSString *newString = [DataString stringByReplacingOccurrencesOfString:@": " withString:@"" options: NSRegularExpressionSearch range:NSMakeRange(0, DataString.length)];
    return newString;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11452) {
        OCRContactListViewController *Contactlist = [[OCRContactListViewController alloc] initWithNibName:@"v" bundle:nil];
        [self.navigationController pushViewController:Contactlist animated:YES];
    }
}

#pragma mark -
#pragma mark Table view delegate
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
        [TitleLabel setText:@"Status"];
    } else if (section == 1) {
        [TitleLabel setText:@"Policy Date"];
    } else if (section == 2) {
        [TitleLabel setText:@"Paid To Date"];
    } else if (section == 3) {
        [TitleLabel setText:@"Modal Premium"];
    } else if (section == 4) {
        [TitleLabel setText:@"Next Modal Premium"];
    } else if (section == 5) {
        [TitleLabel setText:@"Pay Up Date"];
    } else if (section == 6) {
        [TitleLabel setText:@"Maturity Date"];
    } else if (section == 7) {
        [TitleLabel setText:@"Insured Address"];
    } else if (section == 8) {
        [TitleLabel setText:@"Adjusted Premium"];
    } else if (section == 9) {
        [TitleLabel setText:@"NRIC"];
    } else if (section == 10) {
        [TitleLabel setText:@"Issue Age"];
    } else if (section == 11) {
        [TitleLabel setText:@"Owner"];
    } else if (section == 12) {
        [TitleLabel setText:@"Payment Mode"];
    } else if (section == 13) {
        [TitleLabel setText:@"Payment Method"];
    } else if (section == 14) {
        [TitleLabel setText:@"Bill To Date"];
    }
    return Headerview;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  /*  static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    */
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[ContactList Firstname],[ContactList Lastname]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    
    /*
    UISwitch *dataSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(260, 10, 70, 30)];
    [dataSwitch setBackgroundColor:[UIColor clearColor]];
    [dataSwitch setTag:(12546+indexPath.section)];
    [dataSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [dataSwitch setUserInteractionEnabled:YES];
    [cell.contentView addSubview:dataSwitch];
     */
    
    _StatusTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
    
    switch (indexPath.section) {
         
        case 0:
        {
            _StatusTextField = [self SetTextFieldIntoTable:52145 uiview:cell.contentView WithTextValue:[_DataModel Status]];
            [_StatusTextField setDelegate:self];
            break;
        }
        case 1:
        {
            _PolicyDateTextField = [self SetTextFieldIntoTable:52146 uiview:cell.contentView WithTextValue:[_DataModel PolicyDate]];
            [_PolicyDateTextField setDelegate:self];
            break;
        }
        case 2:
        {
            _PaidToDateTextField = [self SetTextFieldIntoTable:52147 uiview:cell.contentView WithTextValue:[_DataModel PaidToDate]];
            [_PaidToDateTextField setDelegate:self];
            break;
        }
        case 3:
        {
            _ModalPremiumTextField = [self SetTextFieldIntoTable:52148 uiview:cell.contentView WithTextValue:[_DataModel ModalPremium]];
            [_ModalPremiumTextField setDelegate:self];
            break;
        }
        case 4:
        {
            _NextModalPremiumTextField = [self SetTextFieldIntoTable:52149 uiview:cell.contentView WithTextValue:[_DataModel NextModalPremium]];
            [_NextModalPremiumTextField setDelegate:self];
            break;
        }
        case 5:
        {
            _PayUpDateTextField = [self SetTextFieldIntoTable:52150 uiview:cell.contentView WithTextValue:[_DataModel PayUpDate]];
            [_PayUpDateTextField setDelegate:self];
            break;
        }
        case 6:
        {
            _MaturityDateTextField = [self SetTextFieldIntoTable:52151 uiview:cell.contentView WithTextValue:[_DataModel MaturityDate]];
            [_MaturityDateTextField setDelegate:self];
            break;
        }
        case 7:
        {
            _InsuredAddressTextField = [self SetTextFieldIntoTable:52152 uiview:cell.contentView WithTextValue:[_DataModel InsuredAddress]];
            [_InsuredAddressTextField setDelegate:self];
             break;
        }
        case 8:
        {
            _AdjustedPremiumTextField = [self SetTextFieldIntoTable:52153 uiview:cell.contentView WithTextValue:[_DataModel AdjustedPremium]];
            [_AdjustedPremiumTextField setDelegate:self];
            break;
        }
        case 9:
        {
            _NRICTextField = [self SetTextFieldIntoTable:52154 uiview:cell.contentView WithTextValue:[_DataModel NRIC]];
            [_NRICTextField setDelegate:self];
            break;
        }
        case 10:
        {
            _IssueAgeTextField = [self SetTextFieldIntoTable:52155 uiview:cell.contentView WithTextValue:[_DataModel IssueAge]];
            [_IssueAgeTextField setDelegate:self];
            break;
        }
        case 11:
        {
            _OwnerTextField = [self SetTextFieldIntoTable:52156 uiview:cell.contentView WithTextValue:[_DataModel Owner]];
            [_OwnerTextField setDelegate:self];
            break;
        }
        case 12:
        {
            _PaymentModeTextField = [self SetTextFieldIntoTable:52157 uiview:cell.contentView WithTextValue:[_DataModel PaymentMode]];
            [_PaymentModeTextField setDelegate:self];
            break;
        }
        case 13:
        {
            _PaymentMothodTextField = [self SetTextFieldIntoTable:52158 uiview:cell.contentView WithTextValue:[_DataModel PaymentMothod]];
            [_PaymentMothodTextField setDelegate:self];
            break;
        }
        case 14:
        {
            _BillToDateTextField = [self SetTextFieldIntoTable:52159 uiview:cell.contentView WithTextValue:[_DataModel BillToDate]];
            [_BillToDateTextField setDelegate:self];
            break;
        }
    }
    
    return cell;
}
-(UITextField *)SetTextFieldIntoTable:(int)Textfieldtag uiview:(UIView *)ParentView WithTextValue:(NSString *)Textvalue
{
    UITextField *dataTextfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
    [dataTextfield setBackgroundColor:[UIColor whiteColor]];
    [dataTextfield setEnabled:YES];
    [dataTextfield setTag:Textfieldtag];
    [dataTextfield setTextColor:[UIColor darkGrayColor]];
    [dataTextfield setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    [dataTextfield setText:[self CharaterRecognizer:Textvalue]];
    [ParentView addSubview:dataTextfield];
    return dataTextfield;
}
-(IBAction)switchIsChanged:(UISwitch *)sender
{
    if (sender.tag == 12546) {
        if ([sender isOn]){
            [_StatusTextField setEnabled:YES];
        } else {
            [_StatusTextField setEnabled:NO];
        }
    } else if (sender.tag == 12547) {
        if ([sender isOn]){
            [_PolicyDateTextField setEnabled:YES];
        } else {
            [_PolicyDateTextField setEnabled:NO];
        }
    } else if (sender.tag == 12548) {
        if ([sender isOn]){
            [_PaidToDateTextField setEnabled:YES];
        } else {
            [_PaidToDateTextField setEnabled:NO];
        }
    } else if (sender.tag == 12549) {
        if ([sender isOn]){
            [_ModalPremiumTextField setEnabled:YES];
        } else {
            [_ModalPremiumTextField setEnabled:NO];
        }
    } else if (sender.tag == 12550) {
        if ([sender isOn]){
            [_NextModalPremiumTextField setEnabled:YES];
        } else {
            [_NextModalPremiumTextField setEnabled:NO];
        }
    }
    else if (sender.tag == 12551) {
        if ([sender isOn]){
            [_PayUpDateTextField setEnabled:YES];
        } else {
            [_PayUpDateTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12552) {
        if ([sender isOn]){
            [_MaturityDateTextField setEnabled:YES];
        } else {
            [_MaturityDateTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12553) {
        if ([sender isOn]){
            [_InsuredAddressTextField setEnabled:YES];
        } else {
            [_InsuredAddressTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12554) {
        if ([sender isOn]){
            [_AdjustedPremiumTextField setEnabled:YES];
        } else {
            [_AdjustedPremiumTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12555) {
        if ([sender isOn]){
            [_NRICTextField setEnabled:YES];
        } else {
            [_NRICTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12556) {
        if ([sender isOn]){
            [_IssueAgeTextField setEnabled:YES];
        } else {
            [_IssueAgeTextField setEnabled:NO];
        }
    }
    else if (sender.tag == 12557) {
        if ([sender isOn]){
            [_OwnerTextField setEnabled:YES];
        } else {
            [_OwnerTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12558) {
        if ([sender isOn]){
            [_PaymentModeTextField setEnabled:YES];
        } else {
            [_PaymentModeTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12559) {
        if ([sender isOn]){
            [_PaymentMothodTextField setEnabled:YES];
        } else {
            [_PaymentMothodTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12560) {
        if ([sender isOn]){
            [_BillToDateTextField setEnabled:YES];
        } else {
            [_BillToDateTextField setEnabled:NO];
        }
    }
}
#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 15;
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
  
    return 44;
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
            [Footerlabel setText:@"Select switch if Status isn't right"];
            break;
        case 1:
            [Footerlabel setText:@"Select switch if Policy Date isn't right"];
            break;
        case 2:
            [Footerlabel setText:@"Select switch if Paid To Date isn't right"];
            break;
        case 3:
            [Footerlabel setText:@"Select switch if Modal Premium isn't right"];
            break;
        case 4:
            [Footerlabel setText:@"Select switch if Next Modal Premium isn't right"];
            break;
        case 5:
            [Footerlabel setText:@"Select switch if Pay Up Date isn't right"];
            break;
        case 6:
            [Footerlabel setText:@"Select switch if Maturity Date isn't right"];
            break;
        case 7:
            [Footerlabel setText:@"Select switch if Insured Address isn't right"];
            break;
        case 8:
            [Footerlabel setText:@"Select switch if Adjusted Premium isn't right"];
            break;
        case 9:
            [Footerlabel setText:@"Select switch if NRIC isn't right"];
            break;
        case 10:
            [Footerlabel setText:@"Select switch if Issue Age isn't right"];
            break;
        case 11:
            [Footerlabel setText:@"Select switch if Owner isn't right"];
            break;
        case 12:
            [Footerlabel setText:@"Select switch if Payment Mode isn't right"];
            break;
        case 13:
            [Footerlabel setText:@"Select switch if Payment Method isn't right"];
            break;
        case 14:
            [Footerlabel setText:@"Select switch if Bill To Date isn't right"];
            break;
        default:
            [Footerlabel setText:@""];
            break;
    }
    /*
     */
    
    return viewFotter;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:1.0 animations:^(void){
        switch (textField.tag) {
            case 52149:
                [_mainScrollView setContentOffset:CGPointMake(0, 0)];
                break;
            case 52150:
                [_mainScrollView setContentOffset:CGPointMake(0, 120)];
                break;
            case 52151:
                [_mainScrollView setContentOffset:CGPointMake(0, 140)];
                break;
            case 52152:
                [_mainScrollView setContentOffset:CGPointMake(0, 290)];
                break;
            case 52153:
                [_mainScrollView setContentOffset:CGPointMake(0, 390)];
                break;
            case 52154:
                [_mainScrollView setContentOffset:CGPointMake(0, 490)];
                break;
            case 52155:
                [_mainScrollView setContentOffset:CGPointMake(0, 590)];
                break;
            case 52156:
                [_mainScrollView setContentOffset:CGPointMake(0, 690)];
                break;
            case 52157:
                [_mainScrollView setContentOffset:CGPointMake(0, 790)];
                break;
            case 52158:
                [_mainScrollView setContentOffset:CGPointMake(0, 890)];
                break;
            case 52159:
                [_mainScrollView setContentOffset:CGPointMake(0, 990)];
                break;
            case 52160:
                [_mainScrollView setContentOffset:CGPointMake(0, 1090)];
                break;
            case 52161:
                [_mainScrollView setContentOffset:CGPointMake(0, 1190)];
                break;
            case 52162:
                [_mainScrollView setContentOffset:CGPointMake(0, 1290)];
                break;
            case 52163:
                [_mainScrollView setContentOffset:CGPointMake(0, 1390)];
                break;
        }
    } completion:nil];
    
    if (textField == _PolicyDateTextField) {
        [textField resignFirstResponder];
        _OpenDateType = dateFieldTypePolicyDate;
        [self openDateSelectionController:_PolicyDateTextField];
    }
    
    if(textField == _PaidToDateTextField) {
        [textField resignFirstResponder];
        _OpenDateType = dateFieldTypePaidTodate;
        [self openDateSelectionController:_PaidToDateTextField];
    }
    
    if (textField == _PayUpDateTextField) {
        [textField resignFirstResponder];
        _OpenDateType = dateFieldTypePayUpDate;
        [self openDateSelectionController:_PayUpDateTextField];
    }
    
    if (textField == _MaturityDateTextField) {
        [textField resignFirstResponder];
        _OpenDateType = dateFieldTypeMaturityDate;
        [self openDateSelectionController:_MaturityDateTextField];
    }
    
    if (textField == _BillToDateTextField) {
        [textField resignFirstResponder];
        _OpenDateType = dateFieldTypeBillTodate;
        [self openDateSelectionController:_BillToDateTextField];
    }
    
    if (textField == _IssueAgeTextField) {
        [textField resignFirstResponder];
        _OpenSelectionType = OptionSelectionTypeIssueAge;
        [self openPickerController:_IssueAgeTextField];
    }
    
    if (textField == _PaymentModeTextField) {
        [textField resignFirstResponder];
        _OpenSelectionType = OptionSelectionTypePaymentMode;
        [self openPickerController:_PaymentModeTextField];
    }
    
    if (textField == _PaymentMothodTextField) {
        [textField resignFirstResponder];
        _OpenSelectionType = OptionSelectionTypePaymentMethod;
        [self openPickerController:_PaymentMothodTextField];
    }
    
    if (textField == _StatusTextField) {
        [textField resignFirstResponder];
        _OpenSelectionType = OptionSelectionTypeStatus;
        [self openPickerController:_StatusTextField];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField*)textField {
    
    [UIView animateWithDuration:1.0 animations:^(void){
        //[_InsurenceDataTable setContentOffset:CGPointMake(0, 0)];
    } completion:nil];
    [textField resignFirstResponder];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    /*
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        NSLog(@"Menu bar button prassed..");
    }];
     */
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSString *)CharaterRecognizer:(NSString *)DataString
{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@":"];
    return [self CleanTextField:[[DataString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""]];
}

#pragma Add calenderview

- (IBAction)openDateSelectionController:(UITextField *)sender {
    
    [self.view endEditing:YES];
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
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
   // dateSelectionVC.datePicker.maximumDate = [NSDate date];
    dateSelectionVC.datePicker.minuteInterval = 5;
    [dateSelectionVC show];
    
}

#pragma mark - RMDAteSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    [self.view endEditing:YES];
    for(id aSubView in [self.view subviews])
    {
        if([aSubView isKindOfClass:[UITextField class]])
        {
            UITextField *textField=(UITextField*)aSubView;
            [textField resignFirstResponder];
        }
    }
    
    NSArray *SelectedDate = [[NSString stringWithFormat:@"%@",aDate] componentsSeparatedByString:@" "];
    
    if (_OpenDateType == dateFieldTypePolicyDate) {
        [_PolicyDateTextField setText:[SelectedDate objectAtIndex:0]];
    }
    
    if (_OpenDateType == dateFieldTypePaidTodate) {
        [_PaidToDateTextField setText:[SelectedDate objectAtIndex:0]];
    }
    
    if (_OpenDateType == dateFieldTypePayUpDate) {
        [_PayUpDateTextField setText:[SelectedDate objectAtIndex:0]];
    }
    
    if (_OpenDateType == dateFieldTypeMaturityDate) {
        [_MaturityDateTextField setText:[SelectedDate objectAtIndex:0]];
    }
    
    if (_OpenDateType == dateFieldTypeBillTodate) {
        [_BillToDateTextField setText:[SelectedDate objectAtIndex:0]];
    }
   
    NSLog(@"Successfully selected date: %@", aDate);
    _OpenDateType = dateFieldTypeNone;
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    [self.view endEditing:YES];
    NSLog(@"Date selection was canceled");
    _OpenDateType = dateFieldTypeNone;
}

#pragma mark - RMPickerViewController Delegates

- (IBAction)openPickerController:(UITextField *)sender {
    [self.view endEditing:YES];
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
    [self.view endEditing:YES];
    NSLog(@"Successfully selected rows: %@", [selectedRows objectAtIndex:0]);
    
    if (_OpenSelectionType == OptionSelectionTypeIssueAge) {
        [_IssueAgeTextField setText:[NSString stringWithFormat:@"%@",[selectedRows objectAtIndex:0]]];
    } else if (_OpenSelectionType == OptionSelectionTypePaymentMode) {
        
        NSString *Dataval = nil;
        
        switch ([[selectedRows objectAtIndex:0] intValue]) {
            case 0:
                Dataval = @"MONTHLY";
                break;
            case 1:
                Dataval = @"QUARTERLY";
                break;
            case 2:
                Dataval = @"HALF YEARLY";
                break;
            case 3:
                Dataval = @"ANNUALLY";
                break;
            default:
                Dataval = @"ANNUALLY";
                break;
        }
        
        [_PaymentModeTextField setText:Dataval];
    } else if (_OpenSelectionType == OptionSelectionTypePaymentMethod) {
        
        NSString *Dataval = nil;
        
        switch ([[selectedRows objectAtIndex:0] intValue]) {
            case 0:
                Dataval = @"Direct Pay-Non-monthly";
                break;
            case 1:
                Dataval = @"Direct Pay-Monthly";
                break;
            default:
                Dataval = @"Direct Pay-Non-monthly";
                break;
        }
        [_PaymentMothodTextField setText:Dataval];
    } else if (_OpenSelectionType == OptionSelectionTypeStatus) {
        
        NSString *Dataval = nil;
        
        switch ([[selectedRows objectAtIndex:0] intValue]) {
            case 0:
                Dataval = @"Inforce-Premium Paying";
                break;
            default:
                Dataval = @"Inforce-Premium Paying";
                break;
        }
        [_StatusTextField setText:Dataval];
    }
    _OpenSelectionType = OptionSelectionTypeNone;
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc {
    [self.view endEditing:YES];
    _OpenSelectionType = OptionSelectionTypeNone;
    NSLog(@"Selection was canceled");
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (_OpenSelectionType == OptionSelectionTypeIssueAge) {
        return 100;
    } else if (_OpenSelectionType == OptionSelectionTypePaymentMode) {
        return 4;
    } else if (_OpenSelectionType == OptionSelectionTypePaymentMethod) {
        return 2;
    } else if (_OpenSelectionType == OptionSelectionTypeStatus) {
        return 1;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    for(id aSubView in [self.view subviews])
    {
        if([aSubView isKindOfClass:[UITextField class]])
        {
            UITextField *textField=(UITextField*)aSubView;
            [textField resignFirstResponder];
        }
    }
    
    if (_OpenSelectionType == OptionSelectionTypeIssueAge) {
        
        return [NSString stringWithFormat:@"%ld",(long)row];
        
    } else if (_OpenSelectionType == OptionSelectionTypePaymentMode) {
        if (row == 0) {
            return @"Monthly";
        } else if (row == 1) {
            return @"Quaterly";
        }  else if (row == 2) {
            return @"Half Yearly";
        }  else if (row == 3) {
            return @"Annually";
        }
        return 0;
    } else if (_OpenSelectionType == OptionSelectionTypePaymentMethod) {
        if (row == 0) {
            return @"Direct Pay-Non-monthly";
        } else if (row == 1) {
            return @"Direct Pay-Monthly";
        }
        return 0;
    } else if (_OpenSelectionType == OptionSelectionTypeStatus) {
        if (row == 0) {
            return @"Inforce-Premium Paying";
        }
        return 0;
    }
    return 0;
}
@end
