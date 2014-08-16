//
//  HokutosaiTimer.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/19.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>

// タイマー
@interface HokutosaiTimer : NSObject

// タイマーが開始されているかどうか
@property (nonatomic, readonly, getter = getIsActive) BOOL isActive;

- (id)initWithTimeInterval:(NSInteger)interval target:(id)target selector:(SEL)sel;
- (id)initWithTimeInterval:(NSInteger)interval target:(id)target selector:(SEL)sel repeats:(BOOL)repeats;

// タイマー開始
- (void)start;
// タイマー終了
- (void)stop;
// リスタート
- (void)restart;

@end
