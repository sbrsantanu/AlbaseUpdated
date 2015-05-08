//
//  OCRAppointmentDetailsViewController.m
//  Albase
//
//  Created by Mac on 30/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRAppointmentDetailsViewController.h"
#import "OCRAppointmentCalenderViewController.h"
#import "UIColor+HexColor.h"
#import "EditAppointmentViewController.h"

@interface OCRAppointmentDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView *AppointmentDetails;
@end

@implementation OCRAppointmentDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRAppointmentDetailsViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRAppointmentDetailsViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRAppointmentDetailsViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRAppointmentDetailsViewController6s" bundle:nil];
        }
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _AppointmentDetails = (UITableView *)[self.view viewWithTag:445];
    [_AppointmentDetails setDelegate:self];
    [_AppointmentDetails setDataSource:self];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Appointment Details"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:145];    
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *EditButton = (UIButton *)[self.view viewWithTag:146];
    [EditButton addTarget:self action:@selector(RightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}
-(IBAction)RightSideMenuButtonPressed:(id)sender
{
    EditAppointmentViewController *EditAppointment = [[EditAppointmentViewController alloc] initWithNibName:@"EditAppointmentViewController" bundle:nil];
    EditAppointment.EditableObjectCarrier = _ObjectCarrier;
    [self.navigationController pushViewController:EditAppointment animated:YES];
}
-(IBAction)leftSideMenuButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
        [TitleLabel setText:@"Title"];
    } else if (section == 1) {
        [TitleLabel setText:@"Appoinment Startdate"];
    } else if (section == 2) {
        [TitleLabel setText:@"Appoinment Enddate"];
    } else if (section == 3) {
        [TitleLabel setText:@"Appoinment Duration"];
    } else if (section == 4) {
        [TitleLabel setText:@"Invites"];
    } else if (section == 5) {
        [TitleLabel setText:@"Notes"];
    }
    return Headerview;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *TableCell = [[UITableViewCell alloc] init];
    [TableCell.textLabel setTextColor:[UIColor darkGrayColor]];
    [TableCell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    if (indexPath.section == 0) {
        [TableCell.textLabel setText:[_ObjectCarrier AppointmentTitle]];
    } else if (indexPath.section == 1) {
        [TableCell.textLabel setText:[NSString stringWithFormat:@"%@ at %@",[_ObjectCarrier ApponitmentStartDate],[_ObjectCarrier AppointmentStartTime]]];
    } else if (indexPath.section == 2) {
        [TableCell.textLabel setText:[NSString stringWithFormat:@"%@ at %@",[_ObjectCarrier ApponitmentEndDate],[_ObjectCarrier AppointmentEndtime]]];
    } else if (indexPath.section == 3) {
        [TableCell.textLabel setText:[NSString stringWithFormat:@"%@ Hr",[_ObjectCarrier ApponitmentDuration]]];
    } else if (indexPath.section == 4) {
        [TableCell.textLabel setText:[_ObjectCarrier AppointmentWithname]];
    } else if (indexPath.section == 5) {
        [TableCell.textLabel setText:[_ObjectCarrier Note]];
    }
    return TableCell;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
