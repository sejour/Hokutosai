//
//  HokutosaiHeaderedLabel.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/20.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiHeaderedLabel.h"

@interface HokutosaiHeaderedLabel ()

- (void)commonInitHeaderedLabel;

@end

@implementation HokutosaiHeaderedLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInitHeaderedLabel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self commonInitHeaderedLabel];
    }
    return self;
}

- (void)commonInitHeaderedLabel
{
    _contentText = nil;
    _contentFontSize = 17.0;
    _numberOfContentLines = 1;
    
    CGRect frameOfLabel;
    frameOfLabel.origin = CGPointMake(10.0, _headlineLabel.frame.origin.y + _headlineLabel.frame.size.height);
    frameOfLabel.size = CGSizeMake(self.frame.size.width - 10.0, 20.0);
    
    // ラベル生成
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:frameOfLabel];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 1;
    [contentLabel sizeToFit];
    
    self.contentView = contentLabel;
    [self addSubview:contentLabel];
}

- (void)applyCongifuration
{
    if (self.contentView == nil) {
        return;
    }
    
    // 見出し設定
    _headlineLabel.text = self.headlineText;
    _headlineLabel.font = [UIFont systemFontOfSize:self.headlineFontSize];
    [_headlineLabel sizeToFit];
    
    // 見出しフレーム調整
    CGRect frameOfHeadlineLabel = CGRectMake(0, 0, self.frame.size.width, _headlineLabel.frame.size.height);
    _headlineLabel.frame = frameOfHeadlineLabel;
    
    // ラベルを取り出す
    UILabel *contentLabel = (UILabel*)self.contentView;
        
    // プロパティ設定
    contentLabel.text = _contentText;
    contentLabel.numberOfLines = _numberOfContentLines;
    contentLabel.font = [UIFont systemFontOfSize:_contentFontSize];
    
    // フレーム設定
    CGRect frameOfContentView;
    frameOfContentView.origin = CGPointMake(self.contentOffset, _headlineLabel.frame.origin.y + _headlineLabel.frame.size.height + self.space);
    frameOfContentView.size = CGSizeMake(self.frame.size.width - self.contentOffset, self.contentView.frame.size.height);
    self.contentView.frame = frameOfContentView;
    
    // リサイズ
    [contentLabel sizeToFit];
    
    // 自身のフレーム更新
    CGRect frameOfSelf;
    frameOfSelf.origin = self.frame.origin;
    frameOfSelf.size = CGSizeMake(self.frame.size.width, _headlineLabel.frame.size.height + self.space + self.contentView.frame.size.height);
    self.frame = frameOfSelf;
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
