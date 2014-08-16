//
//  HokutosaiLoadingView.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/26.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiLoadingView.h"
#import "HokutosaiUIColor.h"

@interface HokutosaiLoadingView ()

@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

@end

@implementation HokutosaiLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame style:UIActivityIndicatorViewStyleGray];
    if (self) {
        self.backgroundColor = [HokutosaiUIColor colorWithRed:240 green:240 blue:240];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        _activityIndicator = activityIndicator;
        [self addSubview:activityIndicator];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame indicatorVerticalOffset:(CGFloat)offset
{
    self = [self initWithFrame:frame style:UIActivityIndicatorViewStyleGray indicatorVerticalOffset:offset];
    if (self) {
        self.backgroundColor = [HokutosaiUIColor colorWithRed:240 green:240 blue:240];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style indicatorVerticalOffset:(CGFloat)offset
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        activityIndicator.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height/2) + offset);
        
        _activityIndicator = activityIndicator;
        [self addSubview:activityIndicator];
    }
    return self;
}

- (void)removeFromSuperview
{
    [_activityIndicator stopAnimating];
    [super removeFromSuperview];
}

- (void)startLoading
{
    if (!_isLoading) {
        [_activityIndicator startAnimating];
        _isLoading = YES;
    }
}

- (void)stopLoading:(BOOL)removeFromSuperView
{
    if (_isLoading) {
        [_activityIndicator stopAnimating];
        _isLoading = NO;
    }
    
    if (removeFromSuperView) {
        [super removeFromSuperview];
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
