//
//  OCRSettingsViewController.m
//  Albase
//
//  Created by Mac on 18/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRSettingsViewController.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"

@interface OCRSettingsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic,retain) UITableView *SettingsTable;
@property (nonatomic,retain) NSArray  *TableViewDataArray;
@end

@implementation OCRSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // self=(IsIphone5)?[super initWithNibName:@"OCRSettingsViewController" bundle:nil]:[super initWithNibName:@"OCRSettingsViewController4s" bundle:nil];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRSettingsViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRSettingsViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRSettingsViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRSettingsViewController6s" bundle:nil];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.SettingsTable = (UITableView *)[self.view viewWithTag:121];
    [self.SettingsTable setDelegate:self];
    [self.SettingsTable setDataSource:self];
    [self.SettingsTable setBackgroundColor:[UIColor clearColor]];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Settings"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateNormal];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateHighlighted];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateSelected];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateApplication];
    
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.TableViewDataArray = [[NSArray alloc] initWithObjects:@"Sync Contact",@"Sync Appointment",@"Sync Birthday",@"Sync Note",@"Terms Of Services",@"Privacy Policy", nil];
    
}

- (void)leftSideMenuButtonPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        NSLog(@"Menu bar button prassed..");
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * TableCell = [[UITableViewCell alloc] init];
    [TableCell setBackgroundColor:[UIColor clearColor]];
    [TableCell.textLabel setTextColor:[UIColor darkGrayColor]];
    [TableCell.textLabel setText:[self.TableViewDataArray objectAtIndex:indexPath.section]];
    [TableCell.textLabel setTextAlignment:NSTextAlignmentLeft];
    [TableCell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    
    return TableCell;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.0;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *Headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.layer.frame.size.width, 50)];
    [Headerview setBackgroundColor:[UIColor clearColor]];
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Headerview.frame.size.width, 15)];
    [TitleLabel setBackgroundColor:[UIColor clearColor]];
    [TitleLabel setTextColor:[UIColor darkGrayColor]];
    [TitleLabel setFont:[UIFont fontWithName:@"Helvetica Bold" size:14.0f]];
    [Headerview addSubview:TitleLabel];
    [TitleLabel setText:[self.TableViewDataArray objectAtIndex:section]];
    return Headerview;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
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
            [Footerlabel setText:@"Sync your contacts"];
            break;
        case 1:
            [Footerlabel setText:@"Sync all Appointments"];
            break;
        case 3:
            [Footerlabel setText:@"Sync Birthday List"];
            break;
        case 5:
            [Footerlabel setText:@"Sync Note"];
            break;
        default:
            [Footerlabel setText:@""];
            break;
    }
    /*
     
     */
    
    return viewFotter;
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
