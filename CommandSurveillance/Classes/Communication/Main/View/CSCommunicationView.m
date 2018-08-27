//
//  CSCommunicationView.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/22.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSCommunicationView.h"
@interface CSCommunicationView ()
@end

@implementation CSCommunicationView
+ (instancetype)appInfoView
{    
    //加载xib中得view
    CSCommunicationView *subView = [[[NSBundle mainBundle] loadNibNamed:@"CSCommunicationView" owner:self options:nil] lastObject];
    return subView;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    NSLog(@"%s",__func__);
    [self drawAllControl];
}

- (void)drawAllControl{

}

@end
