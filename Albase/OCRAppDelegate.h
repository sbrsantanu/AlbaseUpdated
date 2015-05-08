//
//  OCRAppDelegate.h
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "OCRAddAccidentPolicyStepOneViewController.h"

typedef enum {
    NetworkstatusOnline,
    NetworkstatusOffline
} NetworkStatus;

typedef enum {
    ScanTypeLifePolicy,
    ScanTypePersonalAccidentPolicy
} LifeinsurenceScanType;

@interface OCRAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSString *element;
}

/* Core Data Properties Starts with methods */

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (assign) LifeinsurenceScanType InsurenceScanType;
@property (assign) NetworkStatus AppNetworkStatus;

- (void)saveContext;
- (NSDictionary *)AlluserList;
- (NSURL *)applicationDocumentsDirectory;
- (BOOL)isConnectedToInternet;

/* Core Data Properties Ends with methods */

@property (strong, nonatomic) UIImage* imageToProcess;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *NavigationController;
-(void)SetUpTabbarControllerwithcenterView :(UIViewController *)CenterView;

@end
