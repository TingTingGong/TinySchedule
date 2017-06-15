//
//  AppDelegate.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "AppDelegate.h"

#import "RMPhoneFormat.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize rootNaviContor;
@synthesize rootController_iphone;

@synthesize currentWorkplace;
@synthesize currentEmployee;

@synthesize appMailController;
@synthesize appMailController2;
@synthesize contactPeoplePickerVc;

-(UINavigationController *)rootNaviContor
{
    if (rootNaviContor == nil)
    {
        rootNaviContor = [[UINavigationController alloc] initWithRootViewController:self.rootController_iphone];
    }
    return rootNaviContor;
}
-(DashBoardViewController_iphone *)rootController_iphone
{
    if (rootController_iphone == nil)
    {
        rootController_iphone = [[DashBoardViewController_iphone alloc] initWithNibName:@"DashBoardViewController_iphone" bundle:nil];
    }
    return rootController_iphone;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]/*如果不是第二次使用*/)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];//设置第二次使用的value值为yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];//设置第一次使用的value值为yes
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    //注册AWS
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:CognitoRegionType identityPoolId:CognitoIdentityPoolId];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:DefaultServiceRegionType credentialsProvider:credentialsProvider];
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    
    
    //Google Maps
    [GMSServices provideAPIKey:GoogleMapApiKey];
    [GMSPlacesClient provideAPIKey:GoogleMapApiKey];
    
    [self getCurrntEmployeeAndWorkPlace];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
    self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.rootNaviContor];
    self.window.rootViewController = self.LeftSlideVC;

    [[UINavigationBar appearance] setBarTintColor:AppMainColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    return YES;
}


-(MFMailComposeViewController *)appMailController
{
    if (appMailController == nil)
    {
        appMailController = [[MFMailComposeViewController alloc] init];
        [appMailController.navigationBar setTintColor:[UIColor whiteColor]];
        appMailController2.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]};
    }
    
    return appMailController;
}

-(MFMailComposeViewController *)appMailController2
{
    if (appMailController2 == nil)
    {
        appMailController2 = [[MFMailComposeViewController alloc] init];
        [appMailController2.navigationBar setTintColor:[UIColor whiteColor]];
        appMailController2.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]};
    }
    
    return appMailController2;
}
-(CNContactPickerViewController *) contactPeoplePickerVc
{
    if (contactPeoplePickerVc == nil) {
        contactPeoplePickerVc = [[CNContactPickerViewController alloc] init];
        contactPeoplePickerVc.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]};
    }
    return contactPeoplePickerVc;
}

-(void) sendFeedBackEmail:(id<MFMailComposeViewControllerDelegate>)delegate
{
    appMailController = nil;
    NSString * versionStr = [NSString stringWithFormat:@"App:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString * deviceTypeVersion = [NSString stringWithFormat:@"%@:%@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
    NSString *plamfort = [NSString stringWithFormat:@"DEVICE:%@",[self platformString]];
    NSString *feedStr = [NSString stringWithFormat:@"Feedback here:"];
    NSString *mailBody = [NSString stringWithFormat:@"<html><body>%@ %@ %@<br/>%@<br/></body></html>", versionStr,deviceTypeVersion,plamfort,feedStr];
    [self.appMailController setToRecipients:[NSArray arrayWithObject:@"tingting.gong@appxy.com"]];
    [self.appMailController setSubject:InternationalL(@"Tiny Schedule Feedback")];
    [self.appMailController setMessageBody:mailBody isHTML:YES];
    self.appMailController.mailComposeDelegate = delegate;
    [[UINavigationBar appearance] setTintColor:AppMainColor];
}

-(void) callPhoneNumber:(NSString *) phonenumber
{
    NSString *number = [phonenumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    UIWebView * callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if([MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        //controller.body = body;
        controller.messageComposeDelegate = self;
        [self.rootController_iphone presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];
    }
}

-(void) sendEmail:(id<MFMailComposeViewControllerDelegate>)delegate andToEmail:(NSArray *) arr_email
{
    appMailController2 = nil;
    [self.appMailController2 setToRecipients:arr_email];
    self.appMailController2.mailComposeDelegate = delegate;
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self.rootController_iphone dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}

#pragma notification

-(void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 2;
    
    if (self.currentEmployee != nil && self.currentWorkplace != nil) {
        NSLog(@"");
    }
    //根据当前登陆的用户判断，是否在休息期间，是否打开了相应分类的提醒通知,并且是在currentemployee和currentworkplace都不为nil的情况下
    
    UNNotificationContent *content = notification.request.content;
    NSLog(@"%@",content.title);
    NSLog(@"%@",content.subtitle);
    NSLog(@"%@",content.body);
    NSLog(@"%@",content.categoryIdentifier);
    UNNotificationRequest *request = notification.request;
    NSLog(@"%@",request.identifier);
    if ([content.title isEqualToString:@"Apple"]) {
        
        completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
    }
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    
    //根据identifier去获取相应类别的数据，并跳到指定页面
    
    //NSDictionary *userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request;
    NSLog(@"%@",request.identifier);
}

#pragma mark -
#pragma mark UIDevice Extensions
-(NSString*)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString* platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}


-(NSString*)platformString
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    return platform;
}

- (void) getCurrntEmployeeAndWorkPlace
{
    NSManagedObjectContext *context2 = [self managedObjectContext];
    NSError *errors = nil;
    if (self.currentEmployee == nil) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"CurrentEmployee" inManagedObjectContext:context2];
        [request setEntity:entityDesc];
        NSArray *objects = [context2 executeFetchRequest:request error:&errors];
        if ([objects count] != 0)
        {
            self.currentEmployee = [objects objectAtIndex:0];
        }
    }
    if (self.currentWorkplace == nil) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"CurrentWorkPlace" inManagedObjectContext:context2];
        [request setEntity:entityDesc];
        NSArray *objects = [context2 executeFetchRequest:request error:&errors];
        if ([objects count] != 0)
        {
            self.currentWorkplace = [objects objectAtIndex:0];
        }
    }
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //application.applicationIconBadgeNumber = 0;
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
//    __block BOOL isTake = YES;
//    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    if (appDelegate.currentWorkplace.uuid != nil) {
//        
//        AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
//        AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
//        //同步数据表
//        queryExpression.scanIndexForward = 0;
//        queryExpression.indexName = @"CurrentWorkPlaceAllData-Index";
//        queryExpression.keyConditionExpression = [NSString stringWithFormat:@"parentUuid = :PUUID"];
//        queryExpression.expressionAttributeValues = @{@":PUUID" : appDelegate.currentWorkplace.uuid};
//        [[dynamoDBObjectMapper query:[DDBDataModel class] expression:queryExpression] continueWithBlock:^id(AWSTask *task) {
//            if (task.error) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                });
//            }
//            else
//            {
//                AWSDynamoDBPaginatedOutput *output = task.result;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSArray *arr = output.items;
//                    
//                    isTake = [DynamoDBManager dynamodbDataSaveToLocal:arr];
//                    
//                    if (isTake == NO) {
//                        KnowledgeShiftViewController_iphone *know = [KnowledgeShiftViewController_iphone new];
//                        [appDelegate.rootController_iphone presentViewController:know animated:YES completion:nil];
//                    }
//                });
//            }
//            return nil;
//        }];
//    }
//
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "TinyWorks-Dev.TinySchedule" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TinySchedule" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TinySchedule.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
