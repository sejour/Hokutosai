//
//  HokutosaiNewsTopicsBordContent.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/05.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

// トピックスボードのコンテント
@interface HokutosaiNewsTopicsBordContent : UIImageView

// 画像のみのコンテントを作成する
- (id)initWithFrame:(CGRect)frame image:(UIImage*)image;
- (id)initWithFrame:(CGRect)frame imageName:(NSString*)imageName;

// タイトルのみのコンテントを作成する
- (id)initWithFrame:(CGRect)frame title:(NSString*)title;

// 画像とタイトル両方から成るコンテントを作成する
- (id)initWithFrame:(CGRect)frame image:(UIImage*)image title:(NSString*)title;

// 画像を設定する
- (void)setTitle:(NSString*)title;

@end
