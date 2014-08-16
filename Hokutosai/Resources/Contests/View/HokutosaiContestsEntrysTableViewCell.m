//
//  HokutosaiContestsEntrysTableViewCell.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/10.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiContestsEntrysTableViewCell.h"

static const CGFloat horizonContentInset = 15.0;

@interface HokutosaiContestsEntrysTableViewCell ()
{
    // イラストのURL
    NSString *illustrationURL;

    // イラストビュー
    UIImageView *imageView;
    // 優勝者のアイコンビュー
    UIImageView *championIconView;
    
    // 部門名
    UILabel *sectionNameLabel;
    // 出場者名
    UILabel *entryNameLabel;
    // 所属
    UILabel *belongLabel;
}

- (void)initHokutosaiContestsEntrysTableViewCell;
- (void)resizeContent;
@end

@implementation HokutosaiContestsEntrysTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initHokutosaiContestsEntrysTableViewCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)initHokutosaiContestsEntrysTableViewCell
{
    // イラストビュー
    {
        CGRect frame = CGRectMake(0.0, 0.0, 75.0, 75.0);
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor grayColor];
        imageView.hidden = YES;
        [self.contentView addSubview:imageView];
    }
    
    // 優勝者のアイコン
    {
        CGRect frame = CGRectMake(horizonContentInset, 25.0, 26.0, 26.0);
        championIconView = [[UIImageView alloc] initWithFrame:frame];
        championIconView.contentMode = UIViewContentModeScaleAspectFill;
        championIconView.hidden = YES;
        [self.contentView addSubview:championIconView];
    }
    
    // 部門名
    {
        CGRect frame = CGRectMake(horizonContentInset, 5.0, self.frame.size.width - (horizonContentInset * 2), 19.0);
        sectionNameLabel = [[UILabel alloc] initWithFrame:frame];
        sectionNameLabel.textAlignment = NSTextAlignmentLeft;
        sectionNameLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:sectionNameLabel];
    }
    
    // 出場者名
    {
        CGRect frame = CGRectMake(horizonContentInset, 25.0, self.frame.size.width - (horizonContentInset * 2), 26.0);
        entryNameLabel = [[UILabel alloc] initWithFrame:frame];
        entryNameLabel.textAlignment = NSTextAlignmentLeft;
        entryNameLabel.font = [UIFont systemFontOfSize:18.0];
        [self.contentView addSubview:entryNameLabel];
    }
    
    // 所属
    {
        CGRect frame = CGRectMake(horizonContentInset + 10.0, 52.0, self.frame.size.width - (horizonContentInset * 2) - 10.0, 18.0);
        belongLabel = [[UILabel alloc] initWithFrame:frame];
        belongLabel.textAlignment = NSTextAlignmentLeft;
        belongLabel.font = [UIFont systemFontOfSize:14.0];
        belongLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:belongLabel];
    }
}

- (void)updateSection:(NSString *)section entryName:(NSString *)name belong:(NSString *)belong championIcon:(UIImage *)championIcon illustrationImageResource:(NSString *)imageURL
{
    // 部門
    sectionNameLabel.text = section;
    
    // 出場者名
    entryNameLabel.text = name;
    
    // 所属
    belongLabel.text = belong;
    
    // 優勝者のアイコン
    championIconView.image = championIcon;
    championIconView.hidden = championIcon == nil;
    
    // イラスト
    illustrationURL = imageURL;
    imageView.hidden = imageURL == nil;
    if (imageView.hidden) {
        imageView.image = nil;
    }
    
    // フレーム調整
    [self resizeContent];
}

// 設定された属性値を元にフレームを調整する
- (void)resizeContent
{
    CGFloat originX = horizonContentInset;
    CGFloat width = self.frame.size.width - (horizonContentInset * 2);
    
    // 画像の表示がON
    if (!imageView.hidden) {
        originX += imageView.frame.size.width;
        width -= imageView.frame.size.width;
    }
    
    // 部門名リサイズ
    sectionNameLabel.frame = CGRectMake(originX, sectionNameLabel.frame.origin.y, width, sectionNameLabel.frame.size.height);
    
    // 出場者名
    if (championIconView.hidden) {
        entryNameLabel.frame = CGRectMake(originX + 10.0, entryNameLabel.frame.origin.y, width - 10.0, entryNameLabel.frame.size.height);
    } else {
        championIconView.frame = CGRectMake(originX, championIconView.frame.origin.y, championIconView.frame.size.width, championIconView.frame.size.height);
        entryNameLabel.frame = CGRectMake(championIconView.frame.origin.x + championIconView.frame.size.width + 5, entryNameLabel.frame.origin.y, width - championIconView.frame.size.width - 5, entryNameLabel.frame.size.height);
    }
    
    // 所属リサイズ
    belongLabel.frame = CGRectMake(originX + 10.0, belongLabel.frame.origin.y, width - 10.0, belongLabel.frame.size.height);
}

- (void)updateIllustrationImage:(UIImage *)image url:(NSString *)url
{
    // イラストのURLが一致すれば画像を設定
    if ([illustrationURL isEqualToString:url]) {
        imageView.image = image;
    }
}

+ (CGFloat)height
{
    return 75.0;
}

@end
