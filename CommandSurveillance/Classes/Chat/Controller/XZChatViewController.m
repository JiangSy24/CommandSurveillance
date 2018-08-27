//
//  XZChatViewController.m
//  XZ_WeChat
//
//  Created by 郭现壮 on 16/9/27.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import "XZChatViewController.h"
#import "CSSingleCallingVController.h"
#import "CSGroupCallingVController.h"
#import "CSManageGroupVC.h"
#import "ICChatMessageLocationCell.h"
#import "MainViewController.h"
#import "CSMapShowVController.h"
#import "CSInviteViewController.h"

@interface XZChatViewController ()<ICChatBoxViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,ICRecordManagerDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,BaseCellDelegate,WMIMChatManageToolDelegate,CSManageGroupVCDelegate,WMIMTeamManageToolDelegate,MainViewControllerDelegate,ICChatMessageLocationCellDelegate>
{
    CGRect _smallRect;
    CGRect _bigRect;
    
    UIMenuItem * _copyMenuItem;
    UIMenuItem * _deleteMenuItem;
    UIMenuItem * _forwardMenuItem;
    UIMenuItem * _recallMenuItem;
    NSIndexPath *_longIndexPath;
    
    BOOL   _isKeyBoardAppear;     // 键盘是否弹出来了
}

@property (nonatomic, strong) ICChatBoxViewController *chatBoxVC;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *textView;

/** voice path */
@property (nonatomic, copy) NSString *voicePath;

@property (nonatomic, strong) UIImageView *currentVoiceIcon;
@property (nonatomic, strong) UIImageView *presentImageView;
@property (nonatomic, assign)  BOOL presentFlag;  // 是否model出控制器
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) ICVoiceHud *voiceHud;

@end

@implementation XZChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.group.gName;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [self setupUI];
    
    [self registerCell];
    
    [self loadDataSource];
    
}
/*
 typedef NS_ENUM(NSInteger, IM_GroupMsgId)，进帮会点幸运，辽军大营金刚钻，搬砖，挖宝
 {
 IM_GroupMsgId_Invalid = 0,
 IM_GroupMsgId_Join_Notify, //添加组通知(自己被邀请入群), {"sponsorid", "groupinfo":[{"id", "name", "owner", "createtime", "reserved1", "reserved2", "reserved3", "reserved4", "member":[{"id"}]}]}
 IM_GroupMsgId_Other_Join_Notify, //其他人加群通知, {"sponsorid", "groupid", "joinids":[{"id"}]}
 IM_GroupMsgId_KickOut_Notify,  //被踢通知(自己), {"sponsorid", "groupid"}
 IM_GroupMsgId_Other_KickOut_Notify, //被踢通知(其他), {"sponsorid", "groupid", "kickoutid"}
 IM_GroupMsgId_HadLeft_Notify, //退群通知, {"groupid", "userid"}
 IM_GroupMsgId_Dissolve_Notify, //解散通知, {"sponsorid", "groupid"}
 };
 */
- (void)teamChangeNot:(NSNotification*)not{
    WMGroupActModel *tem = not.object;
    
    if ((self.session.sessionId.intValue != tem.groupid) ||
        (self.session.conversationType != WMIMConversationTypeGroup)) {
        
        return;
    }
    
    switch (tem.nMsgId) {
        case IM_GroupMsgId_Join_Notify:
        {
            //添加组通知(自己被邀请入群)
            break;
        }
        case IM_GroupMsgId_Other_Join_Notify:
        {
            //其他人加群通知
            for (WMGroupMsgUserModel *mm in tem.joinids) {
                WMGroupMember *groupMm = [[WMGroupMember alloc] init];
                groupMm.id = mm.id;
                groupMm.name = [CSUsersModel instance].dicPreAccount[UserDicKey(mm.id)];
                [self.session.member addObject:groupMm];
            }
            break;
        }
        case IM_GroupMsgId_Other_KickOut_Notify://被踢通知(其他)
        {
            for (WMGroupMember *groupMm in self.session.member) {
                if (groupMm.id == tem.kickoutid) {
                    [self.session.member removeObject:groupMm];
                    break;
                }
            }
            break;
        }
        case IM_GroupMsgId_HadLeft_Notify://退群通知
        {
            for (WMGroupMember *groupMm in self.session.member) {
                if (groupMm.id == tem.userid) {
                    [self.session.member removeObject:groupMm];
                    break;
                }
            }
            break;
        }
        default:
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)setupUI
{
    UIView *viewBk = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CSScreenW, 64)];
    viewBk.backgroundColor = CSColorZiSe;
    [self.view addSubview:viewBk];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = IColor(240, 237, 237);
    // 注意添加顺序
    [self addChildViewController:self.chatBoxVC];
    [self.view addSubview:self.chatBoxVC.view];
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:singleTapGesture];
    
    self.tableView.backgroundColor = IColor(240, 237, 237);
    // self.view的高度有时候是不准确的
    self.tableView.frame = CGRectMake(0, HEIGHT_NAVBAR+HEIGHT_STATUSBAR, self.view.width, APP_Frame_Height-HEIGHT_TABBAR-HEIGHT_NAVBAR-HEIGHT_STATUSBAR);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    UIImage *image = [UIImage imageNamed:@"call_singal_about"];
    if (self.session.conversationType == WMIMConversationTypeGroup) {
        image = [UIImage imageNamed:@"call_group_about"];
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightAction:)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    [[IMChatManageTool instance].chatManager addDelegate:self];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger row = [self.tableView numberOfRowsInSection:0] - 1;
        if (row > 0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    });
}
-(void)viewDidAppear:(BOOL)animated{
//    [self scrollToBottom];
}

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamChangeNot:) name:CSNoticeTeamChange object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc{
    [[IMChatManageTool instance].chatManager removeDelegate:self];
    [[IMChatManageTool instance].teamManage removeDelegate:self];
}

