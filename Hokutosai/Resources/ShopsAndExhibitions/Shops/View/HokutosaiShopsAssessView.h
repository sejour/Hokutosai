//
//  HokutosaiShopsAssessView.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/07.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HokutosaiStackPanelView.h"
#import "HokutosaiShopsAssessByMeView.h"

@interface HokutosaiShopsAssessView : HokutosaiStackPanelView

- (id)initWithFrame:(CGRect)frame shopName:(NSString*)shopName delegate:(id <HokutosaiShopsAssessByMeViewDelegate>)delegate;

// みんなの評価を設定する
- (void)setAssessByEvery:(NSInteger)lank assessedCount:(NSInteger)count;

// 自分の評価を設定する
- (void)setAssessByMe:(NSInteger)lank;

@end
