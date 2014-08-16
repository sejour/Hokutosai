//
//  HokutosaiApiRequestTasksQueue.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/05.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiApiRequestTasksQueue.h"
#import "HokutosaiApiRequestDemander.h"

@interface HokutosaiApiRequestTasksQueue ()
{
    NSMutableDictionary *_taskQueue;
    NSInteger _issueTaskCount;
}

@end

@implementation HokutosaiApiRequestTasksQueue

- (id)init
{
    self = [super init];
    if (self) {
        _issueTaskCount = 0;
        _taskQueue = [NSMutableDictionary dictionaryWithCapacity:8];
    }
    return self;
}

- (NSInteger)enqueueRequest:(HokutosaiApiRequest*)request receiveData:(void (^)(id))receveData
{
    HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:request];
    
    NSInteger taskId = _issueTaskCount;
    NSString *taskIdStr = [NSString stringWithFormat:@"%ld", (long)taskId];
    
    NSURLSessionTask *task = [requestDemander responseAsync:^(id data) {
        receveData(data);
        [_taskQueue removeObjectForKey:taskIdStr];
    }];
    
    [_taskQueue setValue:task forKey:taskIdStr];
    ++_issueTaskCount;
    
    return taskId;
}

- (NSInteger)enqueueRequest:(HokutosaiApiRequest *)request receiveData:(void (^)(id))receveData complete:(void (^)())complete
{
    HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:request];
    
    NSInteger taskId = _issueTaskCount;
    NSString *taskIdStr = [NSString stringWithFormat:@"%ld", (long)taskId];
    
    NSURLSessionTask *task = [requestDemander responseAsync:^(id data) {
        receveData(data);
        [_taskQueue removeObjectForKey:taskIdStr];
    } complete:complete];
    
    [_taskQueue setValue:task forKey:taskIdStr];
    ++_issueTaskCount;
    
    return taskId;
}

- (NSInteger)enqueueRequest:(HokutosaiApiRequest *)request receiveData:(void (^)(id))receveData receiveError:(BOOL (^)(NSInteger))errorHandler
{
    HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:request];
    
    NSInteger taskId = _issueTaskCount;
    NSString *taskIdStr = [NSString stringWithFormat:@"%ld", (long)taskId];
    
    NSURLSessionTask *task = [requestDemander responseAsync:^(id data) {
        receveData(data);
        [_taskQueue removeObjectForKey:taskIdStr];
    } receiveError:errorHandler];
    
    [_taskQueue setValue:task forKey:taskIdStr];
    ++_issueTaskCount;
    
    return taskId;
}

- (NSInteger)enqueueRequest:(HokutosaiApiRequest *)request receiveData:(void (^)(id))receveData receiveError:(BOOL (^)(NSInteger))errorHandler complete:(void (^)())complete
{
    HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:request];
    
    NSInteger taskId = _issueTaskCount;
    NSString *taskIdStr = [NSString stringWithFormat:@"%ld", (long)taskId];
    
    NSURLSessionTask *task = [requestDemander responseAsync:^(id data) {
        receveData(data);
        [_taskQueue removeObjectForKey:taskIdStr];
    } receiveError:errorHandler complete:complete];
    
    [_taskQueue setValue:task forKey:taskIdStr];
    ++_issueTaskCount;
    
    return taskId;
}

- (void)removeAllTasks
{
    for (NSString *taskIdStr in _taskQueue) {
        [_taskQueue[taskIdStr] cancel];
    }
    
    [_taskQueue removeAllObjects];
}

- (void)removeTask:(NSInteger)taskId
{
    NSString *taskIdStr = [NSString stringWithFormat:@"%d", (int)taskId];
    
    [_taskQueue[taskIdStr] cancel];
    
    [_taskQueue removeObjectForKey:taskIdStr];
}

@end
