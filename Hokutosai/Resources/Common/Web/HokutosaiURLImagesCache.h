//
//  HokutosaiURLImagesCache.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/27.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Webからダウンロードした画像のキャッシュを行う **/
@interface HokutosaiURLImagesCache : NSObject

/** キャッシュを行う上限数 **/
@property (nonatomic, setter = setCountLimit:, getter = getCountLimit) NSUInteger countLimit;

/** キャッシュを行う上限容量 **/
@property (nonatomic, setter = setTotalCostLimit:, getter = getTotalCostLimit) NSUInteger totalCostLimit;

/** キャッシュを行う上限数を設定して初期化する */
- (id)initWithCountLimit:(NSUInteger)limit;

/** キャッシュを行う上限容量を設定して初期化する */
- (id)initWithTotalCostLimit:(NSUInteger)limit;

/**
 *   画像を取得する。
 * @param url 画像のURL。nilを指定した場合、recieveで渡されるUIImageはnilとなる。
 * @param receive キャッシュされていた場合はキャッシュ画像を得る。キャッシュされていなかった場合は非同期ダウンロードで画像を得る。(ダウンロードされた画像は自動キャッシュされる。)
 */
- (void)imageWithURL:(NSString*)url receive:(void(^)(UIImage*))receive;

/**
 *   画像を取得する。
 * @param url 画像のURL。nilを指定した場合、recieveで渡されるUIImageはnilとなる。
 * @param receive キャッシュされていた場合はキャッシュ画像を得る。キャッシュされていなかった場合は非同期ダウンロードで画像を得る。(ダウンロードされた画像は自動キャッシュされる。)
 * @param asyncComplete 非同期で画像をダウンロードした際の完了処理
 */
- (void)imageWithURL:(NSString*)url receive:(void(^)(UIImage*))receive asyncComplete:(void(^)())asyncComplete;

/** 指定したURLの画像のキャッシュを削除する **/
- (void)removeImageWithURL:(NSString*)url;

/** キャッシュをクリアする **/
- (void)clearCashe;

@end
