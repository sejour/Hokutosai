//
//  HokutosaiShopsAndExhibitionsViewController.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HokutosaiViewControllerProtocol.h"
#import "HokutosaiSwipeView.h"

@interface HokutosaiShopsAndExhibitionsViewController : UIViewController <HokutosaiViewControllerProtocol, HokutosaiSwipeViewDelegate, UITableViewDelegate, UITableViewDataSource>

@end
