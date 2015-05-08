//
//  Person+DatabaseActivity.h
//  Albase
//
//  Created by Mac on 17/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "Person.h"
#import "OCRDataObjectModel.h"

@interface Person (DatabaseActivity)

+(Person *)InsurenceWithDataDictionary:(OCRUserDataObjectModel *)DataDictionary
                   inManagedObjectContext:(NSManagedObjectContext *)context;

+(void)LoadInsurenceDataFromServerWithArray:(NSArray *)insurence
                     inManagedObjectContext:(NSManagedObjectContext *)context;

@end
