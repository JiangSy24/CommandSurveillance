//
//  NSString+String.h
//  CloudSurveillance
//
//  Created by liangcong on 17/5/26.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (String)
+ (NSString *)transform:(NSString *)chinese;
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content;
+ (BOOL)isOnlyNum:(NSString*)content;
@end
