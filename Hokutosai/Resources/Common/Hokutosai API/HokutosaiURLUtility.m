//
//  HokutosaiURLUtility.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/10.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiURLUtility.h"

@implementation HokutosaiURLUtility

// UTF-8でURLパーセントエンコードを行う
+ (NSString*)urlEncode:(NSString*)plainString
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) plainString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

// UTF-8でURLパーセントデコードを行う
+ (NSString*)urlDecode:(NSString*)encodedString
{
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)encodedString, CFSTR(""), kCFStringEncodingUTF8);
}

@end
