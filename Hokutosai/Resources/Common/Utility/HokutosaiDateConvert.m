//
//  HokutosaiDateConvert.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/29.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiDateConvert.h"

@implementation HokutosaiDateConvert

// NSDateを文字列に変換する
+ (NSString*)stringFromNSDate:(NSDate*)date format:(NSString*)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

// 日本時間の文字列をNSDateに変換する
+ (NSDate*)dateFromStringWithJST:(NSString*)jst format:(NSString*)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"ja_JP"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
    
    return [formatter dateFromString:jst];
}

// Hokutosai APIの日付型をNSDateに変換する
+ (NSDate*)dateFromHokutosaiApiDatetime:(NSString*) datetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];
    
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"ja_JP"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
    
    return [formatter dateFromString:datetime];
}

+ (NSDate*)dateFromHokutosaiApiDate:(NSString *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"ja_JP"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
    
    return [formatter dateFromString:date];
}

+ (NSDate*)dateFromHokutosaiApiTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"ja_JP"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
    
    return [formatter dateFromString:time];
}

+ (NSDate*)dateFromHokutosaiApiDate:(NSString *)date time:(NSString *)time
{
    NSString *datetime = [NSString stringWithFormat:@"%@ %@", date, time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"ja_JP"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
    
    return [formatter dateFromString:datetime];
}

// Hokutosai APIの日付型を任意のフォーマットの文字列に変換する
+ (NSString*)stringFromHokutosaiApiDatetime:(NSString*) datetime format:(NSString*)format
{
    return [HokutosaiDateConvert stringFromNSDate:[HokutosaiDateConvert dateFromHokutosaiApiDatetime:datetime] format:format];
}

+ (NSString*)stringFromHokutosaiApiDate:(NSString *)date format:(NSString *)format
{
    return [HokutosaiDateConvert stringFromNSDate:[HokutosaiDateConvert dateFromHokutosaiApiDate:date] format:format];
}

+ (NSString*)stringFromHokutosaiApiTime:(NSString *)time format:(NSString *)format
{
    return [HokutosaiDateConvert stringFromNSDate:[HokutosaiDateConvert dateFromHokutosaiApiTime:time] format:format];
}

// 経過時間の文字列を取得する
+ (NSString*)stringElapsedTimeSince:(NSDate*)date
{
    float progress = [[NSDate date] timeIntervalSinceDate:date];
    
    if (progress >= 0) {
        if (progress < 60) {
            return [NSString stringWithFormat:@"%d秒", (int)progress];
        } else if (progress < 3600) {
            return [NSString stringWithFormat:@"%d分", (int)(progress / 60)];
        } else if (progress < 86400) {
            return [NSString stringWithFormat:@"%d時間", (int)(progress / 3600)];
        } else if (progress < 604800) {
            return [NSString stringWithFormat:@"%d日", (int)(progress / 86400)];
        }
    }
    
    return [HokutosaiDateConvert stringFromNSDate:date format:@"yyyy/MM/dd"];
}

@end
