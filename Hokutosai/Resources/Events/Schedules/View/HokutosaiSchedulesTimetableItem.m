//
//  HokutosaiSchedulesTimetableItem.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/02.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiSchedulesTimetableItem.h"
#import "HokutosaiStackPanelView.h"
#import "HokutosaiDateConvert.h"
#import "HokutosaiUIColor.h"

static const CGFloat WidthOfTimeAxis = 10.0;

@interface HokutosaiSchedulesTimetableItem ()
{
    // 時間軸
    UIView *timeAxis;
    // 時間ラベル
    UILabel *timesLabel;
}

- (void)initHokutosaiSchedulesTimetableItemWithTitle:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime detail:(NSString *)detail;

- (void)generateTimeLabel:(HokutosaiStackPanelView*)stackPanel startTime:(NSDate *)startTime endTime:(NSDate *)endTime;
- (void)generateTitleLabel:(HokutosaiStackPanelView*)stackPanel title:(NSString*)title touchBottom:(BOOL)touchBottom;
- (void)generateDetailLabel:(HokutosaiStackPanelView*)stackPanel detail:(NSString*)detail;

@end

@implementation HokutosaiSchedulesTimetableItem

- (id)initWithFrame:(CGRect)frame title:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime detail:(NSString *)detail
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initHokutosaiSchedulesTimetableItemWithTitle:title startTime:startTime endTime:endTime detail:detail];
    }
    return self;
}

- (void)initHokutosaiSchedulesTimetableItemWithTitle:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime detail:(NSString *)detail

{
    // 自身の設定
    self.backgroundColor = [UIColor whiteColor];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.layer setBorderWidth:1.0];
    
    // 時間軸
    CGRect frameOfTimeAxis = CGRectMake(0.0, 0.0, WidthOfTimeAxis, self.frame.size.height);
    timeAxis = [[UIView alloc] initWithFrame:frameOfTimeAxis];
    timeAxis.backgroundColor = [HokutosaiUIColor tnctGreenColor];
    [self addSubview:timeAxis];
    
    // 時間
    float time = [endTime timeIntervalSinceDate:startTime];
    
    // スタックパネル
    CGRect frameOfStackPanel = CGRectMake(WidthOfTimeAxis, 0, self.frame.size.width - WidthOfTimeAxis, 0.0);
    HokutosaiStackPanelView *stackPanel = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfStackPanel];
    stackPanel.backgroundColor = [UIColor clearColor];
    [stackPanel setTopPadding:0.0 rightPadding:0.0 bottomPadding:0.0 leftPadding:0.0];
    [self addSubview:stackPanel];
    
    // 時間ラベル
    if (time > 600) {
        [self generateTimeLabel:stackPanel startTime:startTime endTime:endTime];
    }
    
    // タイトルラベル
    [self generateTitleLabel:stackPanel title:title touchBottom:(time <= 1200.0)];
    
    // 詳細ラベル
    if (time > 1200.0 && stackPanel.frame.size.height < self.frame.size.height) {
        [self generateDetailLabel:stackPanel detail:detail];
    }
    
    // ステータス設定
    [self setStatus:HokutosaiSchedulesTimetableItemStatusNormal];
}

