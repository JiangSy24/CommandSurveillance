//
//  CSUserHeaderView.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/25.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSUserHeaderView.h"

@implementation CSUserHeaderView

+ (instancetype)appInfoView
{
    //加载xib中得view
    CSUserHeaderView *subView = [[[NSBundle mainBundle] loadNibNamed:@"CSUserHeaderView" owner:self options:nil] lastObject];
    return subView;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    NSLog(@"%s",__func__);
    [self drawAllControl];
}

- (void)drawAllControl{
    [CSViewStyle initInputViewRound:self];
}
@end
