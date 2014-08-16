//
//  HokutosaiApiRequestDemander.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/13.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HokutosaiApiRequest.h"

#define JsonValue(value) value == [NSNull null] ? nil : value
#define JsonIntValue(value) value == [NSNull null] ? 0 : [value integerValue]
#define JsonBoolValue(value) value == [NSNull null] ? NO : [value boolValue]
#define JsonStringValue(value) value == [NSNull null] ? nil : [NSString stringWithFormat:@"%@", value]
#define JsonValueIsNull(value) value == [NSNull null] || value == nil
#define JsonValueIsNotNull(value) value != [NSNull null] && value != nil

/** Hokutosai APIへリクエストを要求するクラス */
@interface HokutosaiApiRequestDemander : NSObject <NSURLSessionDelegate>

/** HokutosaiApiRequestDemanderのインスタンスを生成する */
- (id)initWithRequest:(HokutosaiApiRequest*)request;

/**
 * サーバーレスポンス(JSON)を非同期で取得する
 * @param receiveContent 正常にJSONコンテントを取得できた際に呼び出される。引数idはNSDictionaryまたはNSArray
 */
- (NSURLSessionTask*)responseAsync:(void(^)(id))receiveContent;

/**
 * サーバーレスポンス(JSON)を非同期で取得する
 * @param receiveContent 正常にJSONコンテントを取得できた際に呼び出される。引数idはNSDictionaryまたはNSArray
 * @param complete 正常/失敗問わず、完了時に呼び出される
 */
- (NSURLSessionTask*)responseAsync:(void(^)(id))receiveContent complete:(void(^)())complete;

/**
 * サーバーレスポンス(JSON)を非同期で取得する
 * @param receiveContent 正常にJSONコンテントを取得できた際に呼び出される。引数idはNSDictionaryまたはNSArray
 * @param errorHandler サーバーエラー時に呼び出される。引数NSIntegerはエラーコード。戻り値はエラーが処理された場合はYES、処理されなかった場合はNO
 */
- (NSURLSessionTask*)responseAsync:(void(^)(id))receiveContent receiveError:(BOOL(^)(NSInteger))errorHandler;

/**
 * サーバーレスポンス(JSON)を非同期で取得する
 * @param receiveContent 正常にJSONコンテントを取得できた際に呼び出される。引数idはNSDictionaryまたはNSArray
 * @param errorHandler サーバーエラー時に呼び出される。引数NSIntegerはエラーコード。戻り値はエラーが処理された場合はYES、処理されなかった場合はNO
 * @param complete 正常/失敗問わず、完了時に呼び出される
 */
- (NSURLSessionTask*)responseAsync:(void(^)(id))receiveContent receiveError:(BOOL(^)(NSInteger))errorHandler complete:(void(^)())complete;


/** Hokutosai APIが識別するサーバーエラーのハンドラー */
- (void)serverErrorHandler:(NSInteger)errorCode;

@end
