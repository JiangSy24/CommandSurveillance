//
//  CSCommunicationAccountVC.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/8/21.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>
#define btnViewBoxHeight    55
#define btnHeightDDDD           28
#define CollectionViewHeight 45 // 路径控件
#define ScrollerHeight      40
#define PathFont [UIFont systemFontOfSize:16]
@interface PathView : UIView
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UIButton *labelBtn;
@property (nonatomic,assign) int parentId;
@end

@interface CSCommunicationAccountVC : UIViewController

@end
