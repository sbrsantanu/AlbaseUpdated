//
//  OCRSendmailContactlistViewController.m
//  OCRScanner
//
//  Created by Mac on 29/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRSendmailContactlistViewController.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"
#import <MessageUI/MessageUI.h>
#import "OCRDataObjectModel.h"
#import "RetriveUserData.h"

@interface OCRSendmailContactlistViewController ()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate,UISearchBarDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,RetriveUserDataDelegate>
{
    NSMutableArray *content;
    NSArray *indices;
}
@property (nonatomic,retain) NSString * currentpage;
@property (nonatomic,retain) NSString * Totalpage;
@property (nonatomic,retain) NSString * Perpage;

@property (nonatomic,retain) UITableView *ContactTable;

@property (nonatomic,retain) UIActivityIndicatorView *FooterActivity;

@property (nonatomic,retain) UITextField *SearchBoxTextField;

@property (nonatomic,retain) IBOutlet UISearchBar *ContaintSearchBar;
@end

@implementation OCRSendmailContactlistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // self=(IsIphone5)?[super initWithNibName:@"OCRSendmailContactlistViewController" bundle:nil]:[super initWithNibName:@"OCRSendmailContactlistViewController4s" bundle:nil];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRSendmailContactlistViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRSendmailContactlistViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRSendmailContactlistViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRSendmailContactlistViewController6s" bundle:nil];
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
    
    content = [[NSMutableArray alloc] init];
    // indices = [content valueForKey:@"headerTitle"];
    
    self.currentpage = @"0";
    self.Totalpage = @"0";
    self.Perpage = [NSString stringWithFormat:@"%d",20];
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Send Mail"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateNormal];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateHighlighted];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateSelected];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateApplication];
    
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _ContactTable = (UITableView *)[self.view viewWithTag:444];
    [_ContactTable setDelegate:self];
    [_ContactTable setDataSource:self];
    [_ContactTable setHidden:YES];
   // [self AppendDataFromWebservice];
    [_ContaintSearchBar setDelegate:self];
    
    RetriveUserData *userdata = [[RetriveUserData alloc] init];
    [userdata setDelegate:self];
    [userdata GetUserList];
    
    
    /* UITextFiled with tag 55
     */
    
    self.SearchBoxTextField = (UITextField *)[self.view viewWithTag:55];
    [self.SearchBoxTextField setDelegate:self];

}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"editing started");
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSLog(@"editing ended");
    [self.SearchBoxTextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.SearchBoxTextField resignFirstResponder];
    return YES;
}
- (void)leftSideMenuButtonPressed:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        NSLog(@"Menu bar button prassed..");
    }];
}
#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [[[content objectAtIndex:section] objectForKey:@"rowValues"] count] ;
    return [content count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    OCRUserDataObjectModel *UserDataObjectModel = [content objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[UserDataObjectModel Firstname],[UserDataObjectModel Lastname]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.layer.frame.size.width, 50)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    self.FooterActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 5, 32, 32)];
    [footerView addSubview:self.FooterActivity];
    [self.FooterActivity setBackgroundColor:[UIColor clearColor]];
    [self.FooterActivity setColor:[UIColor whiteColor]];
    [self.FooterActivity setHidesWhenStopped:YES];
    return footerView;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *actionSheetTitle = @"Send Mail";
    NSString *other1 = @"Mail";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, nil];
    
    [actionSheet setTag:indexPath.row];
    [actionSheet showInView:self.view];
    
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    
}

#pragma mark searchbar method data

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0) {
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    for(id aSubView in [_ContaintSearchBar subviews])
    {
        if([aSubView isKindOfClass:[UITextField class]])
        {
            UITextField *textField=(UITextField*)aSubView;
            [textField setDelegate:self];
            [textField resignFirstResponder];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
}

#pragma UIActionSheet protocol

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    MFMailComposeViewController *comp=[[MFMailComposeViewController alloc]init];
    [comp setMailComposeDelegate:self];
    if([MFMailComposeViewController canSendMail]) {
        OCRUserDataObjectModel *UserDataObjectModel = [content objectAtIndex:actionSheet.tag];
        [comp setToRecipients:[NSArray arrayWithObjects:[UserDataObjectModel Usersemail], nil]];
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
#pragma get Retrive data delegate

-(void)GetRetrivedUserDataWithSuccess:(RetriveUserData *)UserData ObjectCarrier:(id)ObjectCarrier
{
    for (OCRUserDataObjectModel *UserData in ObjectCarrier) {
        [content addObject:UserData];
    }
    [_ContactTable setHidden:NO];
    [_ContactTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)GetRetrivedUserDataWithError:(RetriveUserData *)UserData Errordata:(NSError *)Error
{
    NSLog(@"protocol data fetch err ---- %@",[NSString stringWithFormat:@"%@",Error]);
}

/*
-(void)AppendDataFromWebservice
{
    [self startSpin];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=getAllUserWithPagination&CurrentPage=%@&dataperpage=%@",self.currentpage,self.Perpage];
        NSLog(@"URL : %@", url);
        
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
        if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if([[results objectForKey:@"status"] isEqualToString:@"success"])
            {
                [self stopSpin];
                
                NSLog(@"user fetched datab------- %@",[results objectForKey:@"userdata"]);
                
                for (id MyBirthday in [results objectForKey:@"userdata"]) {
                    
                    OCRUserDataObjectModel *UserDataObjectModel = [[OCRUserDataObjectModel alloc] initWithFirstname:[MyBirthday objectForKey:@"Firstname"] Lastname:[MyBirthday objectForKey:@"Lastname"] DateOfBirth:[MyBirthday objectForKey:@"DateOfBirth"] UserPhoneNumber:[MyBirthday objectForKey:@"UserPhoneNumber"] Useremail:[MyBirthday objectForKey:@"Useremail"] Gender:[MyBirthday objectForKey:@"Gender"] ProfileImage:@"" UserId:[MyBirthday objectForKey:@"userID"]];
                    
                    [content addObject:UserDataObjectModel];
                }
                self.Totalpage = [results objectForKey:@"totalpages"];
                [self stopSpin];
                if ([self.currentpage intValue] == 0) {
                    [_ContactTable setHidden:NO];
                    [_ContactTable reloadData];
                } else {
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                    for (int i = [self.currentpage intValue]*[self.Perpage intValue]; i< ([self.currentpage intValue]*[self.Perpage intValue] + [self.Perpage intValue]); i++) {
                        
                        if (i < content.count) {
                            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                        } else {
                            break;
                        }
                    }
                    [_ContactTable beginUpdates];
                    [_ContactTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                    [_ContactTable endUpdates];
                    [self.FooterActivity stopAnimating];
                }
            }
        });
    });
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.Totalpage intValue]>[self.currentpage intValue]) {
        
        if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height)
        {
            [self.FooterActivity startAnimating];
            self.currentpage = [NSString stringWithFormat:@"%d",[self.currentpage intValue]+1];
            [self AppendDataFromWebservice];
        }
        else
        {
            [self.FooterActivity stopAnimating];
        }
    } else {
        NSLog(@"I am end of the table");
    }
}
*/
@end