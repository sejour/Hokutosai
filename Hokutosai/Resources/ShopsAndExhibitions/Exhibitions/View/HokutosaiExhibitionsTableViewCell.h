//
//  HokutosaiExhibitionsTableViewCell.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/13.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HokutosaiExhibitionsTableViewCell : UITableViewCell

// セルの高さを取得する
+ (CGFloat)height;

// 展示イラスト
- (void)updateExhibitionImage:(UIImage*)image url:(NSString*)url;

// 展示のタイトル
- (void)setExhibitionTitle:(NSString*)title;

// 主な展示物
- (void)setDisplays:(NSString*)displays;

// 場所
- (void)setPlace:(NSString*)place;

// 一括設定
- (void)updateExhibitionDataWithTitle:(NSString*)title displays:(NSString*)displays place:(NSString*)place imageResource:(NSString*)url;

@end
