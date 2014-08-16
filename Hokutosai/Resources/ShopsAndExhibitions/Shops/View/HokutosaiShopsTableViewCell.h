//
//  HokutosaiShopsTableViewCell.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/06.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HokutosaiShopsTableViewCell : UITableViewCell

// セルの高さを取得する
+ (CGFloat)height;

// 模擬店イラスト
- (void)updateShopImage:(UIImage*)image url:(NSString*)url;

// 模擬店名
- (void)setShopName:(NSString*)shopName;

// 出店者
- (void)setTenant:(NSString*)tenant;

// 主な販売商品
- (void)setSales:(NSString*)sales;

// 一括設定
- (void)updateShopDataWithShopName:(NSString*)shopName tenant:(NSString*)tenant sales:(NSString*)sales imageResource:(NSString*)url;

@end
