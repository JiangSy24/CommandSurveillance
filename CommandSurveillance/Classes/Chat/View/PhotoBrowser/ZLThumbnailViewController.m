//
//  ZLThumbnailViewController.m
//  多选相册照片
//
//  Created by long on 15/11/30.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ZLThumbnailViewController.h"
#import <Photos/Photos.h>
#import "ZLDefine.h"
#import "ZLCollectionCell.h"
#import "ZLPhotoTool.h"
#import "ZLSelectPhotoModel.h"
#import "ZLShowBigImgViewController.h"
#import "ZLPhotoBrowser.h"
#import "ToastUtils.h"
#import "PicModel.h"
//#import "CSDrawPictureVController.h"

@interface ZLThumbnailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray<PHAsset *> *_arrayDataSources;
    
    BOOL _isLayoutOK;
}

@property (nonatomic,strong) NSMutableArray<PicModel*> *picArray;

@end

@implementation ZLThumbnailViewController

- (NSMutableArray*)picArray{
    if (_picArray == nil) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrayDataSources = [NSMutableArray array];
    
//    self.btnDone.layer.masksToBounds = YES;
//    self.btnDone.layer.cornerRadius = 3.0f;
    
    [self.btnPreView setTitle:[NSBundle zlLocalizedStringForKey:ZLPhotoBrowserPreviewText] forState:UIControlStateNormal];
    [self.btnOriginalPhoto setTitle:[NSBundle zlLocalizedStringForKey:ZLPhotoBrowserOriginalText] forState:UIControlStateNormal];
    [self.btnDone setTitle:[NSBundle zlLocalizedStringForKey:ZLPhotoBrowserDoneText] forState:UIControlStateNormal];
    
    [self resetBottomBtnsStatus];
    [self getOriginalImageBytes];
    [self initNavBtn];
    [self initCollectionView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
        if (self.bIsPicCenter) {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self getPicCenterData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.collectionView reloadData];
                });
            });
        }else{
            [self getAssetInAssetCollection];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.collectionView reloadData];
        }
    


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self resetBottomBtnsStatus];
    _isLayoutOK = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!_isLayoutOK) {
        if (self.collectionView.contentSize.height > self.collectionView.frame.size.height) {
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height-self.collectionView.frame.size.height)];
        }
    }
}

- (void)resetBottomBtnsStatus
{
    if (self.arraySelectPhotos.count > 0) {
        if (self.arraySelectPhotos.count > 1) {
            self.btnOriginalPhoto.enabled = NO;
            [self.btnOriginalPhoto setTitleColor:kRGB(204, 204, 204) forState:UIControlStateNormal];
        }else{
            self.btnOriginalPhoto.enabled = YES;
            [self.btnOriginalPhoto setTitleColor:CSColorZiSe forState:UIControlStateNormal];
        }

        self.btnPreView.enabled = YES;
        self.btnDone.enabled = YES;
        [self.btnDone setTitle:[NSString stringWithFormat:@"%@(%ld)", GetLocalLanguageTextValue(ZLPhotoBrowserDoneText), self.arraySelectPhotos.count] forState:UIControlStateNormal];
        [self.btnPreView setTitleColor:CSColorZiSe forState:UIControlStateNormal];
//        self.btnDone.backgroundColor = [UIColor whiteColor];
        [self.btnDone setTitleColor:CSColorZiSe forState:UIControlStateNormal];
    } else {
        self.btnOriginalPhoto.enabled = NO;
        self.btnPreView.enabled = NO;
        self.btnDone.enabled = NO;
        [self.btnDone setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserDoneText) forState:UIControlStateDisabled];
        [self.btnOriginalPhoto setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateDisabled];
        [self.btnPreView setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateDisabled];
//        self.btnDone.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.btnDone setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kViewWidth-9)/4, (kViewWidth-9)/4);
    layout.minimumInteritemSpacing = 1.5;
    layout.minimumLineSpacing = 1.5;
    layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZLCollectionCell" bundle:kZLPhotoBrowserBundle] forCellWithReuseIdentifier:@"ZLCollectionCell"];
}

