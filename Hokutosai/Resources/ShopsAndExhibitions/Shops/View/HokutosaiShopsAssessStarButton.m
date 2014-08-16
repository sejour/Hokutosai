//
//  HokutosaiShopsAssessStarButton.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/17.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiShopsAssessStarButton.h"

@interface HokutosaiShopsAssessStarButton ()
{
    BOOL state;
    
    UIImage *_starFillIcon;
    UIImage *_starFrameIcon;
}

@end

@implementation HokutosaiShopsAssessStarButton

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame starFillIcon:nil starFrameIcon:nil];
}

- (id)initWithFrame:(CGRect)frame starFillIcon:(UIImage *)fillIcon starFrameIcon:(UIImage *)frameIcon
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _starFillIcon = fillIcon;
        _starFrameIcon = frameIcon;
        [self setImage:_starFrameIcon forState:UIControlStateNormal];
        [self setShowsTouchWhenHighlighted:YES];
    }
    return self;
}

- (void)starIsOn:(BOOL)on
{
    state = on;
        
    if (state) {
        [self setImage:_starFillIcon forState:UIControlStateNormal];
    } else {
        [self setImage:_starFrameIcon forState:UIControlStateNormal];
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
