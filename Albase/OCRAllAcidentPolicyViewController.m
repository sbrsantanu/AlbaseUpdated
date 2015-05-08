//
//  OCRAllAcidentPolicyViewController.m
//  Albase
//
//  Created by Mac on 04/12/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRAllAcidentPolicyViewController.h"
#import "UIColor+expanded.h"
#import "UIColor+HexColor.h"
#import "OCRAccidentPolicyViewController.h"

@interface OCRAllAcidentPolicyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *AcidentPolicytable;
@property (nonatomic,retain) NSMutableArray *AccidentdataArray;

@end

@implementation OCRAllAcidentPolicyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self=(IsIphone5)?[super initWithNibName:@"OCRAllAcidentPolicyViewController" bundle:nil]:[super initWithNibName:@"OCRAllAcidentPolicyViewController4s" bundle:nil];
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRAllAcidentPolicyViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRAllAcidentPolicyViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRAllAcidentPolicyViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRAllAcidentPolicyViewController6s" bundle:nil];
        }
    }
    return self;
}

/**
 *  Access viewDidLoad
 */

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Insurance Details"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _AcidentPolicytable = (UITableView *)[self.view viewWithTag:171];
    [_AcidentPolicytable setDelegate:self];
    [_AcidentPolicytable setDataSource:self];
    [_AcidentPolicytable setHidden:YES];
    
    [self AppendDataFromWebservice];
}

/**
 *  Access web service
 */

-(void)AppendDataFromWebservice
{
    [self startSpin];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=getAllInsurencepolicy&userid=%@",self.Userid];
        NSLog(@"URL : %@", url);
        
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
        if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if([[results objectForKey:@"status"] isEqualToString:@"success"])
            {
                [self stopSpin];
                
                [_AcidentPolicytable setHidden:NO];
                
                _AccidentdataArray = [[NSMutableArray alloc] init];
                
                for (id ObjectList in [results objectForKey:@"PolicyDetails"]) {
                    
                    NSMutableDictionary *DataDictionary = [[NSMutableDictionary alloc] init];
                    [DataDictionary setValue:[ObjectList objectForKey:@"AccidentId"] forKey:@"AccidentId"];
                    [DataDictionary setValue:[ObjectList objectForKey:@"PolicyStatus"] forKey:@"PolicyStatus"];
                    
                    [_AccidentdataArray addObject:DataDictionary ];
                }
                [_AcidentPolicytable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self stopSpin];
                UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"There is sno data" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [Alert show];
            }
        });
    });
}

/**
 * Receive memory Warning
 */

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}


/**
 *  Tableview data source
 */


// Number of Section in tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


// Number of rows in tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([_AccidentdataArray count] > 0)?[_AccidentdataArray count]:1;
}

// Cellfor row at indexpath

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = [[UITableViewCell alloc] init];
    
    if ([_AccidentdataArray count] > 0) {
        
        NSDictionary *DataDictionary = [_AccidentdataArray objectAtIndex:indexPath.row];
        [tableCell.textLabel setText:[DataDictionary objectForKey:@"PolicyStatus"]];
        tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        [tableCell.textLabel setText:@"There is no Accident Policy of this user"];
    }
    [tableCell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [tableCell.textLabel setTextColor:[UIColor darkGrayColor]];
    return tableCell;
}

/**
 *  Tableview Delegate
 */

// Return tableview cell height

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

// Tablelview didselect

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexpath
{
    [tableView deselectRowAtIndexPath:indexpath animated:YES];
    
    if ([_AccidentdataArray count]>0) {
        
        NSDictionary *DataDictionary = [_AccidentdataArray objectAtIndex:indexpath.row];
        OCRAccidentPolicyViewController *AccidentPolicy = [[OCRAccidentPolicyViewController alloc] initWithNibName:@"OCRAccidentPolicyViewController" bundle:nil];
        [AccidentPolicy setPolicyId:[DataDictionary objectForKey:@"AccidentId"]];
        [self.navigationController pushViewController:AccidentPolicy animated:YES];
    }
}

/**
 * Go Back
 */

-(IBAction)leftSideMenuButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
