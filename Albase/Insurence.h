//
//  Insurence.h
//  Albase
//
//  Created by Mac on 17/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Insurence : NSManagedObject

@property (nonatomic, retain) NSString * addedDate;
@property (nonatomic, retain) NSString * adjustedPremium;
@property (nonatomic, retain) NSString * billToDate;
@property (nonatomic, retain) NSString * insuredAddress;
@property (nonatomic, retain) NSNumber * insurenceID;
@property (nonatomic, retain) NSString * issueAge;
@property (nonatomic, retain) NSString * maturityDate;
@property (nonatomic, retain) NSString * modalPremium;
@property (nonatomic, retain) NSString * nextModalPremium;
@property (nonatomic, retain) NSString * nric;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSString * paidToDate;
@property (nonatomic, retain) NSString * paymentMode;
@property (nonatomic, retain) NSString * paymentMothod;
@property (nonatomic, retain) NSString * payUpDate;
@property (nonatomic, retain) NSString * policyDate;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) Person *person;

@end
