//
//  HokutosaiShopsAndExhibitionsHeadInfoView.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/07.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HokutosaiStackPanelView.h"

@interface HokutosaiShopsAndExhibitionsHeadInfoView : HokutosaiStackPanelView

- (id)initWithFrame:(CGRect)frame title:(NSString*)title hostNameHeadline:(NSString*)headline;

- (void)setTitle:(NSString*)title;
- (void)setImage:(UIImage*)image;
- (void)setHostName:(NSString*)hostName;

- (void)startTitleStreaming;

@end
