//
//  HokutosaiURLImagesDictionary.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiURLImagesDictionary.h"
#import "HokutosaiURLImageDownloader.h"

@interface HokutosaiURLImagesDictionary ()
{
    NSMutableDictionary *_imagesCache;
}

@end

@implementation HokutosaiURLImagesDictionary

- (id)init
{
    self = [super init];
    if (self) {
        _imagesCache = [NSMutableDictionary dictionaryWithCapacity:16];
    }
    return self;
}

- (void)imageWithURL:(NSString *)url receive:(void (^)(UIImage *))receive
{
    [self imageWithURL:url receive:receive asyncComplete:nil];
}

- (void)imageWithURL:(NSString*)url receive:(void (^)(UIImage *))receive asyncComplete:(void(^)())asyncComplete
{
    // URLがnilであればnilを返す
    if (url == nil) {
        receive(nil);
        return;
    }
    
    // キャッシュを取り出す
    UIImage *cachedImage = _imagesCache[url];
    
    // キャッシュされていればキャッシュ画像を使用
    if (cachedImage) {
        receive(cachedImage);
        return;
    }
    
    // イメージがキャッシュされていなければダウンロード
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    HokutosaiURLImageDownloader *downloader = [[HokutosaiURLImageDownloader alloc] initWithRequest:request];
    
    // 非同期ダウンロード開始
    [downloader downloadAsync:^(UIImage* downloadedImage) {
        // キャッシュ
        [_imagesCache setValue:downloadedImage forKey:url];
        // ダウンロードした画像を使用
        receive(downloadedImage);
        
        // 非同期ダウンロード完了時の処理
        if (asyncComplete != nil) {
            asyncComplete();
        }
    }];
}

- (void)removeImageWithURL:(NSString *)url
{
    [_imagesCache removeObjectForKey:url];
}

- (void)clearCashe
{
    [_imagesCache removeAllObjects];
}

@end

