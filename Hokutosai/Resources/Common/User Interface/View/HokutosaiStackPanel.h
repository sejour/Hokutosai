//
//  HokutosaiStackPanel.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/20.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

/** スタックパネル */
@interface HokutosaiStackPanel : UIView

/** 垂直方向の間隔 (デフォルト設定) */
@property (nonatomic) CGFloat verticalSpace;

/** 追加するサブビューの横幅をスタックパネルの横幅にフィットさせるかどうか　(デフォルト設定) */
@property (nonatomic) BOOL fitWidth;

/** 
 * サブビューを追加する
 * @param space 垂直方向の間隔
 */
- (void)addSubview:(UIView *)view verticalSpace:(CGFloat)space;

/**
 * サブビューを追加する
 * @param fit 追加するサブビューの横幅をスタックパネルの横幅にフィットさせるかどうか
 */
- (void)addSubview:(UIView *)view fitWidth:(BOOL)fit;

/**
 * サブビューを追加する
 * @param space 垂直方向の間隔
 * @param fit 追加するサブビューの横幅をスタックパネルの横幅にフィットさせるかどうか
 */
- (void)addSubview:(UIView *)view verticalSpace:(CGFloat)space fitWidth:(BOOL)fit;

@end
