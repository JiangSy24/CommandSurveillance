//
//  CSSingleCallingVController.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/9.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSGroupCallingVController.h"
#import "CSSIngleCallCViewCell.h"
#import "CSCallingChoiceUsersVC.h"

@interface CSGroupCallingVController ()<WMIMChatCallManageDelegate,UICollectionViewDelegate,UICollectionViewDataSource,CSCallingChoiceUsersVCDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *allowBtnView;
@property (weak, nonatomic) IBOutlet UIView *rejectBtnView;
@property (weak, nonatomic) IBOutlet UIView *soundOffBtnView;
@property (weak, nonatomic) IBOutlet UIView *allowedRejectBtnView;
@property (weak, nonatomic) IBOutlet UIView *handsFreeBtnView;
@property (weak, nonatomic) IBOutlet UIButton *soundOffBtn;
@property (weak, nonatomic) IBOutlet UIButton *handsFreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
//麦克相关的
@property (weak, nonatomic) IBOutlet UIView *micView;
@property (weak, nonatomic) IBOutlet UIView *micTipView;
@property (weak, nonatomic) IBOutlet UILabel *mictipLabel;
@property (weak, nonatomic) IBOutlet UIButton *micBtn;
@property (weak, nonatomic) IBOutlet UIButton *topleftBtn;

@property (nonatomic, assign) int iRobMic;//0-成功，1-失败, 其他-错误码

@property (nonatomic, strong) NSMutableArray<WMGroupMember*>* callingUsers;
@end

@implementation CSGroupCallingVController

- (void)confirmClicked:(NSMutableArray<CSOneUserModel*>*)selectArray{
    //新来的发起邀请走起来哥几个
    for (CSOneUserModel *user in selectArray) {
        [[IMChatManageTool instance].callManage inviteRTS:self.chatId sponsorid:self.sponsorid userid:user.id];
    }
}

- (IBAction)addPeople:(id)sender {
    CSCallingChoiceUsersVC *vc = [CSCallingChoiceUsersVC myTableViewController];
    vc.delegate = self;
    vc.groupId = self.groupId;
    for (WMGroupMember *user in self.callingUsers) {
        if (user.bIsJoinSession) {
            [vc.joinInCallingPeople addObject:user];
        }
    }
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    CSMainTabNavigation *nc = [[CSMainTabNavigation alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:^{
        
    }];
}

- (NSMutableArray<WMGroupMember*>*)callingUsers{
    if (_callingUsers == nil) {
        _callingUsers = [NSMutableArray array];
    }
    return _callingUsers;
}

- (IBAction)shrinkClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.bIsMicCalling) {
            return;
        }
        [[CSNTESNotificationCenter sharedCenter] showMinisCalling:YES chatid:self.chatId sponsorid:self.sponsorid SoundOff:self.bSoundOffBtnisSelect HandsFree:self.bHandsFreebSelect sessionType:WM_IM_CallType_Group_Voice callingMemebers:self.callingUsers groupId:self.groupId];
    }];
}

- (void)makeCollectionLay:(UICollectionViewLayout*)layoutSrc{
    LewReorderableLayout *layout = (LewReorderableLayout *)layoutSrc;
    CGFloat width = (self.collectionView.width - 60) / 3;
//    self.fHeight = width;
    layout.itemSize = CGSizeMake(width, width + 25);
    layout.minimumLineSpacing = 30.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 1.0f, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
}

