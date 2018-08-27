//
//  UIImage+Image.h
//
//  Created by apple on 15-3-4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
// instancetype默认会识别当前是哪个类或者对象调用，就会转换成对应的类的对象
// UIImage *

// 加载最原始的图片，没有渲染
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

+ (instancetype)imageWithStretchableName:(NSString *)imageName;

+(UIImage *)scaleImage:(UIImage *)image toKb:(NSInteger)kb;

+(NSData *)DataFromScaleImage:(UIImage *)image toKb:(NSInteger)kb;

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

+ (NSData *)zipImageWithImage:(UIImage *)image zipSize:(CGFloat)maxFileSize;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage*)getImageFromPicName:(NSString*)name;
@end
