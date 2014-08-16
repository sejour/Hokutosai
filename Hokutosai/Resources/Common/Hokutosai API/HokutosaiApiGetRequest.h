//
//  HokutosaiApiGetRequest.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/10.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HokutosaiApiRequest.h"
#import "HokutosaiApiRequestParameters.h"

// Hokutosai API のGETメソッドから成るリクエスト
@interface HokutosaiApiGetRequest : HokutosaiApiRequest

// 指定したURLで Hokutosai API のGETリクエストを生成する
+ (id)requestWithURL:(NSURL *)URL;

// 指定したエンドポイントパスで Hokutosai API のGETリクエストを生成する
+ (id)requestWithEndpointPath:(NSString*)endpointPath;

// 指定したエンドポイントパスとURLクエリパラメータで Hokutosai API のGETリクエストを生成する
+ (id)requestWithEndpointPath:(NSString *)endpointPath queryParameters:(HokutosaiApiRequestParameters*)queryParams;

@end
