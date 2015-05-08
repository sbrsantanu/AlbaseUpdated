//
//  UserSearchByNRICViewController.m
//  Albase
//
//  Created by Mac on 25/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "UserSearchByNRICViewController.h"
#import "UIColor+HexColor.h"
#import "OCRAddAppointmentViewController.h"
#import "OCRDataObjectModel.h"
#import "RetriveUserData.h"

typedef enum
{
    SearchButtonModeActive,
    SearchButtonModeInActive
} SearchButtonActiveStatus;

typedef enum {
    SearchStatusNil,
    SearchStatusOn
} SearchStatus;

@interface UserSearchByNRICViewController ()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate,UISearchBarDelegate,RetriveUserDataDelegate>
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
@property (assign)           SearchButtonActiveStatus SearchButtonMode;
@property (nonatomic,retain) IBOutlet UISearchBar *ContaintSearchBar;
@property (nonatomic,assign) SearchStatus TableSearchStatus;
@property (nonatomic, strong) NSMutableArray *searchResult;

@end

@implementation UserSearchByNRICViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self=(IsIphone5)?[super initWithNibName:@"UserSearchByNRICViewController" bundle:nil]:[super initWithNibName:@"UserSearchByNRICViewController4s" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    content = [[NSMutableArray alloc] init];
    // indices = [content valueForKey:@"headerTitle"];
    
    self.currentpage = @"0";
    self.Totalpage = @"0";
    self.Perpage = [NSString stringWithFormat:@"%d",20];
    
    self.SearchButtonMode = SearchButtonModeInActive;
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Contacts"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    [SetButton.titleLabel setText:@"Close"];
    [SetButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _ContactTable = (UITableView *)[self.view viewWithTag:444];
    [_ContactTable setDelegate:self];
    [_ContactTable setDataSource:self];
    [_ContactTable setHidden:YES];
    //[self AppendDataFromWebservice];
    
    RetriveUserData *RetrivedData = [[RetriveUserData alloc] init];
    [RetrivedData setDelegate:self];
    [RetrivedData GetUserList];
    
    [_ContaintSearchBar setDelegate:self];
    
    
    /* UITextFiled with tag 55
     */
    
    self.SearchBoxTextField = (UITextField *)[self.view viewWithTag:55];
    [self.SearchBoxTextField setDelegate:self];
    
    _TableSearchStatus = SearchStatusNil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return ([content count] == 0)?1:[content count];
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
    
    if ([content count] ==0) {
        cell.textLabel.text = @"New User";
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[UserDataObjectModel Firstname],[UserDataObjectModel Lastname]];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    }
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
    
    if ([content count] == 0) {
        
        [self dismissViewControllerAnimated:YES completion:^(void){
            [_delegate HandleDataObject:self ObjectCarrier:nil WithUserId:@"0"];
        }];
        
    } else {
        
        OCRUserDataObjectModel *UserDataObjectModel = [content objectAtIndex:indexPath.row];
        [self dismissViewControllerAnimated:YES completion:^(void){
            [_delegate HandleDataObject:self ObjectCarrier:UserDataObjectModel WithUserId:[UserDataObjectModel UserId]];
        }];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    
    _TableSearchStatus  = SearchStatusNil;
    _searchResult       = nil;
    _ContactTable       = nil;
    content             = nil;
    
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
        _TableSearchStatus = SearchStatusNil;
    } else {
        
        _TableSearchStatus = SearchStatusOn;
        [_searchResult removeAllObjects];
        
        for (OCRUserDataObjectModel *dataModel in content) {
            
            NSRange TextRangeFirstName = [[dataModel Firstname] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange TextRangelastName = [[dataModel Lastname] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange TextRangeEmail = [[dataModel Usersemail] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange TextRangePhone = [[dataModel UserPhoneNumber] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            NSRange TextRangeFullname = [[NSString stringWithFormat:@"%@ %@",[dataModel Firstname],[dataModel Lastname]] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(TextRangeFirstName.location != NSNotFound || TextRangelastName.location != NSNotFound || TextRangeEmail.location != NSNotFound || TextRangePhone.location != NSNotFound || TextRangeFullname.location != NSNotFound)
                [_searchResult addObject:dataModel];
        }
    }
    [_ContactTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    _TableSearchStatus = SearchStatusNil;
    [_ContactTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    _TableSearchStatus = SearchStatusOn;
    
    for(id aSubView in [_ContaintSearchBar subviews])
    {
        if([aSubView isKindOfClass:[UITextField class]])
        {
            UITextField *textField=(UITextField*)aSubView;
            [textField setDelegate:self];
            [textField resignFirstResponder];
        }
    }
    [_ContactTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/* Implement Protocol method start */

-(void)GetRetrivedUserDataWithError:(RetriveUserData *)UserData Errordata:(NSError *)Error
{
    NSLog(@"Protocol Dta Fetch Err ----- %@",[NSString stringWithFormat:@"%@",Error]);
}

-(void)GetRetrivedUserDataWithSuccess:(RetriveUserData *)UserData ObjectCarrier:(id)ObjectCarrier
{
    for (OCRUserDataObjectModel *userData in ObjectCarrier) {
        [content addObject:userData];
    }
    [_ContactTable setHidden:NO];
    [_ContactTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/* Implement Protocol method end */

@end
