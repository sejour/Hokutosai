//
//  HokutosaiSchedulesTimeAxis.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/01.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiSchedulesTimeAxis.h"
#import "HokutosaiDateConvert.h"

// 表示開始時刻
static const int StartTime = 9;
// 表示終了時刻
static const int LastTime = 18;

// タイムラベルの高さ
static const CGFloat HeightOfTimeLabel = 20.0;
// タイムラベルのフォントサイズ
static const CGFloat FontSizeOfTimeLabel = 13.0;

// 上下の余白
static const CGFloat TopAndBottomMargine = 30.0;

@interface HokutosaiSchedulesTimeAxis ()

- (void)initHokutosaiSchedulesTimeBaseViewWithTimeLabelColor:(UIColor*)timeColor;
@end

@implementation HokutosaiSchedulesTimeAxis

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initHokutosaiSchedulesTimeBaseViewWithTimeLabelColor:[UIColor blackColor]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame timeLabelColor:(UIColor *)timeColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initHokutosaiSchedulesTimeBaseViewWithTimeLabelColor:timeColor];
    }
    return self;
}

- (void)initHokutosaiSchedulesTimeBaseViewWithTimeLabelColor:(UIColor *)timeColor
{
    // 1時間あたりの高さ
    CGFloat heightOfOneHour = [HokutosaiSchedulesTimeAxis heightOfOneHour];
    
    // 時間軸生成
    int count = [HokutosaiSchedulesTimeAxis numberOfDisplayedTime];
    CGRect frameOfTimeLabel;
    frameOfTimeLabel.size = CGSizeMake(self.frame.size.width, HeightOfTimeLabel);
    UILabel *timeLabel;
    
    for (int i = 0; i <= count; ++i) {
        frameOfTimeLabel.origin = CGPointMake(0, (TopAndBottomMargine - (HeightOfTimeLabel/2)) + (heightOfOneHour * i));
        timeLabel = [[UILabel alloc] initWithFrame:frameOfTimeLabel];
        timeLabel.text = [NSString stringWithFormat:@"%02d:00", (i + StartTime)];
        timeLabel.font = [UIFont systemFontOfSize:FontSizeOfTimeLabel];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = timeColor;
        [self addSubview:timeLabel];
    }
    
    // 自身のフレーム更新
    CGRect frameOfSelf;
    frameOfSelf.origin = self.frame.origin;
    frameOfSelf.size = CGSizeMake(self.frame.size.width, [HokutosaiSchedulesTimeAxis height]);
    self.frame = frameOfSelf;
}

// 表示開始時刻
+ (NSInteger)displayedStartTime
{
    return StartTime;
}

// 表示終了時刻
+ (NSInteger)displayedLastTime
{
    return LastTime;
}

// 表示される時間の数
+ (int)numberOfDisplayedTime
{
    return LastTime - StartTime;
}

// 指定された時間に適合する垂直方向の位置を返す
+ (CGFloat)verticalPositionAtDate:(NSDate*)date
{
    CGFloat hour = [[HokutosaiDateConvert stringFromNSDate:date format:@"HH"] floatValue];
    CGFloat min = [[HokutosaiDateConvert stringFromNSDate:date format:@"mm"] floatValue];
    
    if (hour < StartTime) {
        return 0.0;
    } else if (hour >= LastTime) {
        return TopAndBottomMargine + ([HokutosaiSchedulesTimeAxis heightOfOneHour] * (LastTime - StartTime));
    }
    
    CGFloat heightOfHour = (hour - StartTime) * [HokutosaiSchedulesTimeAxis heightOfOneHour];
    CGFloat heightOfMin = min * [HokutosaiSchedulesTimeAxis heightOfOneMin];
    
    return TopAndBottomMargine + heightOfHour + heightOfMin;
}

// 時間軸ビューの高さ
+ (CGFloat)height
{
    return (TopAndBottomMargine * 2) + ([HokutosaiSchedulesTimeAxis heightOfOneHour] * [HokutosaiSchedulesTimeAxis numberOfDisplayedTime]);
}

// 1分単位の高さ
+ (CGFloat)heightOfOneMin
{
    return HeightOfSchedulesTimeAxis10Min / 10.0;
}

// 10分単位の高さ
+ (CGFloat)heightOf10min
{
    return HeightOfSchedulesTimeAxis10Min;
}

// 1時間単位の高さ
+ (CGFloat)heightOfOneHour
{
    return HeightOfSchedulesTimeAxis10Min * 6;
}

+ (CGFloat)topAndBottomMargine
{
    return TopAndBottomMargine;
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
