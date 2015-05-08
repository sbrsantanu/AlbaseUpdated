//
//  OCRAccidentPolicyViewController.m
//  Albase
//
//  Created by Mac on 03/12/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRAccidentPolicyViewController.h"
#import "OCRDataObjectModel.h"
#import "MFSideMenu.h"
#import "UIColor+HexColor.h"

@interface OCRAccidentPolicyViewController ()
@property (nonatomic,retain) UITableView *AccidentDetailsTable;
@property (nonatomic,retain) OCRAccidentPolicydetails *DataModel;
@property (nonatomic,retain) NSMutableArray *AccidentData;
@end

@implementation OCRAccidentPolicyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self=(IsIphone5)?[super initWithNibName:@"OCRAccidentPolicyViewController" bundle:nil]:[super initWithNibName:@"OCRAccidentPolicyViewController4s" bundle:nil];
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRAccidentPolicyViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRAccidentPolicyViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRAccidentPolicyViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRAccidentPolicyViewController6s" bundle:nil];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Accident Policy Details"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _AccidentDetailsTable = (UITableView *)[self.view viewWithTag:171];
    [_AccidentDetailsTable setHidden:YES];
    [_AccidentDetailsTable setDelegate:self];
    [_AccidentDetailsTable setDataSource:self];
   [self AppendDataFromWebservice];
    
}

-(void)AppendDataFromWebservice
{
    [self startSpin];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=getAllInsurencepolicyData&PolicyId=%@",self.PolicyId];
        NSLog(@"URL : %@", url);
        
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
        if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if([[results objectForKey:@"status"] isEqualToString:@"success"])
            {
                
                _AccidentData = [[NSMutableArray alloc] init];
                
                for (id MydataObject in [results objectForKey:@"userdata"]) {
                    
                    _DataModel = [[OCRAccidentPolicydetails alloc] initWithAccidentPolicyStatus:[MydataObject objectForKey:@"PolicyStatus"] AccidentGender:@""  AccidentName:@""  AccidentNRIC:[MydataObject objectForKey:@"NRIC"]  AccidentDOB:@""  AccidentIssueAge:[MydataObject objectForKey:@"IssueAge"]  AccidentPaymentMode:[MydataObject objectForKey:@"PaymentMode"]  AccidentPaymentMothod:[MydataObject objectForKey:@"PaymentMothod"]  AccidentEffictiveDate:[MydataObject objectForKey:@"EffictiveDate"]  AccidentModelPremium:[MydataObject objectForKey:@"ModelPremium"]  AccidentExpiryDate:[MydataObject objectForKey:@"ExpiryDate"]  AccidentReinStateDate:[MydataObject objectForKey:@"ReinState"]  AccidentAddress:[MydataObject objectForKey:@"Address"]  AccidentOcupationClass:[MydataObject objectForKey:@"OcupationClass"]  AccidentPaidtoDate:[MydataObject objectForKey:@"PaidtoDate"]  AccidentLapseDate:[MydataObject objectForKey:@"LapseDate"]  AccidentRenewalBonus:[MydataObject objectForKey:@"RenewalBonus"] AccidentPolicyNumber:@"PolicyNumber"];
                    
                    [_AccidentData addObject:_DataModel];
                }
                
                [self stopSpin];
                [_AccidentDetailsTable setHidden:NO];
                [_AccidentDetailsTable reloadData];
                
            } else {
                [self stopSpin];
                UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Unknown Error" message:@"There is some error, please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [Alert show];
            }
        });
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)leftSideMenuButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
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
        [TitleLabel setText:@"Policy Number"];
    } else if (section == 1) {
        [TitleLabel setText:@"Policy Status"];
    } else if (section == 2) {
        [TitleLabel setText:@"NRIC Number"];
    } else if (section == 3) {
        [TitleLabel setText:@"Issue Age"];
    } else if (section == 4) {
        [TitleLabel setText:@"Payment Mode"];
    } else if (section == 5) {
        [TitleLabel setText:@"Payment Method"];
    } else if (section == 6) {
        [TitleLabel setText:@"Effictive Date"];
    } else if (section == 7) {
        [TitleLabel setText:@"Model Premium"];
    } else if (section == 8) {
        [TitleLabel setText:@"Expiry Date"];
    } else if (section == 9) {
        [TitleLabel setText:@"Rein State Date"];
    } else if (section == 10) {
        [TitleLabel setText:@"Address"];
    } else if (section == 11) {
        [TitleLabel setText:@"Ocupation Class"];
    } else if (section == 12) {
        [TitleLabel setText:@"Paid to Date"];
    } else if (section == 13) {
        [TitleLabel setText:@"Lapse Date"];
    } else if (section == 14) {
        [TitleLabel setText:@"Renewal Bonus"];
    }
    return Headerview;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    
    OCRAccidentPolicydetails *DataModel = [_AccidentData objectAtIndex:indexPath.row];
    NSLog(@"indexPath.section --- %ld",(long)indexPath.section);
    switch (indexPath.section) {
        case 0:
        {
            [cell.textLabel setText:[DataModel AccidentPolicyNumber]];
            break;
        }
        case 1:
        {
            [cell.textLabel setText:[DataModel AccidentPolicyStatus]];
            break;
        }
        case 2:
        {
           [cell.textLabel setText:[DataModel AccidentNRIC]];
            break;
        }
        case 3:
        {
            [cell.textLabel setText:[DataModel AccidentIssueAge]];
            break;
        }
        case 4:
        {
            [cell.textLabel setText:[DataModel AccidentPaymentMode]];
            break;
        }
        case 5:
        {
            [cell.textLabel setText:[DataModel AccidentPaymentMothod]];
            break;
        }
        case 6:
        {
            [cell.textLabel setText:[DataModel AccidentEffictiveDate]];
            break;
        }
        case 7:
        {
            [cell.textLabel setText:[DataModel AccidentModelPremium]];
            break;
        }
        case 8:
        {
            [cell.textLabel setText:[DataModel AccidentExpiryDate]];
            break;
        }
        case 9:
        {
            [cell.textLabel setText:[DataModel AccidentReinStateDate]];
            break;
        }
        case 10:
        {
            [cell.textLabel setText:[DataModel AccidentAddress]];
            break;
        }
        case 11:
        {
            [cell.textLabel setText:[DataModel AccidentOcupationClass]];
            break;
        }
        case 12:
        {
            [cell.textLabel setText:[DataModel AccidentPaidtoDate]];
            break;
        }
        case 13:
        {
            [cell.textLabel setText:[DataModel AccidentLapseDate]];
            break;
        }
        case 14:
        {
            [cell.textLabel setText:[DataModel AccidentRenewalBonus]];
            break;
        }
    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 14;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
