//
//  HokutosaiShopsAssessByMeView.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/17.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HokutosaiShopsAssessByMeViewDelegate <NSObject>

@required

// 評価を実行する
// score: 評価するスコア
// previousScore: 前回の評価
- (void)assesse:(NSInteger)score previousScore:(NSInteger)previousScore;

@end

// 模擬店の自分の評価のビュー
@interface HokutosaiShopsAssessByMeView : UIView <UIAlertViewDelegate>

// デリゲート
@property (nonatomic, weak) id <HokutosaiShopsAssessByMeViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame starFillIcon:(UIImage *)fillIcon starFrameIcon:(UIImage *)frameIcon;

// スコアを設定する
- (void)setScore:(NSInteger)score;

// 模擬店名を設定する
- (void)setShopName:(NSString*)name;

@end
