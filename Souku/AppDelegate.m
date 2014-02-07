//
//  AppDelegate.m
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "AppDelegate.h"
#import "APIKey.h"
#import <MAMapKit/MAMapKit.h>
#import "HomeViewController.h"
#import "AroundViewController.h"
#import "FavouriteViewController.h"
#import "SettingViewController.h"

@implementation AppDelegate

- (void)configureAPIKey
{
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureAPIKey];
    
    UIViewController *homeViewController = [[HomeViewController alloc] init];
    UIViewController *aroundViewController = [[AroundViewController alloc] init];
    UIViewController *favouriteViewController = [[FavouriteViewController alloc] init];
    UIViewController *settingViewController = [[SettingViewController alloc] init];
    
    self.tabBarController = [[UITabBarController alloc] init];
    
    UINavigationController* homeNavigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:homeViewController];
    UINavigationController* aroundNavigationController = [[UINavigationController alloc]
                                             initWithRootViewController:aroundViewController];
    UINavigationController* favouriteNavigationController = [[UINavigationController alloc] initWithRootViewController:favouriteViewController];
    UINavigationController* settingNavigationController = [[UINavigationController alloc] initWithRootViewController: settingViewController];
    
    self.tabBarController.viewControllers = @[homeNavigationController, aroundNavigationController, favouriteNavigationController, settingNavigationController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
