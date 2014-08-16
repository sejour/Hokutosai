//
//  HokutosaiContestsEntrysListViewController.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/11.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HokutosaiViewControllerProtocol.h"

@interface HokutosaiContestsEntrysListViewController : UITableViewController <HokutosaiViewControllerProtocol>

- (void)setSectionId:(NSString*)sectionId sectionName:(NSString*)sectionName;
@end
