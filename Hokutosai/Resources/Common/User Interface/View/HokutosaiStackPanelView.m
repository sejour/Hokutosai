//
//  HokutosaiStackPanelView.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/29.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiStackPanelView.h"
#import "HokutosaiStackPanel.h"

@interface HokutosaiStackPanelView ()
{
    // スタックパネル
    HokutosaiStackPanel *_stackPanel;
}

- (void)initHokutosaiStackPanelView;
- (void)updateFrame;
- (void)updateFrameOfSelf;
@end

@implementation HokutosaiStackPanelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initHokutosaiStackPanelView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initHokutosaiStackPanelView];
    }
    return  self;
}

- (void)initHokutosaiStackPanelView
{
    // 余白
    _topPadding = 10.0;
    _bottomPadding = 10.0;
    _leftPadding = 20.0;
    _rightPadding = 20.0;
    
    // スタックパネル生成
    CGRect frameOfStackPanel;
    frameOfStackPanel.origin = CGPointMake(_leftPadding, _topPadding);
    frameOfStackPanel.size = CGSizeMake(self.frame.size.width - (_leftPadding + _rightPadding), 0.0);
    _stackPanel = [[HokutosaiStackPanel alloc] initWithFrame:frameOfStackPanel];
    [super addSubview:_stackPanel];
}

- (void)setSubviewVerticalSpace:(CGFloat)subviewVerticalSpace
{
    [_stackPanel setVerticalSpace:subviewVerticalSpace];
}

- (CGFloat)getSubviewVerticalSpace
{
    return _stackPanel.verticalSpace;
}

- (void)setSubViewFitWidth:(BOOL)subviewFitWidth
{
    [_stackPanel setFitWidth:subviewFitWidth];
}

- (BOOL)getSubviewFitWidth
{
    return _stackPanel.fitWidth;
}

- (CGFloat)getWidthOfStackPanel
{
    return _stackPanel.frame.size.width;
}

- (CGFloat)getHeightOfStackPanel
{
    return _stackPanel.frame.size.height;
}

- (CGRect)getFrameOfStackPanel
{
    return _stackPanel.frame;
}

/** 内部のスタックパネルに対する水平方向の余白を設定する */
- (void)setHorizonPadding:(CGFloat)horizonPadding
{
    _leftPadding = horizonPadding;
    _rightPadding = horizonPadding;
    
    [self updateFrame];
}

/** 内部のスタックパネルに対する水平方向の余白を設定する */
- (void)setLeftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding
{
    _leftPadding = leftPadding;
    _rightPadding = rightPadding;
    
    [self updateFrame];
}

/** 内部のスタックパネルに対する垂直方向の余白を設定する */
- (void)setVerticalPadding:(CGFloat)verticalPadding
{
    _topPadding = verticalPadding;
    _bottomPadding = verticalPadding;
    
    [self updateFrame];
}

/** 内部のスタックパネルに対する垂直方向の余白を設定する */
- (void)setTopPadding:(CGFloat)topPadding bottomPadding:(CGFloat)bottomPadding
{
    _topPadding = topPadding;
    _bottomPadding = bottomPadding;
    
    [self updateFrame];
}

/** 内部のスタックパネルに対する水平方向の余白と垂直方向の余白を設定する */
- (void)setHorizonPadding:(CGFloat)horizonMargine verticalPadding:(CGFloat)verticalPadding
{
    _leftPadding = horizonMargine;
    _rightPadding = horizonMargine;
    _topPadding = verticalPadding;
    _bottomPadding = verticalPadding;
    
    [self updateFrame];
}

/** 内部のスタックパネルに対する四方向の余白を設定する */
- (void)setTopPadding:(CGFloat)topPadding rightPadding:(CGFloat)rightPadding bottomPadding:(CGFloat)bottomPadding leftPadding:(CGFloat)leftPadding
{
    _topPadding = topPadding;
    _rightPadding = rightPadding;
    _bottomPadding = bottomPadding;
    _leftPadding = leftPadding;
    
    [self updateFrame];
}

// コンテントとなるサブビューを追加する
- (void)addSubview:(UIView*)view
{
    [_stackPanel addSubview:view];
    
    // 自身のフレーム更新
    [self updateFrameOfSelf];
}

// コンテントとなるサブビューを追加する
- (void)addSubview:(UIView *)view verticalSpace:(CGFloat)space
{
    [_stackPanel addSubview:view verticalSpace:space];
    
    // 自身のフレーム更新
    [self updateFrameOfSelf];
}

// コンテントとなるサブビューを追加する
- (void)addSubview:(UIView*)view fitWidth:(BOOL)fit
{
    [_stackPanel addSubview:view fitWidth:fit];
    
    // 自身のフレーム更新
    [self updateFrameOfSelf];
}

// コンテントとなるサブビューを追加する
- (void)addSubview:(UIView*)view verticalSpace:(CGFloat)space fitWidth:(BOOL)fit
{
    [_stackPanel addSubview:view verticalSpace:space fitWidth:fit];
    
    // 自身のフレーム更新
    [self updateFrameOfSelf];
}

// フレームを更新する
- (void)updateFrame
{
    // スタックパネルのフレーム更新
    CGRect frameOfStackPanel;
    frameOfStackPanel.origin = CGPointMake(_leftPadding, _topPadding);
    frameOfStackPanel.size = CGSizeMake(self.frame.size.width - (_leftPadding + _rightPadding), _stackPanel.frame.size.height);
    
    _stackPanel.frame = frameOfStackPanel;
    
    // 自身のフレームを更新
    [self updateFrameOfSelf];
}

// 自身のフレームのみ更新する
- (void)updateFrameOfSelf
{
    CGRect frameOfSelf;
    frameOfSelf.origin = self.frame.origin;
    frameOfSelf.size = CGSizeMake(self.frame.size.width, _topPadding + _stackPanel.frame.size.height + _bottomPadding);
    
    self.frame = frameOfSelf;
}

@end
