//
//  OCRAppDelegate.m
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRAppDelegate.h"
#import "OCRViewController.h"
#import "SideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "OCRContactListViewController.h"
#import "OCRAddInsuranceViewController.h"
#import "OCRAddAppointmentViewController.h"
#import "OCRDataObjectModel.h"
#import "Person.h"
#import "NotificationCenterStaticParameter.h"
#import "OCRInstractionViewController.h"
#import "GlobalStaticData.h"
#import "OCRAddContactFromOCRViewController.h"
#import "OCRAddAccidentPolicyStepTwoViewController.h"

@implementation OCRAppDelegate

/* Core data objects */

@synthesize managedObjectContext            = __managedObjectContext;
@synthesize managedObjectModel              = __managedObjectModel;
@synthesize persistentStoreCoordinator      = __persistentStoreCoordinator;

/* Core data objects */


@synthesize imageToProcess;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
    /*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    P2MSMapViewController *mapViewC = [[P2MSMapViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController *navCtrl = [[UINavigationController alloc]initWithRootViewController:mapViewC];
    [navCtrl setNavigationBarHidden:YES animated:NO];
    [mapViewC setDefaultLocation:@"My Location" withCoordinate:CLLocationCoordinate2DMake(1.315047,103.764752)];
    mapViewC.mapType = MAP_TYPE_GOOGLE;
    mapViewC.mapAPISource = MAP_API_SOURCE_GOOGLE;
    mapViewC.allowDroppedPin = YES;
    self.window.rootViewController = navCtrl;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
     */
     
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([GlobalClassMetodData isConnectedToInternet]) {
        
        _AppNetworkStatus = NetworkstatusOnline;
        
    } else {
        
        _AppNetworkStatus = NetworkstatusOffline;
        
    }
    
    SideMenuViewController *leftMenuViewController = [[SideMenuViewController alloc] init];
    MFSideMenuContainerViewController *Container;
    
    if (_AppNetworkStatus == NetworkstatusOffline) {
        
        Container = [MFSideMenuContainerViewController containerWithCenterViewController:[self navigationControllerOffline] leftMenuViewController:leftMenuViewController];
        
    } else {
        
        [self AppendDataFromWebservice];
        
        Container = [MFSideMenuContainerViewController containerWithCenterViewController:[self navigationController] leftMenuViewController:leftMenuViewController];
    }
     
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
#ifdef __IPHONE_8_0
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
#endif
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    imageToProcess = [UIImage imageNamed:@"IMG_0360.JPG"];
    self.window.rootViewController = Container;
    [self.window makeKeyAndVisible];
    return YES;
    
    
}

#ifdef __IPHONE_8_0



- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* deviceTokenq = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    /**
     *  call this method if there is internet connection available
     */
    
    if (_AppNetworkStatus != NetworkstatusOffline) {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=SaveDeviceToken&registerddevicetoken=%@",deviceTokenq];
            NSLog(@"URL : %@", url);
            
            NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
            if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if ([[results objectForKey:@"status"] isEqualToString:@"success"]) {
                    NSLog(@"Device token saved");
                } else {
                    NSLog(@"unable to save Device token");
                }
            });
        });
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
    NSLog(@"deviceTokenq Error %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification ---- %@",userInfo);
}

