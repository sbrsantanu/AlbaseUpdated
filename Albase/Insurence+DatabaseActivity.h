//
//  Insurence+DatabaseActivity.h
//  Albase
//
//  Created by Mac on 17/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "Insurence.h"
#import "OCRDataObjectModel.h"

@interface Insurence (DatabaseActivity)

+(Insurence *)InsurenceWithDataDictionary:(OcrInsurenceDataObjectModel *)DataDictionary
                   inManagedObjectContext:(NSManagedObjectContext *)context;

+(void)LoadInsurenceDataFromServerWithArray:(NSArray *)insurence
                     inManagedObjectContext:(NSManagedObjectContext *)context;

@end
