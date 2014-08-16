//
//  HokutosaiExhibitionDetailViewController.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/07.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HokutosaiViewControllerProtocol.h"
#import "HokutosaiURLImagesDictionary.h"

@interface HokutosaiExhibitionDetailViewController : UITableViewController <HokutosaiViewControllerProtocol>

- (void)setExhibitionData:(NSDictionary*)data imageCache:(HokutosaiURLImagesDictionary*)cache requireReload:(BOOL)reload;

@end
