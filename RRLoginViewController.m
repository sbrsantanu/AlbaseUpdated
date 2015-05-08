//
//  RRLoginViewController.m
//  RecordReceived
//
//  Created by Mac on 19/08/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "RRLoginViewController.h"
#import "UITextField+Extaintation.h"
#import "UIButton+Color.h"
#import "UILabel+Presentation.h"
#import "NSString+PJR.h"
#import "RRForgetPasswordViewController.h"
#import "RRVideoListViewController.h"
#import "RRRegisterViewController.h"
#import "KeychainItemWrapper.h"
#import "RRDashboardViewController.h"

@class handelURLConnection;

@interface RRLoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate,HnadleNsUrlConnectionDelegate>

@property (nonatomic,retain) UIScrollView * BackgroundScroollView;
@property (nonatomic,retain) UITextField  *UserEmail,*UserPassword;
@property (nonatomic,retain) handelURLConnection *URLConnection;
@property (nonatomic,retain) UIButton *LoginButton;
@property (nonatomic, retain) KeychainItemWrapper *keychainItemWrapper;

@end

@implementation RRLoginViewController

const float LoginTextXcord          = 55.0f;
const float LoginTextYcord          = 120.0f;
const float LoginTextYcord4S        = 80.0f;
const float LoginTextWidth          = 60.0f;
const float LoginTextHeight         = 50.0f;
const float logingapbetweenTwotext  = -5.0f;
const float LoginRestTextWidth      = 175.0f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UserDataClass *Userdata  = [UserDataClass sharedUserDataClass];
        if (Userdata.UserId > 0) {
            
            RRDashboardViewController *DashboardView = [[RRDashboardViewController alloc] initWithNibName:NSStringFromClass(RRDashboardViewController.class) bundle:nil];
            [self GotoDifferentViewWithAnimation:DashboardView];
        }
        self=(IsIphone5)?[super initWithNibName:@"RRLoginViewController" bundle:nil]:[super initWithNibName:@"RRLoginViewControllerSmall" bundle:nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self SetupHeaderViewWithView:self.view withBackButton:NO];
    [super viewDidLoad];
    
    self.HandleURLConnection = [[handelURLConnection alloc] init];
    
    /*
     Decleare background scrollview
     */
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    self.keychainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[NSString stringWithFormat:@"MY_APP_CREDENTIALS.%@",[[NSBundle mainBundle] bundleIdentifier]] accessGroup:nil];
    [self.keychainItemWrapper resetKeychainItem];
    
    self.BackgroundScroollView = (UIScrollView *)[self.view viewWithTag:99];
    [self.BackgroundScroollView setBackgroundColor:[UIColor clearColor]];
    [self.BackgroundScroollView setDelegate:self];
    
    UILabel *RegTextlabel = [[UILabel alloc] initWithFrame:CGRectMake(LoginTextXcord, (IS_IPHONE5)?LoginTextYcord:LoginTextYcord4S, LoginTextWidth, LoginTextHeight)];
    [RegTextlabel setBackgroundColor:[UIColor clearColor]];
    [RegTextlabel setTextColor:UIColorFromRGB(0x000000)];
    [RegTextlabel setText:@"Login"];
    [RegTextlabel setFont:[UIFont fontWithName:StaticStrings.GlobalNormalFont size:25.0]];
    [self.BackgroundScroollView addSubview:RegTextlabel];
    
    UILabel *RegRestText = [[UILabel alloc] initWithFrame:CGRectMake(LoginTextXcord+LoginTextWidth+logingapbetweenTwotext, (IS_IPHONE5)?LoginTextYcord:LoginTextYcord4S, LoginRestTextWidth, LoginTextHeight)];
    [RegRestText setBackgroundColor:[UIColor clearColor]];
    [RegRestText setTextColor:UIColorFromRGB(0xffffff)];
    [RegRestText setText:@"To Your Account"];
    [RegRestText setFont:[UIFont fontWithName:StaticStrings.GlobalNormalFont size:25.0]];
    [self.BackgroundScroollView addSubview:RegRestText];
    
    UILabel *BorderLabel = [[UILabel alloc] initWithFrame:CGRectMake(LoginTextXcord-10, (IS_IPHONE5)?170:LoginTextYcord4S+LoginTextHeight-5, LoginTextWidth+LoginRestTextWidth+logingapbetweenTwotext, 1)];
    [BorderLabel setBackgroundColor:UIColorFromRGB(0xa3a3a2)];
    [self.BackgroundScroollView addSubview:BorderLabel];
    
    /*
     Searchfor uitextfield in main scrollview
     */
    
    for(id aSubView in [self.BackgroundScroollView subviews])
    {
        if([aSubView isKindOfClass:[UITextField class]])
        {
            /*
             Decleare the textfield
             */
            
            UITextField *textField=(UITextField*)aSubView;
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setBackgroundColor:[UIColor whiteColor]];
            [textField setTextColor:[UIColor blackColor]];
            [textField setDelegate:self];
            
            /*
             Add placholder to textfield
             */
            
            switch (textField.tag) {
                case 11:
                    self.UserEmail = textField;
                    [textField setPlaceholder:@"Username"];
                    break;
                case 12:
                    self.UserPassword = textField;
                    [textField setPlaceholder:@"Password"];
                    [textField setSecureTextEntry:YES];
                    break;
            }
            
            /*
             Add padding to textfield
             */
            
            [self PaddingViewWithTextField:textField];
            
            /*
             Set border
             */
            
            [textField.layer setBorderColor:UIColorFromRGB(0xd9d9d9).CGColor];
            [textField.layer setBorderWidth:1.0f];
            [textField.layer setCornerRadius:1.0f];
        }
    }
    
    /*
     Add register button
     */
    
    self.LoginButton = (UIButton *)[self.BackgroundScroollView viewWithTag:100];
    [self.LoginButton setBackgroundColor:UIColorFromRGB(0xe61700)];
    [self.LoginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.LoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.LoginButton.titleLabel setFont:[UIFont fontWithName:StaticStrings.GlobalNormalFont size:15.0f]];
    
    /*
     label one
     */
    
    UILabel *AlreadyRegisteredLabel = (UILabel *)[self.BackgroundScroollView viewWithTag:101];
    [AlreadyRegisteredLabel setTextColor:UIColorFromRGB(0xffffff)];
    [AlreadyRegisteredLabel setFont:[UIFont fontWithName:StaticStrings.GlobalNormalFont size:13.0f]];
    
    /*
     label two
     */
    
    UILabel *GotoForgetpassLabel = (UILabel *)[self.BackgroundScroollView viewWithTag:102];
    [GotoForgetpassLabel setTextColor:UIColorFromRGB(0xe61700)];
    [GotoForgetpassLabel setFont:[UIFont fontWithName:StaticStrings.GlobalNormalFont size:13.0f]];
    
    /*
     label one
     */
    
    UILabel *AlreadyRegisteredLabel1 = (UILabel *)[self.BackgroundScroollView viewWithTag:110];
    [AlreadyRegisteredLabel1 setTextColor:UIColorFromRGB(0xffffff)];
    [AlreadyRegisteredLabel1 setFont:[UIFont fontWithName:StaticStrings.GlobalNormalFont size:13.0f]];
    
    /*
     label two
     */
    
    UILabel *GotoForgetpassLabel1 = (UILabel *)[self.BackgroundScroollView viewWithTag:111];
    [GotoForgetpassLabel1 setTextColor:UIColorFromRGB(0xe61700)];
    [GotoForgetpassLabel1 setFont:[UIFont fontWithName:StaticStrings.GlobalNormalFont size:13.0f]];
    
    /*
     Go to Login Button
     */
    
    UIButton *ForgetPassButton = (UIButton *)[self.BackgroundScroollView viewWithTag:119];
    UIButton *registerButton = (UIButton *)[self.BackgroundScroollView viewWithTag:120];
    /*
     Add event target to the buttons
     */
    
    [self.LoginButton addTarget:self action:@selector(dologin:) forControlEvents:UIControlEventTouchUpInside];
    [ForgetPassButton addTarget:self action:@selector(Recover:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton addTarget:self action:@selector(Register:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)PaddingViewWithTextField:(UITextField *)UITextField
{
    UIView *paddingView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UITextField.layer.frame.size.height-25, UITextField.layer.frame.size.height)];
    UITextField.leftView        = paddingView;
    UITextField.leftViewMode    = UITextFieldViewModeAlways;
    [UITextField addSubview:paddingView];
}

