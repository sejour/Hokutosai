//
//  HokutosaiURLImageDownloader.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/27.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiURLImageDownloader.h"

@interface HokutosaiURLImageDownloader ()
{
    NSURLRequest *_request;
}

@end

@implementation HokutosaiURLImageDownloader

- (id)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    
    if (self) {
        // リクエスト設定
        _request = request;
    }
    
    return self;
}

- (NSURLSessionTask*)downloadAsync:(void (^)(UIImage *))receiveData
{
    // セッション生成
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // タスク生成
    NSURLSessionTask *task = [session dataTaskWithRequest:_request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            
                                            if (error == nil) {
                                                // HTTPレスポンスを取得
                                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                                
                                                if (httpResponse.statusCode < 400) {
                                                    // レスポンスデータからイメージを生成
                                                    UIImage *image = [[UIImage alloc] initWithData:data];
                                                    // 受信処理
                                                    receiveData(image);
                                                }
                                            }
                                            
                                            // 終了処理
                                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                            [session invalidateAndCancel];
                                            
                                        }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [task resume];
    
    return task;
}

- (NSURLSessionTask*)downloadAsync:(void (^)(UIImage *))receiveData errorHandler:(void (^)(NSInteger))errorHandler
{
    // セッション生成
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // タスク生成
    NSURLSessionTask *task = [session dataTaskWithRequest:_request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            
                                            if (error) {
                                                errorHandler(-1);
                                            } else {
                                                // HTTPレスポンスを取得
                                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                                
                                                if (httpResponse.statusCode >= 400) {
                                                    // エラー処理
                                                    errorHandler(httpResponse.statusCode);
                                                } else {
                                                    // レスポンスデータからイメージを生成
                                                    UIImage *image = [[UIImage alloc] initWithData:data];
                                                    // 受信処理
                                                    receiveData(image);
                                                }
                                            }
                                            
                                            // 終了処理
                                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                            [session invalidateAndCancel];
                                            
                                        }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [task resume];
    
    return task;
}

@end