/*
 typedef NS_ENUM(NSInteger, IM_GroupMsgId)
 {
 IM_GroupMsgId_Invalid = 0,
 IM_GroupMsgId_Join_Notify, //添加组通知(自己被邀请入群), {"sponsorid", "groupinfo":[{"id", "name", "owner", "createtime", "reserved1", "reserved2", "reserved3", "reserved4", "member":[{"id"}]}]}
 IM_GroupMsgId_Other_Join_Notify, //其他人加群通知, {"sponsorid", "groupid", "joinids":[{"id"}]}
 IM_GroupMsgId_KickOut_Notify,  //被踢通知(自己), {"sponsorid", "groupid"}
 IM_GroupMsgId_Other_KickOut_Notify, //被踢通知(其他), {"sponsorid", "groupid", "kickoutid"}
 IM_GroupMsgId_HadLeft_Notify, //退群通知, {"groupid", "userid"}
 IM_GroupMsgId_Dissolve_Notify, //解散通知, {"sponsorid", "groupid"}
 };
 */
#pragma mark
- (void)onTeamMemberChanged:(WMGroupActModel *)team{
    switch (team.nMsgId) {
        case IM_GroupMsgId_KickOut_Notify://被踢通知(自己)
        case IM_GroupMsgId_HadLeft_Notify://退群通知
        case IM_GroupMsgId_Dissolve_Notify:
        {
            //解散通知
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - gesture actions
- (void)closeKeyboard:(UITapGestureRecognizer *)recognizer {
    //在对应的手势触发方法里面让键盘失去焦点
    [self.chatBoxVC resignFirstResponder];
}

- (void)backAction:(id)render{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction:(id)render{
    CSManageGroupVC *vc = [CSManageGroupVC myTableViewController];
    vc.iGroupId = self.group.gId.intValue;
    vc.groupModel = self.groupModel;
    vc.session = self.session;
    vc.delegate = self;
    NSMutableArray *array = [NSMutableArray array];
    for (WMGroupMember *member in self.session.member) {
        CSOneUserModel *model = [[CSOneUserModel alloc] init];
        model.id = member.id;
        model.name = member.name;
        [array addObject:model];
    }
    vc.array = array;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark groupmanage
- (void)groupHadLeft{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)registerCell
{
    [self.tableView registerClass:[ICChatMessageTextCell class] forCellReuseIdentifier:TypeText];
    [self.tableView registerClass:[ICChatMessageImageCell class] forCellReuseIdentifier:TypePic];
    [self.tableView registerClass:[ICChatMessageVideoCell class] forCellReuseIdentifier:TypeVideo];
    [self.tableView registerClass:[ICChatMessageVoiceCell class] forCellReuseIdentifier:TypeVoice];
    [self.tableView registerClass:[ICChatMessageFileCell class] forCellReuseIdentifier:TypeFile];
    [self.tableView registerClass:[ICChatMessageLocationCell class] forCellReuseIdentifier:TypeLocation];
}

// 加载数据
- (void)loadDataSource
{
//    [weadSelf.dataSource addObjectsFromArray:array];
//    [weadSelf scrollToBottom];
}

#pragma mark - Tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj                            = self.dataSource[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return nil;
    } else {
        ICMessageFrame *modelFrame     = (ICMessageFrame *)obj;
        NSString *ID                   = modelFrame.model.message.type;
        if ([ID isEqualToString:TypeSystem]) {
            ICChatSystemCell *cell = [ICChatSystemCell cellWithTableView:tableView reusableId:ID];
            cell.messageF              = modelFrame;
            return cell;
        }
        ICChatMessageBaseCell *cell    = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.longPressDelegate         = self;
        
        if ([modelFrame.model.message.type isEqualToString:TypeLocation]) {
            ((ICChatMessageLocationCell*)cell).delegate = self;
        }

        [[ICMediaManager sharedManager] clearReuseImageMessage:cell.modelFrame.model];
        cell.modelFrame                = modelFrame;
        return cell;
    }
}

#pragma mark - celldelegate
- (void)clickMap:(ICMessageModel *)message{
    // 跳新页面
    CSMapShowVController *map = [[CSMapShowVController alloc] init];
    map.message = message;
    CSMainTabNavigation *nc = [[CSMainTabNavigation alloc] initWithRootViewController:map];
    [self presentViewController:nc animated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICMessageFrame *messageF = [self.dataSource objectAtIndex:indexPath.row];
    return messageF.cellHight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.chatBoxVC resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.chatBoxVC resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([cell isKindOfClass:[ICChatMessageVideoCell class]] && self) {
        ICChatMessageVideoCell *videoCell = (ICChatMessageVideoCell *)cell;
        [videoCell stopVideo];
    }
}

#pragma mark - ICChatBoxViewControllerDelegate

- (void)chatBoxViewController:(ICChatBoxViewController *)chatboxViewController
        didChangeChatBoxHeight:(CGFloat)height
{
    self.chatBoxVC.view.top = self.view.bottom-height;
    self.tableView.height = HEIGHT_SCREEN - height - HEIGHT_NAVBAR-HEIGHT_STATUSBAR;
    if (height == HEIGHT_TABBAR) {
        [self.tableView reloadData];
        _isKeyBoardAppear  = NO;
    } else {
        [self scrollToBottom];
        _isKeyBoardAppear  = YES;
    }
    if (self.textView == nil) {
        self.textView = chatboxViewController.chatBox.textView;
    }
}

- (void)chatBoxViewController:(ICChatBoxViewController *)chatboxViewController didVideoViewAppeared:(ICVideoView *)videoView
{
    [_chatBoxVC.view setFrame:CGRectMake(0, HEIGHT_SCREEN-HEIGHT_TABBAR, App_Frame_Width, APP_Frame_Height)];
    videoView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.height = HEIGHT_SCREEN - videwViewH - HEIGHT_NAVBAR-HEIGHT_STATUSBAR;
        self.chatBoxVC.view.frame = CGRectMake(0, videwViewX+HEIGHT_NAVBAR+HEIGHT_STATUSBAR, App_Frame_Width, videwViewH);
        [self scrollToBottom];
    } completion:^(BOOL finished) { // 状态改变
        self.chatBoxVC.chatBox.status = ICChatBoxStatusShowVideo;
        // 在这里创建视频设配
        UIView *videoLayerView = [videoView viewWithTag:1000];
        UIView *placeholderView = [videoView viewWithTag:1001];
        [[ICVideoManager shareManager] setVideoPreviewLayer:videoLayerView];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(videoPreviewLayerWillAppear:) userInfo:placeholderView repeats:NO];
        
    }];
}

- (void)chatBoxViewController:(ICChatBoxViewController *)chatboxViewController sendVideoMessage:(NSString *)videoPath
{
    ICMessageFrame *messageFrame = [ICMessageHelper createMessageFrame:TypeVideo content:@"[视频]" path:videoPath from:@"gxz" to:self.group.gId fileKey:nil isSender:YES isChatGroup:(self.session.conversationType == WMIMConversationTypeGroup) receivedSenderByYourself:NO isHaveTimeLabel:NO]; // 创建本地消息
    [self addObject:messageFrame isSender:YES];
    [self messageSendSucced:messageFrame];
}

- (void) chatBoxViewController:(ICChatBoxViewController *)chatboxViewController sendFileMessage:(NSString *)fileName
{
    NSString *lastName = [fileName originName];
    NSString*fileKey   = [fileName firstStringSeparatedByString:@"_"];
    NSString *content = [NSString stringWithFormat:@"[文件]%@",lastName];
    ICMessageFrame *messageFrame = [ICMessageHelper createMessageFrame:TypeFile content:content path:fileName from:@"gxz" to:self.group.gId fileKey:nil isSender:YES isChatGroup:(self.session.conversationType == WMIMConversationTypeGroup) receivedSenderByYourself:NO isHaveTimeLabel:NO];
    NSString *path = [[ICFileTool fileMainPath] stringByAppendingPathComponent:fileName];
    double s = [ICFileTool fileSizeWithPath:path];
    NSNumber *x = [ICMessageHelper fileType:[fileName pathExtension]];
    if (!x) {
        x = @0;
    }
    NSDictionary *lnk = @{@"s":@((long)s),@"x":x,@"n":lastName};
    messageFrame.model.message.lnk = [lnk jsonString];
    messageFrame.model.message.fileKey = fileKey;
    [self addObject:messageFrame isSender:YES];
    [self messageSendSucced:messageFrame];
}

// send text message
- (void) chatBoxViewController:(ICChatBoxViewController *)chatboxViewController
               sendTextMessage:(NSString *)messageStr
{
    if (messageStr && messageStr.length > 0) {
        [self sendTextMessageWithContent:messageStr];
    }
}

- (NSString*)chatType:(WMIMessageType)type{
    NSString *strType = nil;
    switch (type) {
        case WMIMessageTypeText:
        {
            strType = TypeText;
            break;
        }
        case WMIMessageTypeAudio:
        {
            strType = TypeVoice;
            break;
        }
        case WMIMessageTypeImage:
        {
            strType = TypePic;
            break;
        }
        case WMIMessageTypeLocation:
        {
            strType = TypeLocation;
            break;
        }
        default:
            break;
    }
    return strType;
}

- (void)sendTextMessageWithContent:(NSString *)messageStr
{
    ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypeText content:messageStr path:nil from:UserDicKey([CSUrlString instance].account.sysconf.accountid) to:self.group.gId fileKey:nil isSender:YES isChatGroup:(self.session.conversationType == WMIMConversationTypeGroup) receivedSenderByYourself:NO isHaveTimeLabel:NO];
    messageF.model.message.messageId = UserDicKey((int)[NSDate date].timeIntervalSince1970);
    [self addObject:messageF isSender:YES];
    
    WMIMMessage *msg = [[WMIMMessage alloc] init];
    msg.createdTime = messageF.model.message.messageId.intValue;
    msg.sessionId = self.group.gId;
    msg.conversationType = self.session.conversationType;
    msg.fromId = UserDicKey([CSUrlString instance].account.sysconf.accountid);
    msg.toId = self.group.gId;
    msg.content = messageStr;
    msg.bIsRead = YES;
    msg.msgType = WMIMessageTypeText;
    msg.msgId = (int)messageF.model.message.messageId;
    
    [[IMChatManageTool instance].chatManager sendMessage:msg];
}

