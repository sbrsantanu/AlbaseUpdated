//
//  OCRAppDelegate+ManageObjectContext.h
//  Albase
//
//  Created by Mac on 17/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRAppDelegate.h"

@interface OCRAppDelegate (ManageObjectContext)

- (void)saveContext:(NSManagedObjectContext *)managedObjectContext;

- (NSManagedObjectContext *)createMainQueueManagedObjectContext;

@end
