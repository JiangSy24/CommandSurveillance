//
//  ZLSelectPhotoModel.h
//  多选相册照片
//
//  Created by long on 15/11/26.
//  Copyright © 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ZLSelectPhotoModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, copy) NSString *localIdentifier;

@property (nonatomic, assign) BOOL bIsHaveEditImage;

@property (nonatomic, strong) UIImage *editImage;

@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, copy) NSString *strPicName;
@end
