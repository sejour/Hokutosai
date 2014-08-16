//
//  HokutosaiAppDelegate.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiAppDelegate.h"
#import "HokutosaiViewControllerProtocol.h"
#import "HokutosaiUIUtility.h"
#import "HokutosaiUIColor.h"
#import "HokutosaiNewsViewController.h"
#import "HokutosaiSchedulesViewController.h"

@interface HokutosaiAppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarController;
@end

@implementation HokutosaiAppDelegate

// アプリケーションが起動するとき
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // タブバーコントローラーを取得
    _tabBarController = (UITabBarController*)_window.rootViewController;
    
    // デリゲート設定
    _tabBarController.delegate = self;
    
    // タブバーアイコンの選択時のカラーを設定
    [[UITabBar appearance] setTintColor:[HokutosaiUIColor hokutosaiColor]];
    
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

// アプリケーションが復帰したとき
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // ニュースのコンテンツを更新
    UINavigationController *newsViewNavigationController = _tabBarController.childViewControllers[0];
    HokutosaiNewsViewController *newsTopViewController = (HokutosaiNewsViewController*)newsViewNavigationController.viewControllers[0];
    [newsTopViewController updateContents];
    
    // スケジュールの状態を更新
    UINavigationController *eventsViewNavigationController = _tabBarController.childViewControllers[1];
    HokutosaiSchedulesViewController *eventsTopViewController = (HokutosaiSchedulesViewController*)eventsViewNavigationController.viewControllers[0];
    [eventsTopViewController updateSchedulesViewController];
}

// アプリケーションがアクティブになるとき
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// ステータスバーの高さが変わったとき
- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
{
    CGFloat statusBarOldHeight = oldStatusBarFrame.size.height;
    CGFloat statusBarNewHeight = [HokutosaiUIUtility statusBarHeight];
    CGFloat screenHeight = [HokutosaiUIUtility screenHeight];
    
    // 全てのビューコントローラーに対してステータスバーの高さが変わったことを通知する
    for (UINavigationController *navigationController in _tabBarController.childViewControllers) {
        for (id<HokutosaiViewControllerProtocol> viewController in navigationController.viewControllers) {
            [viewController changedStatusBarHeightFrom:statusBarOldHeight to:statusBarNewHeight screenHeight:screenHeight];
        }
    }
}

@end
