//
//  NoteDataProtocol.m
//  Albase
//
//  Created by Mac on 20/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "NoteDataProtocol.h"
#import "OCRDataObjectModel.h"
#import "OCRAppDelegate.h"
#import "NoteDetails.h"

@interface NoteDataProtocol ()

@property (nonatomic,weak) OCRAppDelegate *MainDelegate;

@end

@implementation NoteDataProtocol

-(void)SaveNoteDataIntoLocaldatabase
{
    _MainDelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    __block OCRNoteDataObjectModel *NoteDataObjectModel = nil;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=getAllNote"];
        NSLog(@"URL : %@", url);
        
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
        if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if([[results objectForKey:@"status"] isEqualToString:@"success"])
            {
                int i = 0;
                for (id MyBirthday in [results objectForKey:@"userdata"]) {
                    
                    OCRNoteDataObjectModel *NoteObject = [[OCRNoteDataObjectModel alloc] initWithNoteId:[MyBirthday objectForKey:@"noteid"] NoteAddedDate:[MyBirthday objectForKey:@"addedon"] NoteDetails:[MyBirthday objectForKey:@"notedetails"]];
                    i++;
                    [self HandleCoreDataOperation:NoteObject WithTotaldata:[results objectForKey:@"totaldata"] WithCurrentdata:i];
                }
            }
        });
    });
}

-(void)HandleCoreDataOperation :(OCRNoteDataObjectModel *)DataDictionary WithTotaldata:(NSString *)totaldata WithCurrentdata:(int)Currentdata
{
    NSManagedObjectContext *context = [_MainDelegate managedObjectContext];
    NSString *unique = [DataDictionary NoteId];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NoteDetails"];
    request.predicate = [NSPredicate predicateWithFormat:@"noteid = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        // handle error
    } else if ([matches count]) {
        NSLog(@"data is there");
    } else {
        
        NoteDetails *NoteDetails = [NSEntityDescription
                          insertNewObjectForEntityForName:@"NoteDetails"
                          inManagedObjectContext:context];
        
        NoteDetails.noteid = [DataDictionary NoteId];
        NoteDetails.notedetails = [DataDictionary NoteDetails];
        NoteDetails.addedon = [DataDictionary NoteAddedDate];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        } else {
            NSLog(@"data saved into databse");
        }
    }
    
    
    NSLog(@"totaldata ----- %d and curentdata ----- %d",[totaldata intValue],Currentdata);
    
    if ([totaldata intValue] == Currentdata) {

        [self GetNoteList];
    }
}

/*
 data saved into database, now fetch and return back to the protocol
 */

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
        
        [self NotedataSavedIntoLocalDatabaseWithError:error];
        
    } else {
        
        for (NoteDetails *info in fetchedObjects) {
            
            OCRNoteDataObjectModel *NoteDataObject = [[OCRNoteDataObjectModel alloc] initWithNoteId:info.noteid NoteAddedDate:info.notestatus NoteDetails:info.notedetails];
            
            [NoteListArray addObject:NoteDataObject];
            
        }
    }
    
    [self NotedataSavedIntoLocalDatabaseWithSuccess:NoteListArray];
    
}

-(void)EditNoteInLocalDatabase
{
    
}
-(void)DeleteNoteFromLocalDataBase
{
    
}

/*
 Data saved successfully, notify to the protocol
 */

-(void)NotedataSavedIntoLocalDatabaseWithSuccess:(id)ObjectCarrier
{
    [_delegate SaveNoteDataIntoDataBase:self WithSuccess:ObjectCarrier];
}

/*
 Data saved Error, notify to the protocol
 */

-(void)NotedataSavedIntoLocalDatabaseWithError:(NSError *)DataSaveError
{
    [_delegate SaveNoteDataIntoDataBase:self WithError:DataSaveError];
}

@end