- (void)getPicCenterData{
    // 获取图片中心图片逻辑
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSLog(@"update picture");
//        // 更新图片
//        [self.picArray removeAllObjects];
//        NSString *snapPath = [NSString stringWithFormat:@"%@/Documents/snapshot", NSHomeDirectory()];//Documents,Library,tmp
//
//        NSFileManager * fm = [NSFileManager defaultManager];
//
//        NSArray  *arr = [fm  directoryContentsAtPath:snapPath];
//
//        for (NSString *imageName in arr) {
//            // 处理图片信息
//            NSArray *array = [imageName componentsSeparatedByString:@"_"];
//            // pic_useid_工厂id_厂区id_设备id_时间
//            if (array.count < 5) {
//                continue;
//            }
//            NSString *userPhoneNum = array[1];
//            NSString *PhotoTime = array[5];
//
//            NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:[PhotoTime intValue]];
//            NSDateComponents *selectComps = [DAYUtils dateComponentsFromDate:publishDate];
//            NSLog(@"year %ld mon %ld day %ld hour %ld min %ld sec %ld",selectComps.year,selectComps.month,selectComps.day,selectComps.hour,selectComps.minute,selectComps.second);
//
//            if (![[CSAccountTool userInfo].phoneNum isEqualToString:userPhoneNum]) {
//                continue;
//            }
//
//            NSMutableString *strFullPath = [[NSMutableString alloc]init];
//            [strFullPath appendFormat:@"%@/",snapPath];
//            [strFullPath appendString:imageName];
//            NSURL *url = [[NSURL alloc] initFileURLWithPath:strFullPath];
//            NSData *data = [NSData dataWithContentsOfURL:url];
//
//            UIImage *image = [UIImage imageWithData:data];
//            // 压缩图片一下子
//            CGSize sSize = CGSizeMake((kViewWidth-9)/4, (kViewWidth-9)/4);
//            UIImage *imageTem = [UIImage imageWithImageSimple:image scaledToSize:sSize];
//
//            PicModel *picTemModel = [[PicModel alloc] init];
//            picTemModel.lTime = [PhotoTime integerValue];
//            picTemModel.picImage = imageTem;
//            picTemModel.picName = imageName;
//            [self.picArray addObject:picTemModel];
//        }
//
//        // 时间排序
//        [self.picArray sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
//            PicModel *tem1 = obj1;
//            PicModel *tem2 = obj2;
//            return tem1.lTime < tem2.lTime;
//        }];
//    });
}

- (void)getAssetInAssetCollection
{
    [_arrayDataSources addObjectsFromArray:[[ZLPhotoTool sharePhotoTool] getAssetsInAssetCollection:self.assetCollection ascending:YES]];
    
    for (PHAsset *asset in _arrayDataSources) {
        
        CGSize size = CGSizeZero;
        size.width = (kViewWidth-9)/4 * 2.5;
        size.height = (kViewWidth-9)/4 * 2.5;
        [[ZLPhotoTool sharePhotoTool] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image, NSDictionary *info) {
            
            if (image != nil) {
                PicModel *pic = [[PicModel alloc] init];
                pic.asset = asset;
                pic.picImage = image;
                [self.picArray addObject:pic];
            }

            
        }];
    }
    
}

- (void)initNavBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width = GetMatchValue(GetLocalLanguageTextValue(ZLPhotoBrowserCancelText), 16, YES, 44);
    btn.frame = CGRectMake(0, 0, width, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserCancelText) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(navRightBtn_Click) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
//    UIImage *navBackImg = [UIImage imageNamed:kZLPhotoBrowserSrcName(@"navBackBtn.png")]?:[UIImage imageNamed:kZLPhotoBrowserFrameworkSrcName(@"navBackBtn.png")];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[navBackImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtn_Click)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage alloc]init] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtn_Click)];
}

#pragma mark - UIButton Action
- (void)cell_btn_Click:(UIButton *)btn
{
    if (_arraySelectPhotos.count >= self.maxSelectCount
        && btn.selected == NO) {
        ShowToastLong(GetLocalLanguageTextValue(ZLPhotoBrowserMaxSelectCountText), self.maxSelectCount);
        return;
    }
    
    if (self.bIsPicCenter) {
        [self makeCenterArray:btn];
    }else{
        [self makeArray:btn];
    }
    
    btn.selected = !btn.selected;
    [self resetBottomBtnsStatus];
    [self getOriginalImageBytes];
}

