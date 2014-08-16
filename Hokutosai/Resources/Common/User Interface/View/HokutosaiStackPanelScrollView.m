//
//  HokutosaiStackPanelScrollView.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/21.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiStackPanelScrollView.h"
#import "HokutosaiStackPanel.h"
#import "HokutosaiUIUtility.h"

static const CGFloat HeaderHeight = 64;

@interface HokutosaiStackPanelScrollView ()
{
    // コンテントビュー (スタックパネル)
    HokutosaiStackPanel *_contentView;
    
    // 上部の余白
    CGFloat _topMargine;
    // 下部の余白
    CGFloat _bottomMargine;
}

- (void)initHokutosaiStackPanelScrollView;
@end

@implementation HokutosaiStackPanelScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initHokutosaiStackPanelScrollView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initHokutosaiStackPanelScrollView];
    }
    return  self;
}

- (void)initHokutosaiStackPanelScrollView
{
    _topMargine = 15.0;
    _bottomMargine = 20.0;
    
    // フレーム生成
    CGRect contentViewFrame;
    contentViewFrame.origin = CGPointMake(self.frame.origin.x + 20.0, self.frame.origin.y + HeaderHeight + _topMargine);
    contentViewFrame.size = CGSizeMake(self.frame.size.width - 40.0, self.frame.size.height);
    
    // コンテントビュー生成
    _contentView = [[HokutosaiStackPanel alloc] initWithFrame:contentViewFrame];
    [self addSubview:_contentView];
    
    // コンテントサイズ設定
    self.contentSize = CGSizeMake(self.frame.size.width, _contentView.frame.size.height + _topMargine + _bottomMargine);
}

- (CGFloat)getWidthOfPanel
{
    return _contentView.frame.size.width;
}

- (CGRect)getFrameOfPanel
{
    return _contentView.frame;
}

// パネルの水平方向の余白を設定する
- (void)setPanelHorizonMargine:(CGFloat)horizonMargine
{
    CGRect newContentFrame;
    newContentFrame.origin = CGPointMake(horizonMargine, _contentView.frame.origin.y);
    newContentFrame.size = CGSizeMake(self.frame.size.width - (horizonMargine * 2), _contentView.frame.size.height);
    _contentView.frame = newContentFrame;
}

- (void)setPanelLeftMargine:(CGFloat)leftMargine rightMargine:(CGFloat)rightMargine
{
    CGRect newContentFrame;
    newContentFrame.origin = CGPointMake(leftMargine, _contentView.frame.origin.y);
    newContentFrame.size = CGSizeMake(self.frame.size.width - (leftMargine + rightMargine), _contentView.frame.size.height);
    _contentView.frame = newContentFrame;
}

// パネルの垂直方向の余白を設定する
- (void)setPanelVerticalMargine:(CGFloat)verticalMargine
{
    // 垂直余白更新
    _topMargine = verticalMargine;
    _bottomMargine = verticalMargine;
    
    // フレーム更新
    CGRect newContentFrame;
    newContentFrame.origin = CGPointMake(_contentView.frame.origin.x, self.frame.origin.y + HeaderHeight + _topMargine);
    newContentFrame.size = _contentView.frame.size;
    _contentView.frame = newContentFrame;
    
    // コンテントサイズを更新
    CGFloat newContentHeight = _contentView.frame.size.height + _topMargine + _bottomMargine;
    self.contentSize = CGSizeMake(self.contentSize.width, newContentHeight);
}

- (void)setPanelTopMargine:(CGFloat)topMargine bottomMargine:(CGFloat)bottomMargine
{
    // 垂直余白更新
    _topMargine = topMargine;
    _bottomMargine = bottomMargine;
    
    // フレーム更新
    CGRect newContentFrame;
    newContentFrame.origin = CGPointMake(_contentView.frame.origin.x, self.frame.origin.y + HeaderHeight + _topMargine);
    newContentFrame.size = _contentView.frame.size;
    _contentView.frame = newContentFrame;
    
    // コンテントサイズを更新
    CGFloat newContentHeight = _contentView.frame.size.height + _topMargine + _bottomMargine;
    self.contentSize = CGSizeMake(self.contentSize.width, newContentHeight);
}

