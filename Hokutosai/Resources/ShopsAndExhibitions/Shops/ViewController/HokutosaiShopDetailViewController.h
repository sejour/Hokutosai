//
//  HokutosaiShopDetailViewController.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/07.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HokutosaiViewControllerProtocol.h"
#import "HokutosaiURLImagesDictionary.h"
#import "HokutosaiShopsAssessByMeView.h"

@interface HokutosaiShopDetailViewController : UITableViewController <HokutosaiViewControllerProtocol, HokutosaiShopsAssessByMeViewDelegate>

// 模擬店のデータを設定する
- (void)setShopData:(NSDictionary*)data imagesCache:(HokutosaiURLImagesDictionary*)cache;

@end
