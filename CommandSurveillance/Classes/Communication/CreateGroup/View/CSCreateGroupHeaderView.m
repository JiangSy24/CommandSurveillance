//
//  CSCreateGroupHeaderView.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/25.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSCreateGroupHeaderView.h"

@interface CSCreateGroupHeaderView()

@end

@implementation CSCreateGroupHeaderView
+ (instancetype)appInfoView
{
    //加载xib中得view
    CSCreateGroupHeaderView *subView = [[[NSBundle mainBundle] loadNibNamed:@"CSCreateGroupHeaderView" owner:self options:nil] lastObject];
    return subView;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    NSLog(@"%s",__func__);
    [self drawAllControl];
}

- (void)drawAllControl{
    [CSViewStyle initInputViewRound:self.threeViewBox];
    [CSViewStyle initInputViewRound:self.moreViewBox];
    self.threeViewBox.hidden = YES;
}
@end
