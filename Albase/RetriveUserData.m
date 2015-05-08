//
//  RetriveUserData.m
//  Albase
//
//  Created by Mac on 18/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "RetriveUserData.h"
#import "OCRAppDelegate.h"
#import "Person.h"
#import "OCRDataObjectModel.h"

@implementation RetriveUserData

-(void)GetUserList
{
    NSDictionary *DataDictionary = [self AlluserList];
    [self DataRetrivedSuccessfully:[DataDictionary objectForKey:@"UserData"]];
    
}
-(void)DataRetrivedSuccessfully:(NSArray *)DataArray
{
    [_delegate GetRetrivedUserDataWithSuccess:self ObjectCarrier:DataArray];
}
-(void)DataRetriveError:(NSError *)DataErr
{
    [_delegate GetRetrivedUserDataWithError:self Errordata:DataErr];
}

-(NSDictionary *)AlluserList
{
    NSMutableArray *UserListArray = [[NSMutableArray alloc] init];
    
    OCRAppDelegate *MainDelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *Context = [MainDelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:Context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [Context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
       
        [self DataRetriveError:error];
        
    } else {
        
        for (Person *info in fetchedObjects) {
            
            OCRUserDataObjectModel *UserDataObject = [[OCRUserDataObjectModel alloc] initWithFirstname:info.firstname Lastname:info.lastname DateOfBirth:info.dateOfBirth UserPhoneNumber:info.userPhoneNumber Usersemail:info.useremail Gender:info.gender ProfileImage:info.userimage UserId:info.id];
            [UserListArray addObject:UserDataObject];
            
        }
    }
    
    NSMutableDictionary *ReturnedData = [[NSMutableDictionary alloc] init];
    [ReturnedData setObject:UserListArray forKey:@"UserData"];
    return ReturnedData;
}
@end
