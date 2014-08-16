//
//  HokutosaiApiRequestDemander.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/13.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiApiRequestDemander.h"

@interface HokutosaiApiRequestDemander ()
{
    HokutosaiApiRequest *_request;
}

// 通信エラー時
- (void)connectionError:(NSError*)error;

// Hokutosai APIが識別しないエラー
- (void)noDistinctServerError;

// NSDataからJSONオブジェクトへ変換する
- (id)jsonFromData:(NSData*)data;

@end

@implementation HokutosaiApiRequestDemander

- (id)initWithRequest:(HokutosaiApiRequest*)request
{
    self = [super init];
    
    if (self) {
        // リクエスト設定
        _request = request;
    }
    
    return self;
}

- (void)connectionError:(NSError*)error
{
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"サーバーにアクセスできません。" message:@"しばらくしてからもう一度アクセスし直してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
}

- (void)noDistinctServerError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"サーバーにアクセスできません。" message:@"しばらくしてからもう一度アクセスし直してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (id)jsonFromData:(NSData *)data
{
    NSError *jsonError = nil;
    
    id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    
    if (jsonError != nil) {
        return nil;
    }
    
    return jsonResponse;
}

// サーバーレスポンスを非同期で取得する
// (void (^)(id))receiveContent:
//   正常にJSONコンテントを取得できた際に呼び出される。
//   引数idはNSDictionaryまたはNSArray
- (NSURLSessionTask*)responseAsync:(void (^)(id))receiveContent
{
    return [self responseAsync:receiveContent complete:nil];
}

- (NSURLSessionTask*)responseAsync:(void (^)(id))receiveContent complete:(void (^)())complete
{
    // セッション生成
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // タスク生成
    NSURLSessionTask *task = [session dataTaskWithRequest:_request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            
                                            if (error) {
                                                [self connectionError:error];
                                            }
                                            else {
                                                // JSONコンテントを取得
                                                id jsonContent = [self jsonFromData:data];
                                                
                                                // HTTPレスポンスを取得
                                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                                
                                                // サーバーエラー
                                                if (httpResponse.statusCode >= 400) {
                                                    // APIが識別するエラー
                                                    if(jsonContent) {
                                                        [self serverErrorHandler:[jsonContent[@"error"] integerValue]];
                                                    }
                                                    // APIが識別しないエラー
                                                    else {
                                                        [self noDistinctServerError];
                                                    }
                                                }
                                                // サクセス
                                                else {
                                                    if (jsonContent) {
                                                        receiveContent(jsonContent);
                                                    }
                                                }
                                            }
                                            
                                            // 完了時
                                            if (complete != nil) {
                                                complete();
                                            }
                                            
                                            // 終了処理
                                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                            [session invalidateAndCancel];
                                            
                                        }];
    
    // インジケータオン
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // タスク実行
    [task resume];
    
    return task;
}

// サーバーレスポンスを非同期で取得する
// (void (^)(id))receiveContent:
//   正常にJSONコンテントを取得できた際に呼び出される。
//   引数idはNSDictionaryまたはNSArray
// (BOOL (^)(NSDictionary *))errorHandler:
//   サーバーエラー時に呼び出される。
//   引数NSIntegerはエラーコード
//   戻り値はエラーが処理された場合はYES、処理されなかった場合はNO
- (NSURLSessionTask*)responseAsync:(void (^)(id))receiveContent receiveError:(BOOL (^)(NSInteger))errorHandler
{
    return [self responseAsync:receiveContent receiveError:errorHandler complete:nil];
}

- (NSURLSessionTask*)responseAsync:(void (^)(id))receiveContent receiveError:(BOOL (^)(NSInteger))errorHandler complete:(void (^)())complete
{
    // セッション生成
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // タスク生成
    NSURLSessionTask *task = [session dataTaskWithRequest:_request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            
                                            if (error) {
                                                [self connectionError:error];
                                            }
                                            else {
                                                // JSONコンテントを取得
                                                id jsonContent = [self jsonFromData:data];
                                                
                                                // HTTPレスポンスを取得
                                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                                
                                                // サーバーエラー
                                                if (httpResponse.statusCode >= 400) {
                                                    // APIが識別するエラー
                                                    if(jsonContent) {
                                                        NSInteger errorCode = [jsonContent[@"error"] integerValue];
                                                        if (!errorHandler(errorCode)) {
                                                            [self serverErrorHandler:errorCode];
                                                        }
                                                    }
                                                    // APIが識別しないエラー
                                                    else {
                                                        [self noDistinctServerError];
                                                    }
                                                }
                                                // サクセス
                                                else {
                                                    if (jsonContent) {
                                                        receiveContent(jsonContent);
                                                    }
                                                }
                                            }
                                            
                                            // 完了時
                                            if (complete != nil) {
                                                complete();
                                            }
                                            
                                            // 終了処理
                                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                            [session invalidateAndCancel];
                                            
                                        }];
    
    // インジケータオン
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // タスク実行
    [task resume];
    
    return task;
}

- (void)serverErrorHandler:(NSInteger)errorCode
{
    switch (errorCode) {
        case 40100:
            [[[UIAlertView alloc] initWithTitle:@"権限がありません。" message:@"サーバーにアクセスする権限がありません。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
        case 40300:
            [[[UIAlertView alloc] initWithTitle:@"サーバーにアクセスできません。" message:@"リクエストが拒否されました。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
        case 40302:
            [[[UIAlertView alloc] initWithTitle:@"一時的にサーバーにアクセスできません。" message:@"しばらくしてからもう一度アクセスし直してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
        case 40303:
            [[[UIAlertView alloc] initWithTitle:@"メンテナンス中です。" message:@"しばらくしてからもう一度アクセスし直してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
        case 40304:
            [[[UIAlertView alloc] initWithTitle:@"メンテナンス中です。" message:@"しばらくしてからもう一度アクセスし直してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
        case 40401:
            break;
        case 50300:
            [[[UIAlertView alloc] initWithTitle:@"メンテナンス中です。" message:@"しばらくしてからもう一度アクセスし直してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
        default:
            NSLog(@"Hokutosai API Error [Code:%d]", (int)errorCode);
            [[[UIAlertView alloc] initWithTitle:@"サーバーにアクセスできません。" message:@"しばらくしてからもう一度アクセスし直してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
    }
}

@end