- (void)otherSendTextMessageWithContent:(WMIMMessage *)message
{
    if ([message.sessionId isEqualToString: self.group.gId]) {
        ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:[self chatType:message.msgType] content:[CSStatusTool contentMake:message] path:[CSStatusTool pathMake:message] from:message.fromId to:self.group.gId fileKey:nil isSender:NO isChatGroup:(self.session.conversationType == WMIMConversationTypeGroup) receivedSenderByYourself:NO isHaveTimeLabel:NO];
        
        [self addObject:messageF isSender:YES];
    }
}

/*
 @property (nonatomic,assign) WMIMConversationType conversationType;
 @property (nonatomic,assign) int fromId;
 @property (nonatomic,assign) int toId;
 @property (nonatomic,copy) NSString *content;//文本就文本，image就是url，是自己的就存本地url,音频就是数据
 @property (nonatomic,assign) BOOL bIsRead;//是否已读
 @property (nonatomic,assign) WMIMSendStatus sendStatus;//发送状态
 @property (nonatomic,assign) WMIMessageType msgType;//消息类型
 @property (nonatomic,assign) int msgId;
 */
#pragma mark - IMChatManageToolDelegate
/**
 *  发送消息完成回调
 *
 *  @param message 当前发送的消息
 *  @param error   失败原因,如果发送成功则error为nil
 */
