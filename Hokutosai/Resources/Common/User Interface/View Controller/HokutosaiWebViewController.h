//
//  HokutosaiWebViewController.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/25.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HokutosaiViewControllerProtocol.h"

// WEBビューコントローラー
@interface HokutosaiWebViewController : UIViewController <HokutosaiViewControllerProtocol, UIWebViewDelegate>

// タイトル
@property (nonatomic, strong) NSString *pageTitle;

// 表示するページのURL
@property (nonatomic, strong) NSString *pageURL;

@end
