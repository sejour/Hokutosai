//
//  HokutosaiHeaderedContentView.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/20.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiHeaderedContentView.h"

@interface HokutosaiHeaderedContentView ()

- (void)commonInitHeaderContentView;
@end

@implementation HokutosaiHeaderedContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitHeaderContentView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitHeaderContentView];
    }
    return self;
}

- (void)commonInitHeaderContentView
{
    _contentView = nil;
    _headlineFontSize = 12.0;
    _contentOffset = 8.0;
    _space = 2.0;
    
    // 見出しラベル
    CGRect frameOfHeadlineLabel = CGRectMake(0, 0, self.frame.size.width, 20);
    _headlineLabel = [[UILabel alloc] initWithFrame:frameOfHeadlineLabel];
    _headlineLabel.textColor = [UIColor blackColor];
    _headlineLabel.textAlignment = NSTextAlignmentLeft;
    _headlineLabel.numberOfLines = 1;
    
    [self addSubview:_headlineLabel];
}

- (void)applyCongifuration
{
    // 見出し設定
    _headlineLabel.text = _headlineText;
    _headlineLabel.font = [UIFont systemFontOfSize:_headlineFontSize];
    [_headlineLabel sizeToFit];
    
    // 見出しフレーム調整
    CGRect frameOfHeadlineLabel = CGRectMake(0, 0, self.frame.size.width, _headlineLabel.frame.size.height);
    _headlineLabel.frame = frameOfHeadlineLabel;
    
    // コンテントビューを設定
    if (_contentView) {
        // コンテントビューフレーム調整
        CGRect frameOfContentView;
        frameOfContentView.origin = CGPointMake(_contentOffset, _headlineLabel.frame.origin.y + _headlineLabel.frame.size.height + _space);
        frameOfContentView.size = CGSizeMake(self.frame.size.width - _contentOffset, _contentView.frame.size.height);
        _contentView.frame = frameOfContentView;
        [self addSubview:_contentView];
        
        // 自身のフレーム更新
        CGRect frameOfSelf;
        frameOfSelf.origin = self.frame.origin;
        frameOfSelf.size = CGSizeMake(self.frame.size.width, _headlineLabel.frame.size.height + _space + _contentView.frame.size.height);
        self.frame = frameOfSelf;
    }
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
