//
//  HokutosaiStackPanel.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/20.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiStackPanel.h"

@interface HokutosaiStackPanel ()
{
    CGFloat _bottom;
}

- (void)initHokutosaiStackPanel;

@end

@implementation HokutosaiStackPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initHokutosaiStackPanel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initHokutosaiStackPanel];
    }
    return self;
}

- (void)initHokutosaiStackPanel
{
    _bottom = 0.0;
    _verticalSpace = 0.0;
    _fitWidth = NO;
}

- (void)addSubview:(UIView *)view
{
    [self addSubview:view verticalSpace:_verticalSpace fitWidth:_fitWidth];
}

- (void)addSubview:(UIView *)view verticalSpace:(CGFloat)space
{
    [self addSubview:view verticalSpace:space fitWidth:_fitWidth];
}

- (void)addSubview:(UIView *)view fitWidth:(BOOL)fit
{
    [self addSubview:view verticalSpace:_verticalSpace fitWidth:fit];
}

- (void)addSubview:(UIView *)view verticalSpace:(CGFloat)space fitWidth:(BOOL)fit
{
    // 追加するビューのフレーム調整
    CGRect frameOfView;
    frameOfView.origin = CGPointMake(fit ? 0 : view.frame.origin.x, (_bottom == 0.0) ? 0.0 : (_bottom + space));
    frameOfView.size = CGSizeMake(fit ? self.frame.size.width : view.frame.size.width, view.frame.size.height);
    view.frame = frameOfView;
    
    // 高さ更新
    _bottom = view.frame.origin.y + view.frame.size.height;
    
    // 自身のビューフレームの調整
    CGRect frameOfSelf;
    frameOfSelf.origin = self.frame.origin;
    frameOfSelf.size = CGSizeMake(self.frame.size.width, _bottom);
    self.frame = frameOfSelf;
    
    [super addSubview:view];
}

@end
