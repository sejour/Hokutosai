//
//  HokutosaiEventsNotification.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/13.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>

// イベントの通知に関する機能を提供する
@interface HokutosaiEventsNotification : NSObject

/** 指定したイベントIDが通知登録されているか調べる */
+ (BOOL)eventIsRegistered:(NSNumber*)eventId;

/** 
 * 指定したイベントIDを通知登録する
 * @param eventId イベントID
 * @param eventName イベント名
 * @param startTime イベントの開始時刻
 * @param noticeAgoTime 通知する時間 (秒前)
 * 戻り値：過去への通知であればfalseを返す
 */
+ (BOOL)registerNotificationWithEvent:(NSNumber*)eventId eventName:(NSString*)eventName heldDate:(NSString*)date startTime:(NSString*)startTime noticeAgoTime:(NSTimeInterval)noticeAgoTime;

/** 指定したイベントIDの通知を取り消す */
+ (void)cancelNotificationWithEvent:(NSNumber*)eventId;

@end
