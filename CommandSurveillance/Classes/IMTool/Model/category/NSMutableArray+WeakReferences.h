//
//  NSMutableArray+WeakReferences.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/11.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (WeakReferences)
+ (id)mutableArrayUsingWeakReferences;

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;
@end
