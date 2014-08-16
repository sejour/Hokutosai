//
//  HokutosaiSchedulesTimeAxis.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/01.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

// スケージュールタイムテーブルの時間軸の10分単位の高さ
static const CGFloat HeightOfSchedulesTimeAxis10Min = 25.0;

// スケジュールタイムテーブルの時間軸
@interface HokutosaiSchedulesTimeAxis : UIView

- (id)initWithFrame:(CGRect)frame timeLabelColor:(UIColor*)timeColor;

// 表示開始時刻
+ (NSInteger)displayedStartTime;
// 表示終了時刻
+ (NSInteger)displayedLastTime;
// 表示される時間の数
+ (int)numberOfDisplayedTime;

// 指定された時間に適合する垂直方向の位置を返す
+ (CGFloat)verticalPositionAtDate:(NSDate*)date;

// 時間軸ビューの高さ
+ (CGFloat)height;
// 1分単位の高さ
+ (CGFloat)heightOfOneMin;
// 10分単位の高さ
+ (CGFloat)heightOf10min;
// 1時間単位の高さ
+ (CGFloat)heightOfOneHour;

// 上下の余白
+ (CGFloat)topAndBottomMargine;

@end
