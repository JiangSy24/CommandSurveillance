//
//  ICChatMessageBaseCell.m
//  XZ_WeChat
//
//  Created by 郭现壮 on 16/3/12.
//  Copyright © 2016年 gxz All rights reserved.
//

#import "ICChatMessageBaseCell.h"
#import "ICMessageModel.h"
#import "ICMessage.h"
#import "ICMessageTopView.h"
#import "DAYUtils.h"

@interface ICChatMessageBaseCell ()
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation ICChatMessageBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
        longRecognizer.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longRecognizer];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    [self.contentView addSubview:self.bubbleView];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.activityView];
    [self.contentView addSubview:self.retryButton];
    [self.contentView addSubview:self.namelabel];
}

#pragma mark - Getter and Setter

- (ICHeadImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[ICHeadImageView alloc] init];
        [_headImageView setColor:IColor(219, 220, 220) bording:0.0];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked)];
        [_headImageView addGestureRecognizer:tapGes];
    }
    return _headImageView;
}

- (UIView *)timeView{
    if (_timeView == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13.f];
        _timeLabel.textColor = [UIColor grayColor];
        _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _timeView.backgroundColor = CSUIColor(220, 220, 220);
        _timeView.layer.borderColor = [UIColor clearColor].CGColor;
        _timeView.layer.borderWidth = 0;
        _timeView.layer.cornerRadius = 2;
        _timeView.layer.masksToBounds = YES;
        [_timeView addSubview:_timeLabel];
    }
    return _timeView;
}

- (UILabel*)namelabel{
    if (_namelabel == nil) {
        _namelabel = [[UILabel alloc] init];
    }
    return _namelabel;
}

- (UIImageView *)bubbleView {
    if (_bubbleView == nil) {
        _bubbleView = [[UIImageView alloc] init];
    }
    return _bubbleView;
}

- (UIActivityIndicatorView *)activityView {
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
}

- (UIButton *)retryButton {
    if (_retryButton == nil) {
        _retryButton = [[UIButton alloc] init];
        [_retryButton setImage:[UIImage imageNamed:@"button_retry_comment"] forState:UIControlStateNormal];
        [_retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

#pragma mark - Respond Method

- (void)retryButtonClick:(UIButton *)btn {
    if ([self.longPressDelegate respondsToSelector:@selector(reSendMessage:)]) {
        [self.longPressDelegate reSendMessage:self];
    }
}

- (void)setModelFrame:(ICMessageFrame *)modelFrame
{
    _modelFrame = modelFrame;
    
     ICMessageModel *messageModel = modelFrame.model;
    self.headImageView.frame     = modelFrame.headImageViewF;
    self.bubbleView.frame        = modelFrame.bubbleViewF;
    
    if (modelFrame.bIsTimeLabelHave) {
        [self.contentView addSubview:self.timeView];
        self.timeView.frame        = modelFrame.timeLabelF;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:modelFrame.iTime];
        NSDateComponents *selectComps = [DAYUtils dateComponentsFromDate:date];
        
        self.timeLabel.text =[NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",selectComps.year,selectComps.month,selectComps.day,selectComps.hour,selectComps.minute];
        
        CGSize  mainSize = [self.timeLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(CSScreenW, MAXFLOAT)];
        self.timeLabel.frame       = CGRectMake(0, 0, mainSize.width, modelFrame.timeLabelF.size.height);
        self.timeView.width = mainSize.width + 20;
        self.timeView.centerX      = CSScreenW / 2;
        self.timeLabel.centerX = self.timeView.width / 2;
    }
    
    if (messageModel.isSender) {    // 发送者
        self.activityView.frame  = modelFrame.activityF;
        self.retryButton.frame   = modelFrame.retryButtonF;
        switch (modelFrame.model.message.deliveryState) { // 发送状态
            case ICMessageDeliveryState_Delivering:
            {
                [self.activityView setHidden:NO];
                [self.retryButton setHidden:YES];
                [self.activityView startAnimating];
            }
                break;
            case ICMessageDeliveryState_Delivered:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:YES];
                
            }
                break;
            case ICMessageDeliveryState_Failure:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:NO];
            }
                break;
            default:
                break;
        }
        if ([modelFrame.model.message.type isEqualToString:TypeFile] ||
            [modelFrame.model.message.type isEqualToString:TypePicText] ||
            [modelFrame.model.message.type isEqualToString:TypeLocation]) {
            self.bubbleView.image = [UIImage imageNamed:@"liaotianbeijing1"];//原始liaotianfile
        } else if ([modelFrame.model.message.type isEqualToString:TypeText] || [modelFrame.model.message.type isEqualToString:TypeVoice]) {
            self.bubbleView.image = [UIImage imageNamed:@"liaotianbeijing2"];
        }
        CSOneUserModel *one = [CSUsersModel instance].dicPreAccount[UserDicKey([CSUrlString instance].account.sysconf.accountid)];
        self.headImageView.imageView.userName.text = [CSStatusTool getShowUserName:one.name];
        if (self.modelFrame.model.isChatGroup) {
            self.namelabel.frame = modelFrame.userNameF;
            self.namelabel.textColor = [UIColor lightGrayColor];
            self.namelabel.textAlignment = NSTextAlignmentRight;
            self.namelabel.font = [UIFont systemFontOfSize:11];
            self.namelabel.text = one.name;
        }
    } else {    // 他人
        self.retryButton.hidden  = YES;
        if (![modelFrame.model.message.type isEqualToString:TypePic]) {
            self.bubbleView.image = [UIImage imageNamed:@"liaotianbeijing1"];
        }
        CSOneUserModel *one = [CSUsersModel instance].dicPreAccount[modelFrame.model.message.from];
        self.headImageView.imageView.userName.text = [CSStatusTool getShowUserName:one.name];
        if (self.modelFrame.model.isChatGroup) {
            self.namelabel.frame = modelFrame.userNameF;
            self.namelabel.textColor = [UIColor lightGrayColor];
            self.namelabel.textAlignment = NSTextAlignmentLeft;
            self.namelabel.font = [UIFont systemFontOfSize:11];
            self.namelabel.text = one.name;
        }
    }
}

- (void)headClicked
{
    if ([self.longPressDelegate respondsToSelector:@selector(headImageClicked:)]) {
        [self.longPressDelegate headImageClicked:_modelFrame.model.message.from];
    }
}

#pragma mark - longPress delegate

- (void)longPressRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if ([self.longPressDelegate respondsToSelector:@selector(longPress:)]) {
        [self.longPressDelegate longPress:recognizer];
    }
}

@end
