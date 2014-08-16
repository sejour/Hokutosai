//
//  HokutosaiUIColor.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HokutosaiUIColor : UIColor

// RGBカラーを整数値で指定してUIColorを取得する
+ (UIColor*) colorWithRed:(int)r green:(int)g blue:(int)b;

// ARGBカラーを整数値で指定してUIColorを取得する
+ (UIColor*) colorWithRed:(int)r green:(int)g blue:(int)b alpha:(int)a;

// 高専イエロー
+ (UIColor*) tnctYellowColor;

// 高専グリーン
+ (UIColor*) tnctGreenColor;

// 高専ブルー
+ (UIColor*) tnctBlueColor;

// 北斗祭カラー
+ (UIColor*) hokutosaiColor;

// 北斗祭カラー (アルファ値指定)
+ (UIColor*) hokutosaiColorWithAlpha:(NSInteger)alpha;

// 北斗祭カラー (控えめ)
+ (UIColor*) hokutosaiColorModest;

@end