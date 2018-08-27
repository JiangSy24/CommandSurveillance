//
//  CSManageGroupVC.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/6.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSManageGroupVC.h"
#import "CSCreateGroupHeaderView.h"
#import "CSGroupManageUsersVc.h"
#import "CSCreateGroupCell.h"
#import "CSGroupUserShowCell.h"

@interface CSManageGroupVC ()<UITableViewDelegate,UITableViewDataSource,CSGroupUserShowCellDelegate,CSGroupManageUsersVcDelegate,CSCreateGroupCellDelegate,WMIMTeamManageToolDelegate>
@property (weak, nonatomic) IBOutlet UIButton *exitGroupBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CSManageGroupVC

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

+(instancetype)myTableViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ManageGroupVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CSCreateGroupHeaderView *vw = [CSCreateGroupHeaderView appInfoView];
    //    vw.delegate = self;
    self.tableView.tableHeaderView = vw;
    [CSViewStyle initInputView:self.exitGroupBtn color:[UIColor clearColor]];
    [[IMChatManageTool instance].teamManage addDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamChangeNot:) name:CSNoticeTeamChange object:nil];
}

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
                
                CSOneUserModel *model = [[CSOneUserModel alloc] init];
                model.id = groupMm.id;
                model.name = groupMm.name;
                [self.array addObject:model];
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
            
            for (CSOneUserModel *model in self.array) {
                if (model.id == tem.kickoutid) {
                    [self.array removeObject:model];
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
            
            for (CSOneUserModel *model in self.array) {
                if (model.id == tem.userid) {
                    [self.array removeObject:model];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitGroupClick:(id)sender {
    int iret = [[IMChatManageTool instance].teamManage groupHadLeft:self.iGroupId];
    if (iret != 0) {
        [MBProgressHUD showTips:@"退出失败" detail:nil forView:self.view];
        return;
    }

    [[LMRegisterModle instance].syncgroupArry removeObject:self.groupModel];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(groupHadLeft)]) {
        [self.delegate groupHadLeft];
    }

    // 删除数据库该会话表
    WMIMDeleteMessagesOption *option = [[WMIMDeleteMessagesOption alloc] init];
    option.removeTable = YES;
    option.removeSession = YES;
    [[IMChatManageTool instance].msgDataManage deleteAllmessagesInSession:self.session option:option];
    // 通知刷新,不用了在viewwillapear刷新
}

- (void)updateHeaderView{
    CSCreateGroupHeaderView *vw = (CSCreateGroupHeaderView*)self.tableView.tableHeaderView;
    vw.threeViewBox.hidden = YES;
    vw.moreViewBox.hidden = YES;
    if (self.array.count <= 3) {
        vw.threeViewBox.hidden = NO;
        for (int i = 0; i < self.array.count; i++) {
            switch (i) {
                case 0:
                {
                    vw.three_labelOne.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                case 1:
                {
                    vw.three_labeltwo.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                case 2:
                {
                    vw.three_labelthree.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                default:
                    break;
            }
        }
    }else{
        vw.moreViewBox.hidden = NO;
        for (int i = 0; i < self.array.count; i++) {
            switch (i) {
                case 0:
                {
                    vw.more_labelOne.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                case 1:
                {
                    vw.more_labelTwo.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                case 2:
                {
                    vw.more_labelThree.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                case 3:
                {
                    vw.more_labelFour.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                default:
                    break;
            }
        }
    }
}

- (void)changeUserClick:(BOOL)bIsAdd{
    //吊起来
    CSGroupManageUsersVc *vc = [CSGroupManageUsersVc myTableViewController];
    for (CSOneUserModel *tem in self.array) {
        tem.bIsSelect = NO;
    }
    vc.groupArray = self.array;//减法就传组的
    vc.groupModel = self.groupModel;
    vc.bIsAdd = bIsAdd;
    vc.iGroupId = self.iGroupId;
    vc.delegate = self;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    CSMainTabNavigation *nc = [[CSMainTabNavigation alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:^{
        
    }];
}

- (void)confirmClicked:(NSMutableArray<CSOneUserModel*>*)selectArray bIsAdd:(BOOL)bIsAdd{
    // 刷起来
    if (bIsAdd) {
        [self.array addObjectsFromArray:selectArray];
        for (CSOneUserModel *tem in selectArray) {
            WMGroupMember *groupM = [[WMGroupMember alloc] init];
            groupM.id = tem.id;
            groupM.name = tem.name;
            [self.session.member addObject:groupM];
        }
    } else {
        for (int i = 0; i < selectArray.count; i++) {
            
            CSOneUserModel *model = selectArray[i];
            for (CSOneUserModel *tem in self.array) {
                if (tem.id == model.id) {
                    [self.array removeObject:tem];
                    break;
                }
            }
        }
        
        for (CSOneUserModel *tem in selectArray) {
            
            for (WMGroupMember *groupM  in self.session.member) {
                if (tem.id == groupM.id) {
                    [self.session.member removeObject:groupM];
                    break;
                }
            }
        }
    }

    [self.tableView reloadData];
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [self updateHeaderView];
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger iCount = 0;
    if (section == 0) {
        iCount = 2;
    }else{
        iCount = 1;
    }
    return iCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat fHeight = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            fHeight = 44;
        }else{
            fHeight = 100;
        }
    }else{
        fHeight = 64;
    }
    return fHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        if (indexPath.row == 0) {
            static NSString *identify = @"groupname";
            CSCreateGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[CSCreateGroupCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
            }
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            CSGroupUserShowCell *cell = [CSGroupUserShowCell tempTableViewCellWith:tableView];
            cell.delegate = self;
            cell.array = self.array;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        static NSString *identify = @"uploadgroupheader";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma  CSCreateGroupCellDelegate
- (void)doneGroupName:(NSString *)strName{
//    self.groupName = strName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CSScreenW, 20)];
    vw.backgroundColor = [UIColor clearColor];
    return vw;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
