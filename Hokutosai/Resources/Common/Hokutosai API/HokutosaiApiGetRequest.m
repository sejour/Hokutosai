//
//  HokutosaiApiGetRequest.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/10.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiApiGetRequest.h"
#import "HokutosaiURLUtility.h"

static NSString* hokutosaiApiResourceRoot = @"https://api.tnct-hokutosai.info/2014/";
static NSString* apiCredentials = @"ApiCredentials user_id=client_public,key_token=r5D2E2bopV302rlO4Tn2d1H8tXl56gP1";

@implementation HokutosaiApiGetRequest

// 指定したURLで Hokutosai API のGETリクエストを生成する
+ (id)requestWithURL:(NSURL *)URL
{
    // リクエスト生成
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    // GETメソッドを指定
    [request setHTTPMethod:@"GET"];
    
    // 資格情報付加
    [request addValue:apiCredentials forHTTPHeaderField:@"Authorization"];
    
    return request;
}

// 指定したエンドポイントパスで Hokutosai API のGETリクエストを生成する
+ (id)requestWithEndpointPath:(NSString *)endpointPath
{
    // URL生成
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", hokutosaiApiResourceRoot, endpointPath]];
    
    return [HokutosaiApiGetRequest requestWithURL:url];
}

// 指定したエンドポイントパスとURLクエリパラメータで Hokutosai API のGETリクエストを生成する
+ (id)requestWithEndpointPath:(NSString *)endpointPath queryParameters:(HokutosaiApiRequestParameters *)queryParams
{
    NSMutableString *urlQuery = [NSMutableString stringWithCapacity:16];
    BOOL first = YES;
    
    // パラメータディクショナリ取得
    NSDictionary *params = queryParams.params;
    
    // URLクエリ生成
    for (NSString* key in params) {
        if (first) {
            [urlQuery appendFormat:@"?%@=%@", key, [HokutosaiURLUtility urlEncode:params[key]]];
            first = NO;
        } else {
            [urlQuery appendFormat:@"&%@=%@", key, [HokutosaiURLUtility urlEncode:params[key]]];
        }
    }
    
    // URL生成
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", hokutosaiApiResourceRoot, endpointPath, urlQuery]];
    
    return [HokutosaiApiGetRequest requestWithURL:url];
}

@end
