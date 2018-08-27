//
//  NSString+String.h
//  CloudSurveillance
//
//  Created by liangcong on 17/5/26.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IMString)
+ (NSString *)transform:(NSString *)chinese;
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content;
+ (BOOL)isOnlyNum:(NSString*)content;

- (CGSize)stringSizeWithFont:(UIFont *)font Size:(CGSize)size;

+ (NSString*)strPhoneNumFormatStr:(NSString*)str;

+ (NSString*)md5String32:( NSString *)str;

+ (NSString*)md5String16:( NSString *)str;

+ (NSString*)getMacAddress;
@end
