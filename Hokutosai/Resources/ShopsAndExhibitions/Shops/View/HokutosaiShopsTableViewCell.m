//
//  HokutosaiShopsTableViewCell.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/06.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiShopsTableViewCell.h"

@interface HokutosaiShopsTableViewCell ()
{
    NSString *_imageResource;
}

@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenantLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;

@end

@implementation HokutosaiShopsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

// セルの高さを取得する
+ (CGFloat)height
{
    return 75.0;
}

// 模擬店イラスト
- (void)updateShopImage:(UIImage *)image url:(NSString *)url
{
    // URLが一致すればイメージを設定
    if ([_imageResource isEqualToString:url]) {
        _shopImage.image = image;
    }
}

// 模擬店名
- (void)setShopName:(NSString*)shopName
{
    _shopNameLabel.text = shopName;
}

// 出店者
- (void)setTenant:(NSString*)tenant
{
    _tenantLabel.text = tenant;
}

// 主な販売商品
- (void)setSales:(NSString*)sales
{
    _salesLabel.text = sales;
}

// 一括設定
- (void)updateShopDataWithShopName:(NSString *)shopName tenant:(NSString *)tenant sales:(NSString *)sales imageResource:(NSString*)url
{
    _shopImage.image = nil;
    
    _shopNameLabel.text = shopName;
    _tenantLabel.text = tenant;
    _salesLabel.text = sales;
    _imageResource = url;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
