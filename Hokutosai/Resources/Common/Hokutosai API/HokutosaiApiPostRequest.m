//
//  HokutosaiApiPostRequest.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/10.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiApiPostRequest.h"
#import "HokutosaiURLUtility.h"

static NSString* hokutosaiApiResourceRoot = @"https://api.tnct-hokutosai.info/2014/";
static NSString* apiCredentials = @"ApiCredentials user_id=client_public,key_token=r5D2E2bopV302rlO4Tn2d1H8tXl56gP1";

@implementation HokutosaiApiPostRequest

// 指定したURLで Hokutosai API のPOSTリクエストを生成する
+ (id)requestWithURL:(NSURL *)URL
{
    // リクエスト生成
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    // GETメソッドを指定
    [request setHTTPMethod:@"POST"];
    
    // 資格情報付加
    [request addValue:apiCredentials forHTTPHeaderField:@"Authorization"];
    
    return request;
}

// 指定したエンドポイントパスで Hokutosai API のPOSTリクエストを生成する
+ (id)requestWithEndpointPath:(NSString *)endpointPath
{
    // URL生成
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", hokutosaiApiResourceRoot, endpointPath]];
    
    return [HokutosaiApiPostRequest requestWithURL:url];
}

// 指定したエンドポイントパスとURLクエリパラメータで Hokutosai API のPOSTリクエストを生成する
+ (id)requestWithEndpointPath:(NSString *)endpointPath queryParameters:(HokutosaiApiRequestParameters *)queryParams
{
    NSMutableString *contentBody = [NSMutableString stringWithCapacity:16];
    BOOL first = YES;
    
    // パラメータディクショナリ取得
    NSDictionary *params = queryParams.params;
    
    // コンテントボディ生成
    for (NSString* key in params) {
        if (first) {
            [contentBody appendFormat:@"%@=%@", key, [HokutosaiURLUtility urlEncode:params[key]]];
            first = NO;
        } else {
            [contentBody appendFormat:@"&%@=%@", key, [HokutosaiURLUtility urlEncode:params[key]]];
        }
    }
    
    // コンテントデータ生成
    NSData *contentData = [contentBody dataUsingEncoding:NSASCIIStringEncoding];
    
    // URL生成
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", hokutosaiApiResourceRoot, endpointPath]];
    
    // リクエスト生成
    HokutosaiApiPostRequest *request = [HokutosaiApiPostRequest requestWithURL:url];
    
    // コンテントデータ設定
    [request setHTTPBody:contentData];
    
    return request;
}

@end

