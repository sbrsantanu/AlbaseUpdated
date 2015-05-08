//
//  OCRLoginViewController.m
//  Albase
//
//  Created by Mac on 26/12/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRLoginViewController.h"
#import "UIColor+expanded.h"
#import "UIColor+HexColor.h"
//#import "KeychainItemWrapper.h"
#import "OCRContactListViewController.h"
#import <Security/Security.h>

@interface OCRLoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic,retain) UIScrollView * BackgroundScroollView;
@property (nonatomic,retain) UITextField  *LOUserEmail,*LOUserPassword;
@property (nonatomic,retain) UIButton *LoginButton;
//@property (nonatomic, retain) KeychainItemWrapper *keychainItemWrapper;
@end

@implementation OCRLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRLoginViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRLoginViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRLoginViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRLoginViewController6s" bundle:nil];
        }
        //self = ([[UIScreen mainScreen] bounds].size.height>500)?[super initWithNibName:@"OCRLoginViewController" bundle:nil]:[super initWithNibName:@"OCRLoginViewController4s" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    const float LoginTextXcord          = 55.0f;
    const float LoginTextYcord          = 40.0f;
    const float LoginTextYcord4S        = 40.0f;
    const float LoginTextWidth          = 260.0f;
    const float LoginTextHeight         = 50.0f;
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Login"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
   /**self.keychainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[NSString stringWithFormat:@"MY_APP_CREDENTIALS.%@",[[NSBundle mainBundle] bundleIdentifier]] accessGroup:nil];
    [self.keychainItemWrapper resetKeychainItem];
    **/
    
    self.BackgroundScroollView = (UIScrollView *)[self.view viewWithTag:99];
    [self.BackgroundScroollView setBackgroundColor:[UIColor clearColor]];
    [self.BackgroundScroollView setDelegate:self];
    
    UILabel *RegTextlabel = [[UILabel alloc] initWithFrame:CGRectMake(LoginTextXcord, ([[UIScreen mainScreen] bounds].size.height>500)?LoginTextYcord:LoginTextYcord4S, LoginTextWidth, LoginTextHeight)];
    [RegTextlabel setBackgroundColor:[UIColor clearColor]];
    [RegTextlabel setTextColor:[UIColor blackColor]];
    [RegTextlabel setText:@"Login To Your Account"];
    [RegTextlabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
    [self.BackgroundScroollView addSubview:RegTextlabel];
    
    UILabel *BorderLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, (([[UIScreen mainScreen] bounds].size.height>500))?90:LoginTextYcord4S+LoginTextHeight-5, 220, 1)];
    [BorderLabel setBackgroundColor:[UIColor colorFromHex:0xa3a3a2]];
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
                    self.LOUserEmail = textField;
                    [textField setPlaceholder:@"Username"];
                    break;
                case 12:
                    self.LOUserPassword = textField;
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
            
            [textField.layer setBorderColor:[UIColor colorFromHex:0xd9d9d9].CGColor];
            [textField.layer setBorderWidth:1.0f];
            [textField.layer setCornerRadius:1.0f];
        }
    }
    
    /*
     Add register button
     */
    
    self.LoginButton = (UIButton *)[self.BackgroundScroollView viewWithTag:100];
    [self.LoginButton setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    [self.LoginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.LoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.LoginButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    
  
    /*
     Add event target to the buttons
     */
    
    [self.LoginButton addTarget:self action:@selector(dologin) forControlEvents:UIControlEventTouchUpInside];
}

-(void)PaddingViewWithTextField:(UITextField *)UITextField
{
    UIView *paddingView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UITextField.layer.frame.size.height-25, UITextField.layer.frame.size.height)];
    UITextField.leftView        = paddingView;
    UITextField.leftViewMode    = UITextFieldViewModeAlways;
    [UITextField addSubview:paddingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark Spin Button
-(NSString *)CleanTextField:(NSString *)TextfieldName
{
    NSString *Cleanvalue = [TextfieldName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return Cleanvalue;
}
-(void)dologin
{
    if ([self CleanTextField:self.LOUserEmail.text].length == 0) {
        
        UIAlertView *UsernameAlert =[[UIAlertView alloc] initWithTitle:@"Error" message:@"Username can't be empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [UsernameAlert show];
        
    } else if ([self CleanTextField:self.LOUserPassword.text].length == 0) {
        
        UIAlertView *PasswordAlert =[[UIAlertView alloc] initWithTitle:@"Error" message:@"Password can't be empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [PasswordAlert show];
        
    } else {
        
        for(id aSubView in [self.BackgroundScroollView subviews])
        {
            if([aSubView isKindOfClass:[UITextField class]])
            {
                UITextField *textField=(UITextField*)aSubView;
                [textField resignFirstResponder];
            }
        }
        [self startSpin];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=Checkauthentication&accessusername=%@&accessuserpass=%@",[self CleanTextField:self.LOUserEmail.text],[self CleanTextField:self.LOUserPassword.text]];
            NSLog(@"URL : %@", url);
            
            NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
            if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            [self stopSpin];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if ([[results objectForKey:@"status"] isEqualToString:@"success"]) {
                    [self SetUserPrivateDtainKeyChain];
                    
                    OCRContactListViewController *ContactList = [[OCRContactListViewController alloc] initWithNibName:@"OCRContactListViewController" bundle:nil];
                    [self.navigationController pushViewController:ContactList animated:YES];
                } else {
                    UIAlertView *AccessDenied =[[UIAlertView alloc] initWithTitle:@"Error" message:@"There is some Error, Please contact to admin" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [AccessDenied show];
                }
            });
        });
    }
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
-(void)SetUserPrivateDtainKeyChain
{
 
  /**  [self.keychainItemWrapper setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    [self.keychainItemWrapper resetKeychainItem];
    [self.keychainItemWrapper setObject:self.LOUserEmail.text forKey:(__bridge id)kSecAttrAccount];
    [self.keychainItemWrapper setObject:self.LOUserPassword.text forKey:(__bridge id)kSecValueData];
   **/
}

@end
