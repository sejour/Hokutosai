//
//  HokutosaiURLImagesCache.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/27.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiURLImagesCache.h"
#import "HokutosaiURLImageDownloader.h"

@interface HokutosaiURLImagesCache ()
{
    NSCache *_imagesCache;
}

@end

@implementation HokutosaiURLImagesCache

- (id)init
{
    self = [super init];
    if (self) {
        _imagesCache = [[NSCache alloc] init];
    }
    return self;
}

- (id)initWithCountLimit:(NSUInteger)limit
{
    self = [super init];
    if (self) {
        _imagesCache = [[NSCache alloc] init];
        _imagesCache.countLimit = limit;
    }
    return self;
}

- (id)initWithTotalCostLimit:(NSUInteger)limit
{
    self = [super init];
    if (self) {
        _imagesCache = [[NSCache alloc] init];
        _imagesCache.totalCostLimit = limit;
    }
    return self;
}

- (void)setCountLimit:(NSUInteger)countLimit
{
    [_imagesCache setCountLimit:countLimit];
}

- (NSUInteger)getCountLimit
{
    return _imagesCache.countLimit;
}

- (void)setTotalCostLimit:(NSUInteger)totalCostLimit
{
    [_imagesCache setTotalCostLimit:totalCostLimit];
}

- (NSUInteger)getTotalCostLimit
{
    return _imagesCache.totalCostLimit;
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
    UIImage *cachedImage = [_imagesCache objectForKey:url];
    
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
        if (downloadedImage) {
            [_imagesCache setObject:downloadedImage forKey:url];
        }
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
