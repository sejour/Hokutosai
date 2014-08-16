//
//  HokutosaiURLUtility.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/10.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>

// URLの操作機能を提供する
@interface HokutosaiURLUtility : NSObject

/** UTF-8でURLパーセントエンコードを行う */
+ (NSString*)urlEncode:(NSString*)plainString;

/** UTF-8でURLパーセントデコードを行う */
+ (NSString*)urlDecode:(NSString*)encodedString;


@end