- (void)sendMessage:(WMIMMessage *_Nonnull)message didCompleteWithError:(nullable NSError *)error{
    for (ICMessageFrame *model in self.dataSource) {
        if ([model.model.message.messageId isEqualToString:UserDicKey(message.createdTime)]) {
            model.model.message.messageId = UserDicKey(message.msgId);
            dispatch_async(dispatch_get_main_queue(), ^{
                model.model.message.deliveryState = message.sendStatus == WMIMSendStatus_SENT ? ICMessageDeliveryState_Delivered : ICMessageDeliveryState_Failure;
                [self messageSendSucced:model];
            });
        }
    }
}

- (void)recvMessage:(WMIMMessage *)message{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([message.fromId isEqualToString:self.group.gId]) {
            message.bIsRead = YES;
            NSString *sql = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"msgId"),@(message.msgId)];
            [message bg_updateWhere:sql];
            [self otherSendTextMessageWithContent:message];
//            [WMIMMessage bg_clear:message.bg_tableName];
        }
    });
}

// 增加数据源并刷新
- (void)addObject:(ICMessageFrame *)messageF
         isSender:(BOOL)isSender
{
    [self.dataSource addObject:messageF];
    [self.tableView reloadData];
    if (isSender || _isKeyBoardAppear) {
        [self scrollToBottom];
    }
}

- (void)messageSendSucced:(ICMessageFrame *)messageF
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        messageF.model.message.deliveryState = ICMessageDeliveryState_Delivered;
        [self.tableView reloadData];
    });
}

