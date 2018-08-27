//
//  UIImageView+CSImageView.h
//  CloudSurveillance
//
//  Created by liangcong on 2018/1/18.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CSImageView)
- (void)cs_setImageWithData:(NSData *)data placeholderImage:(UIImage *)placeholder;

@end
