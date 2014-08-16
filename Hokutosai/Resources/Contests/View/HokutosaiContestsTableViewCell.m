//
//  HokutosaiContestsTableViewCell.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/11.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiContestsTableViewCell.h"

static const CGFloat horizonInset = 15.0;
static const CGFloat verticalInset = 8.0;
static const CGFloat verticalSpace = 5.0;
static const CGFloat contestNameLabelHeight = 21.0;
static const CGFloat contestNameLabelFontSize = 20.0;
static const CGFloat detailLabelOffset = 10.0;
static const CGFloat detailLabelFontSize = 14.0;

@interface HokutosaiContestsTableViewCell ()
{
    // コンテスト名
    UILabel *contestNameLabel;
    
    // 詳細
    UILabel *detailLabel;
}

- (void)initHokutosaiContestsTableViewCell;
+ (UILabel*)testDetailLabel;
@end

@implementation HokutosaiContestsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initHokutosaiContestsTableViewCell];
    }
    return self;
}

- (void)initHokutosaiContestsTableViewCell
{
    // コンテスト名
    {
        CGRect frame = CGRectMake(horizonInset, verticalInset, self.frame.size.width - (horizonInset * 2), contestNameLabelHeight);
        contestNameLabel = [[UILabel alloc] initWithFrame:frame];
        contestNameLabel.textAlignment = NSTextAlignmentLeft;
        contestNameLabel.font = [UIFont boldSystemFontOfSize:contestNameLabelFontSize];
        [self.contentView addSubview:contestNameLabel];
    }
    
    // 詳細
    {
        CGRect frame = CGRectMake(horizonInset + detailLabelOffset, verticalInset + contestNameLabelHeight + verticalSpace, self.frame.size.width - detailLabelOffset - (horizonInset * 2), 1.0);
        detailLabel = [[UILabel alloc] initWithFrame:frame];
        detailLabel.numberOfLines = 0;
        detailLabel.font = [UIFont systemFontOfSize:detailLabelFontSize];
        [self.contentView addSubview:detailLabel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)updateContestName:(NSString *)name detail:(NSString *)detail
{
    // コンテスト名
    contestNameLabel.text = name;
    
    // 詳細
    CGRect frame = CGRectMake(horizonInset + detailLabelOffset, verticalInset + contestNameLabelHeight + verticalSpace, self.frame.size.width - detailLabelOffset - (horizonInset * 2), 1.0);
    detailLabel.frame = frame;
    detailLabel.text = detail;
    [detailLabel sizeToFit];
}

+ (CGFloat)heightWithDetail:(NSString *)detail
{
    UILabel *testLabel = [HokutosaiContestsTableViewCell testDetailLabel];
    testLabel.text = detail;
    [testLabel sizeToFit];
    
    return contestNameLabelHeight + testLabel.frame.size.height + verticalSpace + (verticalInset * 2);
}

+ (UILabel*)testDetailLabel
{
    // テスト用の詳細ラベル
    static UILabel *label;
    
    if (label == nil) {
        CGRect frame = CGRectMake(1.0, 1.0, 1.0, 1.0);
        label = [[UILabel alloc] initWithFrame:frame];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:detailLabelFontSize];
    }
    
    label.frame = CGRectMake(horizonInset + detailLabelOffset, verticalInset + contestNameLabelHeight + verticalSpace, 320.0 - detailLabelOffset - (horizonInset * 2), 1.0);
    
    return label;
}

@end
