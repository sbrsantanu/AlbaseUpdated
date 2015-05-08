//
//  NoteDataFetcher.m
//  Albase
//
//  Created by Mac on 19/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "NoteDataFetcher.h"
#import "OCRDataObjectModel.h"
#import "NoteDetails.h"
#import "OCRAppDelegate.h"

@implementation NoteDataFetcher

-(void)GetNoteList
{
    NSMutableArray *NoteListArray = [[NSMutableArray alloc] init];
    
    OCRAppDelegate *MainDelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *Context = [MainDelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NoteDetails" inManagedObjectContext:Context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [Context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        [self DataFetchErrorWithdataErrors:error];
        
    } else {
        
        for (NoteDetails *info in fetchedObjects) {
            
            OCRNoteDataObjectModel *NoteDataObject = [[OCRNoteDataObjectModel alloc] initWithNoteId:info.noteid NoteAddedDate:info.notestatus NoteDetails:info.notedetails];
            
            [NoteListArray addObject:NoteDataObject];
            
        }
    }
    
    NSMutableDictionary *ReturnedData = [[NSMutableDictionary alloc] init];
    [ReturnedData setObject:NoteListArray forKey:@"NoteData"];
    
    [self DataFetchSuccessWithDetailsWithDataDetails:ReturnedData];
    
}
-(void)DataFetchErrorWithdataErrors:(NSError *)ErrorData
{
    [_delegate GetNoteListWithError:self WithErrorData:ErrorData];
}
-(void)DataFetchSuccessWithDetailsWithDataDetails:(id)DataDetails
{
    [_delegate GetNoteListWithSuccess:self WithSuccessdata:DataDetails];
}
@end
