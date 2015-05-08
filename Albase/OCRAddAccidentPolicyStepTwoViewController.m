//
//  OCRAddAccidentPolicyStepTwoViewController.m
//  Albase
//
//  Created by Mac on 27/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRAddAccidentPolicyStepTwoViewController.h"
#import "GlobalStaticData.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"
#import "RMDateSelectionViewController.h"
#import "RMPickerViewController.h"
#import "OCRContactListViewController.h"
#import "OCRAppDelegate.h"
#import "Person.h"

typedef enum {
    OptionSelectionTypeNone,
    OptionSelectionTypeStatus,
    OptionSelectionTypeIssueAge,
    OptionSelectionTypePaymentMode,
    OptionSelectionTypePaymentMethod
} OptionSelectionType;

typedef enum {
    AccDateTypeNone,
    AccDateTypeEffectiveDate,
    AccDateTypeExpiryDate,
    AccDateTypeReinStateDate,
    AccDateTypepaidToDate,
    AccDateTypeLapseDate,
    
} AccDateType;

@interface OCRAddAccidentPolicyStepTwoViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,RMDateSelectionViewControllerDelegate,RMPickerViewControllerDelegate>
{
    CGRect mainFrame;
}

@property (nonatomic,retain) NSString               * AccPolicyStatus;
@property (nonatomic,retain) UILabel                * AccPolicyStatusLabel;
@property (nonatomic,retain) UITextField            * AccPolicyStatusTextField;

@property (nonatomic,retain) NSString               * AccNRIC;
@property (nonatomic,retain) UILabel               * AccNRICLabel;
@property (nonatomic,retain) UITextField            * AccNRICTextField;

@property (nonatomic,retain) NSString               * AccIssueAge;
@property (nonatomic,retain) UILabel               * AccIssueAgeLabel;
@property (nonatomic,retain) UITextField            * AccIssueAgeTextField;

@property (nonatomic,retain) NSString               * AccPaymentMode;
@property (nonatomic,retain) UILabel               * AccPaymentModeLabel;
@property (nonatomic,retain) UITextField            * AccPaymentModeTextField;

@property (nonatomic,retain) NSString               * AccPaymentMothod;
@property (nonatomic,retain) UILabel               * AccPaymentMothodLabel;
@property (nonatomic,retain) UITextField            * AccPaymentMothodTextField;

@property (nonatomic,retain) NSString               * AccEffictiveDate;
@property (nonatomic,retain) UILabel               * AccEffictiveDateLabel;
@property (nonatomic,retain) UITextField            * AccEffictiveDateTextField;

@property (nonatomic,retain) NSString               * AccModelPremium;
@property (nonatomic,retain) UILabel               * AccModelPremiumLabel;
@property (nonatomic,retain) UITextField            * AccModelPremiumTextField;

@property (nonatomic,retain) NSString               * AccExpiryDate;
@property (nonatomic,retain) UILabel               * AccExpiryDateLabel;
@property (nonatomic,retain) UITextField            * AccExpiryDateTextField;

@property (nonatomic,retain) NSString               * AccReinStateDate;
@property (nonatomic,retain) UILabel               * AccReinStateDateLabel;
@property (nonatomic,retain) UITextField            * AccReinStateDateTextField;

@property (nonatomic,retain) NSString               * AccAddress;
@property (nonatomic,retain) UILabel               * AccAddressLabel;
@property (nonatomic,retain) UITextField            * AccAddressTextField;

@property (nonatomic,retain) NSString               * AccOcupationClass;
@property (nonatomic,retain) UILabel               * AccOcupationClassLabel;
@property (nonatomic,retain) UITextField            * AccOcupationClassTextField;

@property (nonatomic,retain) NSString               * AccPaidtoDate;
@property (nonatomic,retain) UILabel               * AccPaidtoDateLabel;
@property (nonatomic,retain) UITextField            * AccPaidtoDateTextField;

@property (nonatomic,retain) NSString               * AccLapseDate;
@property (nonatomic,retain) UILabel               * AccLapseDateLabel;
@property (nonatomic,retain) UITextField            * AccLapseDateTextField;

