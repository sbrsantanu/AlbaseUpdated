//
//  OCRNoteListViewController.m
//  OCRScanner
//
//  Created by Mac on 29/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRNoteListViewController.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"
#import "OCRNoteDetailsViewController.h"
#import "OCRDataObjectModel.h"
#import "OCRAddEditNoteViewController.h"
#import "NoteDataProtocol.h"

@interface OCRNoteListViewController () <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate,UISearchBarDelegate,NoteDataProtocolDelegate>
{
    NSMutableArray *NotesData;
}
@property (nonatomic,retain) NSString * currentpage;
@property (nonatomic,retain) NSString * Totalpage;
@property (nonatomic,retain) NSString * Perpage;

@property (nonatomic,retain) UITableView *NoteDataTable;
@property (nonatomic,retain) UIActivityIndicatorView *FooterActivity;
@property (nonatomic,retain) UITextField *SearchBoxTextField;
@property (nonatomic,retain) IBOutlet UISearchBar *ContaintSearchBar;

@end

@implementation OCRNoteListViewController

int CurrentPageNote = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // self=(IsIphone5)?[super initWithNibName:@"OCRNoteListViewController" bundle:nil]:[super initWithNibName:@"OCRNoteListViewController4s" bundle:nil];
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRNoteListViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRNoteListViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRNoteListViewController6s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRNoteListViewController6" bundle:nil];
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
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Notes"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateNormal];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateHighlighted];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateSelected];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateApplication];
    
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _NoteDataTable = (UITableView *)[self.view viewWithTag:444];
    [_NoteDataTable setDelegate:self];
    [_NoteDataTable setDataSource:self];
    [_NoteDataTable setHidden:YES];
    
    [_ContaintSearchBar setDelegate:self];
    
    /*
     Call note data protocol
     */
    
    /*
    NoteDataProtocol *NoteData = [[NoteDataProtocol alloc] init];
    [NoteData setDelegate:self];
    [NoteData SaveNoteDataIntoLocaldatabase];
    [self startSpin];
     */
    
    /* UITextFiled with tag 55
     */
    
    self.SearchBoxTextField = (UITextField *)[self.view viewWithTag:55];
    [self.SearchBoxTextField setDelegate:self];
    
    /*
     */
    
    UIButton *AddNoteButton = (UIButton *)[self.view viewWithTag:112];
    [AddNoteButton addTarget:self action:@selector(AddNewNote:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewDidAppear:(BOOL)animated
{
    NotesData = [[NSMutableArray alloc] init];
    self.currentpage = @"0";
    self.Totalpage = @"0";
    self.Perpage = [NSString stringWithFormat:@"%d",10];
    [self AppendDataFromWebservice];
}

-(IBAction)AddNewNote:(id)sender
{
    OCRAddEditNoteViewController *AddeditNote = [[OCRAddEditNoteViewController alloc] initWithNibName:@"OCRAddEditNoteViewController" bundle:nil];
    AddeditNote.UserNoteWritingStatus = NoteWritingStatusNewNote;
    [self presentViewController:AddeditNote animated:YES completion:nil];
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
    return [NotesData count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    OCRNoteDataObjectModel *NoteObject = [NotesData objectAtIndex:indexPath.row];
    NSLog(@"NotesData ---%@",NoteObject);
    cell.textLabel.text = [NoteObject NoteDetails];
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
    
    OCRNoteDataObjectModel *NoteObject = [NotesData objectAtIndex:indexPath.row];
	OCRNoteDetailsViewController *UserDetailsScreen = [[OCRNoteDetailsViewController alloc] initWithNibName:NSStringFromClass([OCRNoteDetailsViewController class]) bundle:nil];
    UserDetailsScreen.noteobject = NoteObject;
    [self.navigationController pushViewController:UserDetailsScreen animated:YES];
    
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

#pragma call note data protocol methods

/*
 Data protocol with success
 */

-(void)SaveNoteDataIntoDataBase:(NoteDataProtocol *)DataProtocol WithSuccess:(id)NoteObject
{
    for (OCRNoteDataObjectModel *UserData in NoteObject) {
        NSLog(@"NoteDataObject ----- %@",[UserData NoteId]);
        [NotesData addObject:UserData];
    }
    [self stopSpin];
    [_NoteDataTable setHidden:NO];
    [_NoteDataTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

/*
 Data protocol with error
 */

-(void)SaveNoteDataIntoDataBase:(NoteDataProtocol *)DataProtocol WithError:(NSError *)ErrorData
{
    [self stopSpin];
    NSLog(@"Note data protocol error --- %@",[NSString stringWithFormat:@"%@",ErrorData]);
}

-(void)AppendDataFromWebservice
{
    [self startSpin];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=getAllNoteWithPagination&CurrentPage=%@&dataperpage=%@",self.currentpage,self.Perpage];
        NSLog(@"URL : %@", url);
        
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
        if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if([[results objectForKey:@"status"] isEqualToString:@"success"])
            {
                [self stopSpin];
                for (id MyBirthday in [results objectForKey:@"userdata"]) {
                    
                    OCRNoteDataObjectModel *NoteObject = [[OCRNoteDataObjectModel alloc] initWithNoteId:[MyBirthday objectForKey:@"noteid"] NoteAddedDate:[MyBirthday objectForKey:@"addedon"] NoteDetails:[MyBirthday objectForKey:@"notedetails"]];
                    
                    [NotesData addObject:NoteObject];
                }
                NSLog(@"NotesData one === %@",NotesData);
                self.Totalpage = [results objectForKey:@"totalpages"];
                [self stopSpin];
                if ([self.currentpage intValue] == 0) {
                    [_NoteDataTable setHidden:NO];
                    [_NoteDataTable reloadData];
                } else {
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                    for (int i = [self.currentpage intValue]*[self.Perpage intValue]; i< ([self.currentpage intValue]*[self.Perpage intValue] + [self.Perpage intValue]); i++) {
                        
                        if (i < NotesData.count) {
                            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                        } else {
                            break;
                        }
                    }
                    [_NoteDataTable beginUpdates];
                    [_NoteDataTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                    [_NoteDataTable endUpdates];
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

@end
