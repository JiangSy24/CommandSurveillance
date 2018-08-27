//
//  CSNTESNotificationCenter.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/8.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSNTESNotificationCenter.h"
#import "IMChatMangeProtocol.h"
#import "CSSingleCallingVController.h"
#import "CSGroupCallingVController.h"
#import "WMDragView.h"
#import "CSZhiGroupCallingVController.h"


@interface CSNTESNotificationCenter()<WMIMChatCallManageDelegate>
@property (nonatomic,strong) WMDragView *miniCall;
@property (nonatomic,strong) NSMutableArray<WMGroupMember*>* groupCallingUsers;

@property (nonatomic,assign) int chatid;
@property (nonatomic,assign) int sponsorid;
@property (nonatomic,assign) BOOL bIsCalling;

@property (nonatomic,assign) BOOL bSoundOff;
@property (nonatomic,assign) BOOL bHandsFree;

@property (nonatomic,assign) WM_IM_CallType type;

@property (nonatomic,assign) int groupId;
@end
@implementation CSNTESNotificationCenter

- (NSMutableArray<WMGroupMember*>*)groupCallingUsers{
    if (_groupCallingUsers == nil) {
        _groupCallingUsers = [NSMutableArray array];
    }
    return _groupCallingUsers;
}

+ (instancetype)sharedCenter{
    static CSNTESNotificationCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSNTESNotificationCenter alloc] init];
    });
    return instance;
}
- (void)start{
    

    
    NSLog(@"Notification Center Setup");
}

- (WMDragView*)miniCall{
    if (_miniCall == nil) {
        ///初始化可以拖曳的view
        WMDragView *logoView = [[WMDragView alloc] initWithFrame:CGRectMake(CSScreenW - 70, CSScreenH / 2, 70, 70)];
        logoView.layer.cornerRadius = 14;
        logoView.isKeepBounds = YES;
        CSTabBarController *tab = [CSTabBarController instance];
        [tab.selectedViewController.view addSubview:logoView];
        logoView.backgroundColor = [UIColor clearColor];
        //设置显示图片方式一：
        logoView.imageView.image = [UIImage imageNamed:@"av_call"];
        //设置显示图片方式二：
        
        [[UIApplication sharedApplication].keyWindow addSubview:logoView];
        
        _miniCall = logoView;
        //限定logoView的活动范围
        //    logoView.center = self.view.center;
        logoView.clickDragViewBlock = ^(WMDragView *dragView){
            
            //        [self.navigationController pushViewController:[TestViewController new] animated:YES];
            //        [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController pushViewController:[TestViewController new] animated:YES];
            dragView.hidden = YES;
            
            if (self.type == WM_IM_CallType_Single_Voice) {
                // 呼出
                CSSingleCallingVController *vc = [CSSingleCallingVController myTableViewController];
                vc.chatId = self.chatid;
                vc.sponsorid = self.sponsorid;
                vc.bIsCalling = self.bIsCalling;
                vc.bHandsFreebSelect = self.bHandsFree;
                vc.bSoundOffBtnisSelect = self.bSoundOff;
                
                [self presentModelViewController:vc];
            }else{
                // 呼出
                CSGroupCallingVController *vc = [CSGroupCallingVController myTableViewController];
                vc.chatId = self.chatid;
                vc.sponsorid = self.sponsorid;
                vc.bIsCalling = self.bIsCalling;
                vc.callingArray = [NSMutableArray array];
                [vc.callingArray addObjectsFromArray:self.groupCallingUsers];
                vc.bHandsFreebSelect = self.bHandsFree;
                vc.bSoundOffBtnisSelect = self.bSoundOff;
                vc.groupId = self.groupId;
                [self presentModelViewController:vc];
            }

        };
    }
    return _miniCall;
}

- (BOOL)miniCallIsShow{
    return YES;
}

- (void)showMinisCalling:(BOOL)bCalling chatid:(int)chatid sponsorid:(int)sponsorid SoundOff:(BOOL)bSoundOff HandsFree:(BOOL)bHandsFree sessionType:(WM_IM_CallType)type callingMemebers:(NSArray<WMGroupMember*>*)memebers groupId:(int)groupId{
    self.miniCall.hidden = NO;
    self.bIsCalling = bCalling;
    self.chatid = chatid;
    self.bSoundOff = bSoundOff;
    self.bHandsFree = bHandsFree;
    self.type = type;
    self.groupId = groupId;
    [self.groupCallingUsers removeAllObjects];
    for(WMGroupMember *mem in memebers){
        WMGroupMember *newModel = [mem mutableCopy];
        [self.groupCallingUsers addObject:newModel];
    }
}

