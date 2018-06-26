//
//  AppDelegate.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LeftSlideViewController.h"
#import "DashBoardViewController_iphone.h"
#import "LeftSortsViewController.h"
#import "ShiftDetailViewController_iphone.h"

#import <AWSCore.h>
#import <AWSSNS/AWSSNS.h>
#import "Constants.h"

#import <LocalAuthentication/LocalAuthentication.h>
#import <AWSMobileAnalytics/AWSMobileAnalytics.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

#include <sys/types.h>
#include <sys/sysctl.h>

@class CurrentWorkPlace;
@class CurrentEmployee;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate,MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CurrentWorkPlace *currentWorkplace;
@property (strong, nonatomic) CurrentEmployee *currentEmployee;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong ,nonatomic) UINavigationController *rootNaviContor;
@property (strong ,nonatomic) DashBoardViewController_iphone *rootController_iphone;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,strong) MFMailComposeViewController *appMailController;
@property (nonatomic,strong) MFMailComposeViewController *appMailController2;
@property (nonatomic,strong) CNContactPickerViewController *contactPeoplePickerVc;

- (NSURL *)applicationDocumentsDirectory;

-(void) sendFeedBackEmail:(id<MFMailComposeViewControllerDelegate>)delegate;
-(void) callPhoneNumber:(NSString *) phonenumber;
-(void) showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body;
-(void) sendEmail:(id<MFMailComposeViewControllerDelegate>)delegate andToEmail:(NSArray *) arr_email;

- (void)saveContext;


@end

