//
//  HokutosaiSwipeBord.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiSwipeView.h"

// スワイプでコンテンツを移動するボードビュー (コンテンツはループする)
@interface HokutosaiSwipeBord : HokutosaiSwipeView

// ダミーの先頭ページの矩形領域を取得する
- (CGRect)frameOfDummyFirst;

// ダミーの最後尾ページの矩形領域を取得する
- (CGRect)frameOfDummyLast;

@end
