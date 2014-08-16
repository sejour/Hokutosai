//
//  HokutosaiContestsTableViewCell.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/11.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HokutosaiContestsTableViewCell : UITableViewCell

// データ更新
- (void)updateContestName:(NSString*)name detail:(NSString*)detail;

// 高さ
+ (CGFloat)heightWithDetail:(NSString*)detail;

@end
