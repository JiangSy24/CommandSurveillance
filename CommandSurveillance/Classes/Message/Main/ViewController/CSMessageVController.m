//
//  CSMessageVController.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/25.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSMessageVController.h"
#import "CSMessageUserCell.h"
#import "CSMessageGroupCell.h"
#import "CSMessageGroupMoreCell.h"
#import "XZChatViewController.h"

@interface CSMessageVController ()<UITableViewDelegate,UITableViewDataSource,WMIMChatManageToolDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<WMIMSession *> *sessionArray;
@end

@implementation CSMessageVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[IMChatManageTool instance].chatManager addDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashUI:) name:NoticLoginReflash object:nil];
}

- (NSMutableArray<WMIMSession *>*)sessionArray{
    if (_sessionArray == nil) {
        _sessionArray = [NSMutableArray array];
    }
    return _sessionArray;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[IMChatManageTool instance].chatManager removeDelegate:self];
}

- (void)reflashUI:(NSNotification*)noc{
    
    [[IMChatManageTool instance].msgDataManage sessionsInDblimit:20 complete:^(NSArray<WMIMSession *> *sessionArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sessionArray removeAllObjects];
            [self.sessionArray addObjectsFromArray:sessionArray];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated{

    [self reflashUI:nil];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//    }];
//    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sessionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CSCmCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WMIMSession *session = self.sessionArray[indexPath.row];
    UITableViewCell *cellT = nil;
    switch (session.member.count) {
        case 1:
        {
            CSMessageUserCell *cell = [self makeCellOne:tableView sessionModel:session];
            cell.iUnCount = session.iunReadCount;
            cellT = cell;
            break;
        }
        case 2:
        case 3:
        {
            CSMessageGroupCell *cell = [self makeCellThr:tableView sessionModel:session];
            cell.iUnCount = session.iunReadCount;
            cellT = cell;
            break;
        }
        default:
        {
            CSMessageGroupMoreCell *cell = [self makeCellFour:tableView sessionModel:session];
            cell.iUnCount = session.iunReadCount;
            cellT = cell;
            break;
        }
    }

    cellT.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellT;
}

-(CSMessageUserCell *)makeCellOne:(UITableView*)tableView sessionModel:(WMIMSession*)session{
    CSMessageUserCell *cell = [CSMessageUserCell tempTableViewCellWith:tableView];
    cell.username.text = session.member.firstObject.name;
    cell.userHeadLabel.text = [CSStatusTool getShowUserName:session.member.firstObject.name charNum:2];
    cell.lastMsgContent.text = [CSStatusTool contentMake:session.message];
    NSDateComponents *comps = [CSStatusTool dateComponentsFromSince1970:session.message.createdTime];
    cell.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",comps.hour,comps.minute];
    return cell;
}

-(CSMessageGroupCell *)makeCellThr:(UITableView*)tableView sessionModel:(WMIMSession*)session{
    CSMessageGroupCell *cell = [CSMessageGroupCell tempTableViewCellWith:tableView];

    for (int i = 0; i < session.member.count; i++) {
        NSString *show = [CSStatusTool getShowUserName:session.member[i].name charNum:2];
        switch (i) {
            case 0:
            {
                cell.oneLabel.text = show;
                break;
            }
            case 1:
            {
                cell.twoLabel.text = show;
                break;
            }
            case 2:
            {
                cell.threeLabel.text = show;
                break;
            }
            default:
                break;
        }
    }
    
    cell.groupName.text = session.groupName;
    NSDateComponents *comps = [CSStatusTool dateComponentsFromSince1970:session.message.createdTime];
    cell.time.text = [NSString stringWithFormat:@"%02ld:%02ld",comps.hour,comps.minute];
    cell.lastMsg.text = [CSStatusTool contentMake:session.message];
    return cell;
}

-(CSMessageGroupMoreCell *)makeCellFour:(UITableView*)tableView sessionModel:(WMIMSession*)session{
    CSMessageGroupMoreCell *cell = [CSMessageGroupMoreCell tempTableViewCellWith:tableView];
    
    for (int i = 0; i < session.member.count; i++) {
        NSString *show = [CSStatusTool getShowUserName:session.member[i].name charNum:2];
        switch (i) {
            case 0:
            {
                cell.oneLabel.text = show;
                break;
            }
            case 1:
            {
                cell.twoLabel.text = show;
                break;
            }
            case 2:
            {
                cell.threeLabel.text = show;
                break;
            }
            case 3:
            {
                cell.fourLabel.text = show;
                break;
            }
            default:
                break;
        }
    }
    
    cell.groupName.text = session.groupName;
    NSDateComponents *comps = [CSStatusTool dateComponentsFromSince1970:session.message.createdTime];
    cell.time.text = [NSString stringWithFormat:@"%02ld:%02ld",comps.hour,comps.minute];
    cell.msg.text = [CSStatusTool contentMake:session.message];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WMIMSession *session = self.sessionArray[indexPath.row];
    [[IMChatManageTool instance].msgDataManage updateAllmessagesStatusInSession:session];
    
    if (session.conversationType == WMIMConversationTypeGroup) {
        LMRegisterSyncgroupModel* model = nil;
        for (LMRegisterSyncgroupModel* tem in [LMRegisterModle instance].syncgroupArry) {
            if (tem.id == session.sessionId.intValue) {
                model = tem;
                break;
            }
        }
        if (model == nil) {
            model = [[LMRegisterSyncgroupModel alloc] init];
            model.id = session.sessionId.intValue;
            model.name = session.groupName;
            model.owner = session.owenid;
            for (WMGroupMember *mem in session.member) {
                LMRegisterSyncgroupModel *memTem = [[LMRegisterSyncgroupModel alloc] init];
                memTem.id = mem.id;
                memTem.name = mem.name;
                [model.member addObject:memTem];
            }
        }
        [CSStatusTool skipGroupChatVc:model vController:self];
    }else{
        [CSStatusTool skipOneChatVc:session userId:session.member.firstObject.id  vController:self];
    }

}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        
        if (indexPath.row < self.sessionArray.count) {
            
            WMIMDeleteMessagesOption *option = [WMIMDeleteMessagesOption alloc];
            option.removeSession = YES; //只是删除会话
            option.removeTable = YES; //会话内容永久删除
            [[IMChatManageTool instance].msgDataManage deleteAllmessagesInSession:self.sessionArray[indexPath.row] option:option];
            
            [self.sessionArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
    }
}

/**
 *  有信息来了,直接存入数据库，代理通知外部刷新数据。
 *  开始表演
 *
 */
- (void)recvMessage:(WMIMMessage *_Nonnull)message{
    
    for (WMIMSession *temSession in self.sessionArray) {
        if ([temSession.sessionId isEqualToString:message.sessionId]) {
            [self reflashUI:nil];
            return;
        }
    }
    
    if (message.conversationType == WMIMConversationTypeSingle) {
        CSOneUserModel* model = [CSUsersModel instance].dicPreAccount[UserDicKey(message.fromId.intValue)];
        //    chatVc.dataSource
        WMIMSession *session = [[WMIMSession alloc] init];
        WMGroupMember *other = [[WMGroupMember alloc] init];
        other.id = model.id;
        other.name = model.name;
        [session.member addObject:other];
        session.sessionId = UserDicKey(model.id);
        session.conversationType = WMIMConversationTypeSingle;
        [[IMChatManageTool instance].msgDataManage saveSessionInfo:session];
    }else{

        for (LMRegisterSyncgroupModel *mTGroup in [LMRegisterModle instance].syncgroupArry) {
            if (mTGroup.id == message.sessionId.intValue) {
                //    chatVc.dataSource
                WMIMSession *session = [[WMIMSession alloc] init];
                session.sessionId = UserDicKey(mTGroup.id);
                session.groupName = mTGroup.name;
                session.owenid = mTGroup.owner;
                
                for (LMRegisterSyncgroupModel *tem in mTGroup.member) {
                    WMGroupMember *memeber = [[WMGroupMember alloc] init];
                    memeber.id = tem.id;
                    memeber.name = tem.name;
                    [session.member addObject:memeber];
                }
                session.conversationType = WMIMConversationTypeGroup;
                [[IMChatManageTool instance].msgDataManage saveSessionInfo:session];
            }
        }
    }

    [self reflashUI:nil];
}

/**
 *  发送消息完成回调
 *
 *  @param message 当前发送的消息
 *  @param error   失败原因,如果发送成功则error为nil
 */
- (void)sendMessage:(WMIMMessage *_Nonnull)message didCompleteWithError:(nullable NSError *)error{
    [self reflashUI:nil];
}
@end
