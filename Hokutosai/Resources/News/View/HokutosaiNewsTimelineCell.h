//
//  HokutosaiNewsTimelineCell.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/06.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

// ニュースタイムラインのセル
@interface HokutosaiNewsTimelineCell : UITableViewCell

// セルの高さを取得する
+ (CGFloat)height;

// 属性値を更新する
// existImage: 添付画像が存在するかどうか
- (void)updateTitle:(NSString*)title from:(NSString*)sender at:(NSDate*)sendDate important:(BOOL)important attachedImageResource:(NSString*)imageURL;

// 添付画像を設定する
- (void)updateAttachedImage:(UIImage*)image url:(NSString*)url;

@end
