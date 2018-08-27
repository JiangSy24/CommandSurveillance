//
//  CSCommunicationVC.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/22.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSCommunicationVC.h"
#import "CSCommunicationView.h"
#import "CSCommunicationCell.h"
#import "CSCommunicationHView.h"
#import "CSCommunicationGroupVc.h"
#import "IMChatMsgDataManage.h"
#import "CSCommunicationSearchView.h"

@interface CSCommunicationVC ()<UITableViewDelegate,UITableViewDataSource,CSCommunicationHViewDelegte,SSSearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) SSSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchArray;
@end

@implementation CSCommunicationVC

- (NSMutableArray*)searchArray{
    if (_searchArray == nil) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CSCommunicationHView *vw = [CSCommunicationHView appInfoView];
    vw.delegate = self;
    vw.searchBar.delegate = self;
    self.searchBar = vw.searchBar;
    self.tableView.tableHeaderView = vw;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashUI:) name:NoticLoginReflash object:nil];
}

- (void)reflashUI:(NSNotification*)noc{
    
    if ([[NSThread currentThread] isMainThread]) {
        NSLog(@"main");
    } else {
        NSLog(@"not main");
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self showPageInfo];
    });
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPageInfo{
    
    CSCommunicationHView *headView = (CSCommunicationHView*)self.tableView.tableHeaderView;
//    headView.factoryNum.text = [NSString stringWithFormat:@"%ld",[CSGlobalFactoryList instance].factorys.count];
    headView.labelInfo.text = [NSString stringWithFormat:@"群组(%ld)",[LMRegisterModle instance].syncgroupArry.count];
    
}

#pragma CSCommunicationHViewDelegte
- (void)clickGroupView{
    CSCommunicationGroupVc *vc = [CSCommunicationGroupVc myTableViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger iCount = 0;
    if (self.searchBar.text.length > 0) {
        iCount = self.searchArray.count;
    }else{
        iCount = [CSUsersModel instance].accounts.count;
    }
    return iCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CSCmCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSCommunicationCell *cell = [CSCommunicationCell tempTableViewCellWith:tableView];
    
    CSOneUserModel *model = nil;
    if (self.searchBar.text.length > 0) {
        model = self.searchArray[indexPath.row];
    }else{
        model = [CSUsersModel instance].accounts[indexPath.row];
    }
    
    cell.nameLabelOne.text = [CSStatusTool getShowUserName:model.name];
    cell.infoLabel.text = model.name;
    cell.logoinStatus.backgroundColor = model.bIsOnline ? CSColorZiSe : CSColorBtnGray;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 跳聊天走起
    CSOneUserModel* model = [CSUsersModel instance].accounts[indexPath.row];
    [CSStatusTool skipOneChatVc:nil userId:model.id vController:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CSCommunicationView *vw = [CSCommunicationView appInfoView];
    vw.frame = CGRectMake(0, 0, CSScreenW, 40);
    return vw;
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
    for (NSInteger i= 0;i < [CSUsersModel instance].accounts.count ; i ++)
    {
        CSOneUserModel *model = [CSUsersModel instance].accounts[i];
        if (![pinYinHelper isString:model.name MatchsKey:searchText IgnorCase:YES]) {
            continue;
        }
        [self.searchArray addObject:model];
    }
    [self.tableView reloadData];
}


@end
