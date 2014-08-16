//
//  HokutosaiUIUtility.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/16.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// ユーザーインタフェースの各機能を提供する
@interface HokutosaiUIUtility : NSObject

// ステータスバーの高さを取得する
+ (CGFloat)statusBarHeight;

// ナビゲーションバーの高さを取得する
+ (CGFloat)navigationBarHeight:(UIViewController*)viewController;

// タブバーの高さを取得する
+ (CGFloat)tabBarHeight:(UIViewController*)viewController;

// 画面上のビューを配置できる領域の高さを取得する
+ (CGFloat)screenHeight;

// フルスクリーンのスクロールビューのインセットを設定する
+ (void)setInsetsOfContentScrollViewForFullScreen:(UIScrollView*) scrollView viewController:(UIViewController*)viewController;

// フルスクリーンのテーブルビューのインセットを設定する
+ (void)setInsetsOfTableViewForFullScreen:(UITableView*) tableView viewController:(UIViewController*)viewController;

// ボトム配置のテーブルビューのインセットを設定する
+ (void)setInsetsOfTableViewForBottomArrange:(UITableView *)tableView viewController:(UIViewController *)viewController;

// 指定したUIViewの全てのサブビューを削除する
+ (void)removeAllSubviews:(UIView*)view;

@end
