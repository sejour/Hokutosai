//
//  HokutosaiUIColor.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiUIColor.h"

@implementation HokutosaiUIColor

// RGBカラーを整数値で指定してUIColorを取得する
+ (UIColor*) colorWithRed:(int)r green:(int)g blue:(int)b
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

// ARGBカラーを整数値で指定してUIColorを取得する
+ (UIColor*) colorWithRed:(int)r green:(int)g blue:(int)b alpha:(int)a
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

// 高専イエロー
+ (UIColor*) tnctYellowColor
{
    return [UIColor colorWithRed:235/255.0 green:190/255.0 blue:35/255.0 alpha:1.0];
}

// 高専グリーン
+ (UIColor*) tnctGreenColor
{
    return [UIColor colorWithRed:130/255.0 green:180/255.0 blue:75/255.0 alpha:1.0];
}

// 高専ブルー
+ (UIColor*) tnctBlueColor
{
    return [UIColor colorWithRed:40/255.0 green:95/255.0 blue:170/255.0 alpha:1.0];
}

// 北斗祭カラー
+ (UIColor*) hokutosaiColor
{
    return [UIColor colorWithRed:1.0 green:130/255.0 blue:0.0 alpha:1.0];
}

// 北斗祭カラー (アルファ値指定)
+ (UIColor*) hokutosaiColorWithAlpha:(NSInteger)alpha
{
    return [UIColor colorWithRed:1.0 green:130/255.0 blue:0.0 alpha:alpha/255.0];
}

// 北斗祭カラー (控えめ)
+ (UIColor*) hokutosaiColorModest
{
    return [UIColor colorWithRed:1.0 green:150/255.0 blue:60/255.0 alpha:1.0];
}

@end
