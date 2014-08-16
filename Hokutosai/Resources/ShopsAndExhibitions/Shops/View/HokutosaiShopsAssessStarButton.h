//
//  HokutosaiShopsAssessStarButton.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/17.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HokutosaiShopsAssessStarButton : UIButton

- (id)initWithFrame:(CGRect)frame starFillIcon:(UIImage*)fillIcon starFrameIcon:(UIImage*)frameIcon;

// 星のON/OFFを設定する
- (void)starIsOn:(BOOL)on;

@end
