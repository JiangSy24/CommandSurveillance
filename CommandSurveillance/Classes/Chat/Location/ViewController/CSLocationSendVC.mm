//
//  CSLocationSendVC.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/25.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSLocationSendVC.h"
#import "SearchResultsController.h"
#import "MJRefresh.h"
#import "BaiduMapShowVc.h"
#import "BaiduMapModel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#define SCREEN_WIDTH (self.view.bounds.size.width)
#define SCR_H (self.view.bounds.size.height)

#define SearchBarH 44
#define MapViewH 300

#define StatusBar_HEIGHT 20
#define NavigationBar_HEIGHT 44

@interface CSLocationSendVC ()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,UISearchResultsUpdating,UISearchControllerDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate>{
    BMKLocationService *_locService;
    BMKPointAnnotation *_pointAnnotation;
}
@property (nonatomic,strong)UISearchController *searchController;
@property (nonatomic,strong)SearchResultsController *searchResultsController;
@property (nonatomic,strong)BMKMapView *mapView;
@property (nonatomic,strong)UITableView *topTableView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray <BMKPoiInfo*>* dataList;
@property (nonatomic,strong)BMKPoiSearch *searcher;
@property (nonatomic,strong)UIImageView *imageViewAnntation;
@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,strong)NSNumber *secondPageIndex;
@property (nonatomic,assign)BOOL isNeedLocation;
@property (nonatomic,assign)NSInteger isSearchPage; //1:YES  2:NO
//@property (nonatomic,strong)QMSReGeoCodeAdInfo *currentAddressInfo;
@property (nonatomic,assign)CGFloat fltopHeight;//顶栏高

@property (nonatomic,strong)BaiduMapModel *selectModel;

@property (nonatomic,copy) NSString *keyword;//

@end

@implementation CSLocationSendVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isNeedLocation = YES;
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    //启动LocationService
    [_locService startUserLocationService];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    [_locService stopUserLocationService];
}

- (SearchResultsController *)searchResultsController {
    if (_searchResultsController == nil) {
        _searchResultsController = [[SearchResultsController alloc]init];
    }
    return _searchResultsController;
}

- (UISearchController *)searchController {
    if (_searchController == nil) {
        self.definesPresentationContext = YES;
        _searchController = [[UISearchController alloc]initWithSearchResultsController:self.searchResultsController];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = YES;
        _searchController.delegate = self;
        [_searchController.searchBar sizeToFit];
        _searchController.searchBar.tintColor = [UIColor whiteColor];
        _searchController.searchBar.barTintColor = CSColorZiSe;
        _searchController.searchBar.placeholder = @"搜索地点";
        [_searchController.searchBar setBackgroundImage:[UIImage imageWithColor:CSColorZiSe]];//去掉searchbar 黑线
    }
    return _searchController;
}

- (NSMutableArray<BMKPoiInfo *> *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    self.keyword = @"小区";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"位置分享";
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    self.fltopHeight = rectStatus.size.height+ rectNav.size.height;
    [self setNavigationBar];
    [self setTopTableView];
    [self setMapView];
    [self setMainTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:SearchResultsControllerDidSelectRow object:nil];
    
    __weak typeof (self) weakSelf = self;
    self.searchResultsController.searchResultsPage = ^(NSInteger page) {
        weakSelf.secondPageIndex = @(page);
        weakSelf.isSearchPage = 1;
        
        // 收索
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
        option.keyword = weakSelf.searchController.searchBar.text;
        option.pageIndex = 1;
        option.pageCapacity = 20;
        option.radius = 1000;
        CLLocationCoordinate2D centerCoordinate = weakSelf.mapView.region.center;
        option.location = centerCoordinate;
        [weakSelf.searcher poiSearchNearBy:option];
    };
}

- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setNavigationBar
{
    self.pageIndex = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightBarButtonItem)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)goback{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)clickRightBarButtonItem
{
    //初始化搜索对象，并设置代理
    [self dismissViewControllerAnimated:YES completion:nil];
    //发送位置时截图
//    [self.mapView takeSnapshotInRect:self.mapView.bounds withCompletionBlock:^(UIImage *resultImage, CGRect rect) {
//        //resultImage是截取好的图片
//        //同时发送当前位置数据
//        //self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.longitude
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            BaiduMapShowVc *vc = [BaiduMapShowVc myTableViewController];
//            vc.imageViewRect = rect;
//            vc.resultImage = resultImage;
//            vc.selectModel = self.selectModel;
//            [self.navigationController pushViewController:vc animated:YES];
//        });
//    }];
    
}

- (void)setTopTableView
{
    //topTableView(专门放置搜索框)
    self.topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) style:UITableViewStylePlain];
    self.topTableView.tableFooterView = [[UIView alloc] init];
    self.topTableView.scrollEnabled = NO;
    self.topTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CSScreenW, 100)];
    [self.topTableView.tableHeaderView addSubview:self.searchController.searchBar];
    [self.view addSubview:self.topTableView];

}

