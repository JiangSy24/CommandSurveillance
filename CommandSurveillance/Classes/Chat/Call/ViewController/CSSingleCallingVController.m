//
//  CSSingleCallingVController.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/9.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSSingleCallingVController.h"

@interface CSSingleCallingVController ()<WMIMChatCallManageDelegate>
@property (weak, nonatomic) IBOutlet UIView *userHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIView *allowBtnView;
@property (weak, nonatomic) IBOutlet UIView *rejectBtnView;
@property (weak, nonatomic) IBOutlet UIView *soundOffBtnView;
@property (weak, nonatomic) IBOutlet UIView *allowedRejectBtnView;
@property (weak, nonatomic) IBOutlet UIView *handsFreeBtnView;
@property (weak, nonatomic) IBOutlet UIButton *soundOffBtn;
@property (weak, nonatomic) IBOutlet UIButton *handsFreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *headerName;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation CSSingleCallingVController

- (IBAction)shrinkClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[CSNTESNotificationCenter sharedCenter] showMinisCalling:YES chatid:self.chatId sponsorid:self.sponsorid SoundOff:self.bSoundOffBtnisSelect HandsFree:self.bHandsFreebSelect sessionType:WM_IM_CallType_Single_Voice callingMemebers:nil groupId:0];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [[IMChatManageTool instance].callManage addDelegate:self];
    
    if (CSScreenW < 375) {
        // 小屏手机
        self.userHeaderView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.userHeaderView.layer.borderWidth = 2;
        self.userHeaderView.layer.cornerRadius = self.userHeaderView.height/2 - 8;
        self.userHeaderView.layer.masksToBounds = YES;
        self.userName.font = [UIFont systemFontOfSize:16];
        
    }else{
        self.userHeaderView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.userHeaderView.layer.borderWidth = 2;
        self.userHeaderView.layer.cornerRadius = self.userHeaderView.height/2;
        self.userHeaderView.layer.masksToBounds = YES;
    }

    if (!self.bIsCalling) {// 非通话中
        self.soundOffBtn.enabled = NO;
        self.handsFreeBtn.enabled = NO;
        if (self.sponsorid == [CSUrlString instance].account.sysconf.accountid) {
            // 我是呼叫方
            CSOneUserModel *model = [CSUsersModel instance].dicPreAccount[[NSString stringWithFormat:@"%d",self.toUserid]];
            self.userName.text = model.name;
            self.headerName.text = [CSStatusTool getShowUserName:model.name charNum:2];
            [self allowUiRe:NO];
            
            // 起timer 10秒后干掉
            self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(recordTimeOver) userInfo:nil repeats:NO];
        }else{
            // 我是被呼叫方
            CSOneUserModel *model = [CSUsersModel instance].dicPreAccount[[NSString stringWithFormat:@"%d",self.sponsorid]];
            self.userName.text = model.name;
            self.headerName.text = [CSStatusTool getShowUserName:model.name charNum:2];
            [self allowUiRe:YES];
        }
    }else{
        [self allowUiRe:NO];
        self.soundOffBtn.enabled = YES;
        self.handsFreeBtn.enabled = YES;
        if (self.bSoundOffBtnisSelect) {
            [self.soundOffBtn setImage:[UIImage imageNamed:@"call_jingyin.png"] forState:UIControlStateNormal];//静音
        }else{
            [self.soundOffBtn setImage:[UIImage imageNamed:@"call_unjingyin.png"] forState:UIControlStateNormal];//有声音
        }
        if (self.bHandsFreebSelect) {
            [self.handsFreeBtn setImage:[UIImage imageNamed:@"call_yangshengqi.png"] forState:UIControlStateNormal];//扬声器
        }else{
            [self.handsFreeBtn setImage:[UIImage imageNamed:@"call_unyangshengqi.png"] forState:UIControlStateNormal];//耳听
        }
    }
}

// time is over
- (void)recordTimeOver
{
    if (self.soundOffBtn.enabled != YES) {
        [[IMChatManageTool instance].callManage terminateRTS:self.chatId];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)dealloc{
    [[IMChatManageTool instance].callManage removeDelegate:self];
}

- (void)allowUiRe:(BOOL)bIsAllow{
    self.soundOffBtnView.hidden = bIsAllow;
    self.allowedRejectBtnView.hidden = bIsAllow;
    self.handsFreeBtnView.hidden = bIsAllow;
    self.allowBtnView.hidden = !bIsAllow;
    self.rejectBtnView.hidden = !bIsAllow;
}


+(instancetype)myTableViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SingleCallingVController"];
}

- (IBAction)soundOffClick:(id)sender {
    self.bSoundOffBtnisSelect = !self.bSoundOffBtnisSelect;
    if (self.bSoundOffBtnisSelect) {
        [self.soundOffBtn setImage:[UIImage imageNamed:@"call_jingyin.png"] forState:UIControlStateNormal];//静音
    }else{
        [self.soundOffBtn setImage:[UIImage imageNamed:@"call_unjingyin.png"] forState:UIControlStateNormal];//有声音
    }
    [[IMChatManageTool instance].callManage setMute:self.bSoundOffBtnisSelect];
}

- (IBAction)handsFreeClick:(id)sender {
    self.bHandsFreebSelect = !self.bHandsFreebSelect;
    if (self.bHandsFreebSelect) {
        [self.handsFreeBtn setImage:[UIImage imageNamed:@"call_yangshengqi.png"] forState:UIControlStateNormal];//扬声器
    }else{
        [self.handsFreeBtn setImage:[UIImage imageNamed:@"call_unyangshengqi.png"] forState:UIControlStateNormal];//耳听
    }
    [[IMChatManageTool instance].callManage setSpeaker:self.bHandsFreebSelect];
}

- (IBAction)rejectClick:(id)sender {
    // 1 是接听后拒接 and 发起时候拒接
    // 2 是拒接
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 1) {
        [[IMChatManageTool instance].callManage terminateRTS:self.chatId];
    }else{
        [[IMChatManageTool instance].callManage responseRTS:self.chatId sponsorid:self.sponsorid accept:0 completion:^(int error, NSArray<LMCallModel *> * _Nullable array) {
            
        }];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)allowClick:(id)sender {
    [[IMChatManageTool instance].callManage responseRTS:self.chatId sponsorid:self.sponsorid accept:1 completion:^(int error, NSArray<LMCallModel *> * _Nullable array) {
        
    }];
    [self allowUiRe:NO];
    self.soundOffBtn.enabled = YES;
    self.handsFreeBtn.enabled = YES;
    [self.soundOffBtn setImage:[UIImage imageNamed:@"call_unjingyin.png"] forState:UIControlStateNormal];//有声音
    [self.handsFreeBtn setImage:[UIImage imageNamed:@"call_unyangshengqi.png"] forState:UIControlStateNormal];//耳听
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)onRTSResponse:(int)chatid userid:(int)userid response:(int)response {
    if (response == 0) {
        // 接听
        self.soundOffBtn.enabled = YES;
        self.handsFreeBtn.enabled = YES;
        [self.soundOffBtn setImage:[UIImage imageNamed:@"call_unjingyin.png"] forState:UIControlStateNormal];//有声音
        [self.handsFreeBtn setImage:[UIImage imageNamed:@"call_unyangshengqi.png"] forState:UIControlStateNormal];//耳听
    }else{
        // 拒接
        [self dismiss];
    }
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)onRTSTerminate:(int)chatid {
    [self dismiss];
}


@end
