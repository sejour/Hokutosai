//
//  HokutosaiShopsMenuItem.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/16.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模擬店のメニューアイテムビュー
@interface HokutosaiShopsMenuItem : UIView

- (id)initWithFrame:(CGRect)frame itemName:(NSString*)itemName price:(NSInteger)price;

@end
