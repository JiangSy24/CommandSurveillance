//
//  PicModel.h
//  ZLPhotoBrowser
//
//  Created by liangcong on 17/4/14.
//  Copyright © 2017年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PicModel : NSObject

@property (nonatomic,strong) NSString *picName;     // 只有当获取图片中心的才有用

@property (nonatomic,assign) NSInteger lTime;

@property (nonatomic,strong) UIImage *picImage;

@property (nonatomic,strong) PHAsset *asset;

@property (nonatomic,assign) BOOL bCachingIsOk;
+ (instancetype)instance;

@end
