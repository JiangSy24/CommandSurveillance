//
//  ZLBigImageCell.h
//  多选相册照片
//
//  Created by long on 15/11/26.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicModel.h"
@class PHAsset;

@protocol ZLBigImageCellDelegate <NSObject>

- (void)cachingIsOk:(BOOL)bIsOk;

@end

@interface ZLBigImageCell : UICollectionViewCell

@property (nonatomic, weak) id<ZLBigImageCellDelegate> delegate;

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, copy)   void (^singleTapCallBack)();
@property (nonatomic, strong) PicModel *picModel;
@property (nonatomic, assign) BOOL bIsPicCenter;
@end
