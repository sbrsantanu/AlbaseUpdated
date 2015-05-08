//
//  Person+DatabaseActivity.m
//  Albase
//
//  Created by Mac on 17/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "Person+DatabaseActivity.h"

@implementation Person (DatabaseActivity)


+(Person *)InsurenceWithDataDictionary:(OCRUserDataObjectModel *)DataDictionary
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    Person *person = nil;
    
    NSString *Unique = [DataDictionary UserId];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    request.predicate       = [NSPredicate predicateWithFormat:@"id = %@",Unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        // handle error
    } else if ([matches count]) {
        person = [matches firstObject];
    } else {
        person = [NSEntityDescription insertNewObjectForEntityForName:@"Person"
                                              inManagedObjectContext:context];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        person.dateOfBirth =[DataDictionary DateOfBirth];
        person.firstname =[DataDictionary Firstname];
        person.gender =[DataDictionary Gender];
        person.id   =   [DataDictionary UserId];
        person.lastname =[DataDictionary Lastname];
        person.useremail = [DataDictionary Usersemail];
        person.userimage =[DataDictionary ProfileImage];
        person.userPhoneNumber=[DataDictionary UserPhoneNumber];
        //person.personInsurence = [f numberFromString:[DataDictionary UserId]];
    }
    
    return person;
}

+(void)LoadInsurenceDataFromServerWithArray:(NSArray *)insurence
                     inManagedObjectContext:(NSManagedObjectContext *)context
{
    for (OCRUserDataObjectModel *dataObject in insurence) {
        [self InsurenceWithDataDictionary:dataObject inManagedObjectContext:context];
    }
}

@end