- (void)setMapView
{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;

    //mapView
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, self.searchController.searchBar.frame.size.height, self.view.bounds.size.width, MapViewH)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态为普通定位模式
    [_mapView viewWillAppear];

    //QMSSearcher
    self.searcher = [[BMKPoiSearch alloc] init];
    [self.searcher setDelegate:self];
    
    UIButton *buttonReset = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, self.mapView.frame.size.height - 50, 40, 30)];
    buttonReset.backgroundColor = [UIColor grayColor];
    [buttonReset setTitle:@"复位" forState:UIControlStateNormal];
    buttonReset.titleLabel.font = [UIFont systemFontOfSize:14];
    [buttonReset addTarget:self action:@selector(clickResetButton) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:buttonReset];
}

- (void)setMainTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.size.height + self.searchController.searchBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - MapViewH - SearchBarH) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPastData)];
    self.tableView.mj_footer = footer;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在刷新数据" forState:MJRefreshStateRefreshing];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.stateLabel.textColor = [UIColor blackColor];
    [self.tableView.mj_header beginRefreshing];
    
    self.imageViewAnntation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.imageViewAnntation.center = self.mapView.center;
    self.imageViewAnntation.image = [UIImage imageNamed:@"greenPin_lift"];
    self.imageViewAnntation.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageViewAnntation];
}

//复位
- (void)clickResetButton
{
    CLLocationCoordinate2D center = self.mapView.centerCoordinate;
    [self.mapView setCenterCoordinate:center animated:YES];
}

- (void)loadPastData
{
    [self.tableView.mj_footer endRefreshing];
    self.isSearchPage = 2;
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    self.pageIndex++;
    option.pageIndex = (int)self.pageIndex;
    option.pageCapacity = 20;
    option.radius = 1000;
    option.keyword = self.keyword;
    CLLocationCoordinate2D centerCoordinate = _mapView.region.center;
    option.location = centerCoordinate;
    [self.searcher poiSearchNearBy:option];
}

- (void)refreshData:(NSNotification *)notification
{

    dispatch_async(dispatch_get_main_queue(), ^{
        BMKPoiInfo *data = (notification.userInfo[@"data"]);
        CLLocationCoordinate2D center = data.pt;
        [self.mapView setCenterCoordinate:center animated:YES];
        
        self.searchController.delegate = nil;
        self.searchController.searchBar.text = nil;
        
        self.isSearchPage = 2;
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
        option.pageCapacity = 20;
        option.radius = 1000;
        option.location = center;
        option.keyword = @"小区";
        [self.searcher poiSearchNearBy:option];
        [self willDismissSearchController:self.searchController];
    });

    [_searchController dismissViewControllerAnimated:YES completion:^{
        
    }];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITabelViewDataSource / UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Identifier"];
    }
    cell.textLabel.text = self.dataList[indexPath.row].name;
    cell.detailTextLabel.text = self.dataList[indexPath.row].address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLLocationCoordinate2D center = [self.dataList objectAtIndex:indexPath.row].pt;
    [self.mapView setCenterCoordinate:center animated:YES];
    BaiduMapModel *model = [[BaiduMapModel alloc] init];
    model.selectLocation = center;
    model.title = self.dataList[indexPath.row].name;
    model.address = self.dataList[indexPath.row].address;
    self.selectModel = model;
}

#pragma mark - UISearchControllerDelegate / UISearchResultsUpdating
//将要输入
- (void)willPresentSearchController:(UISearchController *)searchController
{
    [UIView animateWithDuration:0.25 animations:^{
        self.mapView.frame = CGRectMake(0, self.fltopHeight, self.view.bounds.size.width, MapViewH);
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.mapView.frame), self.view.bounds.size.width, self.view.bounds.size.height - MapViewH);
        self.imageViewAnntation.center = self.mapView.center;
    }];
}

//将要退出搜索框
- (void)willDismissSearchController:(UISearchController *)searchController
{
    [UIView animateWithDuration:0.25 animations:^{
        self.mapView.frame = CGRectMake(0, self.searchController.searchBar.frame.size.height + 5, self.view.bounds.size.width, MapViewH);
        self.tableView.frame = CGRectMake(0, self.mapView.frame.size.height + self.searchController.searchBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - MapViewH);
        self.imageViewAnntation.center = self.mapView.center;
    }];
}

- (BOOL)shouldResponseBusy
{
    CSTabBarController *tabVC = [CSTabBarController instance];
    UINavigationController *nav = tabVC.selectedViewController;
    return [nav.topViewController isKindOfClass:[SearchResultsController class]];
}

