//
//  ICChatMessageLocationCell.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/12.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "ICChatMessageBaseCell.h"
@protocol ICChatMessageLocationCellDelegate <NSObject>
- (void)clickMap:(ICMessageModel*)message;
@end
//神像，火 攻击，冰 防御， 风 跑路
@interface ICChatMessageLocationCell : ICChatMessageBaseCell
@property (nonatomic,weak) id<ICChatMessageLocationCellDelegate>    delegate;
@end
