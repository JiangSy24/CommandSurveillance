//
//  CSCreateGroupHeaderView.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/25.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCreateGroupHeaderView : UIView
+ (instancetype)appInfoView;
@property (weak, nonatomic) IBOutlet UIView *threeViewBox;
@property (weak, nonatomic) IBOutlet UIView *moreViewBox;
@property (weak, nonatomic) IBOutlet UILabel *three_labelOne;
@property (weak, nonatomic) IBOutlet UILabel *three_labeltwo;
@property (weak, nonatomic) IBOutlet UILabel *three_labelthree;
@property (weak, nonatomic) IBOutlet UIImageView *three_imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *three_imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *three_imageThree;

@property (weak, nonatomic) IBOutlet UILabel *more_labelOne;
@property (weak, nonatomic) IBOutlet UILabel *more_labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *more_labelThree;
@property (weak, nonatomic) IBOutlet UILabel *more_labelFour;
@property (weak, nonatomic) IBOutlet UIImageView *more_imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *more_imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *more_imageThree;
@property (weak, nonatomic) IBOutlet UIImageView *more_imageFour;

@end
