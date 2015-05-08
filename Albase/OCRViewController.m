//
//  OCRViewController.m
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRViewController.h"
#import <Security/Security.h>
#import <UIKit/UIKit.h>
#import "OCRGlobalMethods.h"
#import "MFSideMenu.h"
#import "UIColor+HexColor.h"
#import "ImageViewController.h"
#import "OCRContactListViewController.h"
#import "NotificationCenterStaticParameter.h"
//#import "KeychainItemWrapper.h"
#import "OCRLoginViewController.h"

@interface OCRViewController ()
{
    CGRect mainFrame;
}
@property (nonatomic,retain) UIActivityIndicatorView *MainActivity;
@property (nonatomic,retain) NSTimer *DataTimer;
@end

@implementation OCRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    mainFrame = [[UIScreen mainScreen] bounds];
    [self startSpin];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *HeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];;
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    [self.view addSubview:HeaderView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDataDownloadComplete:) name:UserDataDownloadComplete object:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self stopSpin];
}

-(NSString *)CleanTextField:(NSString *)TextfieldName
{
    NSString *Cleanvalue = [TextfieldName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return Cleanvalue;
}

-(IBAction)userDataDownloadComplete:(id)sender
{
  /**  KeychainItemWrapper *MykeychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[NSString stringWithFormat:@"MY_APP_CREDENTIALS.%@",[[NSBundle mainBundle] bundleIdentifier]] accessGroup:nil];
        
    NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=Checkauthentication&accessusername=%@&accessuserpass=%@",[MykeychainWrapper objectForKey:(__bridge id)kSecAttrAccount],[MykeychainWrapper objectForKey:(__bridge id)kSecValueData]];
   **/
 
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=Checkauthentication&accessusername=%@&accessuserpass=%@",@"demo",@"123456"];
            NSLog(@"URL : %@", url);
            
            NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
            if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if ([[results objectForKey:@"status"] isEqualToString:@"success"]) {
                    OCRContactListViewController *ContactList = [[OCRContactListViewController alloc] init];
                    [self.navigationController pushViewController:ContactList animated:NO];
                } else {
                    OCRLoginViewController *LoginView = [[OCRLoginViewController alloc] initWithNibName:@"OCRLoginViewController" bundle:nil];
                    [self.navigationController pushViewController:LoginView animated:YES];
                }
            });
        });
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