-(IBAction)dologin:(id)sender
{
    // Chaeck username textfild text length
    
    if ([self CleanTextField:self.UserEmail.text].length == 0) {
        
        // Username is blank, show message
        
        ShowAlert([StaticStrings WSInvaliedString],[StaticStrings ErrorBlankUsername]);
    
    // Chaeck password textfild text length
        
    } else if ([self CleanTextField:self.UserPassword.text].length == 0) {
        
        // password is blank, show message
        
        ShowAlert([StaticStrings WSInvaliedString],[StaticStrings ErrorBlankPassword]);
    
    // everything is fine, call webservice for user authentication
        
    } else {
        
        /*
         Hide keyboard start
         */
        
        // check all the view in mainview
        
        for(id aSubView in [self.BackgroundScroollView subviews])
        {
            // Count number of UITextviews in mainview
            
            if([aSubView isKindOfClass:[UITextField class]])
            {
                // Declare UITextview
                
                UITextField *textField=(UITextField*)aSubView;
                
                // Hide keyboard
                
                [textField resignFirstResponder];
            }
        }
        /*
         Hide keyboard end
         */
        
        
        // Create array for parameter
        
        NSArray *ParamArray = [StaticStrings.ParametersOfLogin componentsSeparatedByString:StaticStrings.URLParameterString];
        
        // Create data array with clean value of textfields text
        
        NSArray *FieldArray = [[NSArray alloc] initWithObjects:[self CleanTextField:self.UserEmail.text],[self CleanTextField:self.UserPassword.text], nil];
        
        // Split data and create directory
        
        NSDictionary *ParamDictionary = [self GenerateParamValueForSubmit:ParamArray FieldArray:FieldArray];
        
        // Craete the URL for webservice
        
        NSString *GeneratedParam = [self CallURLForServerReturn:[ParamDictionary mutableCopy] URL:[StaticStrings WebserviceforLogin]];
        
        // make view touch disable for the time being
        
        [self.view setUserInteractionEnabled:NO];
        
        // Start spin
        
        [self startSpin];
        
        // URL connection protol declearation
        
        [self.HandleURLConnection setDelegate:self];
        
        // Call Protol method
        
        [self.HandleURLConnection getValuFromURLWithPost:GeneratedParam URLFOR:[NSString stringWithFormat:@"%@%@",[StaticStrings UrlGlobalSite],[StaticStrings WebserviceforLogin]]];
        
    }
}

