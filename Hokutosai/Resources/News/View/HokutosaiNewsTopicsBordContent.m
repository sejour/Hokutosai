//
//  HokutosaiNewsTopicsBordContent.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/05.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiNewsTopicsBordContent.h"
#import "HokutosaiUIColor.h"

@interface HokutosaiNewsTopicsBordContent ()
{
    UILabel *_titleLabel;
}

// 共通の初期化処理
- (void)commonInitWithImage:(UIImage*)image title:(NSString*)title;

@end

@implementation HokutosaiNewsTopicsBordContent

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInitWithImage:nil title:nil];
    }
    return self;
}

// 画像のみのコンテントを作成する
- (id)initWithFrame:(CGRect)frame image:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInitWithImage:image title:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame imageName:(NSString*)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInitWithImage:[UIImage imageNamed:imageName] title:nil];
    }
    return self;
}

// タイトルのみのコンテントを作成する
- (id)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInitWithImage:nil title:title];
    }
    return self;
}

// 画像とタイトル両方から成るコンテントを作成する
- (id)initWithFrame:(CGRect)frame image:(UIImage*)image title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInitWithImage:image title:title];
    }
    return self;
}

// 共通の初期化処理
- (void)commonInitWithImage:(UIImage *)image title:(NSString *)title
{
    // イメージ設定
    self.image = image;
    
    // スワイプボード一杯に画像を配置
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    // クリッピングする
    self.clipsToBounds = YES;
    
    // タイトルラベル設定
    CGRect titleLabelFrame;
    titleLabelFrame.origin = CGPointMake(10, 30);
    titleLabelFrame.size = CGSizeMake(self.frame.size.width - 20, self.frame.size.height - 60);
        
    _titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        
    _titleLabel.text = title;
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont boldSystemFontOfSize:28.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.backgroundColor = [HokutosaiUIColor colorWithRed:255 green:255 blue:255 alpha:180];
    _titleLabel.hidden = !title;
    
    [self addSubview:_titleLabel];
    
    [self bringSubviewToFront:_titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
    _titleLabel.hidden = !title;
}

@end
