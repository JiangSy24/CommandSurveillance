//
//  CSCommunicationAccountVC.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/8/21.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSCommunicationAccountVC.h"
@implementation PathView
- (void)setLabelBtn:(UIButton *)labelBtn{
    _labelBtn = labelBtn;
    _labelBtn.titleLabel.font = PathFont;
    [_labelBtn setTitleColor:CSColorBtnBule forState:0];
    [_labelBtn setTitleColor:CSUIColor(235, 235, 235) forState:UIControlStateHighlighted];
    [_labelBtn setTitleColor:CSUIColor(170, 170, 170) forState:UIControlStateDisabled];
    _labelBtn.centerY = ScrollerHeight / 2;
    [self addSubview:labelBtn];
}
- (void)setImage:(UIImageView *)image{
    _image = image;
    [self addSubview:image];
}
@end

@interface CSCommunicationAccountVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *btnBoxView;

@property (weak, nonatomic) IBOutlet UIView *tableViewBox;
@property (weak, nonatomic) IBOutlet UIButton *devPlay;
@property (weak, nonatomic) IBOutlet UIButton *cloudPlayBack;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *devBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cloudPlayBackBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playBtnHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnplay;
@property (nonatomic, weak) UITableView *nodeTableView;

@property (nonatomic, strong) UIView *headerView;
@property (weak, nonatomic) UIScrollView *dataScrollview;
@property (nonatomic, strong) NSMutableArray<PathView*> *menuArray;
@property (nonatomic, strong) UIView *sbView;
@property (nonatomic, assign) int curParentId;
//@property (nonatomic, strong) NSMutableArray<VSResListModel*> *listArray;

@property (nonatomic, strong) UILabel* alarmLabel;
@end

@implementation CSCommunicationAccountVC
- (UILabel*)alarmLabel{
    if (_alarmLabel == nil) {
        _alarmLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CSScreenW, 40)];
        [self.tableViewBox addSubview:_alarmLabel];
        _alarmLabel.text = @"暂无资源O(∩_∩)O~";
        _alarmLabel.font = [UIFont systemFontOfSize:16];
        _alarmLabel.textColor = CSUIColor(100, 100, 100);
        _alarmLabel.textAlignment = NSTextAlignmentCenter;
        _alarmLabel.centerY = self.nodeTableView.centerY;
    }
    return _alarmLabel;
}

//- (NSMutableArray<VSResListModel*>*)listArray{
//    if (_listArray == nil) {
//        _listArray = [NSMutableArray array];
//    }
//    return _listArray;
//}

-(NSMutableArray*)menuArray{
    if (_menuArray == nil) {
        _menuArray = [NSMutableArray array];
    }
    return _menuArray;
}

