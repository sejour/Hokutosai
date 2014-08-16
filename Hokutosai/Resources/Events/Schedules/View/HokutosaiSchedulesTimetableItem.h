//
//  HokutosaiSchedulesTimetableItem.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/02.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    HokutosaiSchedulesTimetableItemStatusNormal,
    HokutosaiSchedulesTimetableItemStatusRegisterNotification,
    HokutosaiSchedulesTimetableItemStatusNow
} HokutosaiSchedulesTimetableItemStatus;

/** スケジュールタイムテーブルのアイテム */
@interface HokutosaiSchedulesTimetableItem : UIView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime detail:(NSString *)detail;

// イベントのステータスを設定する
- (void)setStatus:(HokutosaiSchedulesTimetableItemStatus)status;

@end