// 時間ラベルを生成する
- (void)generateTimeLabel:(HokutosaiStackPanelView*)stackPanel startTime:(NSDate *)startTime endTime:(NSDate *)endTime
{
    CGRect frameOfTimesLabel = CGRectMake(0, 0, stackPanel.widthOfStackPanel, 15);
    timesLabel = [[UILabel alloc] initWithFrame:frameOfTimesLabel];
    timesLabel.textColor = [UIColor blackColor];
    timesLabel.textAlignment = NSTextAlignmentLeft;
    timesLabel.font = [UIFont systemFontOfSize:13.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    timesLabel.text = [NSString stringWithFormat:@" %@ 〜 %@", [formatter stringFromDate:startTime], [formatter stringFromDate:endTime]];
    
    [stackPanel addSubview:timesLabel fitWidth:YES];
}

// タイトルラベルを生成する
- (void)generateTitleLabel:(HokutosaiStackPanelView*)stackPanel title:(NSString *)title touchBottom:(BOOL)touchBottom
{
    // 底辺に隣接する場合は高さを計算
    CGFloat heightOfTitleLabel = touchBottom ? self.frame.size.height - stackPanel.heightOfStackPanel : 0.0;
    
    CGRect frameOfTitleLabel = CGRectMake(5.0, stackPanel.heightOfStackPanel, stackPanel.widthOfStackPanel - 10.0, heightOfTitleLabel);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frameOfTitleLabel];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    
    CGFloat verticalSpace = 0.0;
    
    // 底辺に隣接しなければ
    if (!touchBottom) {
        // リサイズ
        [titleLabel sizeToFit];
        // タイトルラベルの底辺が自身のビューをはみ出してれば、サイズを調整
        if (titleLabel.frame.origin.y + titleLabel.frame.size.height > self.frame.size.height) {
            frameOfTitleLabel.origin = titleLabel.frame.origin;
            frameOfTitleLabel.size = CGSizeMake(titleLabel.frame.size.width, self.frame.size.height - stackPanel.heightOfStackPanel);
            titleLabel.frame = frameOfTitleLabel;
        }
        // タイトルラベルの底辺が自身のビューの中に収まっていれば
        else {
            // 垂直方向の余白を作成
            verticalSpace = 3.0;
        }
    }
    
    [stackPanel addSubview:titleLabel verticalSpace:verticalSpace];
}

// 詳細ラベルを生成する
- (void)generateDetailLabel:(HokutosaiStackPanelView*)stackPanel detail:(NSString *)detail
{
    CGRect frameOfDetailLabel = CGRectMake(10, stackPanel.heightOfStackPanel, stackPanel.widthOfStackPanel - 15.0, 50);
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:frameOfDetailLabel];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.textColor = [UIColor blackColor];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.font = [UIFont systemFontOfSize:12.0];
    detailLabel.numberOfLines = 0;
    detailLabel.text = detail;
    
    CGFloat verticalSpace = 0.0;
    
    // リサイズ
    [detailLabel sizeToFit];
    
    // 詳細ラベルの底辺が自身のビューをはみ出していれば、サイズを調整
    if (detailLabel.frame.origin.y + detailLabel.frame.size.height > self.frame.size.height) {
        frameOfDetailLabel.origin = detailLabel.frame.origin;
        frameOfDetailLabel.size = CGSizeMake(detailLabel.frame.size.width, self.frame.size.height - stackPanel.heightOfStackPanel);
        detailLabel.frame = frameOfDetailLabel;
    }
    // 詳細ラベルの底辺が自身のビューの中に収まっていれば
    else {
        verticalSpace = 3.0;
    }
    
    [stackPanel addSubview:detailLabel verticalSpace:verticalSpace];
}

// イベントのステータスを設定する
- (void)setStatus:(HokutosaiSchedulesTimetableItemStatus)status
{
    switch (status) {
        case HokutosaiSchedulesTimetableItemStatusNormal:
            self.backgroundColor = [HokutosaiUIColor colorWithRed:245 green:255 blue:245];
            timesLabel.backgroundColor = [HokutosaiUIColor colorWithRed:170 green:255 blue:200];
            timeAxis.backgroundColor = [HokutosaiUIColor colorWithRed:90 green:220 blue:140];
            break;
        case HokutosaiSchedulesTimetableItemStatusRegisterNotification:
            self.backgroundColor = [HokutosaiUIColor colorWithRed:255 green:250 blue:230];
            timesLabel.backgroundColor = [HokutosaiUIColor colorWithRed:255 green:235 blue:150];
            timeAxis.backgroundColor = [HokutosaiUIColor colorWithRed:240 green:220 blue:80];
            break;
        case HokutosaiSchedulesTimetableItemStatusNow:
            self.backgroundColor = [HokutosaiUIColor colorWithRed:255 green:240 blue:240];
            timesLabel.backgroundColor = [HokutosaiUIColor colorWithRed:255 green:190 blue:190];
            timeAxis.backgroundColor = [HokutosaiUIColor colorWithRed:240 green:140 blue:140];
            break;
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