-(void)HandleCoreDataOperation :(OCRUserDataObjectModel *)DataDictionary WithTotaldata:(NSString *)totaldata WithCurrentdata:(int)Currentdata
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSString *unique = [DataDictionary UserId];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        // handle error
    } else if ([matches count]) {
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id like[cd] %@",[DataDictionary UserId]];
        
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:context]];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:request error:&error];
        for (Person *person in result) {
            
            person.dateOfBirth                              =   [DataDictionary DateOfBirth];
            person.firstname                                =   [DataDictionary Firstname];
            person.gender                                   =   [DataDictionary Gender];
            person.id                                       =   [DataDictionary UserId];
            person.lastname                                 =   [DataDictionary Lastname];
            person.useremail                                =   [DataDictionary Usersemail];
            person.userimage                                =   [DataDictionary ProfileImage];
            person.userPhoneNumber                          =   [DataDictionary UserPhoneNumber];
            
        }
        if ([context save:&error]) {
           // NSLog(@"Data Edit Error");
        }
    } else {
        
        Person *person = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Person"
                          inManagedObjectContext:context];
        
        person.dateOfBirth                              =   [DataDictionary DateOfBirth];
        person.firstname                                =   [DataDictionary Firstname];
        person.gender                                   =   [DataDictionary Gender];
        person.id                                       =   [DataDictionary UserId];
        person.lastname                                 =   [DataDictionary Lastname];
        person.useremail                                =   [DataDictionary Usersemail];
        person.userimage                                =   [DataDictionary ProfileImage];
        person.userPhoneNumber                          =   [DataDictionary UserPhoneNumber];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        } else {
            NSLog(@"data saved into databse");
        }
    }
    
    if (Currentdata == [totaldata intValue]) {

        [[NSNotificationCenter defaultCenter] postNotificationName:UserDataDownloadComplete object:nil];
    }
}

-(NSDictionary *)AlluserList
{
    NSLog(@"data Fetch start");
    NSMutableArray *UserListArray = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *Context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:Context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [Context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"data Fetch Error");
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

-(NSString *)CleanTextField:(NSString *)TextfieldName
{
    NSString *Cleanvalue = [TextfieldName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return Cleanvalue;
}

-(void)SetUpTabbarControllerwithcenterView :(UIViewController *)CenterView
{
    
    SideMenuViewController *leftSideMenuController = [[SideMenuViewController alloc] init];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[[UINavigationController alloc] initWithRootViewController:CenterView]
                                                    leftMenuViewController:leftSideMenuController];
    self.window.rootViewController = container;
    
}

- (OCRViewController *)LandingControllerExample {
    return [[OCRViewController alloc] initWithNibName:@"OCRViewController" bundle:nil];
}

- (OCRViewController *)LandingController {
    return [[OCRViewController alloc] initWithNibName:@"OCRViewController" bundle:nil];
}

- (OCRContactListViewController *)LandingControllerOffline {
    return [[OCRContactListViewController alloc] initWithNibName:@"OCRContactListViewController" bundle:nil];
}

- (UINavigationController *)navigationController {
    return [[UINavigationController alloc]
            initWithRootViewController:[self LandingController]];
}

- (UINavigationController *)navigationControllerOffline {
    return [[UINavigationController alloc]
            initWithRootViewController:[self LandingControllerOffline]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

/*
 Core data methods start
 */

-(void)AppendDataFromWebservice
{
    __block OCRUserDataObjectModel *UserDataObjectModel = nil;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSString *url=[NSString stringWithFormat:@"http://myphpdevelopers.com/dev/ocrscanner/webservice.php?rquest=getAllUser"];
        NSLog(@"URL : %@", url);
        
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
        if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if([[results objectForKey:@"status"] isEqualToString:@"success"])
            {
                int i = 0;
                for (id MyBirthday in [results objectForKey:@"userdata"]) {
                    
                    UserDataObjectModel = [[OCRUserDataObjectModel alloc] initWithFirstname:[MyBirthday objectForKey:@"Firstname"] Lastname:[MyBirthday objectForKey:@"Lastname"] DateOfBirth:[MyBirthday objectForKey:@"DateOfBirth"] UserPhoneNumber:[MyBirthday objectForKey:@"UserPhoneNumber"] Usersemail:[MyBirthday objectForKey:@"Useremail"] Gender:[MyBirthday objectForKey:@"Gender"] ProfileImage:@"" UserId:[MyBirthday objectForKey:@"userID"]];
                    i++;
                    [self HandleCoreDataOperation:UserDataObjectModel WithTotaldata:[results objectForKey:@"totaldata"] WithCurrentdata:i];
                }
            }
        });
    });
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AlbaseModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSURL *)applicationDocumentsDirectory {

    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AlbaseModel.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } else {
        NSLog(@"data saved");
    }
    return __persistentStoreCoordinator;
}
- (NSManagedObjectContext *)managedObjectContext {

    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    return __managedObjectContext;
}

/*
 SQlite methods end
 */


@end