//搜索框正在输入
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    self.isSearchPage = 1;
    
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.keyword = searchController.searchBar.text;
    option.pageIndex = 0;
    option.pageCapacity = 20;
    option.radius = 1000;
    CLLocationCoordinate2D centerCoordinate = _mapView.region.center;
    option.location = centerCoordinate;
    [self.searcher poiSearchNearBy:option];
}

#pragma mark - QMapViewDelegate
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    
//    NSLog(@"%f--%f--%f--%f",self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.longitude,self.mapView.region.center.latitude,self.mapView.region.center.longitude);
//    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
//    option.pageIndex = (int)self.pageIndex;
//    option.pageCapacity = 20;
//    option.radius = 1000;
//    option.keyword = @"小区";
//    CLLocationCoordinate2D centerCoordinate = _mapView.region.center;//_locService.userLocation.location.coordinate;
//    option.location = centerCoordinate;
//
//    //发起城市内POI检索
//    BOOL flag = [self.searcher poiSearchNearBy:option];
//    if(flag) {
//        NSLog(@"城市内检索发送成功");
//    }
//    else {
//        NSLog(@"城市内检索发送失败");
//    }
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
    
}

/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    for (BMKPoiInfo *data in poiResult.poiInfoList) {
        NSLog(@"%@-- %@-- %@",data.name,data.address,data.phone);
    }
    
    /*
     NSString* _name;            ///<POI名称
     NSString* _uid;
     NSString* _address;        ///<POI地址
     NSString* _city;            ///<POI所在城市
     NSString* _phone;        ///<POI电话号码
     NSString* _postcode;        ///<POI邮编
     int          _epoitype;        ///<POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路
     CLLocationCoordinate2D _pt;    ///<POI坐标
     */
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //POI信息类
        //poi列表
        [self.mapView removeAnnotations:self.dataList];
        for (BMKPoiInfo *info in poiResult.poiInfoList) {
            
            //初始化一个点的注释 //只有三个属性
            BMKPointAnnotation *annotoation = [[BMKPointAnnotation alloc] init];
            
            //坐标
            annotoation.coordinate = info.pt;
            
            //title
            annotoation.title = info.name;
            
            //子标题
            annotoation.subtitle = info.address;
            
            //将标注添加到地图上
            [self.mapView addAnnotation:annotoation];
        }
        
        //根据本页地图返回的结果
        if (self.isSearchPage == 2) {
            //手滑动重新赋值数据源
            if (self.pageIndex == 1) {
                [self.dataList removeAllObjects];
                self.dataList = [NSMutableArray arrayWithArray:poiResult.poiInfoList];
            } else {
                [self.dataList addObjectsFromArray:poiResult.poiInfoList];
            }
            [self.tableView reloadData];
        }
        //搜索控制器根据关键词返回的结果
        if (self.isSearchPage == 1) {
            NSLog(@"reflash list SearchResultGetPoiSearchResult");
            [[NSNotificationCenter defaultCenter] postNotificationName:SearchResultGetPoiSearchResult object:nil userInfo:@{@"data":poiResult.poiInfoList}];
        }
    }
    
}

/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
    //    _mapView.centerCoordinate = userLocation.location.coordinate;
    [_mapView updateLocationData:userLocation];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

    if (self.isNeedLocation) {
        self.mapView.centerCoordinate = userLocation.location.coordinate;
        if (userLocation) {
            self.isSearchPage = 2;
            
            BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
            option.pageIndex = 0;
            option.pageCapacity = 20;
            option.radius = 1000;
            CLLocationCoordinate2D centerCoordinate = _mapView.region.center;
            option.location = centerCoordinate;
            option.keyword = @"小区";
            
            BOOL flag = [self.searcher poiSearchNearBy:option];
            if(flag) {
                NSLog(@"城市内检索发送成功");
            }
            else {
                NSLog(@"城市内检索发送失败");
            }
            
        }
        self.isNeedLocation = NO;
    }
    
    [_mapView updateLocationData:userLocation];
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    
    //如果是注释点
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        //根据注释点,创建并初始化注释点视图
        BMKPinAnnotationView  *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"an"];
        
        //设置大头针的颜色
        newAnnotation.pinColor = BMKPinAnnotationColorRed;
        
        //设置动画
        newAnnotation.animatesDrop = YES;
        
        return newAnnotation;
        
    }
    
    return nil;
}

/**
 *地图区域改变完成后会调用此接口  mapView移动后执行
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //手动滑动地图定位
//    if (self.object == nil) {
//        self.pageIndex = 1;
//        BMKCoordinateRegion region;
//        CLLocationCoordinate2D centerCoordinate = mapView.region.center;
//        region.center= centerCoordinate;
//        self.isSearchPage = 2;
//        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
//        option.pageIndex = 0;
//        option.pageCapacity = 20;
//        option.radius = 1000;
//        option.location = centerCoordinate;
//        [self.searcher poiSearchNearBy:option];
//        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
//    } else {
//        self.object = nil;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