// send image message
- (void)chatBoxViewController:(ICChatBoxViewController *)chatboxViewController
              sendImageMessage:(UIImage *)image
                     imagePath:(NSString *)imgPath
{
    if (image && imgPath) {
        [self sendImageMessageWithImgPath:imgPath];
    }
}

/**
 发起位置分享
 */
- (void)locationShare{
    MainViewController *vv = [[MainViewController alloc] init];
    vv.delegate = self;
    CSMainTabNavigation *nav = [[CSMainTabNavigation alloc] initWithRootViewController:vv];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark MainViewControllerDelegate
- (void)sendLocation:(LocationModel *)model{
    NSData *imageData = UIImagePNGRepresentation(model.snapImage);
    NSString *content = [NSString stringWithFormat:@"%f-%f-%@-%@",model.longitude,model.latitude,model.address,[imageData base64EncodedStringWithOptions:0]];
    
    ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypeLocation content:@"[位置]" path:content from:UserDicKey([CSUrlString instance].account.sysconf.accountid) to:self.group.gId fileKey:nil isSender:YES isChatGroup:(self.session.conversationType == WMIMConversationTypeGroup) receivedSenderByYourself:NO isHaveTimeLabel:NO];
    messageF.model.message.messageId = UserDicKey((int)[NSDate date].timeIntervalSince1970);
    [self addObject:messageF isSender:YES];
    
    WMIMMessage *msg = [[WMIMMessage alloc] init];
    msg.createdTime = messageF.model.message.messageId.intValue;
    msg.sessionId = self.group.gId;
    msg.conversationType = self.session.conversationType;
    msg.fromId = UserDicKey([CSUrlString instance].account.sysconf.accountid);
    msg.toId = self.group.gId;
    msg.content = content;
    NSLog(@"sendLocation content[%@]",msg.content);
    msg.bIsRead = YES;
    msg.msgType = WMIMessageTypeLocation;
    msg.msgId = (int)messageF.model.message.messageId;
    
    [[IMChatManageTool instance].chatManager sendMessage:msg];
}

/**
 开始语音对讲
 */
- (void)voiceCommunicationStart{
    
    // 会话类型判断发起多人的还是单人的。
    if (self.session.conversationType == WMIMConversationTypeSingle) {
        self.session.callType = WM_IM_CallType_Single_Voice;
        [[IMChatManageTool instance].callManage requestRTS:self.session completion:^(int error, int chatid) {
            if (error == 0) {
                
                // 成功
                CSSingleCallingVController *vc = [CSSingleCallingVController myTableViewController];
                vc.chatId = chatid;
                vc.toUserid = [self.group.gId intValue];
                vc.sponsorid = [CSUrlString instance].account.sysconf.accountid;
                [self presentViewController:vc animated:NO completion:nil];
                
            }
        }];
        
    }else{

        // 有个改动，来一首搞基送给各位
        CSInviteViewController *vc = [CSInviteViewController myTableViewController];
        vc.iGroupId = self.group.gId.intValue;
        vc.groupModel = self.groupModel;
        vc.session = self.session;
        NSMutableArray *array = [NSMutableArray array];
        for (WMGroupMember *member in self.session.member) {
            CSOneUserModel *model = [[CSOneUserModel alloc] init];
            model.id = member.id;
            model.name = member.name;
            [array addObject:model];
        }
        vc.array = array;
        vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        CSMainTabNavigation *nv = [[CSMainTabNavigation alloc] initWithRootViewController:vc];

        [self presentViewController:nv animated:NO completion:nil];
        
    }
}

/**
 开始抢麦对讲
 */
- (void)micCommunicationStart{
    if (self.session.conversationType == WMIMConversationTypeSingle) {
        [MBProgressHUD showTips:@"暂不支持" detail:nil forView:self.view];
        return;
    }
    self.session.callType = WM_IM_CallType_Group_Voice_RobMic;
    [[IMChatManageTool instance].callManage requestRTS:self.session completion:^(int error, int chatid) {
        if (error == 0) {
            
            CSGroupCallingVController *vc = [CSGroupCallingVController myTableViewController];
            NSMutableArray *array = [NSMutableArray array];
            for (WMGroupMember *mem in self.session.member) {
                if (mem.id == [CSUrlString instance].account.sysconf.accountid) {
                    mem.bIsJoinSession = YES;
                }else{
                    mem.bIsJoinSession = NO;
                }
                [array addObject:mem];
            }
            vc.groupId = self.group.gId.intValue;
            vc.bIsMicCalling = YES;
            vc.callingArray = array;
            vc.chatId = chatid;
            vc.sponsorid = [CSUrlString instance].account.sysconf.accountid;
            [self presentViewController:vc animated:NO completion:nil];
            
        }
    }];
}

