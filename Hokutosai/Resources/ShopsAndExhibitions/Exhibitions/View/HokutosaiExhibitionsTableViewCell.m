//
//  HokutosaiExhibitionsTableViewCell.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/13.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiExhibitionsTableViewCell.h"

@interface HokutosaiExhibitionsTableViewCell ()
{
    NSString *_imageResource;
}

@property (weak, nonatomic) IBOutlet UIImageView *exhibitionImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *displaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end

@implementation HokutosaiExhibitionsTableViewCell

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

// 展示イラスト
- (void)updateExhibitionImage:(UIImage*)image url:(NSString *)url
{
    // イメージリソースが一致していればイメージ設定
    if ([_imageResource isEqualToString:url]) {
        _exhibitionImage.image = image;
    }
}

// 展示のタイトル
- (void)setExhibitionTitle:(NSString*)title
{
    _titleLabel.text = title;
}

// 主な展示物
- (void)setDisplays:(NSString*)displays
{
    _displaysLabel.text = displays;
}

// 場所
- (void)setPlace:(NSString*)place
{
    _placeLabel.text = place;
}

// 一括設定
- (void)updateExhibitionDataWithTitle:(NSString *)title displays:(NSString *)displays place:(NSString *)place imageResource:(NSString *)url
{
    _exhibitionImage.image = nil;
    
    _titleLabel.text = title;
    _displaysLabel.text = displays;
    _placeLabel.text = place;
    _imageResource = url;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
