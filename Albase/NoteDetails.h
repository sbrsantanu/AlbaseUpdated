//
//  NoteDetails.h
//  Albase
//
//  Created by Mac on 19/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NoteDetails : NSManagedObject

@property (nonatomic, retain) NSString * noteid;
@property (nonatomic, retain) NSString * addedon;
@property (nonatomic, retain) NSString * notestatus;
@property (nonatomic, retain) NSString * notedetails;

@end
