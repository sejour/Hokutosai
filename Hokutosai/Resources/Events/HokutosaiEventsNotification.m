//
//  HokutosaiEventsNotification.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/13.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiEventsNotification.h"
#import "HokutosaiDateConvert.h"

@implementation HokutosaiEventsNotification

+ (BOOL)eventIsRegistered:(NSNumber *)eventId
{
    NSString *eventIdWithString = [NSString stringWithFormat:@"%@", eventId];
    
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([notification.userInfo[@"event_id"] isEqualToString:eventIdWithString]) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)registerNotificationWithEvent:(NSNumber *)eventId eventName:(NSString *)eventName heldDate:(NSString *)date startTime:(NSString *)startTime noticeAgoTime:(NSTimeInterval)noticeAgoTime
{
    // イベントID
    NSString *eventIdWithString = [NSString stringWithFormat:@"%@", eventId];
    // 開催日時
    NSDate *heldDatetime = [HokutosaiDateConvert dateFromHokutosaiApiDate:date time:startTime];
    // 通知日時
    NSDate *notificeDate = [[NSDate alloc] initWithTimeInterval:-noticeAgoTime sinceDate:heldDatetime];
    
    // 通知日時 - 現在日時　が負であればエラー
    if ([notificeDate timeIntervalSinceNow] <= 0) {
        return false;
    }
    
    // 通知生成
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    // 設定
    notification.fireDate = notificeDate;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = [NSString stringWithFormat:@"「%@」があと%d分で始まります！", eventName, (int)(noticeAgoTime / 60)];
    notification.alertAction = @"OK";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = @{@"event_id": eventIdWithString};
    
    // クリア
    [self cancelNotificationWithEvent:eventId];
    
    // 登録
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    return true;
}

+ (void)cancelNotificationWithEvent:(NSNumber *)eventId
{
    NSString *eventIdWithString = [NSString stringWithFormat:@"%@", eventId];
    
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([notification.userInfo[@"event_id"] isEqualToString:eventIdWithString]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

@end
