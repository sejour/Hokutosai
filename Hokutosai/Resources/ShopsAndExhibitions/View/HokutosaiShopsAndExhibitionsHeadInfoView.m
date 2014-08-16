//
//  HokutosaiShopsAndExhibitionsHeadInfoView.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/07.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiShopsAndExhibitionsHeadInfoView.h"
#import "HokutosaiStreamingLabel.h"
#import "HokutosaiStackPanel.h"

static const CGFloat ImageHeight = 120.0;

@interface HokutosaiShopsAndExhibitionsHeadInfoView ()
{
    HokutosaiStreamingLabel *_titleLabel;
    UIImageView *_imageView;
    UILabel *_hostNameLabel;
}

- (void)initWithTitle:(NSString*)title hostNameHeadline:(NSString *)headline;
@end

@implementation HokutosaiShopsAndExhibitionsHeadInfoView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame title:nil hostNameHeadline:nil];
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title hostNameHeadline:(NSString *)headline
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initWithTitle:title hostNameHeadline:headline];
    }
    return self;
}

- (void)initWithTitle:(NSString *)title hostNameHeadline:(NSString *)headline
{
    // 自身の設定
    [self setTopPadding:10.0 rightPadding:20.0 bottomPadding:5.0 leftPadding:20.0];
    
    // タイトル
    {
        CGRect frameOfTitleLabel = CGRectMake(0.0, 0.0, self.widthOfStackPanel, 27.0);
        _titleLabel = [[HokutosaiStreamingLabel alloc] initWithFrame:frameOfTitleLabel];
        [_titleLabel setTextFont:[UIFont boldSystemFontOfSize:22.0]];
        [_titleLabel setText:title];
        [self addSubview:_titleLabel];
    }
    
    // コンテントビュー
    CGRect frameOfContentView = CGRectMake(0.0, 0.0, self.widthOfStackPanel, ImageHeight);
    UIView *contentView = [[UIView alloc] initWithFrame:frameOfContentView];
    [self addSubview:contentView verticalSpace:10.0];
    
    // イメージ
    {
        CGRect frameOfImageView = CGRectMake(0.0, 0.0, ImageHeight, ImageHeight);
        _imageView = [[UIImageView alloc] initWithFrame:frameOfImageView];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        [contentView addSubview:_imageView];
    }
    
    static CGFloat offset = 12.0;
    
    // 主催者見出し
    CGRect frameOfHostNameHeadline = CGRectMake(ImageHeight + offset, 20.0, contentView.frame.size.width - ImageHeight - offset, 10.0);
    UILabel *hostNameHeadline = [[UILabel alloc] initWithFrame:frameOfHostNameHeadline];
    hostNameHeadline.textAlignment = NSTextAlignmentLeft;
    hostNameHeadline.numberOfLines = 1;
    hostNameHeadline.font = [UIFont systemFontOfSize:18.0];
    hostNameHeadline.text = headline;
    [hostNameHeadline sizeToFit];
    [contentView addSubview:hostNameHeadline];
    
    // 主催者
    CGRect frameOfHostNameLabel = CGRectMake(ImageHeight + (offset + 10.0), hostNameHeadline.frame.origin.y + hostNameHeadline.frame.size.height + 3.0, contentView.frame.size.width - ImageHeight - (offset + 10.0), 10.0);
    _hostNameLabel = [[UILabel alloc] initWithFrame:frameOfHostNameLabel];
    _hostNameLabel.textAlignment = NSTextAlignmentLeft;
    _hostNameLabel.numberOfLines = 3;
    _hostNameLabel.font = [UIFont systemFontOfSize:16.0];
    [contentView addSubview:_hostNameLabel];
}

- (void)setTitle:(NSString*)title
{
    [_titleLabel setText:title];
}

- (void)setImage:(UIImage*)image
{
    _imageView.image = image;
}

- (void)setHostName:(NSString*)hostName
{
    _hostNameLabel.text = hostName;
    
    if (_hostNameLabel.text) {
        [_hostNameLabel sizeToFit];
    }
}

- (void)startTitleStreaming
{
    [_titleLabel startStreamingInterval:3.0 speed:33.0];
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