- (void)makeCenterArray:(UIButton *)btn{
    PicModel *pic = self.picArray[btn.tag];
    
    if (!btn.selected) {
        //添加图片到选中数组
        [btn.layer addAnimation:GetBtnStatusChangedAnimation() forKey:nil];
        
        ZLSelectPhotoModel *model = [[ZLSelectPhotoModel alloc] init];
        model.strPicName = pic.picName;
        model.tag = btn.tag;
        [_arraySelectPhotos addObject:model];
    } else {
        for (ZLSelectPhotoModel *model in _arraySelectPhotos) {
            if ([model.strPicName isEqualToString:pic.picName]) {
                [_arraySelectPhotos removeObject:model];
                break;
            }
        }
    }
}

- (void)makeArray:(UIButton *)btn{
    PHAsset *asset = _arrayDataSources[btn.tag];
    
    if (!btn.selected) {
        //添加图片到选中数组
        [btn.layer addAnimation:GetBtnStatusChangedAnimation() forKey:nil];
        if (![[ZLPhotoTool sharePhotoTool] judgeAssetisInLocalAblum:asset]) {
            ShowToastLong(@"%@", GetLocalLanguageTextValue(ZLPhotoBrowseriCloudPhotoText));
            return;
        }
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat width = MIN(kViewWidth, kMaxImageWidth);
        CGSize size = CGSizeMake(width*scale, width*scale*asset.pixelHeight/asset.pixelWidth);
        weakify(self);
        [[ZLPhotoTool sharePhotoTool] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
            weakSelf.picArray[btn.tag].picImage = image;
        }];
        ZLSelectPhotoModel *model = [[ZLSelectPhotoModel alloc] init];
        model.asset = asset;
        model.localIdentifier = asset.localIdentifier;
        model.tag = btn.tag;
        [_arraySelectPhotos addObject:model];
    } else {
        for (ZLSelectPhotoModel *model in _arraySelectPhotos) {
            if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                [_arraySelectPhotos removeObject:model];
                break;
            }
        }
    }
}

- (IBAction)btnPreview_Click:(id)sender
{
    NSMutableArray<PHAsset *> *arrSel = [NSMutableArray array];
    NSMutableArray<PicModel *> *picSel = [NSMutableArray array];
    for (ZLSelectPhotoModel *model in self.arraySelectPhotos) {
        
        if (self.bIsPicCenter) {
            for (PicModel *pic in self.picArray) {
                if ([pic.picName isEqualToString:model.strPicName]) {
                    [picSel addObject:pic];
                    break;
                }
            }

        }else{
            [arrSel addObject:model.asset];
            for (PicModel *pic in self.picArray) {
                if ([pic.asset.localIdentifier isEqualToString:model.localIdentifier]) {
                    [picSel addObject:pic];
                    break;
                }
            }
        }
    }
    [self pushShowBigImgVCWithDataArray:arrSel picArray:picSel selectIndex:0];
}

// 浏览界面的编辑
- (IBAction)btnOriginalPhoto_Click:(id)sender
{
    self.isSelectOriginalPhoto = !self.btnOriginalPhoto.selected;
    //    [self getOriginalImageBytes];
    
    for (PicModel *model in self.picArray) {
        
//        if (self.bIsPicCenter && [model.picName isEqualToString:self.arraySelectPhotos.firstObject.strPicName]) {
//            CSDrawPictureVController *vc = [CSDrawPictureVController myTableViewController];
//            vc.imageInfo = model.picImage;
//            vc.delegate = self;
//            [self presentModalViewController:vc animated:YES];
//            break;
//        }
//
//        if (!self.bIsPicCenter && [model.asset.localIdentifier isEqualToString: self.arraySelectPhotos.firstObject.localIdentifier]) {
//            // 搞编辑
//            CSDrawPictureVController *vc = [CSDrawPictureVController myTableViewController];
//            vc.imageInfo = model.picImage;
//            vc.delegate = self;
//            [self presentModalViewController:vc animated:YES];
//            break;
//        }
    }
    
}

#pragma drawpicture delegate
- (void)getDrawImage:(UIImage*)image{
    self.arraySelectPhotos.firstObject.editImage = image;
    self.arraySelectPhotos.firstObject.bIsHaveEditImage = YES;
    self.picArray[self.arraySelectPhotos.firstObject.tag].picImage = image;
    [_collectionView reloadData];
}

- (IBAction)btnDone_Click:(id)sender
{
    if (self.DoneBlock) {
        self.DoneBlock(self.arraySelectPhotos, self.isSelectOriginalPhoto);
    }
}