@property (nonatomic,retain) NSString               * AccRenewalBonus;
@property (nonatomic,retain) UILabel               * AccRenewalBonusLabel;
@property (nonatomic,retain) UITextField            * AccRenewalBonusTextField;

@property (nonatomic,retain) UITableView            * AccidentDataTable;
@property (nonatomic,retain) NSMutableDictionary    * AccidentData;

@property (nonatomic,retain) UIScrollView *mainScrollView;

@property (assign) AccDateType SelectedDateType;

@property (assign) OptionSelectionType OpenSelectionType;

@end

@implementation OCRAddAccidentPolicyStepTwoViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // self=[super initWithNibName:GlobalViewControllerData.ScanAccidentPolicyStepTwo bundle:nil];
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRAddAccidentPolicyStepTwoViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRAddAccidentPolicyStepTwoViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRAddAccidentPolicyStepTwoViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRAddAccidentPolicyStepTwoViewController6s" bundle:nil];
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
    
    _SelectedDateType = AccDateTypeNone;
    _OpenSelectionType = OptionSelectionTypeNone;
    NSLog(@"------- %@------- %@------- %@------- %@------- %@------- %@",[_UserEditedData UserFirstName],[_UserEditedData UserlastName],[_UserEditedData UsersEmail],[_UserEditedData UserDateOfBirth],[_UserEditedData UserGender],[_UserEditedData UserPhoneNumber]);
    
    _mainScrollView = (UIScrollView *)[self.view viewWithTag:586];
    [_mainScrollView setBackgroundColor:[UIColor colorFromHex:0xededf2]];
    [_mainScrollView setUserInteractionEnabled:YES];
    [_mainScrollView setDelegate:self];
    [_mainScrollView setContentSize:CGSizeMake(mainFrame.size.width, 1620)];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccPolicyStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, mainFrame.size.width-20, 20)];
    [_AccPolicyStatusLabel setText:@"Policy Status"];
    [_mainScrollView addSubview:_AccPolicyStatusLabel];
    
    _AccPolicyStatusTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 50, mainFrame.size.width+2, 40)];
    [_AccPolicyStatusTextField setTag:52149];
    [_AccPolicyStatusTextField setText:[self RemoveSpecialCharacter:[_DataModel AccidentPolicyStatus]]];
    [_mainScrollView addSubview:_AccPolicyStatusTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccNRICLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 120, mainFrame.size.width-20, 20)];
    [_AccNRICLabel setText:@"NRIC Number"];
    [_mainScrollView addSubview:_AccNRICLabel];
    
    _AccNRICTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 150, mainFrame.size.width+2, 40)];
    [_AccNRICTextField setTag:52150];
    [_AccNRICTextField setText:[self RemoveSpecialCharacter:[_DataModel AccidentNRIC]]];
    [_mainScrollView addSubview:_AccNRICTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccIssueAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 220, mainFrame.size.width-20, 20)];
    [_AccIssueAgeLabel setText:@"Issue Age"];
    [_mainScrollView addSubview:_AccIssueAgeLabel];
    
    _AccIssueAgeTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 250, mainFrame.size.width+2, 40)];
    [_AccIssueAgeTextField setTag:52151];
    [_AccIssueAgeTextField setText:[self RemoveSpecialCharacter:[_DataModel AccidentIssueAge]]];
    [_mainScrollView addSubview:_AccIssueAgeTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccPaymentModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 320, mainFrame.size.width-20, 20)];
    [_AccPaymentModeLabel setText:@"Payment Mode"];
    [_mainScrollView addSubview:_AccPaymentModeLabel];
    
    _AccPaymentModeTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 350, mainFrame.size.width+2, 40)];
    [_AccPaymentModeTextField setTag:52152];
    [_AccPaymentModeTextField setText:[self RemoveSpecialCharacter:[_DataModel AccidentPaymentMode]]];
    [_mainScrollView addSubview:_AccPaymentModeTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccPaymentMothodLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 420, mainFrame.size.width-20, 20)];
    [_AccPaymentMothodLabel setText:@"Payment Method"];
    [_mainScrollView addSubview:_AccPaymentMothodLabel];
    
    _AccPaymentMothodTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 450, mainFrame.size.width+2, 40)];
    [_AccPaymentMothodTextField setTag:52153];
    [_AccPaymentMothodTextField setText:[self RemoveSpecialCharacter:[_DataModel AccidentPaymentMothod]]];
    [_mainScrollView addSubview:_AccPaymentMothodTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccEffictiveDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 520, mainFrame.size.width-20, 20)];
    [_AccEffictiveDateLabel setText:@"Effective Date"];
    [_mainScrollView addSubview:_AccEffictiveDateLabel];
    
    _AccEffictiveDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 550, mainFrame.size.width+2, 40)];
    [_AccEffictiveDateTextField setTag:52154];
    [_AccEffictiveDateTextField setText:[self ChangedateFormat:[self RemoveSpecialCharacter:[_DataModel AccidentEffictiveDate]]]];
    [_mainScrollView addSubview:_AccEffictiveDateTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccModelPremiumLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 620, mainFrame.size.width-20, 20)];
    [_AccModelPremiumLabel setText:@"Modal Premium"];
    [_mainScrollView addSubview:_AccModelPremiumLabel];
    
    _AccModelPremiumTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 650, mainFrame.size.width+2, 40)];
    [_AccModelPremiumTextField setTag:52155];
    [_AccModelPremiumTextField setText:[self RemoveSpecialCharacter:[_DataModel AccidentModelPremium]]];
    [_mainScrollView addSubview:_AccModelPremiumTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccExpiryDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 720, mainFrame.size.width-20, 20)];
    [_AccExpiryDateLabel setText:@"Expiry Date"];
    [_mainScrollView addSubview:_AccExpiryDateLabel];
    
    _AccExpiryDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 750, mainFrame.size.width+2, 40)];
    [_AccExpiryDateTextField setTag:52156];
    [_AccExpiryDateTextField setText:[self ChangedateFormat:[self RemoveSpecialCharacter:[_DataModel AccidentExpiryDate]]]];
    [_mainScrollView addSubview:_AccExpiryDateTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccReinStateDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 820, mainFrame.size.width-20, 20)];
    [_AccReinStateDateLabel setText:@"Rein State Date"];
    [_mainScrollView addSubview:_AccReinStateDateLabel];
    
    _AccReinStateDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 850, mainFrame.size.width+2, 40)];
    [_AccReinStateDateTextField setTag:52157];
    [_AccReinStateDateTextField setText:[self ChangedateFormat:[self RemoveSpecialCharacter:[_DataModel AccidentReinStateDate]]]];
    [_mainScrollView addSubview:_AccReinStateDateTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 920, mainFrame.size.width-20, 20)];
    [_AccAddressLabel setText:@"Address"];
    [_mainScrollView addSubview:_AccAddressLabel];
    
    _AccAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 950, mainFrame.size.width+2, 40)];
    [_AccAddressTextField setTag:52158];
    [_AccAddressTextField setText:[self RemoveSpecialCharacter:[_DataModel AccidentAddress]]];
    [_mainScrollView addSubview:_AccAddressTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccOcupationClassLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1020, mainFrame.size.width-20, 20)];
    [_AccOcupationClassLabel setText:@"Ocupation Class"];
    [_mainScrollView addSubview:_AccOcupationClassLabel];
    
    _AccOcupationClassTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 1050, mainFrame.size.width+2, 40)];
    [_AccOcupationClassTextField setTag:52159];
    [_AccOcupationClassTextField setText:[self RemoveSpecialCharacter:[_DataModel AccidentOcupationClass]]];
    [_mainScrollView addSubview:_AccOcupationClassTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccPaidtoDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1120, mainFrame.size.width-20, 20)];
    [_AccPaidtoDateLabel setText:@"Paid to Date"];
    [_mainScrollView addSubview:_AccPaidtoDateLabel];
    
    _AccPaidtoDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 1150, mainFrame.size.width+2, 40)];
    [_AccPaidtoDateTextField setTag:52160];
    [_AccPaidtoDateTextField setText:[self ChangedateFormat:[self RemoveSpecialCharacter:[_DataModel AccidentPaidtoDate]]]];
    [_mainScrollView addSubview:_AccPaidtoDateTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccLapseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1220, mainFrame.size.width-20, 20)];
    [_AccLapseDateLabel setText:@"Lapse Date"];
    [_mainScrollView addSubview:_AccLapseDateLabel];
    
    _AccLapseDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 1250, mainFrame.size.width+2, 40)];
    [_AccLapseDateTextField setTag:52161];
    [_AccLapseDateTextField setText:[self ChangedateFormat:[self RemoveSpecialCharacter:[_DataModel AccidentLapseDate]]]];
    [_mainScrollView addSubview:_AccLapseDateTextField];
    
    /**
     *  =======================================================
     *  =======================================================
     */
    
    _AccRenewalBonusLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1320, mainFrame.size.width-20, 20)];
    [_AccRenewalBonusLabel setText:@"Renewal Bonus"];
    [_mainScrollView addSubview:_AccRenewalBonusLabel];
    
    _AccRenewalBonusTextField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 1350, mainFrame.size.width+2, 40)];
    [_AccRenewalBonusTextField setTag:52162];
    [_AccRenewalBonusTextField setText:[self RemoveSpecialCharacter:[_DataModel AccidentRenewalBonus]]];
    [_mainScrollView addSubview:_AccRenewalBonusTextField];
    
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
    
    if ([self CleanTextField:[_AccPolicyStatusTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Plicy Status can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_AccNRICTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"NRIC Number can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_AccIssueAgeTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Issue Age can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_AccPaymentModeTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Payment Mode can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_AccPaymentMothodTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Payment Method can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_AccEffictiveDateTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Effictive Date can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_AccModelPremiumTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Model Premium is can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_AccExpiryDateTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Expiry Date can't be blank");
        isValidate = NO;
    }  else if ([self CleanTextField:[_AccReinStateDateTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Rein State Date can't be blank");
        isValidate = NO;
    }  else if ([self CleanTextField:[_AccAddressTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Address can't be blank");
        isValidate = NO;
    }  else if ([self CleanTextField:[_AccOcupationClassTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Ocupation Class can't be blank");
        isValidate = NO;
    }  else if ([self CleanTextField:[_AccPaidtoDateTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"paid To Date can't be blank");
        isValidate = NO;
    }  else if ([self CleanTextField:[_AccLapseDateTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Lapse Date can't be blank");
        isValidate = NO;
    } else if ([self CleanTextField:[_AccRenewalBonusTextField text]].length == 0) {
        ShowAlert(@"Validation Error", @"Renewal Bonus can't be blank");
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
            
            url = [NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=AddAccidentDetails&UserFirstName=%@&UserlastName=%@&UserEmail=%@&UserDateOfBirth=%@&UserGender=%@&UserPhoneNumber=%@&PolicyStatusTextField=%@&NRICTextField=%@&IssueAgeTextField=%@&PaymentModeTextField=%@&PaymentMothodTextField=%@&EffictiveDateTextField=%@&ModelPremiumTextField=%@&ExpiryDateTextField=%@&ReinStateDateTextField=%@&AddressTextField=%@&OcupationClassTextField=%@&PaidtoDateTextField=%@&LapseDateTextField=%@&RenewalBonusTextField=%@&PolicyNumber=%@",
                   [self FilterdataWithString:[_UserEditedData UserFirstName]],
                   [self FilterdataWithString:[_UserEditedData UserlastName]],
                   [self FilterdataWithString:[_UserEditedData UsersEmail]],
                   [self FilterdataWithString:[_UserEditedData UserDateOfBirth]],
                   [self FilterdataWithString:[_UserEditedData UserGender]],
                   [self FilterdataWithString:[_UserEditedData UserPhoneNumber]],
                   [self FilterdataWithString:[_AccPolicyStatusTextField text]],
                   [self FilterdataWithString:[_AccNRICTextField text]],
                   [self FilterdataWithString:[_AccIssueAgeTextField text]],
                   [self FilterdataWithString:[_AccPaymentModeTextField text]],
                   [self FilterdataWithString:[_AccPaymentMothodTextField text]],
                   [self FilterdataWithString:[_AccEffictiveDateTextField text]],
                   [self FilterdataWithString:[_AccModelPremiumTextField text]],
                   [self FilterdataWithString:[_AccExpiryDateTextField text]],
                   [self FilterdataWithString:[_AccReinStateDateTextField text]],
                   [self FilterdataWithString:[_AccAddressTextField text]],
                   [self FilterdataWithString:[_AccOcupationClassTextField text]],
                   [self FilterdataWithString:[_AccPaidtoDateTextField text]],
                   [self FilterdataWithString:[_AccLapseDateTextField text]],
                   [self FilterdataWithString:[_AccRenewalBonusTextField text]],
                   [self FilterdataWithString:[_UserEditedData UserPolicyNumber]]];
            
            NSLog(@"URL : %@", url);
            
            NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
            if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self stopSpin];
                
                NSLog(@"web result data ----- %@",results);
                
                if([[results objectForKey:@"status"] isEqualToString:@"success"])
                {
                    for (id AllTextView in [self.view subviews]) {
                        if ([AllTextView isKindOfClass:[UITextView class]]) {
                            UITextView *MycustomTextView = (UITextView *)AllTextView;
                            [MycustomTextView resignFirstResponder];
                        }
                    }
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

-(NSString *)RemoveSpecialCharacter:(NSString *)DataString
{
    NSString *newString = [DataString stringByReplacingOccurrencesOfString:@": " withString:@"" options: NSRegularExpressionSearch range:NSMakeRange(0, DataString.length)];
    return newString;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11452) {
        OCRContactListViewController *Contactlist = [[OCRContactListViewController alloc] initWithNibName:@"OCRContactListViewController" bundle:nil];
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
        [TitleLabel setText:@"Policy Status"];
    } else if (section == 1) {
        [TitleLabel setText:@"NRIC Number"];
    } else if (section == 2) {
        [TitleLabel setText:@"Issue Age"];
    } else if (section == 3) {
        [TitleLabel setText:@"Payment Mode"];
    } else if (section == 4) {
        [TitleLabel setText:@"Payment Method"];
    } else if (section == 5) {
        [TitleLabel setText:@"Effictive Date"];
    } else if (section == 6) {
        [TitleLabel setText:@"Model Premium"];
    } else if (section == 7) {
        [TitleLabel setText:@"Expiry Date"];
    } else if (section == 8) {
        [TitleLabel setText:@"Rein State Date"];
    } else if (section == 9) {
        [TitleLabel setText:@"Address"];
    } else if (section == 10) {
        [TitleLabel setText:@"Ocupation Class"];
    } else if (section == 11) {
        [TitleLabel setText:@"Paid to Date"];
    } else if (section == 12) {
        [TitleLabel setText:@"Lapse Date"];
    } else if (section == 13) {
        [TitleLabel setText:@"Renewal Bonus"];
    }
    return Headerview;
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
    
    UISwitch *dataSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(260, 10, 70, 30)];
    [dataSwitch setBackgroundColor:[UIColor clearColor]];
    [dataSwitch setTag:(12546+indexPath.section)];
    [dataSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [dataSwitch setUserInteractionEnabled:YES];
    [cell.contentView addSubview:dataSwitch];
    
    //_StatusTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
    
    switch (indexPath.section) {
            
        case 0:
        {
            _AccPolicyStatusTextField = [self SetTextFieldIntoTable:52145 uiview:cell.contentView WithTextValue:[_DataModel AccidentPolicyStatus]];
            [_AccPolicyStatusTextField setDelegate:self];
            break;
        }
        case 1:
        {
            _AccNRICTextField = [self SetTextFieldIntoTable:52146 uiview:cell.contentView WithTextValue:[_DataModel AccidentNRIC]];
            [_AccNRICTextField setDelegate:self];
            break;
        }
        case 2:
        {
            _AccIssueAgeTextField = [self SetTextFieldIntoTable:52147 uiview:cell.contentView WithTextValue:[_DataModel AccidentIssueAge]];
            [_AccIssueAgeTextField setDelegate:self];
            break;
        }
        case 3:
        {
            _AccPaymentModeTextField = [self SetTextFieldIntoTable:52148 uiview:cell.contentView WithTextValue:[_DataModel AccidentPaymentMode]];
            [_AccPaymentModeTextField setDelegate:self];
            break;
        }
        case 4:
        {
            _AccPaymentMothodTextField = [self SetTextFieldIntoTable:52149 uiview:cell.contentView WithTextValue:[_DataModel AccidentPaymentMothod]];
            [_AccPaymentMothodTextField setDelegate:self];
            break;
        }
        case 5:
        {
            _AccEffictiveDateTextField = [self SetTextFieldIntoTable:52150 uiview:cell.contentView WithTextValue:[_DataModel AccidentEffictiveDate]];
            [_AccEffictiveDateTextField setDelegate:self];
            break;
        }
        case 6:
        {
            _AccModelPremiumTextField = [self SetTextFieldIntoTable:52151 uiview:cell.contentView WithTextValue:[_DataModel AccidentModelPremium]];
            [_AccModelPremiumTextField setDelegate:self];
            break;
        }
        case 7:
        {
            _AccExpiryDateTextField = [self SetTextFieldIntoTable:52152 uiview:cell.contentView WithTextValue:[_DataModel AccidentExpiryDate]];
            [_AccExpiryDateTextField setDelegate:self];
            break;
        }
        case 8:
        {
            _AccReinStateDateTextField = [self SetTextFieldIntoTable:52153 uiview:cell.contentView WithTextValue:[_DataModel AccidentReinStateDate]];
            [_AccReinStateDateTextField setDelegate:self];
            break;
        }
        case 9:
        {
            _AccAddressTextField = [self SetTextFieldIntoTable:52154 uiview:cell.contentView WithTextValue:[_DataModel AccidentAddress]];
            [_AccAddressTextField setDelegate:self];
            break;
        }
        case 10:
        {
            _AccOcupationClassTextField = [self SetTextFieldIntoTable:52155 uiview:cell.contentView WithTextValue:[_DataModel AccidentOcupationClass]];
            [_AccOcupationClassTextField setDelegate:self];
            break;
        }
        case 11:
        {
            _AccPaidtoDateTextField = [self SetTextFieldIntoTable:52156 uiview:cell.contentView WithTextValue:[_DataModel AccidentPaidtoDate]];
            [_AccPaidtoDateTextField setDelegate:self];
            break;
        }
        case 12:
        {
            _AccLapseDateTextField = [self SetTextFieldIntoTable:52157 uiview:cell.contentView WithTextValue:[_DataModel AccidentLapseDate]];
            [_AccLapseDateTextField setDelegate:self];
            break;
        }
        case 13:
        {
            _AccRenewalBonusTextField = [self SetTextFieldIntoTable:52158 uiview:cell.contentView WithTextValue:[_DataModel AccidentRenewalBonus]];
            [_AccRenewalBonusTextField setDelegate:self];
            break;
        }
    }
    
    return cell;
}
-(UITextField *)SetTextFieldIntoTable:(int)Textfieldtag uiview:(UIView *)ParentView WithTextValue:(NSString *)Textvalue
{
    UITextField *dataTextfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
    [dataTextfield setBackgroundColor:[UIColor whiteColor]];
    [dataTextfield setEnabled:NO];
    [dataTextfield setTag:Textfieldtag];
    [dataTextfield setTextColor:[UIColor darkGrayColor]];
    [dataTextfield setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    [dataTextfield setText:Textvalue];
    [ParentView addSubview:dataTextfield];
    return dataTextfield;
}
-(IBAction)switchIsChanged:(UISwitch *)sender
{
    if (sender.tag == 12546) {
        if ([sender isOn]){
            [_AccPolicyStatusTextField setEnabled:YES];
        } else {
            [_AccPolicyStatusTextField setEnabled:NO];
        }
    } else if (sender.tag == 12547) {
        if ([sender isOn]){
            [_AccNRICTextField setEnabled:YES];
        } else {
            [_AccNRICTextField setEnabled:NO];
        }
    } else if (sender.tag == 12548) {
        if ([sender isOn]){
            [_AccIssueAgeTextField setEnabled:YES];
        } else {
            [_AccIssueAgeTextField setEnabled:NO];
        }
    } else if (sender.tag == 12549) {
        if ([sender isOn]){
            [_AccPaymentModeTextField setEnabled:YES];
        } else {
            [_AccPaymentModeTextField setEnabled:NO];
        }
    } else if (sender.tag == 12550) {
        if ([sender isOn]){
            [_AccPaymentMothodTextField setEnabled:YES];
        } else {
            [_AccPaymentMothodTextField setEnabled:NO];
        }
    }
    else if (sender.tag == 12551) {
        if ([sender isOn]){
            [_AccEffictiveDateTextField setEnabled:YES];
        } else {
            [_AccEffictiveDateTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12552) {
        if ([sender isOn]){
            [_AccModelPremiumTextField setEnabled:YES];
        } else {
            [_AccModelPremiumTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12553) {
        if ([sender isOn]){
            [_AccExpiryDateTextField setEnabled:YES];
        } else {
            [_AccExpiryDateTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12554) {
        if ([sender isOn]){
            [_AccReinStateDateTextField setEnabled:YES];
        } else {
            [_AccReinStateDateTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12555) {
        if ([sender isOn]){
            [_AccAddressTextField setEnabled:YES];
        } else {
            [_AccAddressTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12556) {
        if ([sender isOn]){
            [_AccOcupationClassTextField setEnabled:YES];
        } else {
            [_AccOcupationClassTextField setEnabled:NO];
        }
    }
    else if (sender.tag == 12557) {
        if ([sender isOn]){
            [_AccPaidtoDateTextField setEnabled:YES];
        } else {
            [_AccPaidtoDateTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12558) {
        if ([sender isOn]){
            [_AccLapseDateTextField setEnabled:YES];
        } else {
            [_AccLapseDateTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12559) {
        if ([sender isOn]){
            [_AccRenewalBonusTextField setEnabled:YES];
        } else {
            [_AccRenewalBonusTextField setEnabled:NO];
        }
    }
}
#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 14;
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
            [Footerlabel setText:@"Select switch if Policy Status isn't right"]; // Policy Status
            break;
        case 1:
            [Footerlabel setText:@"Select switch if NRIC Number isn't right"]; // NRIC Number
            break;
        case 2:
            [Footerlabel setText:@"Select switch if Issue Age isn't right"]; // Issue Age
            break;
        case 3:
            [Footerlabel setText:@"Select switch if Payment Mode isn't right"]; // Payment Mode
            break;
        case 4:
            [Footerlabel setText:@"Select switch if Payment Method isn't right"]; // Payment Method
            break;
        case 5:
            [Footerlabel setText:@"Select switch if Effictive Date isn't right"]; // Effictive Date
            break;
        case 6:
            [Footerlabel setText:@"Select switch if Model Premium isn't right"]; // Model Premium
            break;
        case 7:
            [Footerlabel setText:@"Select switch if Expiry Date isn't right"]; // Expiry Date
            break;
        case 8:
            [Footerlabel setText:@"Select switch if Rein State Date isn't right"]; // Rein State Date
            break;
        case 9:
            [Footerlabel setText:@"Select switch if Address isn't right"]; // Address
            break;
        case 10:
            [Footerlabel setText:@"Select switch if Ocupation Class isn't right"]; // Ocupation Class
            break;
        case 11:
            [Footerlabel setText:@"Select switch if Paid to Date isn't right"]; // Paid to Date
            break;
        case 12:
            [Footerlabel setText:@"Select switch if Lapse Date isn't right"]; // Lapse Date
            break;
        case 13:
            [Footerlabel setText:@"Select switch if Renewal Bonus isn't right"]; // Renewal Bonus
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
                [_mainScrollView setContentOffset:CGPointMake(0, 120)];
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
    
    if (textField == _AccEffictiveDateTextField) {
        [textField resignFirstResponder];
        _SelectedDateType = AccDateTypeEffectiveDate;
        [self openDateSelectionController:_AccEffictiveDateTextField];
    }
    
    if(textField == _AccExpiryDateTextField) {
        [textField resignFirstResponder];
        _SelectedDateType = AccDateTypeExpiryDate;
        [self openDateSelectionController:_AccExpiryDateTextField];
    }
    
    if (textField == _AccReinStateDateTextField) {
        [textField resignFirstResponder];
        _SelectedDateType = AccDateTypeReinStateDate;
        [self openDateSelectionController:_AccReinStateDateTextField];
    }
    
    if (textField == _AccPaidtoDateTextField) {
        [textField resignFirstResponder];
        _SelectedDateType = AccDateTypepaidToDate;
        [self openDateSelectionController:_AccPaidtoDateTextField];
    }
    
    if (textField == _AccLapseDateTextField) {
        [textField resignFirstResponder];
        _SelectedDateType = AccDateTypeLapseDate;
        [self openDateSelectionController:_AccLapseDateTextField];
    }
    
    if (textField == _AccIssueAgeTextField) {
        [textField resignFirstResponder];
        _OpenSelectionType = OptionSelectionTypeIssueAge;
        [self openPickerController:_AccIssueAgeTextField];
    }
    
    if (textField == _AccPaymentModeTextField) {
        [textField resignFirstResponder];
        _OpenSelectionType = OptionSelectionTypePaymentMode;
        [self openPickerController:_AccPaymentModeTextField];
    }
    
    if (textField == _AccPaymentMothodTextField) {
        [textField resignFirstResponder];
        _OpenSelectionType = OptionSelectionTypePaymentMethod;
        [self openPickerController:_AccPaymentMothodTextField];
    }
    
    if (textField == _AccPolicyStatusTextField) {
        [textField resignFirstResponder];
        _OpenSelectionType = OptionSelectionTypeStatus;
        [self openPickerController:_AccPolicyStatusTextField];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (BOOL) textFieldShouldReturn:(UITextField*)textField {
    
    [UIView animateWithDuration:1.0 animations:^(void){
        [self.AccidentDataTable setContentOffset:CGPointMake(0, 0)];
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


#pragma Add calenderview

- (IBAction)openDateSelectionController:(UITextField *)sender {
    
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
    
    if (_SelectedDateType == AccDateTypeEffectiveDate) {
        [_AccEffictiveDateTextField setText:[SelectedDate objectAtIndex:0]];
    }
    
    if (_SelectedDateType == AccDateTypeExpiryDate) {
        [_AccExpiryDateTextField setText:[SelectedDate objectAtIndex:0]];
    }
    
    if (_SelectedDateType == AccDateTypeReinStateDate) {
        [_AccReinStateDateTextField setText:[SelectedDate objectAtIndex:0]];
    }
    
    if (_SelectedDateType == AccDateTypepaidToDate) {
        [_AccPaidtoDateTextField setText:[SelectedDate objectAtIndex:0]];
    }
    
    if (_SelectedDateType == AccDateTypeLapseDate) {
        [_AccLapseDateTextField setText:[SelectedDate objectAtIndex:0]];
    }
    [self.view endEditing:YES];
    NSLog(@"Successfully selected date: %@", aDate);
    _SelectedDateType = AccDateTypeNone;
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    NSLog(@"Date selection was canceled");
    [self.view endEditing:YES];
    _SelectedDateType = AccDateTypeNone;
}

#pragma mark - RMPickerViewController Delegates

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
    [self.view endEditing:YES];
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.delegate = self;
    pickerVC.titleLabel.text = @"Please choose a row and press 'Select' or 'Cancel'.";
    [pickerVC show];
}

- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows {
    [self.view endEditing:YES];
    NSLog(@"Successfully selected rows: %@", [selectedRows objectAtIndex:0]);
    
    if (_OpenSelectionType == OptionSelectionTypeIssueAge) {
        [_AccIssueAgeTextField setText:[NSString stringWithFormat:@"%@",[selectedRows objectAtIndex:0]]];
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
        
        [_AccPaymentModeTextField setText:Dataval];
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
        [_AccPaymentMothodTextField setText:Dataval];
    } else if (_OpenSelectionType == OptionSelectionTypeStatus) {
        
        NSString *Dataval = nil;
        
        switch ([[selectedRows objectAtIndex:0] intValue]) {
            case 0:
                Dataval = @"INFORCE POLICY";
                break;
            default:
                Dataval = @"INFORCE POLICY";
                break;
        }
        [_AccPolicyStatusTextField setText:Dataval];
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
