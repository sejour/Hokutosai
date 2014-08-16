//
//  HokutosaiURLImagesDictionary.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>

/** URLイメージを半永久キャッシュするディクショナリ */
@interface HokutosaiURLImagesDictionary : NSObject

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
