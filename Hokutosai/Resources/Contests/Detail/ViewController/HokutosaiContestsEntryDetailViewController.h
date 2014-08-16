//
//  HokutosaiContestsEntryDetailViewController.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/11.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HokutosaiViewControllerProtocol.h"
#import "HokutosaiURLImagesDictionary.h"

@interface HokutosaiContestsEntryDetailViewController : UITableViewController <HokutosaiViewControllerProtocol>

- (void)setEntryData:(NSDictionary*)data imageCache:(HokutosaiURLImagesDictionary*)cache title:(NSString*)title;
@end
