//
//  OCRBirthdayListViewController.m
//  OCRScanner
//
//  Created by Mac on 29/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRBirthdayListViewController.h"
#import "DIDatepicker.h"
#import "UIColor+HexColor.h"
#import "OCRAppointmentCalenderViewController.h"
#import "OCRBirthdayTableViewCell.h"
#import "OCRNoDataTableViewCell.h"
#import "OCRDataObjectModel.h"
#import "OCRContactDetailsViewController.h"

@interface OCRBirthdayListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet DIDatepicker *datepicker;
@property (nonatomic,retain) UITableView *BirthdayListtable;
@property (nonatomic,strong) NSMutableArray *BirthdayDataArray;

@end

@implementation OCRBirthdayListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRBirthdayListViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRBirthdayListViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRBirthdayListViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRBirthdayListViewController6s" bundle:nil];
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
    [Titlelabel setText:@"Birthday List"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    
    [SetButton setBackgroundImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateNormal];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateHighlighted];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateSelected];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateApplication];
    
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.datepicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
    
    [self.datepicker fillDatesFromCurrentDate:14];
    [self.datepicker fillCurrentYear];
    NSLog(@"_SelectedDate --- %@",_SelectedDate);
    [self.datepicker selectDateAtIndex:[self numberofdays:[NSString stringWithFormat:@"%@",_SelectedDate]]];
    
    _BirthdayListtable = (UITableView *)[self.view viewWithTag:444];
    
    [_BirthdayListtable setDelegate:self];
    [_BirthdayListtable setDataSource:self];
    
}
-(int)numberofdays :(NSString *)dateStr
{
    int currentDay;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss Z"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:@"D"];
    currentDay = [[dateFormatter stringFromDate:date] intValue];
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
    UIView *Headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _BirthdayListtable.layer.frame.size.width, 10)];
    UILabel *HeaderTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, Headerview.layer.frame.size.width-20, 20)];
    [HeaderTitleLabel setBackgroundColor:[UIColor clearColor]];
    [HeaderTitleLabel setTextColor:[UIColor darkGrayColor]];
    [HeaderTitleLabel setText:(_BirthdayDataArray.count > 0)?@"Birthday List":@"There is no birthday"];
    [HeaderTitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [Headerview addSubview:HeaderTitleLabel];
    return Headerview;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _BirthdayDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier = @"OCRBirthdayTableViewCell";
        OCRBirthdayTableViewCell *cell = (OCRBirthdayTableViewCell *)[_BirthdayListtable dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (OCRBirthdayTableViewCell *)[nibArray objectAtIndex:0];
        }
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        NSMutableDictionary *Mydictionary = [_BirthdayDataArray objectAtIndex:indexPath.row];
    
        NSLog(@"Mydictionary ---- %@",Mydictionary);
    
        [_BirthdayListtable setSeparatorColor:[UIColor clearColor]];
        
        UILabel *TitleLabel = (UILabel *)[cell.contentView viewWithTag:777];
        [TitleLabel setTextColor:[UIColor colorFromHex:0x1EBBFE]];
        [TitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [TitleLabel setText:[NSString stringWithFormat:@"%@ %@",[Mydictionary objectForKey:@"Firstname"],[Mydictionary objectForKey:@"Lastname"]]];
        
        UILabel *DetailsLabel = (UILabel *)[cell.contentView viewWithTag:888];
        [DetailsLabel setTextColor:[UIColor darkGrayColor]];
        [DetailsLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
        [DetailsLabel setText:[NSString stringWithFormat:@"Birthday - %@ ( %@ )",[Mydictionary objectForKey:@"DateOfBirth"],[Mydictionary objectForKey:@"agecalculation"]]];
        
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    OCRContactDetailsViewController *ContactDetails = [[OCRContactDetailsViewController alloc] initWithNibName:@"OCRContactDetailsViewController" bundle:nil];
    [ContactDetails setUserDataDictionary:[_BirthdayDataArray objectAtIndex:indexPath.row]];
    [ContactDetails setUserRedirectedFrom:redirectedFromBirthdayList];
    [self.navigationController pushViewController:ContactDetails animated:YES];
    
}

-(IBAction)leftSideMenuButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateSelectedDate
{
    [_BirthdayListtable setHidden:YES];
    [self startSpin];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-mm-dd" options:0 locale:nil];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSArray *ArrayOne = [[NSString stringWithFormat:@"%@",[self addDays:1 toDate:self.datepicker.selectedDate]] componentsSeparatedByString:@" "];
        
        NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=GetProvidedDayBirthday&provideddate=%@",[ArrayOne objectAtIndex:0]];
        NSLog(@"URL : %@", url);
        
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
        if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
             _BirthdayDataArray = [[NSMutableArray alloc] init];
            if([[results objectForKey:@"status"] isEqualToString:@"success"])
            {
                NSMutableDictionary *Mydictionary = [[NSMutableDictionary alloc] init];
                for (id MyBirthday in [results objectForKey:@"datastring"]) {
                    
                    [Mydictionary setObject:[MyBirthday objectForKey:@"Firstname"] forKey:@"Firstname"];
                    [Mydictionary setObject:[MyBirthday objectForKey:@"Lastname"] forKey:@"Lastname"];
                    [Mydictionary setObject:[MyBirthday objectForKey:@"agecalculation"] forKey:@"agecalculation"];
                    [Mydictionary setObject:[MyBirthday objectForKey:@"DateOfBirth"] forKey:@"DateOfBirth"];
                    [_BirthdayDataArray addObject:MyBirthday];
                    
                }
            }
            [_BirthdayListtable setHidden:NO];
            [_BirthdayListtable reloadData];
            [self stopSpin];
        });
    });
}
-(NSDate *)addDays:(NSInteger)days toDate:(NSDate *)originalDate {
    NSDateComponents *components= [[NSDateComponents alloc] init];
    [components setDay:days];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:originalDate options:0];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
