//
//  Person.h
//  Albase
//
//  Created by Mac on 17/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * dateOfBirth;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * useremail;
@property (nonatomic, retain) NSString * userimage;
@property (nonatomic, retain) NSString * userPhoneNumber;
@property (nonatomic, retain) NSSet *personInsurence;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addPersonInsurenceObject:(NSManagedObject *)value;
- (void)removePersonInsurenceObject:(NSManagedObject *)value;
- (void)addPersonInsurence:(NSSet *)values;
- (void)removePersonInsurence:(NSSet *)values;

@end
