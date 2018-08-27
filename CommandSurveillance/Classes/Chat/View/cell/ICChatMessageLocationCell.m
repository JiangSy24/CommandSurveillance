//
//  ICChatMessageLocationCell.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/12.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "ICChatMessageLocationCell.h"
@interface ICChatMessageLocationCell()
@property (nonatomic, strong) UIButton *imageBtn;
@end

@implementation ICChatMessageLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageBtn];
    }
    return self;
}

#pragma mark - Private Method
- (void)setModelFrame:(ICMessageFrame *)modelFrame
{
    [super setModelFrame:modelFrame];
    NSArray *contentMem = [modelFrame.model.mediaPath componentsSeparatedByString:@"-"];
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:contentMem.lastObject options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:imageData];
//    self.mapImageView.frame = modelFrame.picViewF;

//    self.bubbleView.userInteractionEnabled = self.mapImageView.image != nil;
//    self.bubbleView.image = nil;
//    self.imageView.image = image;
    self.bubbleView.image = image;
    self.imageBtn.frame = modelFrame.bubbleViewF;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bubbleView.width, self.bubbleView.height / 3)];
    view.backgroundColor = [UIColor whiteColor];
    [self.bubbleView addSubview:view];
    // 防具 根骨血量，血量百分比，耐力
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.bubbleView.width - 30, self.bubbleView.height / 3)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = contentMem[2];
    [view addSubview:label];
}

#pragma mark - Getter
- (UIButton *)imageBtn
{
    if (nil == _imageBtn) {
        _imageBtn = [[UIButton alloc] init];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _imageBtn.layer.masksToBounds = YES;
        _imageBtn.layer.cornerRadius = 5;
        _imageBtn.clipsToBounds = YES;
    }
    return _imageBtn;
}

- (void)imageBtnClick:(UIButton *)btn
{
    //走一波
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMap:)]) {
        [self.delegate clickMap:self.modelFrame.model];
    }
}

@end
