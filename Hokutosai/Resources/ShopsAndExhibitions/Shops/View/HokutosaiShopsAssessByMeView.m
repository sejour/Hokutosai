//
//  HokutosaiShopsAssessByMeView.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/17.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiShopsAssessByMeView.h"
#import "HokutosaiShopsAssessStarButton.h"

@interface HokutosaiShopsAssessByMeView ()
{
    // スター画像ボタン
    NSMutableArray *starButtons;
    // 現在のスコア
    NSInteger currentScore;
    // 評価の際のスコア
    NSInteger willAssessScore;
    // 模擬店名
    NSString *shopName;
}

- (void)commonInitWithStarFillIcon:(UIImage *)fillIcon starFrameIcon:(UIImage *)frameIcon;
- (void)tappedButton:(UIButton*)sender;

@end

@implementation HokutosaiShopsAssessByMeView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self commonInitWithStarFillIcon:[UIImage imageNamed:@"star_fill.bmp"] starFrameIcon:[UIImage imageNamed:@"star_frame.bmp"]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInitWithStarFillIcon:[UIImage imageNamed:@"star_fill.bmp"] starFrameIcon:[UIImage imageNamed:@"star_frame.bmp"]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame starFillIcon:(UIImage *)fillIcon starFrameIcon:(UIImage *)frameIcon
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInitWithStarFillIcon:fillIcon starFrameIcon:frameIcon];
    }
    return self;
}

- (void)commonInitWithStarFillIcon:(UIImage *)fillIcon starFrameIcon:(UIImage *)frameIcon
{
    starButtons = [NSMutableArray arrayWithCapacity:5];
    
    CGFloat selfWidthDiv = (self.frame.size.width - self.frame.size.height) / 4.0;
    CGRect starButtonFrame;
    starButtonFrame.size = CGSizeMake(self.frame.size.height, self.frame.size.height);
    
    // ボタン初期化
    HokutosaiShopsAssessStarButton* button;
    for (int i = 0; i < 5; ++i) {
        starButtonFrame.origin = CGPointMake(i * selfWidthDiv, 0);
        button = [[HokutosaiShopsAssessStarButton alloc] initWithFrame:starButtonFrame starFillIcon:fillIcon starFrameIcon:frameIcon];
        button.tag = i + 1;
        [button addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
        [starButtons addObject:button];
        [self addSubview:button];
    }
}

- (void)setScore:(NSInteger)score
{
    // スコア更新
    currentScore = score;
    
    // 評価されている分
    for (int i = 0; i < currentScore; ++i) {
        [starButtons[i] starIsOn:YES];
    }

    // 評価されていない分
    for (int i = (int)currentScore; i < 5; ++i) {
        [starButtons[i] starIsOn:NO];
    }
}

- (void)setShopName:(NSString *)name
{
    shopName = name;
}

// ボタンがタップされた際
- (void)tappedButton:(UIButton *)sender
{
    // 評価が同じであれば弾く
    if (currentScore == sender.tag) {
        return;
    }
    
    // 評価しようとしているスコアを更新
    willAssessScore = sender.tag;
    
    NSString *title;
    NSString *message;
    
    // アラートを表示
    if (currentScore == 0) {
        title = @"模擬店を評価します。";
        message = [NSString stringWithFormat:@"「%@」を星%d個で評価します。", shopName, (int)willAssessScore];
    } else {
        title = @"模擬店を再評価します。";
        message = [NSString stringWithFormat:@"「%@」を星%d個で再評価します。", shopName, (int)willAssessScore];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"キャンセル"
                                          otherButtonTitles:@"OK", nil];
    
    [alert show];
}

// アラートボタンがタップされた際
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // OKのとき
    if (buttonIndex == 1) {
        [_delegate assesse:willAssessScore previousScore:currentScore];
    }
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
