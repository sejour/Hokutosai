//
//  HokutosaiEventsDetailViewController.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HokutosaiViewControllerProtocol.h"

@interface HokutosaiEventsDetailViewController : UITableViewController <HokutosaiViewControllerProtocol, UIAlertViewDelegate>

// イベントデータを設定する
- (void)setEventData:(NSDictionary*)data requireReload:(BOOL)reload;
@end
