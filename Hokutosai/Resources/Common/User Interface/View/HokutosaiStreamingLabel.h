//
//  HokutosaiStreamingLabel.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/23.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

// ストリームアニメーションで画面に収まらない文字列を1行で表示するラベル
@interface HokutosaiStreamingLabel : UIScrollView

// ストリーミングされる際のラベルの間隔
@property (nonatomic) CGFloat streamingLabelSpace;

// コンテントラベルを設定する
- (void)configureContentLabel:(void(^)(UILabel*))configure;

// 表示するテキストを設定する
- (void)setText:(NSString*)text;

// 表示するテキストのフォントを設定する
- (void)setTextFont:(UIFont*)font;

// 表示するテキストのカラーを設定する
- (void)setTextColor:(UIColor *)color;

// 指定の秒数後にストリーミングを開始する
// 速度はデフォルト 30[pixel/s]
- (void)startStreamingInterval:(NSTimeInterval)interval;

// 指定の秒数後に指定の速度でストリーミングを開始する
// 速度の単位は[pixel/s]
- (void)startStreamingInterval:(NSTimeInterval)interval speed:(CGFloat)pixelPerSecond;

@end