/*
 ------ Why to use keychain insted of NSUserdefaults
 
 Computer users typically have to manage multiple accounts that require logins with user IDs and passwords. Secure FTP servers, AppleShare servers, database servers, secure websites, instant messaging accounts, and many other services require authentication before they can be used. Users often respond to this situation by making up very simple, easily remembered passwords, by using the same password over and over, or by writing passwords down where they can be easily found. Any of these cases compromises security.
 
 The Keychain Services API provides a solution to this problem. By making a single call to this API, an application can store login information on a keychain where the application can retrieve the information—also with a single call—when needed. A keychain is an encrypted container that holds passwords for multiple applications and secure services. Keychains are secure storage containers, which means that when the keychain is locked, no one can access its protected contents. In OS X, users can unlock a keychain—thus providing trusted applications access to the contents—by entering a single master password. In iOS, each application always has access to its own keychain items; the user is never asked to unlock the keychain. Whereas in OS X any application can access any keychain item provided the user gives permission, in iOS an application can access only its own keychain items.
 
 Each keychain can contain any number of keychain items. Each keychain item contains data plus a set of attributes. For a keychain item that needs protection, such as a password or private key (a string of bytes used to encrypt or decrypt data), the data is encrypted and protected by the keychain. For keychain items that do not need protection, such as certificates, the data is not encrypted.
 
 The attributes associated with a keychain item depend on the class of the item; the item classes most used by applications (other than the Finder and the Keychain Access application in OS X) are Internet passwords and generic passwords. As you might expect, Internet passwords include attributes for such things as security domain, protocol type, and path. The passwords or other secrets stored as keychain items are encrypted. In OS X, encrypted items are inaccessible when the keychain is locked; if you try to access the item while the keychain is locked, Keychain Services displays a dialog prompting the user for the keychain password. The attributes are not encrypted, however, and can be read at any time, even when the keychain is locked. In iOS, your application always has access to its own keychain items.
 
 In OS X, each protected keychain item (and the keychain itself) contains access control information in the form of an opaque data structure called an access object. The access object contains one or more access control list (ACL) entries for that item. Each ACL entry has a list of one or more authorization tags specifying operations that can be done with that item, such as decrypting or authenticating. In addition, each ACL entry has a list of trusted applications that can perform the specified operations without authorization from the user.
 
 */

