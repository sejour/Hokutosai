//
//  HokutosaiUIUtility.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/16.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiUIUtility.h"

// デフォルトのステータスバーの高さ
static const CGFloat defaultStatusBarHeight = 20.0;

@implementation HokutosaiUIUtility

// ステータスバーの高さを取得する
+ (CGFloat)statusBarHeight
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

+ (CGFloat)navigationBarHeight:(UIViewController*)viewController
{
    return viewController.navigationController.toolbar.frame.size.height + defaultStatusBarHeight;
}

+ (CGFloat)tabBarHeight:(UIViewController *)viewController
{
    return viewController.tabBarController.rotatingFooterView.frame.size.height;
}

+ (CGFloat)screenHeight;
{
    return [[UIScreen mainScreen] applicationFrame].size.height + defaultStatusBarHeight;
}

+ (void)setInsetsOfContentScrollViewForFullScreen:(UIScrollView *)scrollView viewController:(UIViewController *)viewController
{
    // ヘッダの高さを取得
    CGFloat headerHeight = [HokutosaiUIUtility navigationBarHeight:viewController];
    
    // フッターの高さを取得
    CGFloat footerHeight = [HokutosaiUIUtility tabBarHeight:viewController];
    
    // インセットを設定
    scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, headerHeight + footerHeight, 0.0);
    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(headerHeight, 0.0, footerHeight, 0.0);
}

+ (void)setInsetsOfTableViewForFullScreen:(UITableView *)tableView viewController:(UIViewController *)viewController
{
    // ヘッダの高さを取得
    CGFloat headerHeight = [HokutosaiUIUtility navigationBarHeight:viewController];
    // フッタの高さを取得
    CGFloat footerHeight = [HokutosaiUIUtility tabBarHeight:viewController];
    // エッジインセットを生成
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(headerHeight, 0.0, footerHeight, 0.0);
    // インセットを設定
    tableView.contentInset = edgeInsets;
    tableView.scrollIndicatorInsets = edgeInsets;
}

+ (void)setInsetsOfTableViewForBottomArrange:(UITableView *)tableView viewController:(UIViewController *)viewController
{
    // フッタの高さを取得
    CGFloat footerHeight = [HokutosaiUIUtility tabBarHeight:viewController];
    // エッジインセットを生成
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0, 0.0, footerHeight, 0.0);
    // インセットを設定
    tableView.contentInset = edgeInsets;
    tableView.scrollIndicatorInsets = edgeInsets;
}

+ (void)removeAllSubviews:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
}

@end
