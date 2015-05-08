//
//  OCRApponimentListViewController.m
//  OCRScanner
//
//  Created by Mac on 29/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRApponimentListViewController.h"
#import "DIDatepicker.h"
#import "UIColor+HexColor.h"
#import "OCRAppointmentCalenderViewController.h"
#import "OCRAppontmentCell.h"
#import "OCRDataObjectModel.h"
#import "OCRAppointmentNoDataTableViewCell.h"
#import "OCRAppointmentDetailsViewController.h"
#import "MFSideMenu.h"

@interface OCRApponimentListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet DIDatepicker *datepicker;
@property (nonatomic,retain) UITableView *AppointmentListtable;
@property (nonatomic,strong) NSMutableArray *AppointmentDataArray;
@end

@implementation OCRApponimentListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil LastVisitedView:(LastVisitedView )ParamLastVisitedView SelectedDate:(NSDate *)ParamSelectedDate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRApponimentListViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRApponimentListViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRApponimentListViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRApponimentListViewController6s" bundle:nil];
        }
        
        self.LastVisitedViewController = ParamLastVisitedView;
        self.SelectedDate = ParamSelectedDate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    
    if (_LastVisitedViewController == LastVisitedViewCalender) {
        [SetButton setBackgroundImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateNormal];
        [SetButton setBackgroundImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateHighlighted];
        [SetButton setBackgroundImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateSelected];
        [SetButton setBackgroundImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateApplication];
    } else {
        [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2.png"] forState:UIControlStateNormal];
        [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2.png"] forState:UIControlStateHighlighted];
        [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2.png"] forState:UIControlStateSelected];
        [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2.png"] forState:UIControlStateApplication];
    }    
    
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    @try {
        
        [self.datepicker fillDatesFromCurrentDate:14];
        [self.datepicker fillCurrentYear];
        NSLog(@"_SelectedDate hi santanu --- %@",_SelectedDate);
        NSLog(@"---------------- %d",[self numberofdays:[NSString stringWithFormat:@"%@",_SelectedDate]]);
        [self.datepicker selectDateAtIndex:[self numberofdays:[NSString stringWithFormat:@"%@",_SelectedDate]]];
        
        
        _AppointmentListtable = (UITableView *)[self.view viewWithTag:444];
        [_AppointmentListtable setDelegate:self];
        [_AppointmentListtable setDataSource:self];
        
        _AppointmentDataArray = [[NSMutableArray alloc] init];
        
        [self.datepicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
        
        [self updateSelectedDate];
    }
    @catch (NSException *exception) {
        
    }
}
-(int)numberofdays :(NSString *)dateStr
{
    int currentDay;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss Z"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:@"D"];
    currentDay = [[dateFormatter stringFromDate:date] intValue];
    //NSLog(@"All data ====== date _____ %@ +++++ currentDay___%d ------- %@",date,currentDay,dateStr);
    return currentDay-1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *Headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _AppointmentListtable.layer.frame.size.width, 10)];
    UILabel *HeaderTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, Headerview.layer.frame.size.width-20, 20)];
    [HeaderTitleLabel setBackgroundColor:[UIColor clearColor]];
    [HeaderTitleLabel setTextColor:[UIColor darkGrayColor]];
    [HeaderTitleLabel setText:@"Appoinment List"];
    [HeaderTitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [Headerview addSubview:HeaderTitleLabel];
    return Headerview;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"_AppointmentDataArray.count -- %lu",(unsigned long)_AppointmentDataArray.count);
    return (_AppointmentDataArray.count == 0)?1:_AppointmentDataArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_AppointmentDataArray.count > 0) {
        static NSString *CellIdentifier = @"OCRAppontmentCell";
        OCRAppontmentCell *cell = (OCRAppontmentCell *)[_AppointmentListtable dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (OCRAppontmentCell *)[nibArray objectAtIndex:0];
        }
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        OCRAppointmentDataObjectModel *AppointmentDataObjectModel = [_AppointmentDataArray objectAtIndex:indexPath.row];
        
        NSLog(@"AppointmentDataObjectModel ----- %@",AppointmentDataObjectModel);
        
        @try {
            UILabel *TitleLabel = (UILabel *)[cell.contentView viewWithTag:777];
            [TitleLabel setTextColor:[UIColor colorFromHex:0x1EBBFE]];
            [TitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
            [TitleLabel setText:[AppointmentDataObjectModel AppointmentTitle]];
            
            UILabel *DetailsLabel = (UILabel *)[cell.contentView viewWithTag:888];
            [DetailsLabel setTextColor:[UIColor darkGrayColor]];
            [DetailsLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
            [DetailsLabel setText:[NSString stringWithFormat:@"With - %@ at %@ for %@ Hour",[AppointmentDataObjectModel AppointmentWithname],[AppointmentDataObjectModel AppointmentStartTime],[AppointmentDataObjectModel ApponitmentDuration]]];
        }
        @catch (NSException *exception) {
            NSLog(@"------- data exception %@",[NSString stringWithFormat:@"%@",exception]);
        }
        return cell;
    } else {
        static NSString *CellIdentifier = @"OCRAppointmentNoDataTableViewCell";
        OCRAppointmentNoDataTableViewCell *cell = (OCRAppointmentNoDataTableViewCell *)[_AppointmentListtable dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (OCRAppointmentNoDataTableViewCell *)[nibArray objectAtIndex:0];
        }
        [_AppointmentListtable setSeparatorColor:[UIColor clearColor]];
        UILabel *TitleLabel = (UILabel *)[cell.contentView viewWithTag:444];
        [TitleLabel setTextColor:[UIColor darkGrayColor]];
        [TitleLabel setTextAlignment:NSTextAlignmentCenter];
        [TitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [TitleLabel setText:@"No appointment available"];
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_AppointmentDataArray.count > 0) {
    OCRAppointmentDataObjectModel *AppointmentDataObjectModel = [_AppointmentDataArray objectAtIndex:indexPath.row];
    NSLog(@"AppointmentDataObjectModel ---- %@",[AppointmentDataObjectModel AppointmentWithname]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OCRAppointmentDetailsViewController *AppointmentDetails = [[OCRAppointmentDetailsViewController alloc] init];
    [AppointmentDetails setObjectCarrier:AppointmentDataObjectModel];
    [self.navigationController pushViewController:AppointmentDetails animated:YES];
    NSLog(@"book %@, indexPath %@",[_AppointmentDataArray objectAtIndex:indexPath.row],indexPath);
    }
}

-(IBAction)leftSideMenuButtonPressed:(id)sender
{
    if (_LastVisitedViewController == LastVisitedViewCalender) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
            NSLog(@"Menu bar button prassed..");
        }];
    }
}
-(NSDate *)addDays:(NSInteger)days toDate:(NSDate *)originalDate {
    NSDateComponents *components= [[NSDateComponents alloc] init];
    [components setDay:days];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:originalDate options:0];
}
- (void)updateSelectedDate
{
    [_AppointmentListtable setHidden:YES];
    [self startSpin];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-mm-dd" options:0 locale:nil];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSArray *ArrayOne = [[NSString stringWithFormat:@"%@",[self addDays:1 toDate:self.datepicker.selectedDate]] componentsSeparatedByString:@" "];
        
        NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=GetCurrentDateApponitment&requested_date=%@",[ArrayOne objectAtIndex:0]];
        NSLog(@"URL : %@", url);
        
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
        if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self stopSpin];
            _AppointmentDataArray = [[NSMutableArray alloc] init];
            if([[results objectForKey:@"status"] isEqualToString:@"success"])
            {
                for (id MyBirthday in [results objectForKey:@"Apponitmentdata"]) {
                    
                    NSLog(@"MyBirthday --- %@",MyBirthday);
                    
                    OCRAppointmentDataObjectModel *AppointmentDataObjectModel = [[OCRAppointmentDataObjectModel alloc] initWithAppointmentID:[MyBirthday objectForKey:@"AppointmentID"] Appointmentaddedon:[MyBirthday objectForKey:@"Appointmentaddedon"] Note:[MyBirthday objectForKey:@"Note"] ApponitmentStartDate:[MyBirthday objectForKey:@"ApponitmentStartDate"] ApponitmentEndDate:[MyBirthday objectForKey:@"ApponitmentEndDate"] ApponitmentDuration:[MyBirthday objectForKey:@"ApponitmentDuration"] Apponitmentstatus:[MyBirthday objectForKey:@"Apponitmentstatus"] AppointmentTitle:[MyBirthday objectForKey:@"AppointmentTitle"] AppointmentWith:[MyBirthday objectForKey:@"AppointmentWith"] AppointmentWithname:[MyBirthday objectForKey:@"AppointmentWithname"] AppointmentStartTime:[MyBirthday objectForKey:@"AppointmentStartTime"] AppointmentEndtime:[MyBirthday objectForKey:@"AppointmentEndtime"]];
                    
                    [_AppointmentDataArray addObject:AppointmentDataObjectModel];
                }
            }
            NSLog(@"_AppointmentDataArray --- %@",_AppointmentDataArray);
            [_AppointmentListtable setHidden:NO];
            [_AppointmentListtable reloadData];
            
        });
    });
}
//- (void)updateSelectedDate
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEddMMMM" options:0 locale:nil];
//    
//    [_AppointmentListtable setHidden:YES];
//    [self startSpin];
//    
//    [UIView animateWithDuration:0.9 animations:^(void){
//        [_AppointmentListtable setHidden:NO];
//        [self stopSpin];
//    }];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
