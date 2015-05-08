

#import "RecognitionViewController.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"
#import "OCRDataObjectModel.h"
#import "OCRAddContactFromOCRViewController.h"
#import "XMLReader.h"
#import "GlobalStaticData.h"
#import "OCRAppDelegate.h"
#import "OCRAddAccidentPolicyStepOneViewController.h"
#import "UIImage+G8Filters.h"
#import "RegexKitLite.h"


#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]
//// Name of application you created
//static NSString* MyApplicationID = @"ALBase Productivity App";
//// Password should be sent to your e-mail after application was created
//static NSString* MyPassword = @"fEsmI+dHga6isFwquJhsI/Fy";

static NSString *StatusRecognisationString = @"Contract";
static NSString *PolicyRecognisationString = @"Paid";

@interface RecognitionViewController()
{
    NSString *PolicyNumber,*Status,*Name,*DOB,*NRICNumber,*Gender,*Owner,*Policydate,*PaidToDate,*ModelPremium,*NextModelPremium,*PayUpdate,*MaturityDate,*InsuredAddress,*AdjustedPremium,*IssueAge,*PaymentMode,*PaymentMethod,*BillToDate;
}

@end

@implementation RecognitionViewController

@synthesize textView;
@synthesize statusLabel;
@synthesize statusIndicator;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (RecognitionViewController *) initXMLParser
{
    self= [super init];
    appdelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
    return self;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    appdelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[self.navigationController navigationBar] setHidden:YES];
    CGSize MainFrame = [[UIScreen mainScreen] bounds].size;
    
    NSLog(@"-------------- %f",appdelegate.window.frame.size.width);
    
    UIView *HeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 57)];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    [self.view addSubview:HeaderView];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateNormal];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateHighlighted];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateSelected];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateApplication];
    
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect mainFrame = [[UIScreen mainScreen] bounds];
    UIActivityIndicatorView *_MainActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect frame = _MainActivity.frame;
    frame.origin.x = mainFrame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = mainFrame.size.height / 2 - frame.size.height / 2;
    _MainActivity.frame = frame;
    [_MainActivity setColor:[UIColor colorFromHex:0xe66a4c]];
    [_MainActivity startAnimating];
    [self.view addSubview:_MainActivity];
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        NSLog(@"Menu bar button prassed..");
    }];
}
- (void)viewDidUnload
{
	[self setTextView:nil];
	[self setStatusLabel:nil];
	[self setStatusIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	textView.hidden = YES;
    textView.editable = NO;
	statusLabel.hidden = NO;
	statusIndicator. hidden = NO;
	
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	statusLabel.text = [GlobalStringData ScannerLoadingMessge];
	
	UIImage* image = [[(OCRAppDelegate*)[[UIApplication sharedApplication] delegate] imageToProcess] g8_blackAndWhite];
	
	Client *client = [[Client alloc] initWithApplicationID:[GlobalStringData ScannerApplicationId] password:[GlobalStringData ScannerApplicationSecret]];
	[client setDelegate:self];
	
	if([[NSUserDefaults standardUserDefaults] stringForKey:@"installationID"] == nil) {
        
		NSString* deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
		NSLog(@"First run: obtaining installation ID..");
		NSString* installationID = [client activateNewInstallation:deviceID];
		NSLog(@"Done. Installation ID is \"%@\"", installationID);
		
        [[NSUserDefaults standardUserDefaults] setValue:installationID forKey:@"installationID"];
	}
	
	NSString* installationID = [[NSUserDefaults standardUserDefaults] stringForKey:@"installationID"];
	
	client.applicationID = [client.applicationID stringByAppendingString:installationID];
	
	ProcessingParams* params = [[ProcessingParams alloc] init];
	
    NSLog(@"params --- %@",[params urlString]);
    
	[client processImage:image withParams:params];
	
	statusLabel.text = [GlobalStringData ScannerUploadingMessage];
	
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

#pragma mark - ClientDelegate implementation

- (void)clientDidFinishUpload:(Client *)sender
{
	statusLabel.text = [GlobalStringData ScannerProcessingMessage];
}

- (void)clientDidFinishProcessing:(Client *)sender
{
	statusLabel.text = [GlobalStringData ScannerDownloadingMessage];
}

-(NSMutableDictionary *)BusinessLogicLifePolicy:(NSString *)DownloadedData
{
    NSMutableDictionary *DataObject = [[NSMutableDictionary alloc] init];
    NSArray *DataFieldArray = [[NSArray alloc] initWithObjects:@"Status",@"PolicyDate",@"PaidToDate",@"ModalPremium",@"NextModalPremium",@"PayUpDate",@"MaturityDate",@"InsuredAddress",@"AdjustedPremium",@"Gender",@"Name",@"NRIC",@"DOB",@"IssueAge",@"Owner",@"PaymentMode",@"PaymentMothod",@"BillToDate",@"PolicyNumber",nil];
    
    /* Initialize Data Dictionary */
    
    for (int i =0; i<[DataFieldArray count]-1; i++) {
        
        [DataObject setValue:@"" forKey:[DataFieldArray objectAtIndex:i]];
    }
    
    /* Value Explode Start */
    
    @try {
        
        NSLog(@"DownloadedData ---- %@",DownloadedData);
        
        NSArray *DataArray = [DownloadedData componentsSeparatedByString:@"\n"];
       // NSLog(@"DataArray ---- %@",DataArray);
        
        NSMutableArray *mainArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [DataArray count]; i++) {
            id obj = [DataArray objectAtIndex:i];
           // NSLog(@"obj----%@ and obj length ------ %ld",obj,(unsigned long)[allTrim( obj) length]);
            
            if ( [allTrim( obj) length] > 1) {
                
                NSString *trimmed = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [mainArray addObject:trimmed];
            }
        }
        
        
        NSLog(@"mainArray DataArray%@",mainArray);
        
       // NSLog(@"DataArray Count ---- %lu",(unsigned long)[DataArray count]);
       // NSLog(@"Directory seperated by : %@",[DataArray componentsJoinedByString:@": "]);
        
        NSString *DataCount = [NSString stringWithFormat:@"DataArray Count ---- %lu",(unsigned long)[mainArray count]];
        
       UIAlertView *DataAlert = [[UIAlertView alloc] initWithTitle:@"Total data Count" message:DataCount delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [DataAlert show];
        
        // Section To check Policy Number data from array
        
        [DataObject setObject:[self checkPolicyNumberFromArray:DataArray] forKey:@"PolicyNumber"];
        
        // Section To check status data from array
        
        [DataObject setObject:[self checkStatusdataFromArray:DataArray] forKey:@"Status"];
        
        // Section To check name data from array
        
        [DataObject setObject:[self checkNamedataFromArray:DataArray] forKey:@"Name"];
        
        // Section To check Date of Birth data from array
        
        [DataObject setObject:[self checkDOBdataFromArray:DataArray] forKey:@"DOB"];
        
        // Section To check NRIC No data from array
        
        [DataObject setObject:[self checkNRICNumberFromArray:DataArray] forKey:@"NRIC"];
        
        // Section To check Gender data from array
        
        [DataObject setObject:[self checkGenderFromArray:DataArray] forKey:@"Gender"];
        
        // Section To check Owner data from array
        
        [DataObject setObject:[self checkOwnerFromArray:DataArray] forKey:@"Owner"];
        
        // Section To check Policy Date data from array
        
        [DataObject setObject:[self checkPolicyDateFromArray:DataArray] forKey:@"PolicyDate"];
        
        // Section To check Paid To Date data from array
        
        [DataObject setObject:[self checkPaidToDateFromArray:DataArray] forKey:@"PaidToDate"];
        
        // Section To check Model Premium data from array
        
        [DataObject setObject:[self checkModelPremiumFromArray:DataArray] forKey:@"ModalPremium"];
        
        // Section To check Next Model Premium data from array
        
        [DataObject setObject:[self checkNextModelPremiumFromArray:DataArray] forKey:@"NextModalPremium"];
        
        // Section To check Pay Update data from array
        
        [DataObject setObject:[self checkPayUpdateFromArray:DataArray] forKey:@"PayUpDate"];
        
        // Section To check maturity Date data from array
        
        [DataObject setObject:[self checkMaturityDateFromArray:DataArray] forKey:@"MaturityDate"];
        
        // Section To check Insured Address data from array
        
        [DataObject setObject:[self checkInsuredAddressFromArray:DataArray] forKey:@"InsuredAddress"];
        
        // Section To check Adjust Premium data from array
        
        [DataObject setObject:[self checkAdjustedPremiumFromArray:DataArray] forKey:@"AdjustedPremium"];
        
        // Section To check Issue Age data from array
        
        [DataObject setObject:[self checkIssueAgeFromArray:DataArray] forKey:@"IssueAge"];
        
        // Section To check Payment Mode data from array
        
        [DataObject setObject:[self checkPaymentModeFromArray:DataArray] forKey:@"PaymentMode"];
        
        // Section To check payment Method data from array
        
        [DataObject setObject:[self checkPaymentMethodFromArray:DataArray] forKey:@"PaymentMothod"];
        
        // Section To check Bill To Date data from array
        
        [DataObject setObject:[self checkBillToDateFromArray:DataArray] forKey:@"BillToDate"];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception is ===== %@",[NSString stringWithFormat:@"%@",exception]);
    }
    return DataObject;
}

-(NSMutableDictionary *)BusinessLogicAccidentPolicy:(NSString *)DownloadedData
{
    
    NSMutableDictionary *DataObject = [[NSMutableDictionary alloc] init];
    NSArray *DataFieldArray = [[NSArray alloc] initWithObjects:@"PolicyStatus",@"Gender",@"Name",@"NRIC",@"DOB",@"IssueAge",@"PaymentMode",@"PaymentMothod",@"EffictiveDate",@"ModelPremium",@"ExpiryDate",@"ReinStateDate",@"Address",@"OcupationClass",@"PaidtoDate",@"LapseDate",@"RenewalBonus",@"PolicyNumber",nil];
    
    /* Initialize Data Dictionary */
    
    for (int i =0; i<[DataFieldArray count]-1; i++) {
        
        [DataObject setValue:@"" forKey:[DataFieldArray objectAtIndex:i]];
    }
    
    
    /* Value Explode Start */
    
    @try {
        
        /* *************************************************************************
         Section To Split result data into array -- Start
         ************************************************************************* */
        
        @try {
            
            NSLog(@"DownloadedData AccidentPolicy ---- %@",DownloadedData);
            
            // exit(0);
            
            NSArray *DataArray = [DownloadedData componentsSeparatedByString:@"\n"];
            NSLog(@"DataArray ---- %@",DataArray);
            NSLog(@"DataArray Count ---- %lu",(unsigned long)[DataArray count]);
            NSLog(@"Directory seperated by : %@",[DataArray componentsJoinedByString:@": "]);
            
            /* *************************************************************************
             Section To check Policy Number data from array -- Start
             ************************************************************************* */
            
            @try {
                [DataObject setObject:[DataArray objectAtIndex:0] forKey:@"PolicyNumber"];
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"PolicyNumber"];
                
                @throw [NSException exceptionWithName:@"Policy Number Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Policy Number data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check status data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *Statusp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Policy Statue"];
                NSPredicate *Statusp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Policy Status"];
                NSPredicate *Statusp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Policy Stetue"];
                NSPredicate *Statusp4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Policy Stetus"];
                NSPredicate *Statusp5 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Polioy Statue"];
                NSPredicate *Statusp6 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Polioy Status"];
                NSPredicate *Statusp7 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Polioy Stetue"];
                NSPredicate *Statusp8 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Polioy Stetus"];
                
                NSPredicate *StatusPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[Statusp1, Statusp2, Statusp3 ,Statusp4,Statusp5,Statusp6,Statusp7,Statusp8]];
                NSArray *Statusresultsone       = [DataArray filteredArrayUsingPredicate:StatusPredicate];
                
                if ([Statusresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[Statusresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"PolicyStatus"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"PolicyStatus"];
                    }
                    
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"PolicyStatus"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"PolicyStatus"];
                
                @throw [NSException exceptionWithName:@"PolicyStatus Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check status data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Issue Age data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *IssueAgep1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Issue Age"];
                NSPredicate *IssueAgep2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Issue Ago"];
                NSPredicate *IssueAgep3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Issuo Age"];
                NSPredicate *IssueAgep4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Issuo Ago"];
                NSPredicate *IssueAgep5 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Issoo Ago"];
                NSPredicate *IssueAgep6 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"IsouoAgo"];
                
                NSPredicate *IssueAgePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[IssueAgep1, IssueAgep2, IssueAgep3,IssueAgep4,IssueAgep5,IssueAgep6]];
                NSArray *IssueAgeresultsone       = [DataArray filteredArrayUsingPredicate:IssueAgePredicate];
                
                NSLog(@"IssueAgeresultsone === %@",IssueAgeresultsone);
                
                if ([IssueAgeresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[IssueAgeresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArrayIssueAgeresultsone === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        if ([FinalSplitedArray count]==4) {
                            
                            [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"IssueAge"];
                        } else if ([FinalSplitedArray count]==5) {
                            [DataObject setObject:[FinalSplitedArray objectAtIndex:4] forKey:@"IssueAge"];
                        }
                        
                    } else {
                        
                        @try {
                            
                            NSPredicate *DOBp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Date of Birth"];
                            NSPredicate *DOBp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Dato of Birth"];
                            NSPredicate *DOBp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Dote of Birth"];
                            NSPredicate *DOBp4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Doto of Birth"];
                            
                            NSPredicate *DOBPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[DOBp1, DOBp2, DOBp3 ,DOBp4]];
                            NSArray *DOBresultsone       = [DataArray filteredArrayUsingPredicate:DOBPredicate];
                            
                            NSLog(@"DOBresultsone === %@",DOBresultsone);
                            
                            if ([DOBresultsone count] > 0)
                            {
                                NSArray *FinalSplitedArray = [[DOBresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                                
                                if ([FinalSplitedArray count]>0) {
                                    
                                    if ([FinalSplitedArray count]==4) {
                                        
                                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"IssueAge"];
                                    } else if ([FinalSplitedArray count]==5) {
                                        [DataObject setObject:[FinalSplitedArray objectAtIndex:4] forKey:@"IssueAge"];
                                    }
                                    
                                    [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"DOB"];
                                    
                                } else {
                                    
                                    [DataObject setObject:@"0" forKey:@"IssueAge"];
                                }
                            }
                        } @catch (NSException *exception) {
                            
                            [DataObject setObject:@"0" forKey:@"IssueAge"];
                        }
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"IssueAge"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"IssueAge"];
                
                @throw [NSException exceptionWithName:@"IssueAge Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Issue Age data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Gender data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *Genderp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Gender"];
                NSPredicate *Genderp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Gendor"];
                NSPredicate *Genderp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Gonder"];
                NSPredicate *Genderp4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Gondor"];
                
                NSPredicate *GenderPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[Genderp1, Genderp2, Genderp3,Genderp4]];
                NSArray *Genderresultsone       = [DataArray filteredArrayUsingPredicate:GenderPredicate];
                
                NSLog(@"NRICresultsone === %@",Genderresultsone);
                
                if ([Genderresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[Genderresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArray Genderresultsone === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        if ([FinalSplitedArray count]==4) {
                            [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"Gender"];
                        } else if ([FinalSplitedArray count]==5) {
                            [DataObject setObject:[FinalSplitedArray objectAtIndex:4] forKey:@"Gender"];
                        }
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"Gender"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"Gender"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"Gender"];
                
                @throw [NSException exceptionWithName:@"Gender Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Gender data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check name data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *Namep1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Name"];
                NSPredicate *Namep2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Nemo"];
                NSPredicate *Namep3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Nomo"];
                NSPredicate *Namep4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Neme"];
                NSPredicate *Namep5 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Nome"];
                NSPredicate *Namep6 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Homo"];
                NSPredicate *Namep7 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Nnmo"];
                NSPredicate *Namep8 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Nsmo"];
                NSPredicate *Namep9 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Namo"];
                
                NSPredicate *NamePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[Namep1, Namep2, Namep3 ,Namep4,Namep5,Namep6,Namep7,Namep8,Namep9]];
                NSArray *Nameresultsone       = [DataArray filteredArrayUsingPredicate:NamePredicate];
                
                NSLog(@"Nameresultsone === %@",Nameresultsone);
                
                if ([Nameresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[Nameresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"Name"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"Name"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"Name"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"Name"];
                
                @throw [NSException exceptionWithName:@"Name Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check name data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Date of Birth data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *DOBp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Date of Birth"];
                NSPredicate *DOBp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Dato of Birth"];
                NSPredicate *DOBp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Dote of Birth"];
                NSPredicate *DOBp4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Doto of Birth"];
                
                NSPredicate *DOBPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[DOBp1, DOBp2, DOBp3 ,DOBp4]];
                NSArray *DOBresultsone       = [DataArray filteredArrayUsingPredicate:DOBPredicate];
                
                NSLog(@"DOBresultsone === %@",DOBresultsone);
                
                if ([DOBresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[DOBresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"DOB"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"DOB"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"DOB"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"DOB"];
                
                @throw [NSException exceptionWithName:@"DOB Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Date of Birth data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check NRIC No data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *NRICp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"NRIC No"];
                NSPredicate *NRICp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"NRIC Na"];
                NSPredicate *NRICp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"NRIC Ne"];
                NSPredicate *NRICp4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"NR1C No"];
                
                NSPredicate *NRICPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[NRICp1, NRICp2, NRICp3,NRICp4]];
                NSArray *NRICresultsone       = [DataArray filteredArrayUsingPredicate:NRICPredicate];
                
                NSLog(@"NRICresultsone === %@",NRICresultsone);
                
                if ([NRICresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[NRICresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"NRIC"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"NRIC"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"NRIC"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"NRIC"];
                
                @throw [NSException exceptionWithName:@"NRIC Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check NRIC No data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Payment Mode data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *PaymentModep1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Payment Mode"];
                NSPredicate *PaymentModep2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Payment Modo"];
                NSPredicate *PaymentModep3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Payment Mede"];
                NSPredicate *PaymentModep4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Payment Made"];
                NSPredicate *PaymentModep5 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paymont Mode"];
                NSPredicate *PaymentModep6 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paymont Modo"];
                NSPredicate *PaymentModep7 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paymont Mede"];
                NSPredicate *PaymentModep8 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paymont Made"];
                
                NSPredicate *PaymentModePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[PaymentModep1, PaymentModep2, PaymentModep3,PaymentModep4,PaymentModep5,PaymentModep6,PaymentModep7,PaymentModep8]];
                NSArray *PaymentModeresultsone       = [DataArray filteredArrayUsingPredicate:PaymentModePredicate];
                
                NSLog(@"PaymentModeresultsone === %@",PaymentModeresultsone);
                
                if ([PaymentModeresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[PaymentModeresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArrayPaymentMode === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"PaymentMode"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"PaymentMode"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"PaymentMode"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"PaymentMode"];
                
                @throw [NSException exceptionWithName:@"PaymentMode Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Payment Mode data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check payment Method data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *PaymentMothodp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Payment Method"];
                NSPredicate *PaymentMothodp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Payment Mothod"];
                NSPredicate *PaymentMothodp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paymont Method"];
                NSPredicate *PaymentMothodp4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paymont Mothod"];
                
                NSPredicate *PaymentMothodPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[PaymentMothodp1, PaymentMothodp2, PaymentMothodp3,PaymentMothodp4]];
                NSArray *PaymentMothodresultsone       = [DataArray filteredArrayUsingPredicate:PaymentMothodPredicate];
                
                NSLog(@"PaymentMothodresultsone === %@",PaymentMothodresultsone);
                
                if ([PaymentMothodresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[PaymentMothodresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArrayPaymentMothod === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"PaymentMothod"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"PaymentMothod"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"PaymentMothod"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"PaymentMothod"];
                
                @throw [NSException exceptionWithName:@"PaymentMothod Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check payment Method data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Paid To Date data from array -- Start
             ************************************************************************* */
            
            
            @try {
                
                NSPredicate *PaidToDatep1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paid To Date"];
                NSPredicate *PaidToDatep2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paid To Dato"];
                NSPredicate *PaidToDatep3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paid To Dote"];
                NSPredicate *PaidToDatep4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paid To Doto"];
                
                NSPredicate *PaidToDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[PaidToDatep1, PaidToDatep2, PaidToDatep3,PaidToDatep4]];
                NSArray *PaidToDateresultsone       = [DataArray filteredArrayUsingPredicate:PaidToDatePredicate];
                
                NSLog(@"PaidToDateresultsone === %@",PaidToDateresultsone);
                
                if ([PaidToDateresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[PaidToDateresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"PaidToDateSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"PaidToDate"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"PaidToDate"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"PaidToDate"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"PaidToDate"];
                
                @throw [NSException exceptionWithName:@"PaidToDate Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Paid to Date data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Model Premium data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *ModalPremiump1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Modal Premium"];
                NSPredicate *ModalPremiump2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Modol Premium"];
                NSPredicate *ModalPremiump3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Modal Premiom"];
                NSPredicate *ModalPremiump4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Modal Promium"];
                
                NSPredicate *ModalPremiumPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[ModalPremiump1, ModalPremiump2, ModalPremiump3,ModalPremiump4]];
                NSArray *ModalPremiumresultsone       = [DataArray filteredArrayUsingPredicate:ModalPremiumPredicate];
                
                NSLog(@"ModalPremiumresultsone === %@",ModalPremiumresultsone);
                
                if ([ModalPremiumresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[ModalPremiumresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"ModalPremiumSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"ModalPremium"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"ModalPremium"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"ModalPremium"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"ModalPremium"];
                
                @throw [NSException exceptionWithName:@"ModalPremium Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check Model Premium data from array -- End
             ************************************************************************* */
            
            
            /* *************************************************************************
             Section To check Effective Date data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *EffectiveDate1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Effoctfvo Date"];
                NSPredicate *EffectiveDate2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Effectfvo Date"];
                NSPredicate *EffectiveDate3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Effectivo Date"];
                NSPredicate *EffectiveDate4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Effective Date"];
                NSPredicate *EffectiveDate5 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Effective Date"];
                
                
                
                
                NSPredicate *EffictiveDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[EffectiveDate1, EffectiveDate2, EffectiveDate3,EffectiveDate4,EffectiveDate5]];
                NSArray *EffictiveDateresultsone       = [DataArray filteredArrayUsingPredicate:EffictiveDatePredicate];
                
                NSLog(@"EffictiveDateresultsone === %@",EffictiveDateresultsone);
                
                if ([EffictiveDateresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[EffictiveDateresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"EffictiveDateSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"EffictiveDate"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"EffictiveDate"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"EffictiveDate"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"EffictiveDate"];
                
                @throw [NSException exceptionWithName:@"EffictiveDate Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check Effective Date data from array -- End
             ************************************************************************* */
            
            
            /* *************************************************************************
             Section To check Expiry Date data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *ExpiryDate1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Expiry Date"];
                NSPredicate *ExpiryDate2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Expiry Dato"];
                NSPredicate *ExpiryDate3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Expiry Dote"];
                NSPredicate *ExpiryDate4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Expiry Doto"];
                
                
                NSPredicate *ExpiryDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[ExpiryDate1, ExpiryDate2, ExpiryDate3,ExpiryDate4]];
                NSArray *ExpiryDateresultsone       = [DataArray filteredArrayUsingPredicate:ExpiryDatePredicate];
                
                NSLog(@"ExpiryDateresultsone === %@",ExpiryDateresultsone);
                
                if ([ExpiryDateresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[ExpiryDateresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"ExpiryDateSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"ExpiryDate"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"ExpiryDate"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"ExpiryDate"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"ExpiryDate"];
                
                @throw [NSException exceptionWithName:@"ExpiryDate Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check Expiry Date data from array -- End
             ************************************************************************* */
            
            
            /* *************************************************************************
             Section To check Reinstate Date data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *ReinstateDate1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Reinstate Date"];
                NSPredicate *ReinstateDate2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Reinstate Dato"];
                NSPredicate *ReinstateDate3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Reinstote Date"];
                NSPredicate *ReinstateDate4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Reinstato Date"];
                
                
                NSPredicate *ReinstateDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[ReinstateDate1, ReinstateDate2, ReinstateDate3,ReinstateDate4]];
                NSArray *ReinstateDateresultsone       = [DataArray filteredArrayUsingPredicate:ReinstateDatePredicate];
                
                NSLog(@"ReinstateDateresultsone === %@",ReinstateDateresultsone);
                
                if ([ReinstateDateresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[ReinstateDateresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"ReinStateDateSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"ReinStateDate"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"ReinStateDate"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"ReinStateDate"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"ReinStateDate"];
                
                @throw [NSException exceptionWithName:@"ReinStateDate Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check Reinstate Date data from array -- End
             ************************************************************************* */
            
            
            /* *************************************************************************
             Section To check Occupation Class data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *OccupationClass1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Occupation Class"];
                NSPredicate *OccupationClass2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Occupation Closs"];
                NSPredicate *OccupationClass3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Occopation Class"];
                NSPredicate *OccupationClass4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Ocoupation Class"];
                
                
                NSPredicate *OccupationClassPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[OccupationClass1, OccupationClass2, OccupationClass3,OccupationClass4]];
                NSArray *OccupationClassresultsone       = [DataArray filteredArrayUsingPredicate:OccupationClassPredicate];
                
                NSLog(@"OccupationClassresultsone === %@",OccupationClassresultsone);
                
                if ([OccupationClassresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[OccupationClassresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"Occupation Classresultsone FinalSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"OcupationClass"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"OcupationClass"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"OcupationClass"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"OcupationClass"];
                
                @throw [NSException exceptionWithName:@"OcupationClass Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check Occupation Class data from array -- End
             ************************************************************************* */
            
            
            /* *************************************************************************
             Section To check Lapse Date data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *LapseDate1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Lapse Date"];
                NSPredicate *LapseDate2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Lapse Dato"];
                NSPredicate *LapseDate3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Lapso Dato"];
                NSPredicate *LapseDate4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Lapso Dato"];
                
                
                NSPredicate *LapseDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[LapseDate1, LapseDate2, LapseDate3,LapseDate4]];
                NSArray *LapseDateresultsone       = [DataArray filteredArrayUsingPredicate:LapseDatePredicate];
                
                NSLog(@"LapseDateresultsone === %@",LapseDateresultsone);
                
                if ([LapseDateresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[LapseDateresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"LapseDate Classresultsone FinalSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"LapseDate"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"LapseDate"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"LapseDate"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"LapseDate"];
                
                @throw [NSException exceptionWithName:@"LapseDate Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check Lapse Date data from array -- End
             ************************************************************************* */
            
            
            /* *************************************************************************
             Section To check Renewal Bonus data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *RenewalBonus1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Renowal Bonus"];
                NSPredicate *RenewalBonus2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Renowal Bonos"];
                NSPredicate *RenewalBonus3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Renowol Bonus"];
                NSPredicate *RenewalBonus4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Ronowal Bonus"];
                NSPredicate *RenewalBonus5 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Renewal Bonus"];
                NSPredicate *RenewalBonus6 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Renowal Bonus"];
                NSPredicate *RenewalBonus7 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Renewol Bonus"];
                
                NSPredicate *RenewalBonusPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[RenewalBonus1, RenewalBonus2,RenewalBonus3,RenewalBonus4,RenewalBonus5,RenewalBonus6,RenewalBonus7]];
                NSArray *RenewalBonusresultsone       = [DataArray filteredArrayUsingPredicate:RenewalBonusPredicate];
                
                NSLog(@"RenewalBonusresultsone === %@",RenewalBonusresultsone);
                
                if ([RenewalBonusresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[RenewalBonusresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"RenewalBonus Classresultsone FinalSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"RenewalBonus"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"RenewalBonus"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"RenewalBonus"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"RenewalBonus"];
                
                @throw [NSException exceptionWithName:@"RenewalBonus Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check Renewal Bonus data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Address data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *Address1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Address"];
                NSPredicate *Address2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Addreso"];
                NSPredicate *Address3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Addreos"];
                NSPredicate *Address4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Addreoo"];
                
                NSPredicate *AddressPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[Address1, Address2,Address3,Address4]];
                NSArray *Addressresultsone       = [DataArray filteredArrayUsingPredicate:AddressPredicate];
                
                NSLog(@"Addressresultsone === %@",Addressresultsone);
                
                if ([Addressresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[Addressresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"Address Classresultsone FinalSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"Address"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"Address"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"Address"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"Address"];
                
                @throw [NSException exceptionWithName:@"Address Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check Address data from array -- End
             ************************************************************************* */
            
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:@"DownloadedData Data Array for AccidentPolicy Error"
                                           reason:[NSString stringWithFormat:@"%@",exception]
                                         userInfo:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Final Exception is --- %@",[NSString stringWithFormat:@"%@",exception]);
    }
    return DataObject;
}

- (void)client:(Client *)sender didFinishDownloadData:(NSData *)downloadedData
{
	statusLabel.hidden = YES;
    
	statusIndicator.hidden = YES;
	
	textView.hidden = NO;
	
	NSString* result = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
	
	textView.text = result;
    
    NSArray *ImageDataArray =[result componentsSeparatedByString:@"\n"];
    
    NSLog(@"result ----- %@",ImageDataArray);

    NSMutableDictionary *DataContainDictionary = [[NSMutableDictionary alloc] init];
    
    OCRAppDelegate *MainDelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (MainDelegate.InsurenceScanType == ScanTypePersonalAccidentPolicy) {
        
        DataContainDictionary = [self BusinessLogicAccidentPolicy:result];
        
        OCRAccidentPolicydetails *AccidentPolicyObject = [[OCRAccidentPolicydetails alloc] initWithAccidentPolicyStatus:[DataContainDictionary objectForKey:@"PolicyStatus"] AccidentGender:[DataContainDictionary objectForKey:@"Gender"] AccidentName:[DataContainDictionary objectForKey:@"Name"] AccidentNRIC:[DataContainDictionary objectForKey:@"NRIC"] AccidentDOB:[DataContainDictionary objectForKey:@"DOB"] AccidentIssueAge:[DataContainDictionary objectForKey:@"IssueAge"] AccidentPaymentMode:[DataContainDictionary objectForKey:@"PaymentMode"] AccidentPaymentMothod:[DataContainDictionary objectForKey:@"PaymentMothod"] AccidentEffictiveDate:[DataContainDictionary objectForKey:@"EffictiveDate"] AccidentModelPremium:[DataContainDictionary objectForKey:@"EffictiveDate"] AccidentExpiryDate:[DataContainDictionary objectForKey:@"ExpiryDate"] AccidentReinStateDate:[DataContainDictionary objectForKey:@"ReinStateDate"] AccidentAddress:[DataContainDictionary objectForKey:@"Address"] AccidentOcupationClass:[DataContainDictionary objectForKey:@"OcupationClass"] AccidentPaidtoDate:[DataContainDictionary objectForKey:@"PaidtoDate"] AccidentLapseDate:[DataContainDictionary objectForKey:@"LapseDate"] AccidentRenewalBonus:[DataContainDictionary objectForKey:@"RenewalBonus"] AccidentPolicyNumber:[DataContainDictionary objectForKey:@"PolicyNumber"]];
        
        OCRAddAccidentPolicyStepOneViewController *AddContact = [[OCRAddAccidentPolicyStepOneViewController alloc] initWithNibName:@"OCRAddAccidentPolicyStepOneViewController" bundle:nil];
        [AddContact setDataModel:AccidentPolicyObject];
        [self.navigationController pushViewController:AddContact animated:YES];
        
    } else if (MainDelegate.InsurenceScanType == ScanTypeLifePolicy) {
        
        DataContainDictionary = [self BusinessLogicLifePolicy:result];
        
        OCRScanDataObjectModel *ScandataObject = [[OCRScanDataObjectModel alloc] initWithStatus:[DataContainDictionary objectForKey:@"Status"] PolicyDate:[DataContainDictionary objectForKey:@"PolicyDate"] PaidToDate:[DataContainDictionary objectForKey:@"PaidToDate"] ModalPremium:[DataContainDictionary objectForKey:@"ModalPremium"] NextModalPremium:[DataContainDictionary objectForKey:@"NextModalPremium"] PayUpDate:[DataContainDictionary objectForKey:@"PayUpDate"] MaturityDate:[DataContainDictionary objectForKey:@"MaturityDate"] InsuredAddress:[DataContainDictionary objectForKey:@"InsuredAddress"] AdjustedPremium:[DataContainDictionary objectForKey:@"AdjustedPremium"] Gender:[DataContainDictionary objectForKey:@"Gender"] Name:[DataContainDictionary objectForKey:@"Name"] NRIC:[DataContainDictionary objectForKey:@"NRIC"] DOB:[DataContainDictionary objectForKey:@"DOB"] IssueAge:[DataContainDictionary objectForKey:@"IssueAge"] Owner:[DataContainDictionary objectForKey:@"Owner"] PaymentMode:[DataContainDictionary objectForKey:@"PaymentMode"] PaymentMothod:[DataContainDictionary objectForKey:@"PaymentMothod"] BillToDate:[DataContainDictionary objectForKey:@"BillToDate"] PolicyNumber:[DataContainDictionary objectForKey:@"PolicyNumber"]];
        
        OCRAddContactFromOCRViewController *AddContact = [[OCRAddContactFromOCRViewController alloc] initWithNibName:@"OCRAddContactFromOCRViewController" bundle:nil];
        [AddContact setDataadtionstatus:DataAditionStatusOcr];
        [AddContact setDataModel:ScandataObject];
        //[AddContact setUserParentSection:ParentPersonalPolicy];
       [self.navigationController pushViewController:AddContact animated:YES];
        
    } else {
        NSLog(@"I am nowhere");
    }
    
    NSLog(@"DataContainDictionary final resultß ------ %@",result);
  
    NSString *NewString = [NSString stringWithFormat:@"%@",DataContainDictionary];
    textView.text = NewString;
}

- (void)client:(Client *)sender didFailedWithError:(NSError *)error
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:[error localizedDescription]
												   delegate:nil 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles:nil, nil];
	
	[alert show];
	
	statusLabel.text = [error localizedDescription];
	statusIndicator.hidden = YES;
}

/**
 *  Insurence Policy Data Retrieve Methods
 */

-(NSString *)checkPolicyNumberFromArray:(NSArray *)ArrayObject
{
    @try {
        if (ArrayObject.count > 0) {
            PolicyNumber = [ArrayObject objectAtIndex:0];
        }
    } @catch (NSException *exception) {
        PolicyNumber = @"";
    }
    NSLog(@"ArrayObject and PolicyNumber ---%@",PolicyNumber);
    
    return (PolicyNumber == (id)[NSNull null])?@"":PolicyNumber;
}

-(NSString *)checkStatusdataFromArray:(NSArray *)ArrayObject
{
    @try {
        NSPredicate *Statusp1 = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS[cd] %@ )", @"Statue", @"Status", @"Stetue", @"Stetus"];
        NSPredicate *StatusPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[Statusp1]];
        NSArray *Statusresultsone       = [ArrayObject filteredArrayUsingPredicate:StatusPredicate];
        
        NSLog(@"Policy Status result --- %@",Statusresultsone);
        
        if ([Statusresultsone count] > 0)
        {
            NSString *trimmedString = [[Statusresultsone objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSArray *StringNameArray = [trimmedString componentsSeparatedByString:@":"];
            NSArray *Step2Array = nil;
            NSLog(@"StringNameArray result --- %@",StringNameArray);
            
            if (StringNameArray.count > 2) {
                Step2Array = [[StringNameArray objectAtIndex:1] componentsSeparatedByString:@"    "];
            } else if (StringNameArray.count == 2) {
                Step2Array = [[StringNameArray objectAtIndex:0] componentsSeparatedByString:@"    "];;
            }
            NSLog(@"Step2Array StringNameArray------- %@",Step2Array);
            
            NSMutableArray *mainArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < [Step2Array count]; i++) {
                id obj = [Step2Array objectAtIndex:i];
                if ( [allTrim( obj) length] > 1) {
                    NSString *trimmed = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSString *RemovedString = [trimmed stringByReplacingOccurrencesOfString:@":" withString:@""];
                    NSString *RemoveSpaceFromFirstAndLast = [RemovedString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                    if ([RemoveSpaceFromFirstAndLast rangeOfString:@"  "].location == NSNotFound) {
                        [mainArray addObject:RemoveSpaceFromFirstAndLast];
                    } else {
                        NSArray *DataArrayString = [RemoveSpaceFromFirstAndLast componentsSeparatedByString:@"  "];
                        for (int i = 0; i < [DataArrayString count]; i++) {
                            NSString *RemoveSpaceFromFirstAndLast = [[DataArrayString objectAtIndex:i] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                            NSString *RemovedString = [RemoveSpaceFromFirstAndLast stringByReplacingOccurrencesOfString:@":" withString:@""];
                            [mainArray addObject:RemovedString];
                        }
                    }
                }
            }
            NSLog(@"mainArray StringNameArray------- %@",mainArray);
            
            if (mainArray.count == 3) {
                Status = [[mainArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            } else if (mainArray.count == 2) {
                Status = [[mainArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            } else {
               NSArray *Arr1 =  [self SeperatedData:Statusresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                Status = [Arr1 objectAtIndex:1];
            }
            
           // Status = (Step2Array.count > 2)?[[Step2Array objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"Not Found";
            
        } else {
            //Status = @"Inforce - Premium Paying";
            NSArray *Arr1 =  [self SeperatedData:Statusresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
            Status = [Arr1 objectAtIndex:1];
        }
    } @catch (NSException *exception) {
        Status = @"Inforce - Premium Paying";
    }
    NSLog(@"ArrayObject and Status ---%@",Status);
    
    return (Status == (id)[NSNull null])?@"":Status;
}

-(NSString *)checkNamedataFromArray:(NSArray *)ArrayObject
{
    @try {
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Name",@"Nemo",@"Nomo",@"Neme", @"Nome", @"Homo", @"Nnmo", @"Nsmo", @"Namo", @"Na mo", @"Nam o", @"Hama", @"Nairn", @"Hamo", @"Kamo",@"Harm",@"fiamo",@"Nsamo",@"Uamo",@"Same"];
        
        NSPredicate *NamePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *Nameresultsone       = [ArrayObject filteredArrayUsingPredicate:NamePredicate];
        if ([Nameresultsone count] > 0)
        {
            
            NSArray *FinalSplitedArray = [self SeperateStringIntoArray:[Nameresultsone objectAtIndex:0]];
            NSLog(@"FinalSplitedArray for name value -----%@",FinalSplitedArray);
            
            if (FinalSplitedArray.count == 4 || FinalSplitedArray.count == 3) {
                Name = [FinalSplitedArray objectAtIndex:1];
            } else {
                NSArray *Arr1 =  [self SeperatedData:Nameresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                Name = [Arr1 objectAtIndex:1];
            }
        } else {
            NSArray *Arr1 =  [self SeperatedData:Nameresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
            Name = [Arr1 objectAtIndex:1];
        }
    } @catch (NSException *exception) {
        Name = @"Not Found";
    }
    NSLog(@"ArrayObject and Name ---%@",Name);
    return (Name == (id)[NSNull null])?@"":Name;
}

-(NSString *)checkDOBdataFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Date of Birth",@"Dato of Birth",@"Dote of Birth",@"Doto of Birth", @"Oato of Birth", @"Data of Blrtb", @"Data of Birth"];
        
        NSPredicate *DOBPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *DOBresultsone       = [ArrayObject filteredArrayUsingPredicate:DOBPredicate];
        
        NSLog(@"date of Birth result --- %@",DOBresultsone);
        
        if ([DOBresultsone count] > 0)
        {
            NSArray *Arr1 =  [self SeperatedData:DOBresultsone Dataint:0 DataOne:@"DOBCalculateData"];
            DOB = [Arr1 objectAtIndex:1];
            
           /** [self SeperatedData:DOBresultsone Dataint:0 DataOne:@"DOBresultsone"];
            
            NSArray *FinalSplitedArray = [[DOBresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
            NSLog(@"date of Birth FinalSplitedArray --- %@",FinalSplitedArray);
            if ([FinalSplitedArray count]>0) {
                NSArray *SP1 = nil;
                
                if ([FinalSplitedArray count]==1) {
                    SP1 = [[[FinalSplitedArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@" "];
                    NSLog(@"date of Birth SP1 --- %@",SP1);
                    NSMutableArray *mainArray = [[NSMutableArray alloc]init];
                    for (int i = 0; i < [SP1 count]; i++) {
                        id obj = [SP1 objectAtIndex:i];
                        if ( [allTrim( obj) length] > 1) {
                            NSString *trimmed = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            [mainArray addObject:trimmed];
                        }
                    }
                    NSLog(@"dob mainArray result --- %@",mainArray);
                    DOB = [mainArray objectAtIndex:0];
                } else {
                    SP1 = [[[FinalSplitedArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@" "];
                    NSLog(@"date of Birth SP1 --- %@",SP1);
                    NSMutableArray *mainArray = [[NSMutableArray alloc]init];
                    for (int i = 0; i < [SP1 count]; i++) {
                        id obj = [SP1 objectAtIndex:i];
                        if ( [allTrim( obj) length] > 1) {
                            NSString *trimmed = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            [mainArray addObject:trimmed];
                        }
                    }
                    NSLog(@"dob mainArray result --- %@",mainArray);
                    DOB = [mainArray objectAtIndex:0];
                }
                
            } else {
                NSArray *Arr1 =  [self SeperatedData:DOBresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                DOB = [Arr1 objectAtIndex:1];
            }
            **/
        } else {
            NSArray *Arr1 =  [self SeperatedData:DOBresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
            DOB = [Arr1 objectAtIndex:1];
        }
    } @catch (NSException *exception) {
        
        DOB = @"";
    }
    NSLog(@"ArrayObject and DOB ---%@",DOB);
    
    return (DOB == (id)[NSNull null])?@"":DOB;
}

-(NSString *)checkNRICNumberFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )",@"NRIC No",@"NRIC Na",@"NRIC Ne",@"NR1C No", @"NRJC No", @"NRJC No.",@"NRIC No.",@"NRiC No",@"NRiC Na",@"NRiC No.",@"NRiC Na.",@"NRIC Na.",@"NRIC Ne.",@"NR1C No.",@"URIC No."];
        
        NSPredicate *NRICPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *NRICresultsone       = [ArrayObject filteredArrayUsingPredicate:NRICPredicate];
        
        NSLog(@"NRIC result --- %@",NRICresultsone);
        
        if ([NRICresultsone count] > 0)
        {
            [self SeperatedData:NRICresultsone Dataint:0 DataOne:@"NRICresultsone"];
            
            NSArray *FinalSplitedArray = nil;
            
            if ([[NRICresultsone objectAtIndex:0] rangeOfString:@":"].location == NSNotFound) {
                NSLog(@"checkNRICNumberFromArray string does not contain :");
                FinalSplitedArray = [[NRICresultsone objectAtIndex:0] componentsSeparatedByString:@"  "];
            } else {
                if ([[NRICresultsone objectAtIndex:0] rangeOfString:@";"].location == NSNotFound) {
                    NSLog(@"checkNRICNumberFromArray string does not contain ;");
                    FinalSplitedArray = [[NRICresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
                } else {
                    FinalSplitedArray = [[NRICresultsone objectAtIndex:0] componentsSeparatedByString:@";"];
                    NSLog(@"checkNRICNumberFromArray string contains ;");
                }
            }
            
            NSLog(@"NRIC FinalSplitedArray result --- %@",FinalSplitedArray);
            NSMutableArray *mainArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < [FinalSplitedArray count]; i++) {
                id obj = [FinalSplitedArray objectAtIndex:i];
                if ( [allTrim( obj) length] > 1) {
                    NSString *trimmed = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    [mainArray addObject:trimmed];
                }
            }
            
            if ([mainArray count]>0) {
                
                NRICNumber = [mainArray objectAtIndex:1];
                
            } else {
                
                NSArray *Arr1 =  [self SeperatedData:NRICresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                NRICNumber = [Arr1 objectAtIndex:1];
            }
        } else {
            NSArray *Arr1 =  [self SeperatedData:NRICresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
            NRICNumber = [Arr1 objectAtIndex:1];
        }
    } @catch (NSException *exception) {
        
        NSLog(@"NRIC Number detection exception %@",exception.description);
        NRICNumber = @"";
    }
    
    NSLog(@"ArrayObject and NRICNumber ---%@",NRICNumber);
    
    return (NRICNumber == (id)[NSNull null])?@"":NRICNumber;
}

-(NSString *)checkGenderFromArray:(NSArray *)ArrayObject
{
    @try {
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Name",@"Nemo",@"Nomo",@"Neme", @"Nome", @"Homo", @"Nnmo", @"Nsmo", @"Namo", @"Na mo", @"Nam o", @"Hama", @"Nairn", @"Hamo", @"Kamo",@"Harm",@"fiamo",@"Nsamo"];
        NSPredicate *NamePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *Nameresultsone       = [ArrayObject filteredArrayUsingPredicate:NamePredicate];
        if ([Nameresultsone count] > 0)
        {
            
            [self SeperatedData:Nameresultsone Dataint:0 DataOne:@"Nameresultsone"];
            
            
            NSArray *FinalSplitedArray = [self SeperateStringIntoArray:[Nameresultsone objectAtIndex:0]];
            if (FinalSplitedArray.count == 4) {
                Gender = [FinalSplitedArray objectAtIndex:3];
            } else {
               Gender = @"MALE";
            }
        } else {
            Gender = @"MALE";
        }
    } @catch (NSException *exception) {
        Gender = @"MALE";
    }
    NSLog(@"ArrayObject and Gender ---%@",Gender);
    
    return (Gender == (id)[NSNull null])?@"":Gender;
}

-(NSString *)checkOwnerFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )",@"Owner",@"Ownor",@"Owoer",@"Owoor"];
        
        NSPredicate *OwnerPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray     *Ownerresultsone   = [ArrayObject filteredArrayUsingPredicate:OwnerPredicate];
        
        NSLog(@"Owner result --- %@",Ownerresultsone);
        
        if ([Ownerresultsone count] > 0)
        {
            
            NSArray *FinalSplitedArray = [self SeperatedData:Ownerresultsone Dataint:1 DataOne:@"Ownerresultsone"];
            
          /**  if ([[Ownerresultsone objectAtIndex:1] rangeOfString:@":"].location == NSNotFound) {
                FinalSplitedArray = [[[Ownerresultsone objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@"  "];
            } else {
                if ([[Ownerresultsone objectAtIndex:1] rangeOfString:@";"].location == NSNotFound) {
                    FinalSplitedArray = [[[Ownerresultsone objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@":"];
                } else {
                    FinalSplitedArray = [[[Ownerresultsone objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@";"];
                }
            }
           **/
            NSLog(@"owner data splited array %@",FinalSplitedArray);
            
            if ([FinalSplitedArray count]>0) {
                
                Owner = [[FinalSplitedArray objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                
            } else {
            
                Owner = @"Not Found";
            }
        } else {
            Owner = @"Not Found";
        }
    } @catch (NSException *exception) {
        Owner = @"Not Found";
    }
    NSLog(@"ArrayObject and Owner ---%@",Owner);
    
    return (Owner == (id)[NSNull null])?@"":Owner;
}

-(NSString *)checkPolicyDateFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Policy Dato",@"Policy Date",@"Policy Doto",@"Policy Dote", @"Policy Oato", @"Policy Ooto",@"Policy Osto"];
        
        NSPredicate *PolicyDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *PolicyDateresultsone       = [ArrayObject filteredArrayUsingPredicate:PolicyDatePredicate];
        
        NSLog(@"Policy Date result --- %@",PolicyDateresultsone);
        
        if ([PolicyDateresultsone count] > 0)
        {
            
            NSArray *FinalSplitedArray = [self SeperatedData:PolicyDateresultsone Dataint:0 DataOne:@"PolicyDateresultsone"];
            
           /** NSArray *FinalSplitedArray = nil;
            if ([[PolicyDateresultsone objectAtIndex:0] rangeOfString:@":"].location == NSNotFound) {
                FinalSplitedArray = [[[PolicyDateresultsone objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@"  "];
            } else {
                if ([[PolicyDateresultsone objectAtIndex:0] rangeOfString:@";"].location == NSNotFound) {
                    FinalSplitedArray = [[[PolicyDateresultsone objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@":"];
                } else {
                    FinalSplitedArray = [[[PolicyDateresultsone objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@";"];
                }
            }
            
            NSLog(@"FinalSplitedArray Date result --- %@",FinalSplitedArray);
            if ([FinalSplitedArray count]>0) {
                
                NSString *RR1 =[[FinalSplitedArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSArray *RR2 = [RR1 componentsSeparatedByString:@" "];
                
                NSLog(@"RR2 ----- %@",RR2);
                NSMutableArray *mainArray = [[NSMutableArray alloc]init];
                for (int i = 0; i < [RR2 count]; i++) {
                    id obj = [RR2 objectAtIndex:i];
                    if ( [allTrim( obj) length] > 1) {
                        NSString *trimmed = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        [mainArray addObject:trimmed];
                    }
                }
            
                Policydate = [mainArray objectAtIndex:0];
                
                
            } else {
                NSArray *Arr1 =  [self SeperatedData:PolicyDateresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                Policydate = [Arr1 objectAtIndex:1];
            }
            **/
            Policydate = (FinalSplitedArray.count == 2)?@"":[FinalSplitedArray objectAtIndex:1];
        } else {
            Policydate = @"";
        }
    } @catch (NSException *exception) {
        Policydate = @"";
    }
    return (Policydate == (id)[NSNull null])?@"":Policydate;
}

-(NSString *)checkPaidToDateFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Paid To Date",@"Paid To Dato",@"Paid To Dote",@"Paid To Doto", @"Paid To Data", @"Paid To"];
        
        NSPredicate *PaidToDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *PaidToDateresultsone       = [ArrayObject filteredArrayUsingPredicate:PaidToDatePredicate];
        
        NSArray *FinalSplitedArray = [self SeperatedData:PaidToDateresultsone Dataint:0 DataOne:@"PaidToDateresultsone"];
        
        NSLog(@"Paid to Date result --- %@",FinalSplitedArray);
     
        if ([PaidToDateresultsone count] > 0)
        {
             /**
            [self SeperatedData:PaidToDateresultsone Dataint:0 DataOne:@"PaidToDateresultsone"];
            
            NSArray *FinalSplitedArray = [[PaidToDateresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
            NSLog(@"Paid to Date FinalSplitedArray ---%@",FinalSplitedArray);
            
            if ([FinalSplitedArray count]>0) {
                NSLog(@"FinalSplitedArray === %lu",(unsigned long)FinalSplitedArray.count);
                if ([FinalSplitedArray count]==4) {
                    PaidToDate = [[FinalSplitedArray objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                } else if ([FinalSplitedArray count]==3) {
                    PaidToDate = [[FinalSplitedArray objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                } else {
                    PaidToDate = @"";
                }
                NSLog(@"PaidToDate ---%@",PaidToDate);
            } else {
                NSArray *Arr1 =  [self SeperatedData:PaidToDateresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                PaidToDate = (Arr1.count ==3)?[Arr1 objectAtIndex:3]:@"";
            }
       **/
            
            PaidToDate = (FinalSplitedArray.count == 4)?[FinalSplitedArray objectAtIndex:3]:@"";
        } else {
            PaidToDate = @"";
        }
    } @catch (NSException *exception) {
        PaidToDate = @"";
    }
    NSLog(@"ArrayObject and PaidToDate ---%@",PaidToDate);
    
    return (PaidToDate == (id)[NSNull null])?@"":PaidToDate;
}

-(NSString *)checkModelPremiumFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Modal Premium",@"Modol Premium",@"Modal Premiom",@"Modal Promium"];
        
        NSPredicate *ModalPremiumPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *ModalPremiumresultsone       = [ArrayObject filteredArrayUsingPredicate:ModalPremiumPredicate];
        
        NSLog(@"Model Premum Date result --- %@",ModalPremiumresultsone);
        
        if ([ModalPremiumresultsone count] > 0)
        {
            NSArray *FinalSplitedArray = [self SeperatedData:ModalPremiumresultsone Dataint:0 DataOne:@"ModalPremiumresultsone"];
            /**
            NSArray *FinalSplitedArray = [[ModalPremiumresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
            
            if ([FinalSplitedArray count]>0) {
                
                ModelPremium = [FinalSplitedArray objectAtIndex:1];
                
            } else {
                
                NSArray *Arr1 =  [self SeperatedData:ModalPremiumresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                ModelPremium =[Arr1 objectAtIndex:1];
            }**/
            ModelPremium =(FinalSplitedArray.count>2)?[FinalSplitedArray objectAtIndex:1]:@"";
        }
        else
        {
            ModelPremium = @"";
        }
        
    } @catch (NSException *exception) {
        
        ModelPremium = @"";
    }
    
    return (ModelPremium == (id)[NSNull null])?@"":ModelPremium;
}

-(NSString *)checkNextModelPremiumFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Next Modal Premiom",@"Next Modal Premium",@"Next Modol Premium",@"Noxt Modal Premium"];
        
        NSPredicate *NextModalPremiumPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *NextModalPremiumresultsone       = [ArrayObject filteredArrayUsingPredicate:NextModalPremiumPredicate];
        
        NSLog(@"next modal premum result --- %@",NextModalPremiumresultsone);
        
        if ([NextModalPremiumresultsone count] > 0)
        {
           NSArray *FinalSplitedArray = [self SeperatedData:NextModalPremiumresultsone Dataint:0 DataOne:@"NextModalPremiumresultsone"];
            
           /** NSArray *FinalSplitedArray = [[NextModalPremiumresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
            
            if ([FinalSplitedArray count]==3) {
                
                NextModelPremium = [[FinalSplitedArray objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
            } else {
                NSArray *Arr1 =  [self SeperatedData:NextModalPremiumresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                NextModelPremium =[Arr1 objectAtIndex:1];
            }
            **/
            NextModelPremium =(FinalSplitedArray.count == 4)?[FinalSplitedArray objectAtIndex:3]:@"";
        }
        else
        {
            NextModelPremium = @"";
        }
    } @catch (NSException *exception) {
        NextModelPremium = @"";
    }
    NSLog(@"ArrayObject and NextModelPremium ---%@",NextModelPremium);
    return (NextModelPremium == (id)[NSNull null])?@"":NextModelPremium;
}

-(NSString *)checkPayUpdateFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Pay Up Dato",@"Pay Up Date",@"Pay Up Dote",@"Pay Up Dete"];
        
        NSPredicate *PayUpDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *PayUpDateresultsone       = [ArrayObject filteredArrayUsingPredicate:PayUpDatePredicate];
        
        NSLog(@"Payupdate result --- %@",PayUpDateresultsone);
        
        if ([PayUpDateresultsone count] > 0)
        {
           NSArray *FinalSplitedArray = [self SeperatedData:PayUpDateresultsone Dataint:0 DataOne:@"PayUpDateresultsone"];
            
           /** NSArray *FinalSplitedArray = [[PayUpDateresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
            
            if ([FinalSplitedArray count]>0) {
                
                PayUpdate = [FinalSplitedArray objectAtIndex:1];
            } else {
                NSArray *Arr1 =  [self SeperatedData:PayUpDateresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                PayUpdate =[Arr1 objectAtIndex:1];

            }
            **/
            PayUpdate =(FinalSplitedArray.count > 2)?[FinalSplitedArray objectAtIndex:1]:@"";
        } else {
            PayUpdate = @"";
        }
    } @catch (NSException *exception) {
        
        PayUpdate = @"";
    }
    NSLog(@"ArrayObject and PayUpdate ---%@",PayUpdate);
    
    return (PayUpdate == (id)[NSNull null])?@"":PayUpdate;
}

-(NSString *)checkMaturityDateFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Maturity Date",@"Maturity Dato",@"Maturity Dote",@"Maturity Dete", @"Maturity Doto"];
        
        NSPredicate *MaturityDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *MaturityDateresultsone       = [ArrayObject filteredArrayUsingPredicate:MaturityDatePredicate];
        
        NSLog(@"maturity Date result --- %@",MaturityDateresultsone);
        
        if ([MaturityDateresultsone count] > 0)
        {
            NSArray *FinalSplitedArray = [self SeperatedData:MaturityDateresultsone Dataint:0 DataOne:@"MaturityDateresultsone"];
            /**
            NSArray *FinalSplitedArray = [[MaturityDateresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
            
            if ([FinalSplitedArray count]>0) {
                
                MaturityDate = [FinalSplitedArray objectAtIndex:3];
                
            } else {
                
                NSArray *Arr1 =  [self SeperatedData:MaturityDateresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                MaturityDate =[Arr1 objectAtIndex:1];
            }
             **/
            MaturityDate =(FinalSplitedArray.count == 4)?[FinalSplitedArray objectAtIndex:3]:@"";
        }
        else
        {
            MaturityDate = @"";
        }
        
    } @catch (NSException *exception) {
        
        MaturityDate = @"";
    }
    NSLog(@"ArrayObject and MaturityDate ---%@",MaturityDate);
    
    return (MaturityDate == (id)[NSNull null])?@"":MaturityDate;
}

-(NSString *)checkInsuredAddressFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Insured Address",@"Insured Addross",@"Insured Addreso",@"Insured Addreoo", @"insured Address", @"insured address"];
        
        NSPredicate *InsuredAddressPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *InsuredAddressresultsone       = [ArrayObject filteredArrayUsingPredicate:InsuredAddressPredicate];
        
        NSLog(@"Insured Address result --- %@",InsuredAddressresultsone);
        
        if ([InsuredAddressresultsone count] > 0)
        {
           NSArray *FinalSplitedArray = [self SeperatedData:InsuredAddressresultsone Dataint:0 DataOne:@"InsuredAddressresultsone"];
            
           /** NSArray *FinalSplitedArray = [[InsuredAddressresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
            
            if ([FinalSplitedArray count]>0) {
                
                InsuredAddress = [FinalSplitedArray objectAtIndex:1];
                
            } else {
                
                NSArray *Arr1 =  [self SeperatedData:InsuredAddressresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                InsuredAddress =[Arr1 objectAtIndex:1];
            }
            **/
            InsuredAddress =(FinalSplitedArray.count > 2)?[FinalSplitedArray objectAtIndex:1]:@"";
        }
        else
        {
            InsuredAddress = @"";
        }
        
    } @catch (NSException *exception) {
        InsuredAddress = @"";
    }
    NSLog(@"ArrayObject and InsuredAddress ---%@",InsuredAddress);
    
    return (InsuredAddress == (id)[NSNull null])?@"":InsuredAddress;
}

-(NSString *)checkAdjustedPremiumFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Adjusted Premiom",@"Adjusted Promiom",@"Adjusted Promium",@"Adjusted Premium"];
        
        NSPredicate *AdjustedPremiumPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *AdjustedPremiumresultsone       = [ArrayObject filteredArrayUsingPredicate:AdjustedPremiumPredicate];
        
        NSLog(@"Adjusted premium result --- %@",AdjustedPremiumresultsone);
        
        if ([AdjustedPremiumresultsone count] > 0)
        {
            
            NSArray *FinalSplitedArray =[self SeperatedData:AdjustedPremiumresultsone Dataint:0 DataOne:@"AdjustedPremiumresultsone"];
            
          /**  NSArray *FinalSplitedArray = [[AdjustedPremiumresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
            
            if ([FinalSplitedArray count]>0) {
                
                AdjustedPremium = [FinalSplitedArray objectAtIndex:3];
                
            } else {
                
                NSArray *Arr1 =  [self SeperatedData:AdjustedPremiumresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                AdjustedPremium =[Arr1 objectAtIndex:1];
            }
           **/
            AdjustedPremium =(FinalSplitedArray.count == 4)?[FinalSplitedArray objectAtIndex:3]:@"";
        }
        else
        {
            AdjustedPremium = @"";
        }
        
    } @catch (NSException *exception) {
        
        AdjustedPremium = @"";
    }
    NSLog(@"ArrayObject and AdjustedPremium ---%@",AdjustedPremium);
    
    return (AdjustedPremium == (id)[NSNull null])?@"":AdjustedPremium;
}

-(NSString *)checkIssueAgeFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Date of Birth",@"Dato of Birth",@"Dote of Birth",@"Doto of Birth", @"Oato of Birth", @"Data of Blrtb"];
        
        NSPredicate *DOBPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *DOBresultsone       = [ArrayObject filteredArrayUsingPredicate:DOBPredicate];
        
        NSLog(@"Issue Age result --- %@",DOBresultsone);
        
        if ([DOBresultsone count] > 0)
        {
            [self SeperatedData:DOBresultsone Dataint:0 DataOne:@"DOBresultsone"];
            
            NSArray *FinalSplitedArray = [[DOBresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
            
            NSLog(@"Issue Age FinalSplitedArray --- %@",FinalSplitedArray);
            
            if ([FinalSplitedArray count]>0) {
                if ([FinalSplitedArray count] == 3) {
                    IssueAge = [FinalSplitedArray objectAtIndex:2];
                } else if([FinalSplitedArray count] == 2) {
                   NSArray * IssueAgeSepArray = [[FinalSplitedArray objectAtIndex:1] componentsSeparatedByString:@" "];
                    NSMutableArray *mainArray = [[NSMutableArray alloc]init];
                    for (int i = 0; i < [IssueAgeSepArray count]; i++) {
                        id obj = [IssueAgeSepArray objectAtIndex:i];
                        if ( [allTrim( obj) length] > 1) {
                            NSString *trimmed = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            [mainArray addObject:trimmed];
                        }
                        
                        NSLog(@"issue age final array == %@",mainArray );
                    }
                } else {
                    IssueAge = @"";
                }
            } else {
                IssueAge = @"";
            }
        } else {
            IssueAge = @"";
        }
    } @catch (NSException *exception) {
        
        IssueAge = @"";
    }
    NSLog(@"ArrayObject and IssueAge ---%@",IssueAge);
    
    return (IssueAge == (id)[NSNull null])?@"":IssueAge;
}

-(NSString *)checkPaymentModeFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Payment Mode",@"Payment Modo",@"Payment Mede",@"Payment Made", @"Paymont Mode", @"Paymont Modo", @"Paymont Mede", @"Paymont Made"];
        
        NSPredicate *PaymentModePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *PaymentModeresultsone       = [ArrayObject filteredArrayUsingPredicate:PaymentModePredicate];
        
        NSLog(@"Payment Mode result --- %@",PaymentModeresultsone);
        
        if ([PaymentModeresultsone count] > 0)
        {
            NSArray *FinalSplitedArray = [self SeperatedData:PaymentModeresultsone Dataint:0 DataOne:@"PaymentModeresultsone"];
            
          /**  NSArray *FinalSplitedArray = [[PaymentModeresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
            
            if ([FinalSplitedArray count]>0) {
                
                PaymentMode = [FinalSplitedArray objectAtIndex:1];
                
            } else {
                
                NSArray *Arr1 =  [self SeperatedData:PaymentModeresultsone Dataint:0 DataOne:@"checkStatusdataFromArray"];
                AdjustedPremium =(Arr1.count>=3)?[Arr1 objectAtIndex:1]:@"";
            }
           **/
            PaymentMode = (FinalSplitedArray.count > 2)?[FinalSplitedArray objectAtIndex:1]:@"";
        }
        else
        {
            PaymentMode = @"";
        }
        
    } @catch (NSException *exception) {
        
        PaymentMode = @"";
    }
    NSLog(@"ArrayObject and PaymentMode ---%@",PaymentMode);
    return (PaymentMode == (id)[NSNull null])?@"":PaymentMode;
}
-(NSString *)checkPaymentMethodFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Payment Method",@"Payment Mothod",@"Paymont Method",@"Paymont Mothod"];
        
        NSPredicate *PaymentMothodPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *PaymentMothodresultsone       = [ArrayObject filteredArrayUsingPredicate:PaymentMothodPredicate];
        
        NSLog(@"payment Method result --- %@",PaymentMothodresultsone);
        
        if ([PaymentMothodresultsone count] > 0)
        {
           NSArray *FinalSplitedArray =  [self SeperatedData:PaymentMothodresultsone Dataint:0 DataOne:@"PaymentMothodresultsone"];
            
           /** NSArray *FinalSplitedArray = [[PaymentMothodresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
            
            if ([FinalSplitedArray count]>0) {
                PaymentMethod = [FinalSplitedArray objectAtIndex:3];
            } else {
                PaymentMethod = @"";
            }
            **/
            PaymentMethod = (FinalSplitedArray.count == 4)?[FinalSplitedArray objectAtIndex:3]:@"";
        } else {
            PaymentMethod = @"";
        }
    } @catch (NSException *exception) {
        
        PaymentMethod = @"";
    }
    NSLog(@"ArrayObject and PaymentMethod ---%@",PaymentMethod);
    return (PaymentMethod == (id)[NSNull null])?@"":PaymentMethod;
}
-(NSString *)checkBillToDateFromArray:(NSArray *)ArrayObject
{
    @try {
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"( SELF CONTAINS[cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ ) OR ( SELF CONTAINS [cd] %@ )", @"Bill To Date",@"Bill To Dato",@"Bill To Dote",@"Bill To Dete"];
        
        NSPredicate *BillToDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[_myPredicate]];
        NSArray *BillToDateresultsone       = [ArrayObject filteredArrayUsingPredicate:BillToDatePredicate];
        
        NSLog(@"Bill t6o Date result --- %@",BillToDateresultsone);
        
        if ([BillToDateresultsone count] > 0)
        {
            [self SeperatedData:BillToDateresultsone Dataint:0 DataOne:@"BillToDateresultsone"];
            
            NSArray *FinalSplitedArray = [[BillToDateresultsone objectAtIndex:0] componentsSeparatedByString:@":"];
            
            if ([FinalSplitedArray count]>0) {
                
                BillToDate =[FinalSplitedArray objectAtIndex:3];
                
            } else {
                
                BillToDate = @"";
            }
        }
        else
        {
            BillToDate = @"";
        }
        
    } @catch (NSException *exception) {
        
        BillToDate = @"";
    }
    NSLog(@"ArrayObject and BillToDate ---%@",BillToDate);
    return (BillToDate == (id)[NSNull null])?@"":BillToDate;
}
-(NSArray *)SeperateStringIntoArray:(NSString *)DataString
{
    NSMutableArray *mainArray = [[NSMutableArray alloc]init];
    NSArray *DataArray = [DataString componentsSeparatedByString:@"  "];
    for (int i = 0; i < [DataArray count]; i++) {
        id obj = [DataArray objectAtIndex:i];
        if ( [allTrim( obj) length] > 1) {
            NSString *trimmed = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *RemovedString = [trimmed stringByReplacingOccurrencesOfString:@":" withString:@""];
            NSString *RemoveSpaceFromFirstAndLast = [RemovedString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            if ([RemoveSpaceFromFirstAndLast rangeOfString:@"  "].location == NSNotFound) {
                [mainArray addObject:RemoveSpaceFromFirstAndLast];
            } else {
                NSArray *DataArrayString = [RemoveSpaceFromFirstAndLast componentsSeparatedByString:@"  "];
                for (int i = 0; i < [DataArrayString count]; i++) {
                    NSString *RemoveSpaceFromFirstAndLast = [[DataArrayString objectAtIndex:i] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                    NSString *RemovedString = [RemoveSpaceFromFirstAndLast stringByReplacingOccurrencesOfString:@":" withString:@""];
                    [mainArray addObject:RemovedString];
                }
            }
        }
    }
    return mainArray;
}
-(NSArray *)SeperatedData:(NSArray *)DataArray Dataint:(int)Myint DataOne:(NSString *)DataOne
{
    /**
     *  Owner Special Containt data array start
     */
    
    NSString *DataArrayone = [[[DataArray objectAtIndex:Myint] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *DataArraytwo = [DataArrayone stringByReplacingOccurrencesOfString:@";" withString:@""];
    
    NSString *Str = [DataArraytwo stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"-----%@ -----%@",DataOne,[self SeperateStringIntoArray:Str]);
    return [self SeperateStringIntoArray:Str];
    
    /**
    
    Str = [Str stringByReplacingOccurrencesOfRegex:@" +" withString:@"***********"];
    
    NSLog(@"%@ result StringArray ------ %@",DataOne,Str);
    
    NSArray *DataArrayObject = [Str componentsSeparatedByString:@"******"];
    
    NSLog(@"%@SeperatedData DataArray ------ %@",DataOne,DataArrayObject);
    
    NSMutableArray *NamevalueArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [DataArrayObject count]; i++) {
        id objNew = [DataArrayObject objectAtIndex:i];
        if ( [allTrim( objNew) length] > 1) {
            
            NSString *trimmedNew = [objNew stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [NamevalueArray addObject:trimmedNew];
        }
    }
    
    NSLog(@"resulted Array ---- %@ Mya data ---%@",DataOne,NamevalueArray);
     **/
    
    /**
     *  Owner Special Containt data array end
     */
}

@end
