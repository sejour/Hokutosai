//
//  HokutosaiViewControllerProtocol.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/06.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HokutosaiViewControllerProtocol <NSObject>

@required

- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight;

@end