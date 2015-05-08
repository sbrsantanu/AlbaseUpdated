//
//  OCRAddEditNoteViewController.m
//  Albase
//
//  Created by Mac on 27/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRAddEditNoteViewController.h"
#import "UIColor+HexColor.h"
#import "OCRNoteListViewController.h"
#import "OCRDataObjectModel.h"

@interface OCRAddEditNoteViewController ()<UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic,retain) UITextView *NoteTextView;
@end

@implementation OCRAddEditNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         //self=(IsIphone5)?[super initWithNibName:@"OCRAddEditNoteViewController" bundle:nil]:[super initWithNibName:@"OCRAddEditNoteViewController4s" bundle:nil];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRAddEditNoteViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRAddEditNoteViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRAddEditNoteViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRAddEditNoteViewController6s" bundle:nil];
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
    [Titlelabel setText:(_UserNoteWritingStatus == NoteWritingStatusNewNote)?@"Add New Note":@"Edit Note"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    NSDateFormatter *dateFormatterallday = [[NSDateFormatter alloc] init];
    [dateFormatterallday setDateFormat:@"EEE,dd MMM yyy hh:mm aa"];
    
    NSDate *Todaydate = [NSDate date];
    NSString *DateData =  [dateFormatterallday stringFromDate:Todaydate];
    NSLog(@"Successfully selected end date: %@",DateData);
    
    UILabel *NoteStatusLabel = (UILabel *)[self.view viewWithTag:171];
    [NoteStatusLabel setText:DateData];
    [NoteStatusLabel setTextColor:[UIColor darkGrayColor]];
    [NoteStatusLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];

    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateHighlighted];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateSelected];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateApplication];
    
    [SetButton addTarget:self action:@selector(GoBackToMainPage:) forControlEvents:UIControlEventTouchUpInside];
    
    _NoteTextView = (UITextView *)[self.view viewWithTag:172];
    [_NoteTextView setDelegate:self];
    [_NoteTextView setTextColor:[UIColor darkGrayColor]];
    [_NoteTextView becomeFirstResponder];
    [_NoteTextView setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    
    UIButton *saveDataButton = (UIButton *)[self.view viewWithTag:444];
    [saveDataButton addTarget:self action:@selector(SaveNoteData) forControlEvents:UIControlEventTouchUpInside];
    [saveDataButton.titleLabel setTextColor:[UIColor darkGrayColor]];
    [saveDataButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    
    OCRNoteDataObjectModel *NoteObject = _ObjectCarrier;
    
    if (_UserNoteWritingStatus == NoteWritingStatusEditNote) {
        [_NoteTextView setText:[NoteObject NoteDetails]];
    }
    
}
-(void)SaveNoteData
{
    for (id AllTextView in [self.view subviews]) {
        if ([AllTextView isKindOfClass:[UITextView class]]) {
            UITextView *MycustomTextView = (UITextView *)AllTextView;
            [MycustomTextView resignFirstResponder];
        }
    }
    NSLog(@"save note data");
    if ([self CleanTextField:[_NoteTextView text]].length == 0) {
        ShowAlert(@"Credintial Error", @"Note Details can't be empty");
    } else {
        [self startSpin];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            NSString *url = nil;
            
            if (_UserNoteWritingStatus == NoteWritingStatusNewNote) {
                url = [NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=AddNoteDetails&Notedetails=%@&Mode=add",[[self CleanTextField:[_NoteTextView text]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            } else if (_UserNoteWritingStatus == NoteWritingStatusEditNote) {
                
                OCRNoteDataObjectModel *NoteObject = _ObjectCarrier;
                
                url = [NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=AddNoteDetails&Notedetails=%@&NoteId=%@&Mode=edit",[[self CleanTextField:[_NoteTextView text]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[NoteObject NoteId]];
            }
            
            NSLog(@"URL : %@", url);
            
            NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
            if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self stopSpin];
                if([[results objectForKey:@"status"] isEqualToString:@"success"])
                {
                    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Note saved successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [Alert setTag:11452];
                    [Alert show];
                } else {
                    ShowAlert(@"Error", @"Unable to save note, please try again later");
                }
            });
        });
    }
}

-(IBAction)GoBackToMainPage:(id)sender
{
    for (id AllTextView in [self.view subviews]) {
        if ([AllTextView isKindOfClass:[UITextView class]]) {
            UITextView *MycustomTextView = (UITextView *)AllTextView;
            [MycustomTextView resignFirstResponder];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(NSString *)CleanTextField:(NSString *)TextfieldName
{
    NSString *Cleanvalue = [TextfieldName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return Cleanvalue;
}

#pragma uitextview protocol delegate declearation

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11452) {
        
        NSMutableDictionary *DataDictionary = [[NSMutableDictionary alloc] init];
        [DataDictionary setObject:[self CleanTextField:[_NoteTextView text]] forKey:@"notedata"];
        id objectdata = DataDictionary;
        
        [self dismissViewControllerAnimated:YES completion:^(void){
            [_delegate HandleDataObject:self ObjectCarrier:objectdata];
        }];
    }
}
@end
