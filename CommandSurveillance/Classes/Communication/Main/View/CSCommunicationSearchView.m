//
//  CSCommunicationSearchView.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/24.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSCommunicationSearchView.h"
@interface CSCommunicationSearchView()
@property (weak, nonatomic) IBOutlet UIView *searchViewBox;

@end

@implementation CSCommunicationSearchView

+ (instancetype)appInfoView
{
    //加载xib中得view
    CSCommunicationSearchView *subView = [[[NSBundle mainBundle] loadNibNamed:@"CSCommunicationSearchView" owner:self options:nil] lastObject];
    return subView;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    NSLog(@"%s",__func__);
    [self drawAllControl];
}

- (void)drawAllControl{
    SSSearchBar *sss = [[SSSearchBar alloc]initWithFrame:CGRectMake(0, 0, CSScreenW - 30, 30)];
    sss.centerY = self.searchViewBox.height / 2;
    sss.centerX = CSScreenW / 2;
    [self.searchViewBox addSubview:sss];
    self.searchBar = sss;
    self.searchBar.cancelButtonHidden = YES;
    self.searchBar.placeholder = NSLocalizedString(@"输入设备名称", nil);
}
@end
