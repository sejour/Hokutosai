//
//  HokutosaiStackPanelView.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/29.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 内部の余白が設定可能なスタックパネル */
@interface HokutosaiStackPanelView : UIView

/** 内部のスタックパネルに対する上部の余白 */
@property (nonatomic, readonly) CGFloat topPadding;
/** 内部のスタックパネルに対する下部の余白 */
@property (nonatomic, readonly) CGFloat bottomPadding;
/** 内部のスタックパネルに対する左部の余白 */
@property (nonatomic, readonly) CGFloat leftPadding;
/** 内部のスタックパネルに対する右部の余白 */
@property (nonatomic, readonly) CGFloat rightPadding;

/** サブビューの垂直方向の間隔 (デフォルト設定) */
@property (nonatomic, setter = setSubviewVerticalSpace:, getter = getSubviewVerticalSpace) CGFloat subviewVerticalSpace;
/** 追加するサブビューの横幅をスタックパネルの横幅にフィットさせるかどうか　(デフォルト設定) */
@property (nonatomic, setter = setSubViewFitWidth:, getter = getSubviewFitWidth) BOOL subviewFitWidth;

/** 内部のスタックパネルの水平方向のサイズ */
@property (nonatomic, readonly, getter = getWidthOfStackPanel) CGFloat widthOfStackPanel;
/** 内部のスタックパネルの垂直方向のサイズ */
@property (nonatomic, readonly, getter = getHeightOfStackPanel) CGFloat heightOfStackPanel;
/** 内部のスタックパネルのフレーム */
@property (nonatomic, readonly, getter = getFrameOfStackPanel) CGRect frameOfStackPanel;

/** 内部のスタックパネルに対する水平方向の余白を設定する */
- (void)setHorizonPadding:(CGFloat)horizonPadding;

/** 内部のスタックパネルに対する水平方向の余白を設定する */
- (void)setLeftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding;

/** 内部のスタックパネルに対する垂直方向の余白を設定する */
- (void)setVerticalPadding:(CGFloat)verticalPadding;

/** 内部のスタックパネルに対する垂直方向の余白を設定する */
- (void)setTopPadding:(CGFloat)topPadding bottomPadding:(CGFloat)bottomPadding;

/** 内部のスタックパネルに対する水平方向の余白と垂直方向の余白を設定する */
- (void)setHorizonPadding:(CGFloat)horizonMargine verticalPadding:(CGFloat)verticalPadding;

/** 内部のスタックパネルに対する四方向の余白を設定する */
- (void)setTopPadding:(CGFloat)topPadding rightPadding:(CGFloat)rightPadding bottomPadding:(CGFloat)bottomPadding leftPadding:(CGFloat)leftPadding;

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
