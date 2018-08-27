//
//  CSCmChoiceVc.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/24.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSCmChoiceVc.h"
#import "CSChoiceUsersCell.h"
#import "CSCommunicationSearchView.h"
#import "AIMTableViewIndexBar.h"

@interface CSCmChoiceVc ()<UITableViewDelegate,UITableViewDataSource,AIMTableViewIndexBarDelegate,SSSearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *choiceLabel;
@property (strong, nonatomic) AIMTableViewIndexBar *indexBar;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, weak) SSSearchBar *searchBar;
@end

@implementation CSCmChoiceVc

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
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CmChoiceVc"];
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
    
    // 自己写的indexbar
    self.indexBar = [[AIMTableViewIndexBar alloc] initWithFrame:CGRectMake(self.view.width - 15, self.tableView.y, 15, CSScreenH - 64)];
    self.indexBar.backgroundColor = CSUIColor(248, 248, 248);// 220 245 255
    self.indexBar.delegate = self;
    [self.indexBar setIndexes:[CSUsersModel instance].arrySortedKeys];
    [CSViewStyle initInputView:self.confirmBtn color:[UIColor clearColor] radiusSize:5];
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
    if (self.selectArray.count < 2) {
        [MBProgressHUD showTips:@"所选人数小于两人" detail:nil forView:self.view];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(confirmClicked:)]) {
            [self.delegate confirmClicked:self.selectArray];
        }
    }];
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
        iCount = [CSUsersModel instance].arrySortedKeys.count;
    }
    return iCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger iCount = 0;
    if (self.searchBar.text.length > 0) {
        iCount = self.searchArray.count;
    }else{
        NSArray *array = [[CSUsersModel instance].dicAccounts objectForKey:[CSUsersModel instance].arrySortedKeys[section]];
        iCount = array.count;
    }
    return iCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CSCmCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSOneUserModel *model = nil;
    if (self.searchBar.text.length > 0) {
        model = self.searchArray[indexPath.row];
    }else{
        NSArray *array = [[CSUsersModel instance].dicAccounts objectForKey:[CSUsersModel instance].arrySortedKeys[indexPath.section]];
        model = array[indexPath.row];
    }
    
    CSChoiceUsersCell *cell = [CSChoiceUsersCell tempTableViewCellWith:tableView];
    cell.nameLabel.text = [CSStatusTool getShowUserName:model.name];
    cell.infoLabel.text = model.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (CSOneUserModel *tem in self.selectArray) {
        if ([tem isEqual:model]) {
            cell.selectImage.image = [UIImage imageNamed:@"choice_sel_users"];
            return cell;
        }
    }
    cell.selectImage.image = [UIImage imageNamed:@"choice_users"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CSOneUserModel *model = nil;
    if (self.searchBar.text.length > 0) {
        model = self.searchArray[indexPath.row];
    }else{
        NSArray *array = [[CSUsersModel instance].dicAccounts objectForKey:[CSUsersModel instance].arrySortedKeys[indexPath.section]];
        model = array[indexPath.row];
    }

    for (CSOneUserModel *modelTem in self.selectArray) {
        if ([model isEqual:modelTem]) {
            [self.selectArray removeObject:modelTem];
            [self.tableView reloadData];
            self.choiceLabel.text = [NSString stringWithFormat:@"已选择:%ld人",self.selectArray.count];
            return;
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