/**
 获取图片
 */
- (void)imagesFromAlbum:(NSArray<NSString *> *)selectPhotos{
    for (int i = 0; i < selectPhotos.count; i++) {
        NSString *path = selectPhotos[i];
        ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypePic content:@"[图片]" path:path from:@"gxz" to:self.group.gId fileKey:nil isSender:YES isChatGroup:(self.session.conversationType == WMIMConversationTypeGroup) receivedSenderByYourself:NO isHaveTimeLabel:NO];
        [self addObject:messageF isSender:YES];
        messageF.model.message.messageId = UserDicKey((int)[NSDate date].timeIntervalSince1970+i);
        [self messageSendSucced:messageF];
        
        WMIMMessage *msg = [[WMIMMessage alloc] init];
        msg.createdTime = messageF.model.message.messageId.intValue;
        msg.sessionId = self.group.gId;
        msg.conversationType = self.session.conversationType;
        msg.fromId = UserDicKey([CSUrlString instance].account.sysconf.accountid);
        msg.toId = self.group.gId;
        msg.content = path;
        msg.bIsRead = YES;
        msg.msgType = WMIMessageTypeImage;
        msg.msgId = (int)messageF.model.message.messageId;
        
        [[IMChatManageTool instance].chatManager sendMessage:msg];
    }
}

- (void)sendImageMessageWithImgPath:(NSString *)imgPath
{
    ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypePic content:@"[图片]" path:imgPath from:UserDicKey([CSUrlString instance].account.sysconf.accountid) to:self.group.gId fileKey:nil isSender:YES isChatGroup:(self.session.conversationType == WMIMConversationTypeGroup) receivedSenderByYourself:NO isHaveTimeLabel:NO];
    messageF.model.message.messageId = UserDicKey((int)[NSDate date].timeIntervalSince1970);
    [self addObject:messageF isSender:YES];
    
    [self messageSendSucced:messageF];
    
}

// send voice message
- (void) chatBoxViewController:(ICChatBoxViewController *)chatboxViewController sendVoiceMessage:(NSString *)voicePath
{
    [self timerInvalue]; // 销毁定时器
    self.voiceHud.hidden = YES;
    if (voicePath) {
        ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypeVoice content:@"[语音]" path:voicePath from:UserDicKey([CSUrlString instance].account.sysconf.accountid) to:self.group.gId fileKey:nil isSender:YES isChatGroup:(self.session.conversationType == WMIMConversationTypeGroup) receivedSenderByYourself:NO isHaveTimeLabel:NO];
        messageF.model.message.messageId = UserDicKey((int)[NSDate date].timeIntervalSince1970);
        [self addObject:messageF isSender:YES];
        NSFileHandle *readFileHandle = [NSFileHandle fileHandleForReadingAtPath:voicePath];
        NSString *toPath = [NSString stringWithFormat:@"%@/%@",RecordPath,voicePath.lastPathComponent];
        NSData *data = [readFileHandle readDataToEndOfFile];
        [data writeToFile:toPath atomically:YES];
        NSString* messageStr = [data base64EncodedStringWithOptions:0];
        // 发音频
        WMIMMessage *msg = [[WMIMMessage alloc] init];
        msg.createdTime = messageF.model.message.messageId.intValue;
        msg.sessionId = self.group.gId;
        msg.conversationType = self.session.conversationType;
        msg.fromId = UserDicKey([CSUrlString instance].account.sysconf.accountid);
        msg.toId = self.group.gId;
        msg.content = messageStr;
        msg.videoName = voicePath.lastPathComponent;
        msg.bIsRead = YES;
        msg.msgType = WMIMessageTypeAudio;
        msg.msgId = (int)messageF.model.message.messageId;

        [[IMChatManageTool instance].chatManager sendMessage:msg];
        [self messageSendSucced:messageF];
    }
}


#pragma mark - baseCell delegate

- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer
{
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location       = [longRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        _longIndexPath         = indexPath;
        id object              = [self.dataSource objectAtIndex:indexPath.row];
        if (![object isKindOfClass:[ICMessageFrame class]]) return;
        ICChatMessageBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath message:cell.modelFrame.model];
    }
}


#pragma mark - public method

