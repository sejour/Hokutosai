//
//  HokutosaiNewsTimelineCell.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/06.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiNewsTimelineCell.h"
#import "HokutosaiDateConvert.h"

@interface HokutosaiNewsTimelineCell ()
{
    // 添付画像のURL
    NSString *_attachedImageResource;
    
    // タイトル
    UILabel *_titleLabel;
    // 送信元
    UILabel *_senderLabel;
    // 経過時間
    UILabel *_elapsedTimeLabel;
    // 添付画像
    UIImageView *_image;
    // 重要なニュースの場合のアイコン
    UIImageView *_importantIcon;
}

- (void)commonInit;

// タイトルラベルのフレームを取得する
- (CGRect)frameOfTitleLabel;
// 送信者ラベルのフレームを取得する
- (CGRect)frameOfSenderLabel;
// 経過時間ラベルのフレームを取得する
- (CGRect)frameOfElapsedTimeLabel;

@end

@implementation HokutosaiNewsTimelineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self commonInit];
}

- (void)commonInit
{
    // 重要なニュースのアイコン
    _importantIcon = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 20, 20)];
    _importantIcon.image = [UIImage imageNamed:@"star_fill.bmp"];
    _importantIcon.contentMode = UIViewContentModeScaleAspectFit;
    //_importantIcon.hidden = YES;
    [self.contentView addSubview:_importantIcon];
    
    // 添付画像
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 69, 0, 69, 69)];
    _image.backgroundColor = [UIColor grayColor];
    _image.contentMode = UIViewContentModeScaleAspectFill;
    _image.clipsToBounds = YES;
    _image.hidden = YES;
    [self.contentView addSubview:_image];
    
    // タイトルラベル
    _titleLabel = [[UILabel alloc] initWithFrame:[self frameOfTitleLabel]];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
    
    // 送信者ラベル
    _senderLabel = [[UILabel alloc] initWithFrame:[self frameOfSenderLabel]];
    _senderLabel.font = [UIFont systemFontOfSize:14.0];
    _senderLabel.textColor = [UIColor blackColor];
    _senderLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_senderLabel];
    
    // 経過時間ラベル
    _elapsedTimeLabel = [[UILabel alloc] initWithFrame:[self frameOfElapsedTimeLabel]];
    _elapsedTimeLabel.font = [UIFont systemFontOfSize:14.0];
    _elapsedTimeLabel.textColor = [UIColor lightGrayColor];
    _elapsedTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_elapsedTimeLabel];
}


// タイトルラベルのフレームを取得する
- (CGRect)frameOfTitleLabel
{
    CGRect titleLabelFrame;
    
    // 原点
    if (_importantIcon.hidden) {
        titleLabelFrame.origin = CGPointMake(10, 6);
    } else {
        titleLabelFrame.origin = CGPointMake(_importantIcon.frame.origin.x + _importantIcon.frame.size.width + 4, 6);
    }
    
    // サイズ
    if (_image.hidden) {
        titleLabelFrame.size = CGSizeMake(self.contentView.frame.size.width - titleLabelFrame.origin.x - 10 , 22);
    } else {
        titleLabelFrame.size = CGSizeMake(_image.frame.origin.x - titleLabelFrame.origin.x - 10, 22);
    }
    
    return titleLabelFrame;
}

// 送信者ラベルのフレームを取得する
- (CGRect)frameOfSenderLabel
{
    CGRect senderLabelFrame;
    senderLabelFrame.origin = CGPointMake(20, 30);
    
    if (_image.hidden) {
        senderLabelFrame.size = CGSizeMake(self.contentView.frame.size.width - 30, 16);
    } else {
        senderLabelFrame.size = CGSizeMake(_image.frame.origin.x - 30, 16);
    }
    
    return senderLabelFrame;
}

// 経過時間ラベルのフレームを取得する
- (CGRect)frameOfElapsedTimeLabel
{
    CGRect elapsedTimeLabelFrame;
    elapsedTimeLabelFrame.origin = CGPointMake(20, 48);
    
    if (_image.hidden) {
        elapsedTimeLabelFrame.size = CGSizeMake(self.contentView.frame.size.width - 30, 16);
    } else {
        elapsedTimeLabelFrame.size = CGSizeMake(_image.frame.origin.x - 30, 16);
    }
    
    return elapsedTimeLabelFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (CGFloat)height
{
    return 70.0;
}

- (void)updateTitle:(NSString *)title from:(NSString *)sender at:(NSDate *)sendDate important:(BOOL)important attachedImageResource:(NSString *)imageURL
{
    // タイトル
    _titleLabel.text = title;
    // 送信者
    _senderLabel.text = sender;
    // 経過時間
    _elapsedTimeLabel.text = [HokutosaiDateConvert stringElapsedTimeSince:sendDate];
    
    // 重要なニュース
    _importantIcon.hidden = !important;
    
    // イメージ
    _attachedImageResource = imageURL;
    _image.hidden = imageURL == nil;
    
    // フレーム調整
    _titleLabel.frame = [self frameOfTitleLabel];
    _senderLabel.frame = [self frameOfSenderLabel];
    _elapsedTimeLabel.frame = [self frameOfElapsedTimeLabel];
}

- (void)updateAttachedImage:(UIImage *)image url:(NSString *)url
{
    // 添付画像のURLが一致すれば画像を設定
    if ([_attachedImageResource isEqualToString:url]) {
        _image.image = image;
    }
}

@end
