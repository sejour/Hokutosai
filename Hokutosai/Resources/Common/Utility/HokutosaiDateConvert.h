//
//  HokutosaiDateConvert.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/29.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HokutosaiDateConvert : NSObject

// NSDateを文字列に変換する
+ (NSString*)stringFromNSDate:(NSDate*)date format:(NSString*)format;

// 日本時間の文字列をNSDateに変換する
+ (NSDate*)dateFromStringWithJST:(NSString*)jst format:(NSString*)format;

// Hokutosai APIのDatetime型をNSDateに変換する
+ (NSDate*)dateFromHokutosaiApiDatetime:(NSString*) datetime;

// Hokutosai APIのDate型をNSDateに変換する
+ (NSDate*)dateFromHokutosaiApiDate:(NSString*) date;

// Hokutosai APIのTime型をNSDateに変換する
+ (NSDate*)dateFromHokutosaiApiTime:(NSString*) time;

// Hokutosai APIのDate+Time型をNSDateに変換する
+ (NSDate*)dateFromHokutosaiApiDate:(NSString*)date time:(NSString*)time;

// Hokutosai APIのDatetime型を任意のフォーマットの文字列に変換する
+ (NSString*)stringFromHokutosaiApiDatetime:(NSString*) datetime format:(NSString*)format;

// Hokutosai APIのDate型を任意のフォーマットの文字列に変換する
+ (NSString*)stringFromHokutosaiApiDate:(NSString*) date format:(NSString*)format;

// Hokutosai APIのTime型を任意のフォーマットの文字列に変換する
+ (NSString*)stringFromHokutosaiApiTime:(NSString*) time format:(NSString*)format;

// 経過時間の文字列を取得する
+ (NSString*)stringElapsedTimeSince:(NSDate*)date;

@end
