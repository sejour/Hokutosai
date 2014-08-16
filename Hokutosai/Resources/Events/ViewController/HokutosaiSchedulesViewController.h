//
//  HokutosaiSchedulesViewController.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/30.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HokutosaiViewControllerProtocol.h"

@interface HokutosaiSchedulesViewController : UIViewController <HokutosaiViewControllerProtocol>

// スケジュールビューコントローラーを最新の状態にする
- (void)updateSchedulesViewController;

// 指定した日時に指定したイベントが開催されているかどうかを調べる
+ (BOOL)theEventBeingHeld:(NSDictionary*)event at:(NSDate*)date;

@end
