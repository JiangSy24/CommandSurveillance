//
//  CSGroupManageUsersVc.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/9.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSGroupManageUsersVc.h"
#import "CSChoiceUsersCell.h"
#import "CSCommunicationSearchView.h"
#import "AIMTableViewIndexBar.h"

@interface CSGroupManageUsersVc ()<UITableViewDelegate,UITableViewDataSource,AIMTableViewIndexBarDelegate,SSSearchBarDelegate,WMIMTeamManageToolDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *choiceLabel;
@property (strong, nonatomic) AIMTableViewIndexBar *indexBar;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, weak) SSSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray<CSOneUserModel*> *selectArray;

@property (nonatomic, strong) NSMutableDictionary *submitGroup;
@property (nonatomic, strong) NSArray *keysArray;



@end

@implementation CSGroupManageUsersVc

- (NSMutableDictionary*)submitGroup{
    if (_submitGroup == nil) {
        _submitGroup = [NSMutableDictionary dictionary];
    }
    return _submitGroup;
}

- (NSMutableArray<CSOneUserModel*>*)selectArray{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (NSMutableArray*)searchArray{
    if (_searchArray == nil) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

+(instancetype)myTableViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GroupManageUsersVc"];
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
    self.navigationController.title = self.bIsAdd ? @"添加群成员" : @"删除群成员";
    
    // 自己写的indexbar
    self.indexBar = [[AIMTableViewIndexBar alloc] initWithFrame:CGRectMake(self.view.width - 15, self.tableView.y, 15, CSScreenH - 64)];
    self.indexBar.backgroundColor = CSUIColor(248, 248, 248);// 220 245 255
    self.indexBar.delegate = self;
    [self.indexBar setIndexes:[CSUsersModel instance].arrySortedKeys];
    [CSViewStyle initInputView:self.confirmBtn color:[UIColor clearColor] radiusSize:5];
    
    if (!self.bIsAdd) {
        self.keysArray = [CSUsersModel makeArrayData:self.groupArray toDic:self.submitGroup];
    }
    
    [[IMChatManageTool instance].teamManage addDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamChangeNot:) name:CSNoticeTeamChange object:nil];
}

