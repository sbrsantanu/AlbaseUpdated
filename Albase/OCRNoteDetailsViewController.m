//
//  OCRNoteDetailsViewController.m
//  OCRScanner
//
//  Created by Mac on 23/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRNoteDetailsViewController.h"
#import "OCRDataObjectModel.h"
#import "UIColor+HexColor.h"
#import "OCRNoteListViewController.h"

@interface OCRNoteDetailsViewController ()
{
    UITextView *TextViewDetails;
}
@end

@implementation OCRNoteDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self=(IsIphone5)?[super initWithNibName:@"OCRNoteDetailsViewController" bundle:nil]:[super initWithNibName:@"OCRNoteDetailsViewController4s" bundle:nil];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRNoteDetailsViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRNoteDetailsViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRNoteDetailsViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRNoteDetailsViewController6s" bundle:nil];
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
    [Titlelabel setText:@"Note Details"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    [SetButton addTarget:self action:@selector(BackviewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    TextViewDetails = (UITextView *)[self.view viewWithTag:777];
    OCRNoteDataObjectModel *NoteObject = self.noteobject;
    [TextViewDetails setText:[NoteObject NoteDetails]];
    [TextViewDetails setTextColor:[UIColor darkGrayColor]];
    [TextViewDetails setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    [TextViewDetails setTextAlignment:NSTextAlignmentJustified];
    
    UIButton *EditButton = (UIButton *)[self.view viewWithTag:452];
    [EditButton addTarget:self action:@selector(Editnote:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *DeleteButton = (UIButton *)[self.view viewWithTag:453];
    [DeleteButton addTarget:self action:@selector(Deletenote:) forControlEvents:UIControlEventTouchUpInside];
}
-(IBAction)Deletenote:(id)sender
{
    
    UIAlertView *DeleteNoteAlert =[[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure to delete this note?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil];
    [DeleteNoteAlert setTag:47896];
    [DeleteNoteAlert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 47896) {
        if (buttonIndex == 1) {
            [self startSpin];
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                
                NSString *url = nil;
                OCRNoteDataObjectModel *NoteObject = self.noteobject;
                url = [NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=DeleteNote&NoteID=%@",[NoteObject NoteId]];
                
                NSLog(@"URL : %@", url);
                
                NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
                if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self stopSpin];
                    if([[results objectForKey:@"status"] isEqualToString:@"success"])
                    {
                        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Note deleted successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [Alert setTag:11452];
                        [Alert show];
                    } else {
                        ShowAlert(@"Error", @"Unable to delete note, please try again later");
                    }
                });
            });
        }
    } else if (alertView.tag == 11452) {
        OCRNoteListViewController *NoteList = [[OCRNoteListViewController alloc] initWithNibName:@"OCRNoteListViewController" bundle:nil];
        [self.navigationController pushViewController:NoteList animated:YES];
    }
}
-(IBAction)Editnote:(id)sender
{
    OCRAddEditNoteViewController *EditNote = [[OCRAddEditNoteViewController alloc] initWithNibName:@"OCRAddEditNoteViewController" bundle:nil];
    [EditNote setUserNoteWritingStatus:NoteWritingStatusEditNote];
    [EditNote setDelegate:self];
    [EditNote setObjectCarrier:self.noteobject];
    [self presentViewController:EditNote animated:YES completion:nil];
}
- (void)HandleDataObject:(OCRAddEditNoteViewController *)myObj ObjectCarrier:(id)ObjectCarrier
{
    [TextViewDetails setText:[ObjectCarrier objectForKey:@"notedata"]];
}
-(IBAction)BackviewClicked:(id)sender
{
    OCRNoteListViewController *notelist = [[OCRNoteListViewController alloc] init];
    [self.navigationController pushViewController:notelist animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