// 路由响应
- (void)routerEventWithName:(NSString *)eventName
                   userInfo:(NSDictionary *)userInfo
{
    ICMessageFrame *modelFrame = [userInfo objectForKey:MessageKey];
    if ([eventName isEqualToString:GXRouterEventTextUrlTapEventName]) {
    } else if ([eventName isEqualToString:GXRouterEventImageTapEventName]) {
        _smallRect             = [[userInfo objectForKey:@"smallRect"] CGRectValue];
        _bigRect               =  [[userInfo objectForKey:@"bigRect"] CGRectValue];
        NSString *imgPath      = modelFrame.model.mediaPath;
        NSString *orgImgPath = [[ICMediaManager sharedManager] originImgPath:modelFrame];
        if ([ICFileTool fileExistsAtPath:orgImgPath]) {
            modelFrame.model.mediaPath = orgImgPath;
            imgPath                    = orgImgPath;
        }
        [self showLargeImageWithPath:imgPath withMessageF:modelFrame];
    } else if ([eventName isEqualToString:GXRouterEventVoiceTapEventName]) {
        
        UIImageView *imageView = (UIImageView *)userInfo[VoiceIcon];
        UIView *redView        = (UIView *)userInfo[RedView];
        [self chatVoiceTaped:modelFrame voiceIcon:imageView redView:redView];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - voice & video

- (void)voiceDidCancelRecording
{
    [self timerInvalue];
    self.voiceHud.hidden = YES;
}
- (void)voiceDidStartRecording
{
    [self timerInvalue];
    self.voiceHud.hidden = NO;
    [self timer];
}

// 向外或向里移动
- (void)voiceWillDragout:(BOOL)inside
{
    if (inside) {
        [_timer setFireDate:[NSDate distantPast]];
        _voiceHud.image  = [UIImage imageNamed:@"voice_1"];
    } else {
        [_timer setFireDate:[NSDate distantFuture]];
        self.voiceHud.animationImages  = nil;
        self.voiceHud.image = [UIImage imageNamed:@"cancelVoice"];
    }
}
- (void)progressChange
{
    AVAudioRecorder *recorder = [[ICRecordManager shareManager] recorder] ;
    [recorder updateMeters];
    float power= [recorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0,声音越大power绝对值越小
    CGFloat progress = (1.0/160)*(power + 160);
    self.voiceHud.progress = progress;
}

- (void)voiceRecordSoShort
{
    [self timerInvalue];
    self.voiceHud.animationImages = nil;
    self.voiceHud.image = [UIImage imageNamed:@"voiceShort"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.voiceHud.hidden = YES;
    });
}

// play voice
- (void)chatVoiceTaped:(ICMessageFrame *)messageFrame
             voiceIcon:(UIImageView *)voiceIcon
               redView:(UIView *)redView
{
    ICRecordManager *recordManager = [ICRecordManager shareManager];
    recordManager.playDelegate = self;
    // 文件路径
    NSString *voicePath = [self mediaPath:messageFrame.model.mediaPath];
    NSString *amrPath   = messageFrame.model.mediaPath;//[[voicePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"amr"];
    [VoiceConverter ConvertAmrToWav:amrPath wavSavePath:voicePath];
    if (messageFrame.model.message.status == 0){
        messageFrame.model.message.status = 1;
        redView.hidden = YES;
    }
    if (self.voicePath) {
        if ([self.voicePath isEqualToString:voicePath]) { // the same recoder
            self.voicePath = nil;
            [[ICRecordManager shareManager] stopPlayRecorder:voicePath];
            [voiceIcon stopAnimating];
            self.currentVoiceIcon = nil;
            return;
        } else {
            [self.currentVoiceIcon stopAnimating];
            self.currentVoiceIcon = nil;
        }
    }
    [[ICRecordManager shareManager] startPlayRecorder:voicePath];
    [voiceIcon startAnimating];
    self.voicePath = voicePath;
    self.currentVoiceIcon = voiceIcon;
}

// 移除录视频时的占位图片
- (void)videoPreviewLayerWillAppear:(NSTimer *)timer
{
    UIView *placeholderView = (UIView *)[timer userInfo];
    [placeholderView removeFromSuperview];
}


#pragma mark - ICRecordManagerDelegate

- (void)voiceDidPlayFinished
{
    self.voicePath = nil;
    ICRecordManager *manager = [ICRecordManager shareManager];
    manager.playDelegate = nil;
    [self.currentVoiceIcon stopAnimating];
    self.currentVoiceIcon = nil;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.presentFlag = YES;
    return self;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presentFlag = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.presentFlag) {
        UIView *toView              = [transitionContext viewForKey:UITransitionContextToViewKey];
        self.presentImageView.frame = _smallRect;
        [[transitionContext containerView] addSubview:self.presentImageView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.presentImageView.frame = _bigRect;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.presentImageView removeFromSuperview];
                [[transitionContext containerView] addSubview:toView];
                [transitionContext completeTransition:YES];
            }
        }];
    } else {
        ICPhotoBrowserController *photoVC = (ICPhotoBrowserController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIImageView *iv     = photoVC.imageView;
        UIView *fromView    = [transitionContext viewForKey:UITransitionContextFromViewKey];
        iv.center = fromView.center;
        [fromView removeFromSuperview];
        [[transitionContext containerView] addSubview:iv];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            iv.frame = _smallRect;
        } completion:^(BOOL finished) {
            if (finished) {
                [iv removeFromSuperview];
                [transitionContext completeTransition:YES];
            }
        }];
    }
}

