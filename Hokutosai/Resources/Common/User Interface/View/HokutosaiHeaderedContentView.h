//
//  HokutosaiHeaderedContentView.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/20.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

// 見出し付きのビュー
@interface HokutosaiHeaderedContentView : UIView
{
    UILabel *_headlineLabel;
}

// コンテントビュー
@property (nonatomic, weak) UIView *contentView;

// 見出し
@property (nonatomic, weak) NSString *headlineText;

// 見出しフォントサイズ
@property (nonatomic) CGFloat headlineFontSize;

// コンテントのオフセット
@property (nonatomic) CGFloat contentOffset;

// 見出しとコンテントの間隔
@property (nonatomic) CGFloat space;

// 設定を適用する
- (void)applyCongifuration;

@end
