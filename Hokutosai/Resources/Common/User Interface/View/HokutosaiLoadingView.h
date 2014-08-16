//
//  HokutosaiLoadingView.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/26.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

// ローディングビュー
@interface HokutosaiLoadingView : UIView

@property (nonatomic, readonly) BOOL isLoading;

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style;
- (id)initWithFrame:(CGRect)frame indicatorVerticalOffset:(CGFloat)offset;
- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style indicatorVerticalOffset:(CGFloat)offset;

- (void)startLoading;
- (void)stopLoading:(BOOL)removeFromSuperView;

@end