- (void)changeUserMicStatus:(int)userid micStatus:(BOOL)bisOnMic{
    for (WMGroupMember *member in self.callingUsers) {
        if (member.id == userid) {
            member.bIsOnMic = bisOnMic;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.bIsMicCalling) {

        [self onChoiceMicStatus:YES];
        //0-成功，1-失败, 其他-错误码
        [[IMChatManageTool instance].callManage chatRobMic:self.chatId completion:^(int micResult, int chatid, int userid) {
            self.iRobMic = micResult;
            if (self.iRobMic == 1) {
                // 显示谁通话
                [self changeUserMicStatus:userid micStatus:YES];
            }
            
            if (self.iRobMic == 0) {
                [[IMChatManageTool instance].callManage chatFreeMic:self.chatId];
            }
        }];
    }
    self.testLabel.text = [NSString stringWithFormat:@"%d",self.chatId];

    for (WMGroupMember *model in self.callingArray) {
        [self.callingUsers addObject:[model mutableCopy]];
    }
    
    [self makeCollectionLay:self.collectionView.collectionViewLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    // Do any additional setup after loading the view.
    [[IMChatManageTool instance].callManage addDelegate:self];
    
    if (!self.bIsCalling) {// 非通话中
        self.soundOffBtn.enabled = NO;
        self.handsFreeBtn.enabled = NO;
        if (self.sponsorid == [CSUrlString instance].account.sysconf.accountid) {
            // 我是呼叫方
            if (self.bIsMicCalling) {
                [self allowMicUIRe];
            }else{
                [self allowUiRe:NO];
            }
        }else{
            // 我是被呼叫方
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

// bIsOnmic 是否被占麦
- (void)onChoiceMicStatus:(BOOL)bIsOnmic{
    if (!bIsOnmic) {
        [self.micBtn setImage:[UIImage imageNamed:@"call_onmic.png"] forState:UIControlStateNormal];
        [self.micBtn setImage:[UIImage imageNamed:@"call_onmic.png"] forState:UIControlStateHighlighted];
    }else{
        [self.micBtn setImage:[UIImage imageNamed:@"call_unmic.png"] forState:UIControlStateHighlighted];
        [self.micBtn setImage:[UIImage imageNamed:@"call_nomic.png"] forState:UIControlStateNormal];
    }
}

- (void)dealloc{
    [[IMChatManageTool instance].callManage removeDelegate:self];
}

- (void)allowMicUIRe{
    self.soundOffBtnView.hidden = YES;
    self.allowedRejectBtnView.hidden = YES;
    self.handsFreeBtnView.hidden = YES;
    self.allowBtnView.hidden = YES;
    self.rejectBtnView.hidden = YES;
    
    self.micView.hidden = NO;
    [self.topleftBtn setImage:[UIImage imageNamed:@"call_micclose.png"] forState:UIControlStateNormal];
    
    self.micTipView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.micTipView.layer.borderWidth = 1;
    self.micTipView.layer.cornerRadius = self.micTipView.height/2;
    self.micTipView.layer.masksToBounds = YES;
    
    [self.micBtn addTarget:self action:@selector(offsetButtonTouchBegin:)forControlEvents:UIControlEventTouchDown];// 摁下
    [self.micBtn addTarget:self action:@selector(offsetButtonTouchEnd:)forControlEvents:UIControlEventTouchUpInside];// 摁住并抬起
    [self.micBtn addTarget:self action:@selector(offsetButtonTouchEnd:)forControlEvents:UIControlEventTouchUpOutside];// 摁住移动到btn外，放手
}

-(void)offsetButtonTouchBegin:(id)sender{
    
    [[IMChatManageTool instance].callManage chatRobMic:self.chatId completion:^(int micResult, int chatid, int userid) {
        self.iRobMic = micResult;
        if (self.iRobMic == 0) {
            // 抢麦成功
            [self onChoiceMicStatus:YES];
        }
    }];
}

-(void) offsetButtonTouchEnd:(id)sender{
    
    if (self.iRobMic == 0) {
        [[IMChatManageTool instance].callManage chatFreeMic:self.chatId];
        [self onChoiceMicStatus:YES];
    }
}

- (void)allowUiRe:(BOOL)bIsAllow{
    self.soundOffBtnView.hidden = bIsAllow;
    self.allowedRejectBtnView.hidden = bIsAllow;
    self.handsFreeBtnView.hidden = bIsAllow;
    self.allowBtnView.hidden = !bIsAllow;
    self.rejectBtnView.hidden = !bIsAllow;
    
    self.micView.hidden = YES;
}

+(instancetype)myTableViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GroupCallingVController"];
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
        for (WMGroupMember *membter in self.callingArray) {
            if (membter.bIsJoinSession) {
                [[IMChatManageTool instance].callManage cancelRTS:self.chatId users:membter.id];
            }
        }

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
        for (LMCallModel *model in array) {
            WMGroupMember *mem = [[WMGroupMember alloc] init];
            mem.id = model.userid;
            CSOneUserModel *one = [CSUsersModel instance].dicPreAccount[UserDicKey(mem.id)];
            mem.name = one.name;
            mem.bIsJoinSession = YES;
            [self.callingUsers addObject:mem];
        }
        [self.collectionView reloadData];
    }];
    
    if (self.bIsMicCalling) {
        [self allowMicUIRe];
    }else{
        [self allowUiRe:NO];
        self.soundOffBtn.enabled = YES;
        self.handsFreeBtn.enabled = YES;
        [self.soundOffBtn setImage:[UIImage imageNamed:@"call_unjingyin.png"] forState:UIControlStateNormal];//有声音
        [self.handsFreeBtn setImage:[UIImage imageNamed:@"call_unyangshengqi.png"] forState:UIControlStateNormal];//耳听
    }
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
        for (WMGroupMember *member in self.callingUsers) {
            if (member.id == userid) {
                member.bIsJoinSession = YES;
                break;
            }
        }
        [self.collectionView reloadData];
    }else{

    }
}

/**
 *  用户加入了多人会议
 *
 *  @param userid     用户 id
 *  @param chatid     会议 id
 */
- (void)onUserJoined:(int)userid
              chatid:(int)chatid{
    
    do {
        
        for (WMGroupMember *membter in self.callingUsers) {
            if (membter.id == userid) {
                membter.bIsJoinSession = YES;
                break;
            }
        }
        
        [self.collectionView reloadData];
    } while (FALSE);
    
}

/**
 *  用户离开了多人会议
 *
 *  @param userid    用户 id
 *  @param chatid    会议 id
 */
- (void)onUserLeft:(int)userid
            chatid:(int)chatid{
    
    do {
        
        for (WMGroupMember *membter in self.callingUsers) {
            if (membter.id == userid) {
                membter.bIsJoinSession = NO;
                break;
            }
        }
        
        [self.collectionView reloadData];
    } while (FALSE);
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)onRTSTerminate:(int)chatid {
    [self dismiss];
}

/**
 *  成员抢麦成功
 *
 *  @param userid    用户 id
 *  @param chatid    会议 id
 */
- (void)userOnMic:(int)userid
           chatid:(int)chatid{
    [self changeUserMicStatus:userid micStatus:YES];
    if ([CSUrlString instance].account.sysconf.accountid == userid) {
        // 是自己
        [self onChoiceMicStatus:YES];
    }else{
        [self onChoiceMicStatus:NO];
    }
    [self.collectionView reloadData];
}

/**
 *  成员放麦
 *
 *  @param userid    用户 id
 *  @param chatid    会议 id
 */
- (void)userLeftMic:(int)userid
             chatid:(int)chatid{
    [self changeUserMicStatus:userid micStatus:NO];
    [self.micBtn setImage:[UIImage imageNamed:@"call_nomic.png"] forState:UIControlStateNormal];
    [self.collectionView reloadData];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    WMGroupMember *membter = self.session.member
    WMGroupMember *member = self.callingUsers[indexPath.row];
    CSSIngleCallCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SIngleCallCViewCell" forIndexPath:indexPath];
    cell.userName.text = member.name;
    cell.headerView.backgroundColor = member.bIsJoinSession ? CSColorZiSe : [UIColor grayColor];
    if (member.bIsOnMic && self.bIsMicCalling) {
        cell.headerView.backgroundColor = CSColorGreen;
    }
    cell.headUserImage.text = [CSStatusTool getShowUserName:member.name charNum:2];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.callingUsers.count;
}



@end
