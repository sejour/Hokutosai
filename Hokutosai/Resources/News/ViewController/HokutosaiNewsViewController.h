//
//  HokutosaiNewsViewController.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HokutosaiViewControllerProtocol.h"
#import "HokutosaiSwipeView.h"

@interface HokutosaiNewsViewController : UIViewController <HokutosaiViewControllerProtocol, HokutosaiSwipeViewDelegate, UITableViewDelegate, UITableViewDataSource>

/** コンテンツを更新する。(非同期) */
- (void)updateContents;

/**
 * コンテンツを更新する。(非同期)
 * @param complete 更新が完了した際に呼び出される。
 */
- (void)updateContentsWithComplete:(void(^)())complete;

@end