#define ImageWide 20
- (void)setScrollData:(NSString*)pathName parentId:(int)parentId{
    
    if (pathName == nil) {
        return;
    }
    
    CGSize size = self.dataScrollview.contentSize;
    
    CGFloat fWideTem = parentId == 0 ? 0 : ImageWide;
    
    CGSize  mainSize = [pathName sizeWithFont:PathFont];
    PathView *cellView = [[PathView alloc] initWithFrame:CGRectMake(size.width, 0, mainSize.width + fWideTem, ScrollerHeight)];
    cellView.labelBtn = [[UIButton alloc] initWithFrame:CGRectMake(fWideTem, 0, mainSize.width, ScrollerHeight)];
    [cellView.labelBtn setTitle:pathName forState:UIControlStateNormal];
    cellView.labelBtn.tag = self.menuArray.count;
    cellView.labelBtn.enabled = parentId == 0;
    cellView.tag = self.menuArray.count;
    cellView.parentId = parentId;
    if (self.menuArray.count > 0) {
        
        cellView.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWide, ScrollerHeight - 10)];
        cellView.image.image = [UIImage imageNamed:@"list_path_next"];
        cellView.image.centerY = ScrollerHeight / 2;
        
    }
    
    for (PathView *temView in self.menuArray) {
        temView.labelBtn.enabled = YES;
    }
    
    [self.dataScrollview addSubview:cellView];
    [self.menuArray addObject:cellView];
    
    size.width += mainSize.width + fWideTem;
    self.dataScrollview.contentSize = size;
    
    [cellView.labelBtn addTarget:self action:@selector(pathBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

// 搞路径
- (void)pathBtnClick:(id)sender{
    UIButton *btn = (UIButton*)sender;
    CGFloat fWide = 0;
    for (NSInteger i = 0; i < self.menuArray.lastObject.tag - btn.tag; i++) {
        [self.menuArray[self.menuArray.lastObject.tag - i] removeFromSuperview];
        fWide += self.menuArray[self.menuArray.lastObject.tag - i].width;
    }
    NSRange range = {0};
    range.location = btn.tag + 1;
    range.length = self.menuArray.lastObject.tag - btn.tag;
    [self.menuArray removeObjectsInRange:range];
    CGSize size = self.dataScrollview.contentSize;
    size.width -= fWide;
    self.dataScrollview.contentSize = size;
    self.menuArray[btn.tag].labelBtn.enabled = btn.tag == 0;
    //    VSResListModel *
    self.curParentId = self.menuArray[btn.tag].parentId;
//    [self.listArray removeAllObjects];
    [self makeCurArray];
    
}

- (void)makeCurArray{
//    NSArray *temGroupArray = [[VSDataCache sharedInstance].dicResGroupDic objectForKey:[NSString stringWithFormat:@"%d",self.curParentId]];
//    NSArray *temDevArray = [[VSDataCache sharedInstance].dicResDevDic  objectForKey:[NSString stringWithFormat:@"%d",self.curParentId]];
//    [self.listArray addObjectsFromArray:temGroupArray];
//    [self.listArray addObjectsFromArray:temDevArray];
//    [self.nodeTableView reloadData];
}

- (void)initTableHearderView{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CSScreenW, CollectionViewHeight)];
    UIScrollView *dataScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, CSScreenW - 10, ScrollerHeight)];
    [self.headerView addSubview:dataScrollview];
    self.dataScrollview = dataScrollview;
    //设置不显示横拉动条
    self.dataScrollview.showsHorizontalScrollIndicator = NO;
    //设置反弹效果
    self.dataScrollview.bounces = YES;
    [self setScrollData:@"资源列表" parentId:0];
    self.curParentId = 0;
    [self makeCurArray];
    
    UIView *sbView = [[UIView alloc]initWithFrame:CGRectMake(0, ScrollerHeight, CSScreenW, CollectionViewHeight - ScrollerHeight)];
    sbView.backgroundColor = CSUIColor(235, 235, 235);
    self.sbView = sbView;
    [self.headerView addSubview:sbView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableHearderView];
    
    CGRect frame = CGRectMake(10, 0, CSScreenW, CSScreenH - 64 - 50 - btnViewBoxHeight - 5 - 50);
    UITableView *mutableTable = [[UITableView alloc] initWithFrame:frame];
    //                                                                                 nodes:[VSDataCache sharedInstance].nodeArray
    //                                                                            rootNodeID:@""
    //                                                                      needPreservation:YES
    //                                                                           selectBlock:^(YKNodeModel *node) {
    //                                                                               NSLog(@"--select node name=%@", node.ykNParam.name);
    //                                                                               node.ykNParam.iPlayBackType = self.iPlayBackType;
    //                                                                               self.selectModel = node.ykNParam;
    //                                                                           }];
    [self.tableViewBox addSubview:mutableTable];
    mutableTable.delegate = self;
    mutableTable.dataSource = self;
    self.nodeTableView = mutableTable;
    self.nodeTableView.tableHeaderView = self.headerView;
    self.nodeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initInputView:self.devPlay clear:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devStatusChange:) name:CSNoticeDevStatus object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)devStatusChange:(NSNotification*)notc{
    //    [self.nodeTableView refleshTableViewNode:[VSDataCache sharedInstance].nodeArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.nodeTableView reloadData];
    });
}

- (void)initInputView:(UIView*)view clear:(BOOL)bIsClear{
    
    if (bIsClear) {
        view.layer.borderColor = [UIColor clearColor].CGColor;
        view.layer.borderWidth = 0;
        view.layer.cornerRadius = view.height/2;
        view.layer.masksToBounds = YES;
        
    }else{
        view.layer.borderColor = CSColorBtnBule.CGColor;
        view.layer.borderWidth = 1;
        view.layer.cornerRadius = view.height/2;
        view.layer.masksToBounds = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    self.alarmLabel.hidden = self.listArray.count != 0;
//    return self.listArray.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    VSResListModel *model = self.listArray[indexPath.row];
//    if (model.bIsGroup) {
//        VSChoiceDevCell *cell = [VSChoiceDevCell tempTableViewCellWith:tableView cellLevel:CellLevel_First];
//        cell.mainLable.text = model.name;
//        cell.onlineLable.text = [NSString stringWithFormat:@"%ld/%ld",model.iAllOnlineCount,model.iAllDevCount];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }else{
//        VSChoiceDevCell *cell = [VSChoiceDevCell tempTableViewCellWith:tableView cellLevel:CellLevel_Second];
//        cell.mainLable.text = model.name;
//        cell.onlineLable.text = model.status == 1 ? @"在线" : @"离线";
//        cell.onlineLable.textColor = model.status == 1 ? CSColorLabelGreen : CSColorLabelGray;
//        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    VSResListModel *model = self.listArray[indexPath.row];
//    if (model.bIsGroup) {
//        self.curParentId = model.id;
//        [self.listArray removeAllObjects];
//        [self makeCurArray];
//        [self setScrollData:model.name parentId:model.id];//path
//
//    }else{
//        model.mePlayBackType = self.mePlayBackType;
//        self.selectModel = model;
//    }
}

+(instancetype)myTableViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CommunicationAccountVC"];
}

@end