// パネルの水平方向の余白と垂直方向の余白を設定する
- (void)setPanelHorizonMargine:(CGFloat)horizonMargine verticalMargine:(CGFloat)verticalMargine
{
    // 垂直余白更新
    _topMargine = verticalMargine;
    _bottomMargine = verticalMargine;
    
    // フレーム更新
    CGRect newContentFrame;
    newContentFrame.origin = CGPointMake(horizonMargine, self.frame.origin.y + HeaderHeight + _topMargine);
    newContentFrame.size = CGSizeMake(self.frame.size.width - (horizonMargine * 2), _contentView.frame.size.height);
    _contentView.frame = newContentFrame;
    
    // コンテントサイズを更新
    CGFloat newContentHeight = _contentView.frame.size.height + _topMargine + _bottomMargine;
    self.contentSize = CGSizeMake(self.contentSize.width, newContentHeight);
}

// パネルの四方向の余白を設定する
- (void)setPanelTopMargine:(CGFloat)topMargine rightMargine:(CGFloat)rightMargine bottomMargine:(CGFloat)bottomMargine leftMargine:(CGFloat)leftMargine
{
    // 垂直余白更新
    _topMargine = topMargine;
    _bottomMargine = bottomMargine;
    
    // フレーム更新
    CGRect newContentFrame;
    newContentFrame.origin = CGPointMake(leftMargine, self.frame.origin.y + HeaderHeight + _topMargine);
    newContentFrame.size = CGSizeMake(self.frame.size.width - (leftMargine + rightMargine), _contentView.frame.size.height);
    _contentView.frame = newContentFrame;
    
    // コンテントサイズを更新
    CGFloat newContentHeight = _contentView.frame.size.height + _topMargine + _bottomMargine;
    self.contentSize = CGSizeMake(self.contentSize.width, newContentHeight);
}

// コンテントの垂直方向のデフォルトの間隔を設定する
- (void)setContentVerticalSpace:(CGFloat)space
{
    [_contentView setVerticalSpace:space];
}

// コンテントをスクロールビューの横幅にフィットさせるかを設定する
- (void)setContentFitWidth:(BOOL)fit
{
    [_contentView setFitWidth:fit];
}

// コンテントとなるサブビューを追加する
- (void)addContentSubview:(UIView*)view
{
    [_contentView addSubview:view];
    
    // コンテントサイズを更新
    CGFloat newContentHeight = _contentView.frame.size.height + _topMargine + _bottomMargine;
    self.contentSize = CGSizeMake(self.contentSize.width, newContentHeight);
}

// コンテントとなるサブビューを追加する
- (void)addContentSubview:(UIView *)view verticalSpace:(CGFloat)space
{
    [_contentView addSubview:view verticalSpace:space];
    
    // コンテントサイズを更新
    CGFloat newContentHeight = _contentView.frame.size.height + _topMargine + _bottomMargine;
    self.contentSize = CGSizeMake(self.contentSize.width, newContentHeight);
}

// コンテントとなるサブビューを追加する
- (void)addContentSubview:(UIView*)view fitWidth:(BOOL)fit
{
    [_contentView addSubview:view fitWidth:fit];
    
    // コンテントサイズを更新
    CGFloat newContentHeight = _contentView.frame.size.height + _topMargine + _bottomMargine;
    self.contentSize = CGSizeMake(self.contentSize.width, newContentHeight);
}

// コンテントとなるサブビューを追加する
- (void)addContentSubview:(UIView*)view verticalSpace:(CGFloat)space fitWhidth:(BOOL)fit
{
    [_contentView addSubview:view verticalSpace:space fitWidth:fit];
    
    // コンテントサイズを更新
    CGFloat newContentHeight = _contentView.frame.size.height + _topMargine + _bottomMargine;
    self.contentSize = CGSizeMake(self.contentSize.width, newContentHeight);
}

// フルスクリーンに対応するためにインセットを設定する
- (void)setScrollInsetForFullScreen:(UIViewController*)controller
{
    [HokutosaiUIUtility setInsetsOfContentScrollViewForFullScreen:self viewController:controller];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
