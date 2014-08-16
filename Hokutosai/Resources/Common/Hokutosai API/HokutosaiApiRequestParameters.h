//
//  HokutosaiApiRequestParameters.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/13.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>

// Hokutosai API リクエストで使用されるパラメータリスト
@interface HokutosaiApiRequestParameters : NSObject

// パラメータディクショナリ
@property (nonatomic, readonly) NSMutableDictionary *params;

// 文字列のパラメータ追加する
- (void)setValueWithString:(NSString*)value forKey:(NSString*)identifier;

// 整数値のパラメータを追加する
- (void)setValueWithInteger:(NSInteger)value forKey:(NSString*)identifier;

// 整数値のパラメータを追加する
- (void)setValueWithNumber:(NSNumber*)value forKey:(NSString*)identifier;

// 論理値のパラメータを追加する
- (void)setValueWithBool:(BOOL)value forKey:(NSString*)identifier;

// 日付のパラメータを追加する
- (void)setValueWithDate:(NSDate*)date forKey:(NSString*)identifier;

// 時間のパラメータを追加する
- (void)setValueWithTime:(NSDate*)time forKey:(NSString*)identifier;

// 日時のパラメータを追加する
- (void)setValueWithDateTime:(NSDate*)dateTime forKey:(NSString*)identifier;

@end