-(void)SetUserPrivateDtainKeyChain
{
    /*
     Initialze keychain class / Create instance of keychain class
     */
    
    
    
    /*
     Set keychain data accessable conirtion. Keycahin value can be accessed when the phone is unlock state/ active state
     */
    [self.keychainItemWrapper setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    
    /*
     Reset Keychan data before update it, keychain data can't be overwrite
     */
    [self.keychainItemWrapper resetKeychainItem];
    
    /*
     Set User emailis in keychain as secure value
    */
    [self.keychainItemWrapper setObject:self.UserEmail.text forKey:(__bridge id)kSecAttrAccount];
    
    /*
     Set user password in keychain as secure value data
     */
    [self.keychainItemWrapper setObject:self.UserPassword.text forKey:(__bridge id)kSecValueData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 11:
        {
            [UIView animateWithDuration:1.0f animations:^(void){
                [self.BackgroundScroollView setContentOffset:CGPointMake(0, 20) animated:YES];
            }];
            break;
        }
        case 12:
        {
            [UIView animateWithDuration:1.0f animations:^(void){
                [self.BackgroundScroollView setContentOffset:CGPointMake(0, 40) animated:YES];
            }];
            break;
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:1.0f animations:^(void){
       [self.BackgroundScroollView setContentOffset:CGPointMake(0, -20) animated:YES];
    }];
    [textField resignFirstResponder];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma URL connection protocol required method details

/*
 URL connection success handler
 */
- (void)HnadleNsUrlConnection:(handelURLConnection *)myObj json:(NSDictionary *)json
{
    [self.view setUserInteractionEnabled:YES];
    [self stopSpin];
    if ([[json objectForKey:[StaticStrings WSStatusStringString]] isEqualToString:[StaticStrings WSReturnSuccessString]]) {
        
        // Save data in keychain
        
        [self SetUserPrivateDtainKeyChain];
        
        // Clear all text filed data
        
        for(id aSubView in [self.BackgroundScroollView subviews])
        {
            if([aSubView isKindOfClass:[UITextField class]])
            {
                UITextField *textField=(UITextField*)aSubView;
                [textField setText:nil];
            }
        }
        
        UserDataClass *DataClass = [[UserDataClass alloc] initWithParamName:[json objectForKey:@"name"] ParamRegistrationDate:[json objectForKey:@"registration_date"] ParamuserEmail:[json objectForKey:@"user_email"] ParamUserId:[[json objectForKey:@"user_id"] intValue] ParamUsername:[json objectForKey:@"user_name"] ParamPaypalEmailId:@"Not Available" ParamUsedSpace:[json objectForKey:@"usedspace"]];
        [UserDataClass setSharedUserDataClass:DataClass];
        
        [self GotoDashboard];
        
    } else {
        
        ShowAlert([StaticStrings WSInvaliedString], [json objectForKey:[StaticStrings WSMessageString]]);
    }
}

/*
 URL connection Error Handler
 */
- (void)HnadleNsUrlConnectionErr:(handelURLConnection *)myObj Errdata:(NSError *)Errdata
{
    NSLog(@"URL connection handle error --- %@",[NSString stringWithFormat:@"%@",Errdata]);
}

-(void)dealloc
{
    self.BackgroundScroollView          = nil;
    self.UserEmail                      = nil;
    self.UserPassword                   = nil;
    self.URLConnection                  = nil;
    self.LoginButton                    = nil;
}

/*
 */

-(IBAction)Register:(id)sender
{
    RRRegisterViewController *RR = [[RRRegisterViewController alloc] initWithNibName:NSStringFromClass(RRRegisterViewController.class) bundle:nil];
    [self GotoDifferentViewWithAnimation:RR];
}

-(IBAction)Recover:(id)sender
{
    RRForgetPasswordViewController *RR = [[RRForgetPasswordViewController alloc] initWithNibName:NSStringFromClass(RRForgetPasswordViewController.class) bundle:nil];
    [self GotoDifferentViewWithAnimation:RR];
}

-(void)GotoDashboard
{
    RRDashboardViewController *DashBoard = [[RRDashboardViewController alloc] initWithNibName:NSStringFromClass(RRDashboardViewController.class) bundle:nil];
    [self GotoDifferentViewWithAnimation:DashBoard];
    
}

@end
