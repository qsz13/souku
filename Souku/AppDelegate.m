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
#import "CommonUtility.h"

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
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar"]];
    
    
    

    [[UITabBar appearance] setSelectionIndicatorImage:[CommonUtility imageWithImage:[UIImage imageNamed:@"tabbarSelected"] scaledToSize:CGSizeMake(self.tabBarController.tabBar.frame.size.width/4, self.tabBarController.tabBar.frame.size.height)]];
    

    
    CGFloat tabIconHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat tabIconWidth = self.tabBarController.tabBar.frame.size.width;
    
    
    
    UINavigationController* homeNavigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:homeViewController];
    UIImage *homeIcon = [CommonUtility imageWithImage:[UIImage imageNamed:@"homeIcon" ] scaledToSize:CGSizeMake(tabIconWidth/10, tabIconHeight/2)];
    [homeNavigationController.tabBarItem setFinishedSelectedImage:homeIcon withFinishedUnselectedImage:homeIcon];
    
    
    UINavigationController* aroundNavigationController = [[UINavigationController alloc]
                                             initWithRootViewController:aroundViewController];
    UIImage *aroundIcon = [CommonUtility imageWithImage:[UIImage imageNamed:@"aroundIcon" ] scaledToSize:CGSizeMake(tabIconWidth/11, tabIconHeight/1.8)];
    [aroundNavigationController.tabBarItem setFinishedSelectedImage:aroundIcon withFinishedUnselectedImage:aroundIcon];

    
    
    UINavigationController* favouriteNavigationController = [[UINavigationController alloc] initWithRootViewController:favouriteViewController];
    UIImage *favouriteIcon = [CommonUtility imageWithImage:[UIImage imageNamed:@"favouriteIcon" ] scaledToSize:CGSizeMake(tabIconWidth/11, tabIconHeight/1.8)];
    [favouriteNavigationController.tabBarItem setFinishedSelectedImage:favouriteIcon withFinishedUnselectedImage:favouriteIcon];
    
    
    UINavigationController* settingNavigationController = [[UINavigationController alloc] initWithRootViewController: settingViewController];
    UIImage *settingIcon = [CommonUtility imageWithImage:[UIImage imageNamed:@"settingIcon" ] scaledToSize:CGSizeMake(tabIconWidth/11, tabIconHeight/1.8)];
    [settingNavigationController.tabBarItem setFinishedSelectedImage:settingIcon withFinishedUnselectedImage:settingIcon];
    
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        UITextAttributeTextColor: [UIColor whiteColor],
                                                        UITextAttributeTextShadowColor: [UIColor clearColor],
                                                        UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                        UITextAttributeFont: [UIFont fontWithName:@"Helvetica-Bold" size:10.0],
                                                        }forState:UIControlStateNormal];

    
    
    
     
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBar"]  forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            UITextAttributeTextColor: [UIColor whiteColor],
                                                            UITextAttributeTextShadowColor: [UIColor clearColor],
                                                            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                            UITextAttributeFont: [UIFont fontWithName:@"Helvetica-Bold" size:20.0],
                                                            }];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           UITextAttributeTextColor: [UIColor whiteColor],
                                                           UITextAttributeTextShadowColor: [UIColor clearColor],
                                                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                           UITextAttributeFont: [UIFont fontWithName:@"Helvetica-Bold" size:20.0],
                                                           } forState:UIControlStateNormal];
    
    
    
    self.tabBarController.viewControllers = @[homeNavigationController, aroundNavigationController, favouriteNavigationController, settingNavigationController];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    UIImage *backButtonImage = [CommonUtility imageWithImage:[UIImage imageNamed:@"backButton"] scaledToSize:CGSizeMake(100, self.tabBarController.tabBar.frame.size.height*0.6)];
    if ([UINavigationBar instancesRespondToSelector:@selector(setBackIndicatorImage:)]) {
        [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
    } else {
        
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[backButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    
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
