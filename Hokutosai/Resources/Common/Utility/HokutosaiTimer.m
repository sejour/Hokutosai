//
//  HokutosaiTimer.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/19.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiTimer.h"

@interface HokutosaiTimer ()
{
    NSInteger _interval;
    id _target;
    SEL _selector;
    BOOL _repeats;
    
    NSTimer *timer;
}

@end

@implementation HokutosaiTimer

- (id)initWithTimeInterval:(NSInteger)interval target:(id)target selector:(SEL)sel
{
    return [self initWithTimeInterval:interval target:target selector:sel repeats:YES];
}

- (id)initWithTimeInterval:(NSInteger)interval target:(id)target selector:(SEL)sel repeats:(BOOL)repeats
{
    self = [super init];
    
    if (self) {
        _interval = interval;
        _target = target;
        _selector = sel;
        _repeats = repeats;
    }
    
    return self;
}

- (BOOL)getIsActive
{
    return timer != nil;
}

// タイマー開始
- (void)start
{
    if (timer) {
        return;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:_target selector:_selector userInfo:nil repeats:_repeats];
}

// タイマー終了
- (void)stop
{
    if (timer == nil) {
        return;
    }
    
    [timer invalidate];
    timer = nil;
}

// リスタート
- (void)restart
{
    if (timer) {
        // 終了
        [timer invalidate];
        timer = nil;
    }
    
    // 起動
    timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:_target selector:_selector userInfo:nil repeats:_repeats];
}

@end