- (void)navLeftBtn_Click
{
//    if (self.bIsPicCenter) {
//        [self navRightBtn_Click];
//    }else{
//        self.sender.arraySelectPhotos = self.arraySelectPhotos.mutableCopy;
//        self.sender.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)navRightBtn_Click
{
    if (self.CancelBlock) {
        self.CancelBlock();
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger lCount = 0;
    if (self.bIsPicCenter) {
        lCount = self.picArray.count;
    }else{
        lCount = _arrayDataSources.count;
    }
    return lCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLCollectionCell" forIndexPath:indexPath];
    
    cell.btnSelect.selected = NO;
    
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    
//    CGSize size = cell.frame.size;
//    size.width *= 2.5;
//    size.height *= 2.5;
//    weakify(self);
//    [[ZLPhotoTool sharePhotoTool] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image, NSDictionary *info) {
//        strongify(weakSelf);
//        cell.imageView.image = image;
//        for (ZLSelectPhotoModel *model in strongSelf.arraySelectPhotos) {
//            if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
//                cell.btnSelect.selected = YES;
//                break;
//            }
//        }
//    }];
    
    cell.imageView.image = self.picArray[indexPath.row].picImage;
    if (self.bIsPicCenter) {
        PicModel *picTem = self.picArray[indexPath.row];
        for (ZLSelectPhotoModel *model in self.arraySelectPhotos) {
            if ([model.strPicName isEqualToString:picTem.picName]) {
                cell.btnSelect.selected = YES;
                break;
            }
        }
    }else{
        PHAsset *asset = _arrayDataSources[indexPath.row];
        for (ZLSelectPhotoModel *model in self.arraySelectPhotos) {
            if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                cell.btnSelect.selected = YES;
                break;
            }
        }
    }
    
    cell.btnSelect.tag = indexPath.row;
    [cell.btnSelect addTarget:self action:@selector(cell_btn_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushShowBigImgVCWithDataArray:_arrayDataSources picArray:self.picArray selectIndex:indexPath.row];
}

- (void)pushShowBigImgVCWithDataArray:(NSArray<PHAsset *> *)dataArray picArray:(NSMutableArray<PicModel*> *)picArray selectIndex:(NSInteger)selectIndex
{
    ZLShowBigImgViewController *svc = [[ZLShowBigImgViewController alloc] init];
    svc.assets         = dataArray;
    svc.arraySelectPhotos = self.arraySelectPhotos.mutableCopy;
    svc.arrayPics = picArray;
    svc.selectIndex    = selectIndex;
    svc.maxSelectCount = _maxSelectCount;
    svc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    svc.bIsPicCenter = self.bIsPicCenter;
    svc.isPresent = NO;
    svc.shouldReverseAssets = NO;
    
    weakify(self);
    [svc setOnSelectedPhotos:^(NSArray<ZLSelectPhotoModel *> *selectedPhotos, BOOL isSelectOriginalPhoto) {
        strongify(weakSelf);
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf.arraySelectPhotos removeAllObjects];
        [strongSelf.arraySelectPhotos addObjectsFromArray:selectedPhotos];
        [strongSelf.collectionView reloadData];
        [strongSelf getOriginalImageBytes];
        [strongSelf resetBottomBtnsStatus];
    }];
    [svc setBtnDoneBlock:^(NSArray<ZLSelectPhotoModel *> *selectedPhotos, BOOL isSelectOriginalPhoto) {
        strongify(weakSelf);
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf.arraySelectPhotos removeAllObjects];
        [strongSelf.arraySelectPhotos addObjectsFromArray:selectedPhotos];
        [strongSelf btnDone_Click:nil];
    }];
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)getOriginalImageBytes
{
    weakify(self);
    if (self.isSelectOriginalPhoto && self.arraySelectPhotos.count > 0) {
        [[ZLPhotoTool sharePhotoTool] getPhotosBytesWithArray:self.arraySelectPhotos completion:^(NSString *photosBytes) {
            strongify(weakSelf);
//            strongSelf.labPhotosBytes.text = [NSString stringWithFormat:@"(%@)", photosBytes];
        }];
        self.btnOriginalPhoto.selected = self.isSelectOriginalPhoto;
    } else {
        self.btnOriginalPhoto.selected = NO;
        self.labPhotosBytes.text = nil;
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait ;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
