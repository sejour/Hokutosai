//
//  HokutosaiURLImageDownloader.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/27.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Web上のイメージをダウンロードする */
@interface HokutosaiURLImageDownloader : NSObject <NSURLSessionDelegate>

/** リクエストを設定して初期化 */
- (id)initWithRequest:(NSURLRequest*)request;

/**
 *  画像を非同期でダウンロードする
 * @param receiveData 正常にイメージを取得できた際に呼び出される。
 */
- (NSURLSessionTask*)downloadAsync:(void(^)(UIImage*))receiveData;

/** 画像を非同期でダウンロードする
 * @param receiveData 正常にイメージを取得できた際に呼び出される。
 * @param errorHandler サーバーエラー時に呼び出される。引数NSIntegerはHTTPステータスコード
 */
- (NSURLSessionTask*)downloadAsync:(void(^)(UIImage*))receiveData errorHandler:(void(^)(NSInteger))errorHandler;

@end
