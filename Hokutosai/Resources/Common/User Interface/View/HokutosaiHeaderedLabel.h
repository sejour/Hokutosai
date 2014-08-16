//
//  HokutosaiHeaderedLabel.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/20.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiHeaderedContentView.h"

@interface HokutosaiHeaderedLabel : HokutosaiHeaderedContentView

// コンテントテキスト
@property (nonatomic, weak) NSString* contentText;

// コンテントフォントサイズ
@property (nonatomic) CGFloat contentFontSize;

// コンテントの行数
@property (nonatomic) NSInteger numberOfContentLines;

@end
