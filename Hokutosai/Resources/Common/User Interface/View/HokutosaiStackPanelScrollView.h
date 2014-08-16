//
//  HokutosaiStackPanelScrollView.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/21.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HokutosaiStackPanelScrollView : UIScrollView

// パネルの水平方向のサイズ
@property (nonatomic, readonly, getter = getWidthOfPanel) CGFloat widthOfPanel;

// パネルのフレーム
@property (nonatomic, readonly, getter = getFrameOfPanel) CGRect frameOfPanel;

// パネルの水平方向の余白を設定する
- (void)setPanelHorizonMargine:(CGFloat)horizonMargine;

// パネルの水平方向の余白を設定する
- (void)setPanelLeftMargine:(CGFloat)leftMargine rightMargine:(CGFloat)rightMargine;

// パネルの垂直方向の余白を設定する
- (void)setPanelVerticalMargine:(CGFloat)verticalMargine;

// パネルの垂直方向の余白を設定する
- (void)setPanelTopMargine:(CGFloat)topMargine bottomMargine:(CGFloat)bottomMargine;

// パネルの水平方向の余白と垂直方向の余白を設定する
- (void)setPanelHorizonMargine:(CGFloat)horizonMargine verticalMargine:(CGFloat)verticalMargine;

// パネルの四方向の余白を設定する
- (void)setPanelTopMargine:(CGFloat)topMargine rightMargine:(CGFloat)rightMargine bottomMargine:(CGFloat)bottomMargine leftMargine:(CGFloat)leftMargine;

// コンテントの垂直方向のデフォルトの間隔を設定する
- (void)setContentVerticalSpace:(CGFloat)space;
// コンテントをスクロールビューの横幅にフィットさせるかを設定する
- (void)setContentFitWidth:(BOOL)fit;

// コンテントとなるサブビューを追加する
- (void)addContentSubview:(UIView*)view;
// コンテントとなるサブビューを追加する
- (void)addContentSubview:(UIView*)view verticalSpace:(CGFloat)space;
// コンテントとなるサブビューを追加する
- (void)addContentSubview:(UIView*)view fitWidth:(BOOL)fit;
// コンテントとなるサブビューを追加する
- (void)addContentSubview:(UIView*)view verticalSpace:(CGFloat)space fitWhidth:(BOOL)fit;

// フルスクリーンに対応するためにインセットを設定する
- (void)setScrollInsetForFullScreen:(UIViewController*)controller;

@end
