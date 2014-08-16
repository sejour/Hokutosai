//
//  HokutosaiApiRequestParameters.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/13.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiApiRequestParameters.h"

@implementation HokutosaiApiRequestParameters

- (id)init
{
    self = [super init];
    
    if (self) {
        _params = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    
    return self;
}

- (void)setValueWithString:(NSString*)value forKey:(NSString*)identifier
{
    [_params setValue:value forKey:identifier];
}

- (void)setValueWithInteger:(NSInteger)value forKey:(NSString*)identifier
{
    [_params setValue:[NSString stringWithFormat:@"%d", (int)value] forKey:identifier];
}

- (void)setValueWithNumber:(NSNumber *)value forKey:(NSString *)identifier
{
    [_params setValue:[NSString stringWithFormat:@"%@", value] forKey:identifier];
}

- (void)setValueWithBool:(BOOL)value forKey:(NSString*)identifier
{
    NSString *boolValue = value ? @"true" : @"false";
    
    [_params setValue:boolValue forKey:identifier];
}

- (void)setValueWithDate:(NSDate*)date forKey:(NSString*)identifier
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    [_params setValue:[formatter stringFromDate:date] forKey:identifier];
}

- (void)setValueWithTime:(NSDate*)time forKey:(NSString*)identifier
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    [_params setValue:[formatter stringFromDate:time] forKey:identifier];}

- (void)setValueWithDateTime:(NSDate*)dateTime forKey:(NSString*)identifier
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [_params setValue:[formatter stringFromDate:dateTime] forKey:identifier];
}

@end
