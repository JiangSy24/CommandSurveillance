//
//  CSCommunicationGroupVc.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/24.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSCommunicationGroupVc.h"
#import "CSCommunicationSearchView.h"
#import "CSCommunicationGroupCell.h"
#import "CSCommunicationSearchView.h"
#import "CSComGroupMoreCell.h"
#import "CSCmChoiceVc.h"
#import "CSCreateGroupVc.h"

@interface CSCommunicationGroupVc ()<UITableViewDelegate,UITableViewDataSource,CSCmChoiceVcDelegate,WMIMTeamManageToolDelegate,SSSearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noGroupsView;
@property (nonatomic, weak) SSSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchArray;
@end

@implementation CSCommunicationGroupVc

- (NSMutableArray*)searchArray{
    if (_searchArray == nil) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

+(instancetype)myTableViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CommunicationGroupVc"];
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addGroup:(id)sender {
    
    CSCmChoiceVc *vc = [CSCmChoiceVc myTableViewController];
    vc.delegate = self;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    CSMainTabNavigation *nc = [[CSMainTabNavigation alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:^{
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

#pragma ChoiceDelegate
- (void)confirmClicked:(NSMutableArray<CSOneUserModel *> *)selectArray{
    // 跳转创建组
    CSCreateGroupVc *vc = [CSCreateGroupVc myTableViewController];
    
    vc.array = selectArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CSCommunicationSearchView *vw = [CSCommunicationSearchView appInfoView];
    vw.searchBar.delegate = self;
    self.searchBar = vw.searchBar;
    self.tableView.tableHeaderView = vw;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashUI:) name:NoticLoginReflash object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[IMChatManageTool instance].teamManage addDelegate:self];
    
}

- (void)dealloc{
    [[IMChatManageTool instance].teamManage removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        case IM_GroupMsgId_Join_Notify:
        {
            //添加组通知(自己被邀请入群)
            LMRegisterSyncgroupModel *group = [[LMRegisterSyncgroupModel alloc] init];
            group.id = team.groupinfo.id;
            group.name = team.groupinfo.name;
            group.createtime = team.groupinfo.createtime;
            group.member = [NSMutableArray array];
            for (WMGroupMsgUserModel *model in team.groupinfo.member) {
                LMRegisterSyncgroupModel *user = [[LMRegisterSyncgroupModel alloc] init];
                user.id = model.id;
                [group.member addObject:user];
            }
            [[LMRegisterModle instance].syncgroupArry addObject:group];
            break;
        }
        case IM_GroupMsgId_Other_Join_Notify:
        {
            //其他人加群通知
            for (LMRegisterSyncgroupModel *tem in [LMRegisterModle instance].syncgroupArry) {
                if (team.groupid != tem.id) {
                    continue;
                }
                
                for (WMGroupMsgUserModel *model in team.joinids) {
                    LMRegisterSyncgroupModel *join = [[LMRegisterSyncgroupModel alloc] init];
                    join.id = model.id;
                    [tem.member addObject:join];
                }
                break;
            }
            break;
        }
        case IM_GroupMsgId_KickOut_Notify://被踢通知(自己)
        {
            for (LMRegisterSyncgroupModel *tem in [LMRegisterModle instance].syncgroupArry) {
                if (team.groupid != tem.id) {
                    continue;
                }
                
                WMIMSession *session = [[WMIMSession alloc] init];
                session.sessionId = UserDicKey(tem.id);
                session.groupName = tem.name;
                session.owenid = tem.owner;
                session.conversationType = WMIMConversationTypeGroup;
                // 删除数据库该会话表
                WMIMDeleteMessagesOption *option = [[WMIMDeleteMessagesOption alloc] init];
                option.removeTable = YES;
                option.removeSession = YES;
                [[IMChatManageTool instance].msgDataManage deleteAllmessagesInSession:session option:option];
                [[LMRegisterModle instance].syncgroupArry removeObject:tem];
                break;
            }
            
            break;
        }
        case IM_GroupMsgId_Other_KickOut_Notify://被踢通知(其他)
        {
            for (LMRegisterSyncgroupModel *tem in [LMRegisterModle instance].syncgroupArry) {
                if (team.groupid != tem.id) {
                    continue;
                }
                
                for (LMRegisterSyncgroupModel *model in tem.member) {
                    if (model.id == team.userid) {
                        [tem.member removeObject:model];
                        break;
                    }
                }
                break;
            }
            break;
        }
        case IM_GroupMsgId_HadLeft_Notify://退群通知
        {
            for (LMRegisterSyncgroupModel *tem in [LMRegisterModle instance].syncgroupArry) {
                if (team.groupid != tem.id) {
                    continue;
                }
                
                for (LMRegisterSyncgroupModel *model in tem.member) {
                    if (model.id == team.kickoutid) {
                        [tem.member removeObject:model];
                        break;
                    }
                    
                    if (tem.member.count <= 1) {
                        WMIMSession *session = [[WMIMSession alloc] init];
                        session.sessionId = UserDicKey(tem.id);
                        session.groupName = tem.name;
                        session.owenid = tem.owner;
                        session.conversationType = WMIMConversationTypeGroup;
                        // 删除数据库该会话表
                        WMIMDeleteMessagesOption *option = [[WMIMDeleteMessagesOption alloc] init];
                        option.removeTable = YES;
                        option.removeSession = YES;
                        [[IMChatManageTool instance].msgDataManage deleteAllmessagesInSession:session option:option];
                        [[LMRegisterModle instance].syncgroupArry removeObject:tem];
                    }
                }
                break;
            }
            break;
        }
        case IM_GroupMsgId_Dissolve_Notify://解散通知
        {
            WMIMSession *session = [[WMIMSession alloc] init];
            session.sessionId = UserDicKey(team.groupid);
            session.owenid = team.sponsorid;
            session.conversationType = WMIMConversationTypeGroup;
            // 删除数据库该会话表
            WMIMDeleteMessagesOption *option = [[WMIMDeleteMessagesOption alloc] init];
            option.removeTable = YES;
            option.removeSession = YES;
            [[IMChatManageTool instance].msgDataManage deleteAllmessagesInSession:session option:option];
            
            for (LMRegisterSyncgroupModel *tem in [LMRegisterModle instance].syncgroupArry) {
                if (team.groupid != tem.id) {
                    continue;
                }
                
                [[LMRegisterModle instance].syncgroupArry removeObject:tem];
                break;
            }
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            break;
        }
        default:
            break;
    }
    
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:CSNoticeTeamChange object:team];
}

- (void)reflashUI:(NSNotification*)noc{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSSearchBarDelegate
- (void)searchBarCancelButtonClicked:(SSSearchBar *)searchBar {
    searchBar.text = @"";
    [self filterTableViewWithText:searchBar.text];
}
- (void)searchBarSearchButtonClicked:(SSSearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
- (void)searchBar:(SSSearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterTableViewWithText:searchText];
}

- (void)filterTableViewWithText:(NSString *)searchText {
    [self.searchArray removeAllObjects];//清空searchDataArr，防止显示之前搜索的结果内容
    if (searchText.length <= 0) {
        [self.tableView reloadData];
        return;
    }
    
    UTPinYinHelper *pinYinHelper = [UTPinYinHelper sharedPinYinHelper];
    for (NSInteger i= 0;i < [LMRegisterModle instance].syncgroupArry.count ; i ++)
    {
        LMRegisterSyncgroupModel *model = [LMRegisterModle instance].syncgroupArry[i];
        if (![pinYinHelper isString:model.name MatchsKey:searchText IgnorCase:YES]) {
            continue;
        }
        [self.searchArray addObject:model];
    }
    [self.tableView reloadData];
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([LMRegisterModle instance].syncgroupArry.count == 0) {
        self.noGroupsView.hidden = NO;
    }else{
        self.noGroupsView.hidden = YES;
    }
    
    NSInteger iCount = 0;
    if (self.searchBar.text.length > 0) {
        iCount = self.searchArray.count;
    }else{
        iCount = [LMRegisterModle instance].syncgroupArry.count;
    }
    return iCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LMRegisterSyncgroupModel *model = nil;
    if (self.searchBar.text.length > 0) {
        model = self.searchArray[indexPath.row];
    }else{
        model = [LMRegisterModle instance].syncgroupArry[indexPath.row];
    }
    
    if (model.member.count <= 3) {
        CSCommunicationGroupCell *cell = [CSCommunicationGroupCell tempTableViewCellWith:tableView];
        cell.infoLabel.text = model.name;
        for (int i = 0; i < model.member.count; i++) {
            CSOneUserModel *tem = [CSUsersModel instance].dicPreAccount[UserDicKey(model.member[i].id)];
            model.member[i].name = tem.name;
            NSString *strShow = [CSStatusTool getShowUserName:tem.name];
            switch (i) {
                case 0:
                {
                    cell.oneLabel.text = strShow;
                    break;
                }
                case 1:
                {
                    cell.twoLabel.text = strShow;
                    break;
                }
                case 2:
                {
                    cell.thrLabel.text = strShow;
                    break;
                }
                default:
                    break;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CSComGroupMoreCell *cell = [CSComGroupMoreCell tempTableViewCellWith:tableView];
        cell.infoLabel.text = model.name;
        for (int i = 0; i < model.member.count; i++) {
            CSOneUserModel *tem = [CSUsersModel instance].dicPreAccount[UserDicKey(model.member[i].id)];
            NSString *strShow = [CSStatusTool getShowUserName:tem.name];
            model.member[i].name = tem.name;
            switch (i) {
                case 0:
                {
                    cell.oneLabel.text = strShow;
                    break;
                }
                case 1:
                {
                    cell.twoLabel.text = strShow;
                    break;
                }
                case 2:
                {
                    cell.threeLabel.text = strShow;
                    break;
                }
                case 3:
                {
                    cell.fourLabel.text = strShow;
                    break;
                }
                default:
                    break;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击搞起来
    // 跳聊天走起
    LMRegisterSyncgroupModel* model = [LMRegisterModle instance].syncgroupArry[indexPath.row];
    [CSStatusTool skipGroupChatVc:model vController:self];
}
@end
