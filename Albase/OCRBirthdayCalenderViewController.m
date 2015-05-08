//
//  OCRBirthdayCalenderViewController.m
//  OCRScanner
//
//  Created by Mac on 26/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRBirthdayCalenderViewController.h"
#import "VRGCalendarView.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"
#import "OCRBirthdayListViewController.h"

@interface OCRBirthdayCalenderViewController ()<VRGCalendarViewDelegate>
{
    NSMutableArray *BirthdayArray;
    VRGCalendarView *calendar;
}
@end

@implementation OCRBirthdayCalenderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRBirthdayCalenderViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRBirthdayCalenderViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRBirthdayCalenderViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRBirthdayCalenderViewController6s" bundle:nil];
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
    [Titlelabel setText:@"Birthday Calender"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateNormal];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateHighlighted];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateSelected];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateApplication];
    
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *GenericView = (UIView *)[self.view viewWithTag:101];
    calendar = [[VRGCalendarView alloc] init];
    [calendar setDelegate:self];
    [GenericView addSubview:calendar];
    
}

-(void)SetBirthdayInCalender :(int)Formonth
{
    [self startSpin];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=GetBirthdayForGivenMonth&ProvidedMonth=%d",Formonth];
        NSLog(@"URL : %@", url);
        
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
        if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if([[results objectForKey:@"status"] isEqualToString:@"success"])
            {
                [self stopSpin];
                BirthdayArray = [[NSMutableArray alloc] init];
                for (id MyBirthday in [results objectForKey:@"totaldata"]) {
                    
                    [BirthdayArray addObject:[NSNumber numberWithInt:[[MyBirthday objectForKey:@"dateofbirth"] intValue]]];
                }
                [calendar markDates:BirthdayArray];
            }
        });
    });
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        NSLog(@"Menu bar button prassed..");
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma Calendar Protocol Details

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    [self SetBirthdayInCalender:month];
    NSLog(@"switchedToMonth clicked ==== %d",month);
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    
    OCRBirthdayListViewController *BirthdayListView = [[OCRBirthdayListViewController alloc] initWithNibName:@"OCRBirthdayListViewController" bundle:nil];
    [BirthdayListView setSelectedDate:date];
    [self.navigationController pushViewController:BirthdayListView animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
