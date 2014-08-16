//
//  HokutosaiShopsAssessView.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/07.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiShopsAssessView.h"
#import "HokutosaiShopsAssessByMeView.h"

@interface HokutosaiShopsAssessView ()
{
    // 塗りつぶしの星
    UIImage *starFillIcon;
    // 枠だけの星
    UIImage *starFrameIcon;
    
    // みんなの評価
    NSMutableArray *assessByEveryStars;
    
    // 評価数
    UILabel *assessedCountLabel;
    
    // 自分の評価
    HokutosaiShopsAssessByMeView *assessByMeView;
}

- (void)initHokutosaiShopsAssessViewWithShopName:(NSString *)shopName delegate:(id<HokutosaiShopsAssessByMeViewDelegate>)delegate;
@end

@implementation HokutosaiShopsAssessView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame shopName:nil delegate:nil];
}

- (id)initWithFrame:(CGRect)frame shopName:(NSString *)shopName delegate:(id<HokutosaiShopsAssessByMeViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initHokutosaiShopsAssessViewWithShopName:shopName delegate:delegate];
    }
    return self;
}

- (void)initHokutosaiShopsAssessViewWithShopName:(NSString *)shopName delegate:(id<HokutosaiShopsAssessByMeViewDelegate>)delegate
{
    assessByEveryStars = [NSMutableArray arrayWithCapacity:5];
    
    // アイコンロード
    starFillIcon = [UIImage imageNamed:@"star_fill.bmp"];
    starFrameIcon = [UIImage imageNamed:@"star_frame.bmp"];
    
    // 自身の設定
    [self setTopPadding:5.0 rightPadding:20.0 bottomPadding:5.0 leftPadding:20.0];
    
    // 評価見出し
    {
        CGRect frame = CGRectMake(0.0, 0.0, self.widthOfStackPanel, 20.0);
        UILabel *assessHeadline = [[UILabel alloc] initWithFrame:frame];
        assessHeadline.textAlignment = NSTextAlignmentLeft;
        assessHeadline.font = [UIFont systemFontOfSize:17.0];
        assessHeadline.text = @"評価";
        [self addSubview:assessHeadline];
    }
    
    // みんなの評価見出し
    {
        CGRect frame = CGRectMake(0.0, 0.0, self.widthOfStackPanel, 15.0);
        UILabel *assessByEveryHeadline = [[UILabel alloc] initWithFrame:frame];
        assessByEveryHeadline.textAlignment = NSTextAlignmentLeft;
        assessByEveryHeadline.font = [UIFont systemFontOfSize:14.0];
        assessByEveryHeadline.text = @"みんなの評価";
        [self addSubview:assessByEveryHeadline verticalSpace:4.0];
    }
    
    // みんなの評価・評価数
    {
        static CGFloat starIconSize = 21.0;
        
        // 評価ビュー
        UIView *assessByEveryView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.widthOfStackPanel, starIconSize)];
        [self addSubview:assessByEveryView verticalSpace:3.0];
        
        // 星のアイコン
        UIImageView *starImageView;
        CGRect frameOfStarImageView;
        frameOfStarImageView.size = CGSizeMake(starIconSize, starIconSize);
        for (NSInteger i = 0; i < 5; ++i) {
            frameOfStarImageView.origin = CGPointMake(i * (starIconSize + 3.0), 0.0);
            starImageView = [[UIImageView alloc] initWithFrame:frameOfStarImageView];
            starImageView.image = starFrameIcon;
            // 配列に追加
            [assessByEveryStars addObject:starImageView];
            // ビューに追加
            [assessByEveryView addSubview:starImageView];
        }
        
        // 評価数ラベル
        CGFloat originX = (5 * (starIconSize + 3.0)) + 10.0;
        CGRect frameOfAssessedCount = CGRectMake(originX, 0.0, assessByEveryView.frame.size.width - originX, starIconSize);
        assessedCountLabel = [[UILabel alloc] initWithFrame:frameOfAssessedCount];
        assessedCountLabel.textAlignment = NSTextAlignmentLeft;
        assessedCountLabel.font = [UIFont systemFontOfSize:17.0];
        assessedCountLabel.text = @"(0)";
        [assessByEveryView addSubview:assessedCountLabel];
    }
    
    // 自分の評価見出し
    {
        CGRect frame = CGRectMake(0.0, 0.0, self.widthOfStackPanel, 15.0);
        UILabel *assessByEveryHeadline = [[UILabel alloc] initWithFrame:frame];
        assessByEveryHeadline.textAlignment = NSTextAlignmentLeft;
        assessByEveryHeadline.font = [UIFont systemFontOfSize:14.0];
        assessByEveryHeadline.text = @"自分の評価  (星をタップして評価)";
        [self addSubview:assessByEveryHeadline verticalSpace:10.0];
    }
    
    // 自分の評価
    {
        CGRect frame = CGRectMake(0.0, 0.0, self.widthOfStackPanel, 42.0);
        assessByMeView = [[HokutosaiShopsAssessByMeView alloc] initWithFrame:frame starFillIcon:starFillIcon starFrameIcon:starFrameIcon];
        [assessByMeView setShopName:shopName];
        assessByMeView.delegate = delegate;
        [self addSubview:assessByMeView verticalSpace:3.0];
    }
}

- (void)setAssessByEvery:(NSInteger)lank assessedCount:(NSInteger)count
{
    // 評価されている分
    for (NSInteger i = 0; i < lank; ++i) {
        [assessByEveryStars[i] setImage:starFillIcon];
    }
    //　評価されていない分
    for (NSInteger i = lank; i < 5; ++i) {
        [assessByEveryStars[i] setImage:starFrameIcon];
    }
    
    assessedCountLabel.text = [NSString stringWithFormat:@"(%d)", (int)count];
}

- (void)setAssessByMe:(NSInteger)lank
{
    [assessByMeView setScore:lank];
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
