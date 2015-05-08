//
//  Insurence+DatabaseActivity.m
//  Albase
//
//  Created by Mac on 17/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "Insurence+DatabaseActivity.h"

@implementation Insurence (DatabaseActivity)

+(Insurence *)InsurenceWithDataDictionary:(OcrInsurenceDataObjectModel *)DataDictionary
                   inManagedObjectContext:(NSManagedObjectContext *)context
{
    Insurence *insurence = nil;
    
    NSString *Unique                = [DataDictionary InsurenceinsurenceID];
    NSFetchRequest *FetchRequest    = [NSFetchRequest fetchRequestWithEntityName:@"Insurence"];
    // Fetch data against the entity name @"Insurence"
    FetchRequest.predicate          = [NSPredicate predicateWithFormat:@"insurenceID = %@",Unique];
    
    NSError *Error = nil;
    NSArray *Match = [context executeFetchRequest:FetchRequest error:&Error];
    
    if (!Match || [Match count]> 1 || Error) {
        
        // handle error
        
    } else if ([Match count]) {
        
        insurence = [Match firstObject];
    } else {
        
        insurence = [NSEntityDescription insertNewObjectForEntityForName:@"Insurence" inManagedObjectContext:context];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterNoStyle];
        
        [insurence setAddedDate:[DataDictionary InsurenceaddedDate]];
        [insurence setAdjustedPremium:[DataDictionary InsurenceadjustedPremium]];
        [insurence setBillToDate:[DataDictionary InsurencebillToDate]];
        [insurence setInsuredAddress:[DataDictionary InsurenceinsuredAddress]];
        [insurence setInsurenceID:[f numberFromString:[DataDictionary InsurenceinsurenceID]]];
        [insurence setIssueAge:[DataDictionary InsurenceissueAge]];
        [insurence setMaturityDate:[DataDictionary InsurencematurityDate]];
        [insurence setModalPremium:[DataDictionary InsurencemodalPremium]];
        [insurence setNextModalPremium:[DataDictionary InsurencenextModalPremium]];
        [insurence setNric:[DataDictionary Insurencenric]];
        [insurence setOwner:[DataDictionary Insurenceowner]];
        [insurence setPaidToDate:[DataDictionary InsurencepaidToDate]];
        [insurence setPaymentMode:[DataDictionary InsurencepaymentMode]];
        [insurence setPaymentMothod:[DataDictionary InsurencepaymentMothod]];
        [insurence setPayUpDate:[DataDictionary InsurencepayUpDate]];
        [insurence setPolicyDate:[DataDictionary InsurencepolicyDate]];
        [insurence setStatus:[DataDictionary Insurencestatus]];
        [insurence setUserId:[DataDictionary InsurenceuserId]];
    }
    return insurence;
}

+(void)LoadInsurenceDataFromServerWithArray:(NSArray *)insurence
                     inManagedObjectContext:(NSManagedObjectContext *)context
{
    for (OcrInsurenceDataObjectModel *dataObject in insurence) {
        [self InsurenceWithDataDictionary:dataObject inManagedObjectContext:context];
    }
}

@end
