//
//  HokutosaiApiRequestTasksQueue.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/05.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HokutosaiApiRequest.h"

@interface HokutosaiApiRequestTasksQueue : NSObject

//@property (nonatomic, readonly) NSInteger activeTaskCount;

- (NSInteger)enqueueRequest:(HokutosaiApiRequest*)request receiveData:(void (^)(id))receveData;
- (NSInteger)enqueueRequest:(HokutosaiApiRequest *)request receiveData:(void (^)(id))receveData complete:(void (^)())complete;
- (NSInteger)enqueueRequest:(HokutosaiApiRequest *)request receiveData:(void (^)(id))receveData receiveError:(BOOL (^)(NSInteger))errorHandler;
- (NSInteger)enqueueRequest:(HokutosaiApiRequest *)request receiveData:(void (^)(id))receveData receiveError:(BOOL (^)(NSInteger))errorHandler complete:(void (^)())complete;

- (void)removeTask:(NSInteger)taskId;
- (void)removeAllTasks;

@end
