//
//  AppDelegate.m
//  Quickpace
//
//  Created by Jonathan Kaufman on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "HistoryViewController.h"
#import "SettingsViewController.h"
#import "Flurry.h"
#import "iRate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize mainViewController = _mainViewController;

+ (void)initialize
{
    //configure iRate ratings pop-up
    [iRate sharedInstance].daysUntilPrompt = 10;
    [iRate sharedInstance].usesUntilPrompt = 10;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.tabBarController = [[UITabBarController alloc] init];
    
    // This programmatic creation of tab bars pattern comes from the non-storyboard tab bar template in Xcode
    UIViewController *viewController1 = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UIViewController *viewController2 = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
    UIViewController *viewController3 = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
	UINavigationController *theNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController2];
    viewController2.navigationItem.title=@"Run History";
    theNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:2];
    theNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    UINavigationController *theSettingNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController3];
    viewController3.navigationItem.title=@"Settings";
    theSettingNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"SettingsGearTab.png"] tag:3];
    theSettingNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, theNavigationController, theSettingNavigationController, nil];
    self.window.rootViewController = self.mainViewController;
    
    self.mainViewController.managedObjectContext = self.managedObjectContext;
    [_window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
    
    // Call a SettingsManager
    SettingsManager *userSettings = [[SettingsManager alloc] init];
    
    // Fire up Flurry (if user permits)
    if ( [[userSettings getUsageDefault] isEqualToString:@"Yes"] )
    {
        [Flurry startSession:@"BHPZGM1XL1R9P7KAGXVY"];
        [Flurry setAge:[[userSettings getAgeDefault] intValue]];
        
        if ([[userSettings getSexDefault] isEqualToString:@"male"]) 
            [Flurry setGender:@"m"];
        else
            [Flurry setGender:@"f"];
    }
    
    // Pull version number from Info plist and put in Settings so it is visible in the Settings.app
    [userSettings saveVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
//    MainViewController *controller = (MainViewController *)self.window.rootViewController;
//    [controller displayWelcome];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Quickpace" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Quickpace.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // Lightweight migration
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        //[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
