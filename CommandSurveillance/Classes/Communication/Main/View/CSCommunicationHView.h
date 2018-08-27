//
//  CSCommunicationHView.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/23.
//  Copyright © 2018年 liangcong. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol CSCommunicationHViewDelegte<NSObject>
- (void)clickGroupView;
@end
@interface CSCommunicationHView : UIView
@property (nonatomic,weak) id<CSCommunicationHViewDelegte> delegate;
@property (weak, nonatomic) SSSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;

+ (instancetype)appInfoView;
@end
