//
//  HokutosaiContestsEntrysTableViewCell.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/10.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HokutosaiContestsEntrysTableViewCell : UITableViewCell

// セルの高さを取得する
+ (CGFloat)height;

// 属性値を更新する
// 優勝していれなければchampionIconはnilを、イラストが無ければimageURLをnilに設定する
- (void)updateSection:(NSString*)section entryName:(NSString*)name belong:(NSString*)belong championIcon:(UIImage*)championIcon illustrationImageResource:(NSString*)imageURL;

// イラストを設定する
- (void)updateIllustrationImage:(UIImage*)image url:(NSString*)url;

@end
