//
//  OCRInsurenceDetailsViewController.m
//  Albase
//
//  Created by Mac on 03/12/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRInsurenceDetailsViewController.h"
#import "OCRDataObjectModel.h"
#import "MFSideMenu.h"
#import "UIColor+HexColor.h"

@interface OCRInsurenceDetailsViewController ()

@property (nonatomic,retain) UITableView *InsurenceDetailsTable;
@property (nonatomic,retain) NSMutableArray *AccidentData;
@property (nonatomic,retain) OCRScanDataObjectModel *DataModel;
@end

@implementation OCRInsurenceDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // self=(IsIphone5)?[super initWithNibName:@"OCRInsurenceDetailsViewController" bundle:nil]:[super initWithNibName:@"OCRInsurenceDetailsViewController4s" bundle:nil];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRInsurenceDetailsViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRInsurenceDetailsViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRInsurenceDetailsViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRInsurenceDetailsViewController6s" bundle:nil];
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
    [Titlelabel setText:@"Insurance Details"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _InsurenceDetailsTable = (UITableView *)[self.view viewWithTag:171];
    [_InsurenceDetailsTable setDelegate:self];
    [_InsurenceDetailsTable setDataSource:self];
    [_InsurenceDetailsTable setHidden:YES];
    [self AppendDataFromWebservice];
    
}
-(void)AppendDataFromWebservice
{
    [self startSpin];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSLog(@"InsurenceId --%@",_InsurenceId);
        
        NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=getAllpersonalpolicyData&PolicyId=%@",self.InsurenceId];
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
                    
                    _DataModel = [[OCRScanDataObjectModel alloc] initWithStatus:[MydataObject objectForKey:@"Status"] PolicyDate:[MydataObject objectForKey:@"PolicyDate"] PaidToDate:[MydataObject objectForKey:@"PaidToDate"] ModalPremium:[MydataObject objectForKey:@"ModalPremium"] NextModalPremium:[MydataObject objectForKey:@"NextModalPremium"] PayUpDate:[MydataObject objectForKey:@"PayUpDate"] MaturityDate:[MydataObject objectForKey:@"MaturityDate"]  InsuredAddress:[MydataObject objectForKey:@"InsuredAddress"] AdjustedPremium:[MydataObject objectForKey:@"AdjustedPremium"] Gender:@"" Name:@"" NRIC:[MydataObject objectForKey:@"NRIC"] DOB:@"" IssueAge:[MydataObject objectForKey:@"IssueAge"] Owner:[MydataObject objectForKey:@"Owner"] PaymentMode:[MydataObject objectForKey:@"PaymentMode"] PaymentMothod:[MydataObject objectForKey:@"PaymentMothod"] BillToDate:[MydataObject objectForKey:@"BillToDate"] PolicyNumber:[MydataObject objectForKey:@"PolicyNumber"]];
                    
                    [_AccidentData addObject:_DataModel];
                }
                
                [self stopSpin];
                [_InsurenceDetailsTable setHidden:NO];
                [_InsurenceDetailsTable reloadData];
                
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
        [TitleLabel setText:@"Status"];
    } else if (section == 2) {
        [TitleLabel setText:@"Policy Date"];
    } else if (section == 3) {
        [TitleLabel setText:@"Paid To Date"];
    } else if (section == 4) {
        [TitleLabel setText:@"Modal Premium"];
    } else if (section == 5) {
        [TitleLabel setText:@"Next Modal Premium"];
    } else if (section == 6) {
        [TitleLabel setText:@"Pay Up Date"];
    } else if (section == 7) {
        [TitleLabel setText:@"Maturity Date"];
    } else if (section == 8) {
        [TitleLabel setText:@"Insured Address"];
    } else if (section == 9) {
        [TitleLabel setText:@"Adjusted Premium"];
    } else if (section == 10) {
        [TitleLabel setText:@"NRIC"];
    } else if (section == 11) {
        [TitleLabel setText:@"Issue Age"];
    } else if (section == 12) {
        [TitleLabel setText:@"Owner"];
    } else if (section == 13) {
        [TitleLabel setText:@"Payment Mode"];
    } else if (section == 14) {
        [TitleLabel setText:@"Payment Method"];
    } else if (section == 15) {
        [TitleLabel setText:@"Bill To Date"];
    }
    return Headerview;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    
    switch (indexPath.section) {
        
        case 0:
        {
            [cell.textLabel setText:[_DataModel PolicyNumber]];
            break;
        }
        case 1:
        {
            [cell.textLabel setText:[_DataModel Status]];
            break;
        }
        case 2:
        {
            [cell.textLabel setText:[_DataModel PolicyDate]];
            break;
        }
        case 3:
        {
            [cell.textLabel setText:[_DataModel PaidToDate]];
            break;
        }
        case 4:
        {
            [cell.textLabel setText:[_DataModel ModalPremium]];
            break;
        }
        case 5:
        {
            [cell.textLabel setText:[_DataModel NextModalPremium]];
            break;
        }
        case 6:
        {
            [cell.textLabel setText:[_DataModel PayUpDate]];
            break;
        }
        case 7:
        {
            [cell.textLabel setText:[_DataModel MaturityDate]];
            break;
        }
        case 8:
        {
            [cell.textLabel setText:[_DataModel InsuredAddress]];
            break;
        }
        case 9:
        {
            [cell.textLabel setText:[_DataModel AdjustedPremium]];
            break;
        }
        case 10:
        {
            [cell.textLabel setText:[_DataModel NRIC]];
            break;
        }
        case 11:
        {
            [cell.textLabel setText:[_DataModel IssueAge]];
            break;
        }
        case 12:
        {
            [cell.textLabel setText:[_DataModel Owner]];
            break;
        }
        case 13:
        {
            [cell.textLabel setText:[_DataModel PaymentMode]];
            break;
        }
        case 14:
        {
            [cell.textLabel setText:[_DataModel PaymentMothod]];
            break;
        }
        case 15:
        {
            [cell.textLabel setText:[_DataModel BillToDate]];
            break;
        }
    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 16;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
