//
//  HokutosaiNewsDetailViewController.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/28.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HokutosaiViewControllerProtocol.h"
#import "HokutosaiURLImagesCache.h"

@interface HokutosaiNewsDetailViewController : UITableViewController <HokutosaiViewControllerProtocol>

- (void)setNewsData:(NSDictionary*)data imageCache:(HokutosaiURLImagesCache*)cache;
- (void)setNewsData:(NSDictionary *)data imageCache:(HokutosaiURLImagesCache *)cache rquireReload:(BOOL)reload;

@end
