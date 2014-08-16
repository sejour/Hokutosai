//
//  HokutosaiStreamingLabel.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/23.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiStreamingLabel.h"
#import "HokutosaiTimer.h"

@interface HokutosaiStreamingLabel ()
{
    // コンテントラベル
    NSArray *_contentLabels;
    
    // アニメーションの時間
    CGFloat _streamingDuration;
    // インターバル
    CGFloat _streamingInterval;
}

// 初期化
- (void)initHokutosaiStreamingLabel;

// ノーマルモードでラベルを設定する (中央揃え/通常の表示)
- (void)adjustForNormalMode:(UILabel*)contentLabel dummy:(UILabel*)contentLabelDummy;
// ストリーミングモードでラベルを設定する (左揃え/ストリーミング表示)
- (void)adjustForStreamingMode:(UILabel*)contentLabel dummy:(UILabel*)contentLabelDummy;

// ストリーミングを行う
- (void)streaming;

@end

@implementation HokutosaiStreamingLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initHokutosaiStreamingLabel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initHokutosaiStreamingLabel];
    }
    return self;
}

- (void)initHokutosaiStreamingLabel
{
    // ラベルの間隔
    _streamingLabelSpace = 50.0;
    
    // スクロールインジケータ非表示
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    // バウンドしない
    self.bounces = NO;
    self.bouncesZoom = NO;
    // クリッピング有効
    self.clipsToBounds = YES;
    // スクロール無効
    self.scrollEnabled = false;
    
    // ラベル生成
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UILabel *contentLabelDummy = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    contentLabelDummy.hidden = YES;
    
    _contentLabels = @[contentLabel, contentLabelDummy];
    
    // 属性設定
    for (UILabel *label in _contentLabels) {
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:17];
        
        [self addSubview:label];
    }
}

// ノーマルモードでラベルを設定する
- (void)adjustForNormalMode:(UILabel *)contentLabel dummy:(UILabel *)contentLabelDummy
{
    // ラベルを表示
    contentLabel.hidden = NO;
    // ダミーラベルは非表示
    contentLabelDummy.hidden = YES;
    
    // 中央揃え
    contentLabel.textAlignment = NSTextAlignmentCenter;
    
    // ラベルフレームの調整
    contentLabel.frame = CGRectMake(0, 0, self.frame.size.width, contentLabel.frame.size.height);
    
    // 自身のフレーム調整
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, contentLabel.frame.size.height);
}

// ストリーミングモードでラベルを設定する
- (void)adjustForStreamingMode:(UILabel *)contentLabel dummy:(UILabel *)contentLabelDummy
{
    // ラベルを表示
    contentLabel.hidden = NO;
    contentLabelDummy.hidden = NO;
    
    // 左揃え
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabelDummy.textAlignment = NSTextAlignmentLeft;
    
    // ラベルの幅
    CGFloat labelWidth = contentLabel.frame.size.width + _streamingLabelSpace;
    
    // ラベルフレームの調整
    contentLabel.frame = CGRectMake(0, 0, labelWidth, contentLabel.frame.size.height);
    
    // ダミーラベルのフレーム調整
    contentLabelDummy.frame = CGRectMake(labelWidth, 0, labelWidth, contentLabelDummy.frame.size.height);
    
    // 自身のフレーム調整
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, contentLabel.frame.size.height);
    
    // コンテントサイズ設定
    self.contentSize = CGSizeMake(labelWidth * 2, contentLabel.frame.size.height);
}

// コンテントラベルを設定する
- (void)configureContentLabel:(void(^)(UILabel*))configure
{
    for (UILabel *label in _contentLabels) {
        configure(label);
    }
    
    [self sizeToFit];
}

// サイズを調整する
- (void)sizeToFit
{
    // コンテントのサイズを自動調整
    for (UILabel *label in _contentLabels) {
        [label sizeToFit];
    }
    
    UILabel *contentLabel = _contentLabels[0];
    UILabel *contentLabelDummy = _contentLabels[1];
    
    // コンテントラベルの幅が自身のビューの幅を超えていたらストリーミングモードで調整
    if (contentLabel.frame.size.width > self.frame.size.width) {
        [self adjustForStreamingMode:contentLabel dummy:contentLabelDummy];
    }
    // コンテントラベルの幅が自身のビューの幅以下ならばノーマルモードで調整
    else {
        [self adjustForNormalMode:contentLabel dummy:contentLabelDummy];
    }
}

// 表示するテキストを設定する
- (void)setText:(NSString*)text
{
    for (UILabel *label in _contentLabels) {
        label.text = text;
    }
    
    [self sizeToFit];
}

// 表示するテキストのフォントを設定する
- (void)setTextFont:(UIFont*)font
{
    for (UILabel *label in _contentLabels) {
        label.font = font;
    }
    
    [self sizeToFit];
    
}

// 表示するテキストのカラーを設定する
- (void)setTextColor:(UIColor *)color
{
    for (UILabel *label in _contentLabels) {
        label.textColor = color;
    }
}

// 指定の秒数後にストリーミングを開始する
// 速度はデフォルト 30[pixel/s]
- (void)startStreamingInterval:(NSTimeInterval)interval
{
    [self startStreamingInterval:interval speed:30.0];
}

// 指定の秒数後に指定の速度でストリーミングを開始する
// 速度の単位は[pixel/s]
- (void)startStreamingInterval:(NSTimeInterval)interval speed:(CGFloat)pixelPerSecond
{
    UILabel* contentLabelDummy = _contentLabels[1];
    
    // スクロール禁止であればストリーミングしない
    if (contentLabelDummy.hidden) {
        return;
    }
    
    // インターバル設定
    _streamingInterval = interval;
    
    // アニメーションの時間を設定
    _streamingDuration = ((UILabel*)_contentLabels[0]).frame.size.width / pixelPerSecond;
    
    // タイマーの間隔
    NSTimeInterval timerInterval = _streamingInterval + _streamingDuration + 1;
    
    // タイマー開始
    [[NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(streaming) userInfo:nil repeats:YES] fire];
}

// ストリーミングを行う
- (void)streaming
{
    CGFloat destinationX = ((UILabel*)_contentLabels[0]).frame.size.width;
    
    // アニメーション開始
    [UIView animateWithDuration:_streamingDuration
                          delay:_streamingInterval
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.contentOffset = CGPointMake(destinationX, self.contentOffset.y);
                     }
                     completion:^(BOOL finished){
                         self.contentOffset = CGPointZero;
                     }
     ];
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