- (void)dealloc{
    [[IMChatManageTool instance].teamManage removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)teamChangeNot:(NSNotification*)not{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark
- (void)onTeamMemberChanged:(WMGroupActModel *)team{
    switch (team.nMsgId) {
        case IM_GroupMsgId_KickOut_Notify://被踢通知(自己)
        case IM_GroupMsgId_HadLeft_Notify://退群通知
        case IM_GroupMsgId_Dissolve_Notify:
        {
            //解散通知
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            break;
        }
        default:
            break;
    }
}

- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickConfirmBtn:(id)sender {
    
    for (CSOneUserModel *model in self.selectArray) {
        model.bIsSelect = NO;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.bIsAdd) {
        [[IMChatManageTool instance].teamManage groupInviteMember:self.iGroupId members:self.selectArray success:^{
            dispatch_async(dispatch_get_main_queue(), ^{

                for (CSOneUserModel *one in self.selectArray) {
                    LMRegisterSyncgroupModel *temSelect = [[LMRegisterSyncgroupModel alloc] init];
                    temSelect.id = one.id;
                    temSelect.name = one.name;
                    [self.groupModel.member addObject:temSelect];
                }
                // 成功
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (self.delegate && [self.delegate respondsToSelector:@selector(confirmClicked:bIsAdd:)]) {
                    [self.delegate confirmClicked:self.selectArray bIsAdd:self.bIsAdd];
                }
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            });
        } failure:^(int error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 失败
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showTips:@"添加失败" detail:nil forView:self.view];
            });
        }];
    }else{
        
        __block BOOL bIsOk = NO;
        for (CSOneUserModel *oneModel in self.selectArray) {
            
            [[IMChatManageTool instance].teamManage groupKickOut:self.iGroupId memberid:oneModel.id success:^{
                bIsOk = YES;
            } failure:^(int error) {
                bIsOk = NO;
            }];
            
            if (!bIsOk) {
                break;
            }
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!bIsOk) {
            [MBProgressHUD showTips:@"删除失败" detail:nil forView:self.view];
        } else {
                
            for (CSOneUserModel *one in self.selectArray) {
                for (LMRegisterSyncgroupModel *temU in self.groupModel.member) {
                    if (temU.id == one.id) {
                        [self.groupModel.member removeObject:temU];
                        break;
                    }
                }
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(confirmClicked:bIsAdd:)]) {
                [self.delegate confirmClicked:self.selectArray bIsAdd:self.bIsAdd];
            }
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger iCount = 0;
    if (self.searchBar.text.length > 0) {
        self.indexBar.hidden = YES;
        iCount = 1;
    }else{
        self.indexBar.hidden = NO;
        if (self.bIsAdd) {
            iCount = [CSUsersModel instance].arrySortedKeys.count;
        }else{
            iCount = self.keysArray.count;
        }
    }
    return iCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger iCount = 0;
    if (self.searchBar.text.length > 0) {
        iCount = self.searchArray.count;
    }else{
        
        NSArray *array = nil;
        if (self.bIsAdd) {
            array = [[CSUsersModel instance].dicAccounts objectForKey:[CSUsersModel instance].arrySortedKeys[section]];
        } else {
            array = [self.submitGroup objectForKey:self.keysArray[section]];
        }
        iCount = array.count;
    }
    return iCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CSCmCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSOneUserModel *model = nil;
    if (self.searchBar.text.length > 0) {
        model = self.searchArray[indexPath.row];
    }else{
        
        NSArray *array = nil;
        if (self.bIsAdd) {
            array = [[CSUsersModel instance].dicAccounts objectForKey:[CSUsersModel instance].arrySortedKeys[indexPath.section]];
        } else {
            array = [self.submitGroup objectForKey:self.keysArray[indexPath.section]];
        }
        model = array[indexPath.row];
    }
    
    CSChoiceUsersCell *cell = [CSChoiceUsersCell tempTableViewCellWith:tableView];
    cell.nameLabel.text = [CSStatusTool getShowUserName:model.name];
    cell.infoLabel.text = model.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectImage.image = model.bIsSelect ? [UIImage imageNamed:@"choice_sel_users"] : [UIImage imageNamed:@"choice_users"];

    if (self.bIsAdd) {
        for (CSOneUserModel *tem in self.groupArray) {
            if (tem.id == model.id) {
                cell.selectImage.image = [UIImage imageNamed:@"choice_sel_unusers"];
            }
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSOneUserModel *model = nil;
    if (self.searchBar.text.length > 0) {
        model = self.searchArray[indexPath.row];
    }else{
        NSArray *array = nil;
        if (self.bIsAdd) {
            array = [[CSUsersModel instance].dicAccounts objectForKey:[CSUsersModel instance].arrySortedKeys[indexPath.section]];
            
        } else {
            array = [self.submitGroup objectForKey:self.keysArray[indexPath.section]];
        }
        model = array[indexPath.row];
    }
    
    if (self.bIsAdd) {
        for (CSOneUserModel *tem in self.groupArray) {
            if (tem.id == model.id) {
                return;
            }
        }
    }
    
    
    model.bIsSelect = !model.bIsSelect;
    for (CSOneUserModel *modelTem in self.selectArray) {
        if ([model isEqual:modelTem]) {
            [self.selectArray removeObject:model];
            break;
        }
    }
    [self.selectArray addObject:model];
    [self.tableView reloadData];
    self.choiceLabel.text = [NSString stringWithFormat:@"已选择:%ld人",self.selectArray.count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = CSUIColor(245, 245, 245);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 90, 20)];
    titleLabel.textColor=[UIColor grayColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    titleLabel.text= [[CSUsersModel instance].arrySortedKeys objectAtIndex:section];//获得所有的key值（A B C D……Z）
    [myView addSubview:titleLabel];
    return myView;
}

#pragma mark - AIMTableViewIndexBarDelegate
- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index{
    if ([self.tableView numberOfSections] > index && index > -1){   // for safety, should always be YES
        NSLog(@"tableViewIndexBar %d",(int)index);
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
    }
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
    if (self.bIsAdd) {
        for (NSInteger i=0; i<[CSUsersModel instance].accounts.count; i++)
        {
            CSOneUserModel *model = [CSUsersModel instance].accounts[i];
            if (![pinYinHelper isString:model.name MatchsKey:searchText IgnorCase:YES]) {
                continue;
            }
            [self.searchArray addObject:model];
        }
    } else {
        for (NSInteger i=0; i<self.groupArray.count; i++)
        {
            CSOneUserModel *model = self.groupArray[i];
            if (![pinYinHelper isString:model.name MatchsKey:searchText IgnorCase:YES]) {
                continue;
            }
            [self.searchArray addObject:model];
        }
    }
    
    [self.tableView reloadData];
}

@end
