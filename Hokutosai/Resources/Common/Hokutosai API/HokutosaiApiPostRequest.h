//
//  HokutosaiApiPostRequest.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/10.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HokutosaiApiRequest.h"
#import "HokutosaiApiRequestParameters.h"

// Hokutosai API のPOSTメソッドから成るリクエスト
@interface HokutosaiApiPostRequest : HokutosaiApiRequest

// 指定したURLで Hokutosai API のPOSTリクエストを生成する
+ (id)requestWithURL:(NSURL *)URL;

// 指定したエンドポイントパスで Hokutosai API のPOSTリクエストを生成する
+ (id)requestWithEndpointPath:(NSString*)endpointPath;

// 指定したエンドポイントパスとURLクエリパラメータで Hokutosai API のPOSTリクエストを生成する
+ (id)requestWithEndpointPath:(NSString *)endpointPath queryParameters:(HokutosaiApiRequestParameters*)queryParams;

@end