#pragma mark - private

- (void) scrollToBottom
{
    if (self.dataSource.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

// tap image
- (void)showLargeImageWithPath:(NSString *)imgPath
                  withMessageF:(ICMessageFrame *)messageF
{
    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];//[[ICMediaManager sharedManager] imageWithLocalPath:imgPath];
    if (image == nil) {
        ICLog(@"image is not existed");
        return;
    }
    ICPhotoBrowserController *photoVC = [[ICPhotoBrowserController alloc] initWithImage:image];
    self.presentImageView.image       = image;
    photoVC.transitioningDelegate     = self;
    photoVC.modalPresentationStyle    = UIModalPresentationCustom;
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (void)timerInvalue
{
    [_timer invalidate];
    _timer  = nil;
}

// 文件路径
- (NSString *)mediaPath:(NSString *)originPath
{
    // 这里文件路径重新给，根据文件名字来拼接
    NSString *name = [[originPath lastPathComponent] stringByDeletingPathExtension];
    return [[ICRecordManager shareManager] receiveVoicePathWithFileKey:name];
}

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath message:(ICMessageModel *)messageModel
{
    if (_copyMenuItem   == nil) {
        _copyMenuItem   = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    }
    if (_forwardMenuItem == nil) {
        _forwardMenuItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardMessage:)];
    }
    NSInteger currentTime = [ICMessageHelper currentMessageTime];
    NSInteger interval    = currentTime - messageModel.message.date;
    if (messageModel.isSender) {
        if ((interval/1000) < 5*60 && !(messageModel.message.deliveryState == ICMessageDeliveryState_Failure)) {
            if (_recallMenuItem == nil) {
                _recallMenuItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(recallMessage:)];
            }
            [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_recallMenuItem,_forwardMenuItem]];
        } else {
            [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_forwardMenuItem]];
        }
    } else {
        [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_forwardMenuItem]];
    }
    [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview ];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)copyMessage:(UIMenuItem *)copyMenuItem
{
    UIPasteboard *pasteboard  = [UIPasteboard generalPasteboard];
    ICMessageFrame * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
    pasteboard.string         = messageF.model.message.content;
}

- (void)deleteMessage:(UIMenuItem *)deleteMenuItem
{
    // 这里还应该把本地的消息附件删除
    ICMessageFrame * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
    [self statusChanged:messageF];
}

- (void)recallMessage:(UIMenuItem *)recallMenuItem
{
    // 这里应该发送消息撤回的网络请求
    ICMessageFrame * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
    [self.dataSource removeObject:messageF];
    
    ICMessageFrame *msgF = [ICMessageHelper createMessageFrame:TypeSystem content:@"你撤回了一条消息" path:nil from:@"gxz" to:self.group.gId fileKey:nil isSender:YES isChatGroup:(self.session.conversationType == WMIMConversationTypeGroup) receivedSenderByYourself:NO isHaveTimeLabel:NO];
    [self.dataSource insertObject:msgF atIndex:_longIndexPath.row];
    [self.tableView reloadData];
}

- (void)statusChanged:(ICMessageFrame *)messageF
{
    [self.dataSource removeObject:messageF];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[_longIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)forwardMessage:(UIMenuItem *)forwardItem
{
    ICLog(@"需要用到的数据库，等添加了数据库再做转发...");
}

#pragma mark - Getter and Setter

- (ICChatBoxViewController *) chatBoxVC
{
    if (_chatBoxVC == nil) {
        _chatBoxVC = [[ICChatBoxViewController alloc] init];
        [_chatBoxVC.view setFrame:CGRectMake(0,APP_Frame_Height-HEIGHT_TABBAR, App_Frame_Width, APP_Frame_Height)];
        _chatBoxVC.delegate = self;
    }
    return _chatBoxVC;
}

-(UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
//        _tableView.contentInset = UIEdgeInsetsMake(-(HEIGHT_STATUSBAR+HEIGHT_NAVBAR), 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIImageView *)presentImageView
{
    if (!_presentImageView) {
        _presentImageView = [[UIImageView alloc] init];
    }
    return _presentImageView;
}

- (ICVoiceHud *)voiceHud
{
    if (!_voiceHud) {
        _voiceHud = [[ICVoiceHud alloc] initWithFrame:CGRectMake(0, 0, 155, 155)];
        _voiceHud.hidden = YES;
        [self.view addSubview:_voiceHud];
        _voiceHud.center = CGPointMake(App_Frame_Width/2, APP_Frame_Height/2);
    }
    return _voiceHud;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer =[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
        [_timer fire];
    }
    return _timer;
}




@end