- (instancetype)init {
    self = [super init];
    if(self) {
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"message" withExtension:@"wav"];
//        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//        _notifier = [[NTESAVNotifier alloc] init];

        [[IMChatManageTool instance].callManage addDelegate:self]; // 聊天
    }
    return self;
}

- (void)dealloc{
    [[IMChatManageTool instance].callManage removeDelegate:self];
}

- (BOOL)shouldResponseBusy
{
    CSTabBarController *tabVC = [CSTabBarController instance];
    UINavigationController *nav = tabVC.selectedViewController;
    return [nav.topViewController isKindOfClass:[CSSingleCallingVController class]] ||
           [nav.topViewController isKindOfClass:[CSGroupCallingVController class]];
}

/**
 *  被叫收到实时会话请求
 *
 *  @param chatid 实时会话ID
 *  @param sponsorid 主叫用户id
 *  @param chattype 会话类型
 */
- (void)onRTSRequest:(int)chatid
                from:(int)sponsorid
            services:(WM_IM_CallType)chattype{
    if ([self shouldResponseBusy]) {
        [[IMChatManageTool instance].callManage responseRTS:chatid sponsorid:sponsorid accept:NO completion:^(int error, NSArray<LMCallModel *> * _Nullable array) {
            
        }];
    }
    else {

//        if ([self shouldFireNotification:caller]) {
//            NSString *text = [self textByCaller:caller];
//            [_notifier start:text];
//        }
        switch (chattype) {
            case WM_IM_CallType_Single_Voice:
            {
                CSSingleCallingVController *vc = [CSSingleCallingVController myTableViewController];
                vc.chatId = chatid;
                vc.sponsorid = sponsorid;
                vc.bIsCalling = NO;
                [self presentModelViewController:vc];
                break;
            }
            case WM_IM_CallType_Group_Voice:
            {
                CSGroupCallingVController *vc = [CSGroupCallingVController myTableViewController];
                vc.chatId = chatid;
                vc.sponsorid = sponsorid;
                [self presentModelViewController:vc];
                break;
            }
            case WM_IM_CallType_Group_Voice_RobMic:
            {
                CSGroupCallingVController *vc = [CSGroupCallingVController myTableViewController];
                vc.chatId = chatid;
                vc.sponsorid = sponsorid;
                vc.bIsMicCalling = YES;
                [self presentModelViewController:vc];
                break;
            }
            case WM_IM_CallType_Group_Conference:
            {
                CSZhiGroupCallingVController *vc = [CSZhiGroupCallingVController myTableViewController];
                vc.chatId = chatid;
                vc.sponsorid = sponsorid;
                [self presentModelViewController:vc];
                break;
            }
            default:
                break;
        }

    }
}

- (void)presentModelViewController:(UIViewController *)vc
{
    CSTabBarController *tab = [CSTabBarController instance];
    [tab.view endEditing:YES];
    if (tab.presentedViewController) {
        __weak CSTabBarController *wtabVC = tab;
        [tab.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [wtabVC presentViewController:vc animated:NO completion:nil];
        }];
    }else{
        [tab presentViewController:vc animated:NO completion:nil];
    }
}

/**
 *  主叫收到被叫实时会话响应
 *
 *  @param chatid 实时会话ID
 *  @param userid 被叫用户id
 *  @param response 是否接听, 1 是拒绝
 *
 */
- (void)onRTSResponse:(int)chatid
               userid:(int)userid
             response:(int)response{
    
}

/**
 *  对方结束实时会话
 *
 *  @param chatid 实时会话ID
 */
- (void)onRTSTerminate:(int)chatid{
    
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
        if (self.chatid != chatid) {
            break;
        }
        
        for (WMGroupMember *membter in self.groupCallingUsers) {
            if (membter.id == userid) {
                membter.bIsJoinSession = YES;
                break;
            }
        }
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
        if (self.chatid != chatid) {
            break;
        }
        
        for (WMGroupMember *membter in self.groupCallingUsers) {
            if (membter.id == userid) {
                membter.bIsJoinSession = NO;
                break;
            }
        }
    } while (FALSE);
    
}

@end
