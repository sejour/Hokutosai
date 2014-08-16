//
//  HokutosaiShopsMenuItem.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/16.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiShopsMenuItem.h"

@interface HokutosaiShopsMenuItem ()

- (void)commonInitWithItemName:(NSString *)itemName price:(NSInteger)price;

@end

@implementation HokutosaiShopsMenuItem

- (id)initWithFrame:(CGRect)frame itemName:(NSString *)itemName price:(NSInteger)price
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInitWithItemName:itemName price:price];
        
    }
    return self;
}

- (void)commonInitWithItemName:(NSString *)itemName price:(NSInteger)price
{
    // フォントサイズ
    static NSInteger fontSize = 15;
    
    // 基準となる座標を取得
    CGFloat selfWith = self.frame.size.width;
    CGFloat selfWithDiv = selfWith/6.0;
    
    // アイテム名ラベル
    CGRect itemNameLabelFrame;
    itemNameLabelFrame.origin = CGPointMake(0, 0);
    itemNameLabelFrame.size = CGSizeMake(selfWith - selfWithDiv, self.frame.size.height);
    
    UILabel *itemNameLabel = [[UILabel alloc] initWithFrame:itemNameLabelFrame];
    itemNameLabel.text = itemName;
    itemNameLabel.font = [UIFont systemFontOfSize:fontSize];
    itemNameLabel.textAlignment = NSTextAlignmentLeft;
    [itemNameLabel sizeToFit];
    [self addSubview:itemNameLabel];
    
    // 価格ラベル
    CGRect priceLabelFrame;
    priceLabelFrame.origin = CGPointMake(itemNameLabelFrame.size.width, itemNameLabel.frame.origin.y);
    priceLabelFrame.size = CGSizeMake(selfWithDiv, itemNameLabel.frame.size.height);
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:priceLabelFrame];
    priceLabel.text = [NSString stringWithFormat:@"%d円", (int)price];
    priceLabel.font = [UIFont systemFontOfSize:fontSize];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:priceLabel];
    
    // 自身のフレームを更新
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, itemNameLabel.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
