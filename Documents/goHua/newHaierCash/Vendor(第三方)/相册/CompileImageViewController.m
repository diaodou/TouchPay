//
//  CompileImageViewController.m
//  编辑影像
//
//  Created by 史长硕 on 16/4/14.
//  Copyright © 2016年 史长硕. All rights reserved.
//

#import "CompileImageViewController.h"
#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"
#import "GoodGestureRecognizer.h"
#import "RMUniversalAlert.h"
#import "LMSTakePhotoController.h"
#import "JKImagePickerController.h"
#import "DSComposeToolbar.h"
#import "DSComposePhotosView.h"
#import "SpecialButton.h"
#import "BSVKHttpClient.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import <MJExtension.h>
#import "UpImagesResult.h"
#import "UpImagesTypes.h"
#import "DeleteImageNetFlow.h"
#import "UpImagesTypes.h"
#import "DefineSystemTool.h"
#import "LookImageModel.h"
#import <YYWebImage.h>
#import "PortraitImageModel.h"
#import "SelectNameModel.h"
#import "DefineSystemTool.h"

@interface CompileImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,LMSTakePhotoControllerDelegate,DSComposeToolbarDelegate ,JKImagePickerControllerDelegate,DSComposePhotosViewDelegate,BSVKHttpClientDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    float x ;//适应屏幕比例
    
    UIView *_groundView;//笼罩视图
    
    NSMutableArray *_indexArray;
    
        UIView *_lightView;
    
    UILabel *_titleLab;//标题lab
    
    DeleteImageNetFlow *netFlow;
    
    NSInteger putIndex;
    
    NSString *_loanType;//影像类型代码
    
    NSString *_loanName;//影像类型名称
    
    UIButton *_backBtn;
    
    
    BOOL bUpFileNet;
    
    BOOL _isHiddenStatuBar;//是否隐藏状态栏
    
    CGFloat _firstX;
    
    CGFloat _firstY;
    
    UIImagePickerController *_picker;
}
@property (nonatomic, strong)  UICollectionView *imageCollection;//图片展示视图;

@property (nonatomic, strong)   UICollectionView *lookImgCollection;//查看图片视图

@property (nonatomic, strong)  NSMutableArray *numArray;//记录选中的图片

@property (nonatomic, strong) NSMutableArray *tempMulitArray;

@property (nonatomic, strong) NSMutableArray *storeMulitArray;

@property(nonatomic,strong)NSMutableArray *_portraitArray;//盛放请求下来的影像数据

@end

@implementation CompileImageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _isHiddenStatuBar = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"影像编辑";
    
    self.navigationController.navigationBar.tintColor = [UIColor UIColorWithHexColorString:@"0x32beff" AndAlpha:1.0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    netFlow = [[DeleteImageNetFlow alloc]init];
    
    _tempMulitArray = [NSMutableArray array];
    
    _storeMulitArray = [NSMutableArray array];
    
    x = DeviceWidth/375.0;
    
    _indexArray = [[NSMutableArray alloc]init];
    
    _numArray = [[NSMutableArray alloc]init];
    
    _imageArray = [[NSMutableArray alloc]init];
    
    [self creatRightBtn];
    
    [self creatImageCollection];
    
    [self creatGroundView];
    
    [self creatLookImageCollection];
    
    [self buildGetInfo];
    
    [self creatLightView];
    
    [self creatSelectTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --> setting and getting

-(void)setImageArray:(NSMutableArray *)imageArray{
    
    _imageArray = imageArray;
    
    _numArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<_imageArray.count; i++) {
        
        [_numArray addObject:@"NO"];
        
    }
    
    
    
}

-(void)setSelectCount:(NSString *)selectCount{
    
    _selectCount = selectCount;
    
    if ([selectCount integerValue]>0) {

        if(![self.flowName isEqualToString:@"fromMoney"] && ![self.flowName isEqualToString:@"fromPersonData"] && [AppDelegate delegate].userInfo.busFlowName != QuotaApply && [AppDelegate delegate].userInfo.busFlowName != QuotaReturned)
        {
            [self buildGetSelectImage:_imageType.docCde];
        }
    }
    
}

-(void)buildGetSelectImage:(NSString *)docCde{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    

    if (_typCde && _typCde.length > 0) {
        
        [parm setObject:_typCde forKey:@"typCde"];
        
    }
    
    if (docCde && docCde.length > 0) {
        
        [parm setObject:docCde forKey:@"docCde"];
        
    }
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [client getInfo:@"app/appserver/cmis/typImagesList" requestArgument:parm requestTag:405 requestClass:NSStringFromClass([self class])];
    
    
}


#pragma mark --> private Methods

//创建笼罩视图
-(void)creatLightView{
    
    
    _lightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,DeviceWidth , DeviceHeight)];
    
    _lightView.backgroundColor  = [UIColor UIColorWithHexColorString:@"0x7f7f7f" AndAlpha:0.8];
    
    _lightView.hidden = YES;
    
    [self.view addSubview:_lightView];
    
    
}

//创建可选影像名称列表

-(void)creatSelectTable{
    
    _selectTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    
    _selectTable.dataSource = self;
    
    _selectTable.delegate = self;
    
    _selectTable.showsVerticalScrollIndicator = NO;
    
    _selectTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _selectTable.backgroundColor = [UIColor UIColorWithHexColorString:@"0xf6f6f6" AndAlpha:1.0];
    
    
    [self.view addSubview:_selectTable];
    
}


//创建请求影像数据的方法

-(void)buildGetInfo{
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    client.delegate = self;
    
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if (dele.userInfo.custNum && dele.userInfo.custNum.length > 0) {
        
        [parm setObject:dele.userInfo.custNum forKey:@"custNo"];
        
    }
    
    if (_imageType.docCde && _imageType.docCde.length > 0) {
        
        [parm setObject:_imageType.docCde forKey:@"attachType"];
        
    }
    
    if ([_flowName isEqualToString:@"fromMoney"]) {
       
        [parm setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"applSeq"];
    }
    if ([_flowName isEqualToString:@"fromMoney"]) {
        [client getInfo:@"app/appserver/getTeAttachTypeSearchPerson" requestArgument:parm requestTag:1000 requestClass:NSStringFromClass([self class])];
    }else{
    [client getInfo:@"app/appserver/attachTypeSearchPerson" requestArgument:parm requestTag:1000 requestClass:NSStringFromClass([self class])];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//创建照片展示视图
-(void)creatImageCollection{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake((DeviceWidth-60*x)/4, (DeviceWidth-60*x)/4);
    
    layout.minimumLineSpacing = 10*x;
    
    layout.minimumInteritemSpacing = 10*x;
    
    _imageCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64*x) collectionViewLayout:layout];
    
    _imageCollection.dataSource = self;
    
    _imageCollection.delegate = self;
    
    _imageCollection.tag = 10;
    
    _imageCollection.backgroundColor = [UIColor whiteColor];
    
    [_imageCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"kill"];
    
    
    [self.view addSubview:_imageCollection];
    
}


//创建笼罩视图
-(void)creatGroundView{
    
    _groundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    
    _groundView.backgroundColor = [UIColor blackColor];
    
    _groundView.hidden = YES;
    
    _groundView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gest =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buildHidden)];
    
    [_groundView addGestureRecognizer:gest];
    
    [self.view addSubview:_groundView];
    
    [self creatLookImageCollection];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 50*x, DeviceWidth, 25*x)];
    
    _titleLab.textColor = [UIColor blackColor];
    
    _titleLab.font = [UIFont appFontRegularOfSize:20*x];
    
    _titleLab.textAlignment = NSTextAlignmentCenter;
    
    [_groundView addSubview:_titleLab];
    
}

//创建导航栏右侧删除按钮
-(void)creatRightBtn{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 30*x, 40*x)];
    
    [button setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    
    //    [button addTarget:self action:@selector(buildImageDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [button addTarget:self action:@selector(showOkayCancelAlert) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = bar;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button2.frame  =ReturnRect;
    
    [button2 setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    
    [button2 addTarget:self action:@selector(buildBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    
    self.navigationItem.leftBarButtonItem = bar2;
}

//创建查看图片视图
-(void)creatLookImageCollection{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake(DeviceWidth,DeviceHeight);
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    layout.minimumLineSpacing = 0;
    
    layout.minimumInteritemSpacing = 0;
    
    _lookImgCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) collectionViewLayout:layout];
    
    _lookImgCollection.dataSource = self;
    
    _lookImgCollection.delegate = self;
    
    _lookImgCollection.tag = 11;
    
    _lookImgCollection.backgroundColor = [UIColor whiteColor];
    
    _lookImgCollection.pagingEnabled = YES;
    
    _lookImgCollection.minimumZoomScale = 0.5;
    
    _lookImgCollection.maximumZoomScale =  2.0;
    
    
    _lookImgCollection.showsHorizontalScrollIndicator = NO;
    
    [_lookImgCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"kiss"];
    
    
    [_groundView  addSubview:_lookImgCollection];
    
}


#pragma mark --> collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView.tag == 11) {
        
        return _imageArray.count;
        
    }
    
    if (_imageArray.count == 0) {
        
        return 1;
        
    }else{
        
        return _imageArray.count+1;
        
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == 10) {
        
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kill" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        for (UIView *sub in cell.contentView.subviews) {
            
            [sub removeFromSuperview];
            
        }
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
        
        imgView.contentMode = UIViewContentModeScaleToFill;
        
        imgView.userInteractionEnabled = YES;
        
        [cell.contentView addSubview:imgView];
        
       
        
        UIImageView *deleteImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        
        deleteImg.contentMode = UIViewContentModeScaleAspectFill;
        
        deleteImg.tag = 10 + indexPath.row;
        
        [cell.contentView addSubview:deleteImg];
        
        
        if (indexPath.row<_imageArray.count) {
            
            NSString *moon = _imageArray[indexPath.row];
            
            if (moon && moon.length > 0) {
                
                NSData *tempData = (NSData *)[[AppDelegate delegate].imagePutCache objectForKey:ImageUrl(moon)];
                
                if (tempData) {
                    
                    imgView.image = [UIImage imageWithData:tempData];
                    
                }else{
                    
                    [imgView yy_setImageWithURL:[NSURL URLWithString:ImageUrl(moon)] placeholder:[UIImage imageNamed:@"加载展位图"] options:YYWebImageOptionIgnoreDiskCache | YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                        
                        [[AppDelegate delegate].imagePutCache setObject:UIImageJPEGRepresentation(image, 0.6) forKey:url.absoluteString];
                        
                    }];
                }
                
                
            }
            
            
            
            GoodGestureRecognizer *gest2  = [[GoodGestureRecognizer alloc]initWithTarget:self action:@selector(buildViewNoHidden:)];
            
            gest2.isLike = NO;
            
            gest2.num = indexPath.row;
            
            gest2.index = indexPath;
            
            [imgView addGestureRecognizer:gest2];
            
            deleteImg.image = [UIImage imageNamed:@"对号灰"];
            
            SpecialButton *specBtn = [[SpecialButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            
            specBtn.backgroundColor = [UIColor clearColor];
            
            specBtn.index = indexPath;
            
            specBtn.tag = indexPath.row;
            
            [specBtn addTarget:self action:@selector(buildImageAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:specBtn];
            
            
        }else{
            
            imgView.image = [UIImage imageNamed:@"默认照片"];
            
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            
            imgView.clipsToBounds = YES;
            
            deleteImg.hidden = YES;
            
        }
        
        return cell;
        
        
        
    }else{
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kiss" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        for (UIView *sub in cell.contentView.subviews) {
            
            
            [sub removeFromSuperview];
            
        }
        
        [_indexArray addObject:indexPath];
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 2.0f;
        scrollView.minimumZoomScale = 1.0f;
        [cell.contentView addSubview:scrollView];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
        
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        [scrollView addSubview:imgView];
        
        imgView.tag = 100;
        
        NSString *strID = _imageArray[indexPath.row];
        
        NSData *tempData = (NSData *)[[AppDelegate delegate].imagePutCache objectForKey:ImageUrl(strID)];
        
        if (tempData ) {
            
            imgView.image = [UIImage imageWithData:tempData];
            
        }
        
        
        
        return cell;
        
        
        
        
    }
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == 11) {
        
        _groundView.hidden = YES;
        
        self.navigationController.navigationBarHidden = NO;
        
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
        
    }else if (collectionView.tag == 10){
        
        
        if (indexPath.row == _imageArray.count) {
            
            if (_selectNameArray.count > 0) {
                
                NSInteger rose = ((NSArray *)(_selectNameArray[0])).count+((NSArray *)(_selectNameArray[1])).count;
                
                _selectTable.frame = CGRectMake(0, DeviceHeight-rose*40-64, DeviceWidth, 40*rose);
                
                _lightView.hidden = NO;
                
            }else{
                if (_usePhoto) {
                    
                    [self buildCamera];
                    
                }else{
                WEAKSELF
                
                [RMUniversalAlert showActionSheetInViewController:self withTitle:@"选择一张照片" message:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册中选取"] popoverPresentationControllerBlock:^(RMPopoverPresentationController * _Nonnull popover) {
                    popover.sourceView = self.view;
                    popover.sourceRect = _imageCollection.frame;
                    
                } tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    
                    STRONGSELF
                    
                    if (strongSelf) {
                        
                        if (buttonIndex == 2) {
                            
                            [strongSelf buildCamera];
                            
                        }else if (buttonIndex == 3){
                            
                            [strongSelf buildPhoto];
                            
                        }
                        
                    }
                    
                }];
            }
            
                
            }
            
            
            
        }else{
            
            _groundView.hidden = NO;
            
            self.navigationController.navigationBarHidden = YES;
            
            [[UIApplication sharedApplication]setStatusBarHidden:YES];
            
            
        }
        
    }
    
    
}




- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (collectionView.tag == 10) {
        return UIEdgeInsetsMake(10, 10*x, 0, 10*x);
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//视图开始滑动

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    NSInteger number = scrollView.contentOffset.x/DeviceWidth;
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld - %ld",(long)number+1,(long)_imageArray.count]];
    
    NSString *num = [NSString stringWithFormat:@"%ld",(long)number+1];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(num.length, 1)];
    
    _titleLab.attributedText = string;
    
}

#pragma mark --> event Methods

-(void)buildBackAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendResultNumber:array:)]) {
        
        [_delegate sendResultNumber:0 array:nil];
        
    }
}


//创建提示框
- (void)showOkayCancelAlert {
    
    NSInteger boy = 0;
    
    for (NSString *string in _numArray) {
        
        if ([string isEqualToString:@"YES"]) {
            
            boy++;
        }
        
    }
    
    if (boy > 0) {
        
        WEAKSELF
        
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"是否删除所选图片" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            
            STRONGSELF
            
            if (buttonIndex == 0) {
                
                return ;
                
            }else if (buttonIndex == 1){
                
                if (strongSelf) {
                    
                    [strongSelf buildDeleteImage];
                    
                    
                }
                
                
            }
            
            
        }];
        
        
    }
    
    
    
    
}

-(void)buildDeleteImage{
    
    
    NSInteger laker = _numArray.count;
    
    netFlow = nil;
    
    netFlow = [[DeleteImageNetFlow alloc]init];
    
    for (int i=0; i<laker; ++i) {
        
        NSString *string = _numArray[i];
        
        if ([string isEqualToString:@"YES"]) {
            
            netFlow.bDeleteImage  =YES;
            
            ++netFlow.allCount;
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSString *stringId =  StringOrNull([_imageArray objectAtIndex:i]) ;
            
            [BSVKHttpClient shareInstance].delegate = self;
            
            NSString *url = [NSString stringWithFormat:@"app/appserver/attachDeletePerson?id=%@",stringId];
            
            [[BSVKHttpClient shareInstance]deleteInfo:url requestArgument:nil requestTag:i requestClass:NSStringFromClass([self class]) with:@{@"id":stringId}];
            
        }
    }
    
    [_imageCollection reloadData];
    
    
    
}

-(void)buildImageAction:(SpecialButton *)sender{
    
    sender.selected = !sender.selected;
    
    UICollectionViewCell *cell  = [_imageCollection cellForItemAtIndexPath:sender.index];
    
    UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:10+sender.tag];
    
    if (sender.selected == YES) {
        
        
        img.image = [UIImage imageNamed:@"勾选"];
        
        [_numArray replaceObjectAtIndex:sender.tag withObject:@"YES"];
        
        
        
    }else{
        
        img.image = [UIImage imageNamed:@"对号灰"];
        
        [_numArray replaceObjectAtIndex:sender.tag withObject:@"NO"];
        
    }
    
}

//改变图片的选中状态
-(void)buildImageTap:( GoodGestureRecognizer*)tap{
    
    
    
    tap.isLike = !tap.isLike;
    
    UICollectionViewCell *cell  = [_imageCollection cellForItemAtIndexPath:tap.index];
    
    UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:10+tap.num];
    
    if (tap.isLike == YES) {
        
        
        img.image = [UIImage imageNamed:@"勾选"];
        
        [_numArray replaceObjectAtIndex:tap.num withObject:@"YES"];
        
    }else{
        
        img.image = [UIImage imageNamed:@"对号灰"];
        
        [_numArray replaceObjectAtIndex:tap.num withObject:@"NO"];
        
    }
    
}

//隐藏图片查看视图
-(void)buildHidden{
    
    _groundView.hidden = YES;
    
    self.navigationController.navigationBarHidden = NO;
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
}


//显示图片查看视图
-(void)buildViewNoHidden:(GoodGestureRecognizer *)tap{
    
    
    _groundView.hidden = NO;
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    _lookImgCollection.contentOffset = CGPointMake(DeviceWidth*tap.index.row, 0);
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld - %ld",(long)tap.index.row+1,(long)_imageArray.count]];
    
    NSString *num = [NSString stringWithFormat:@"%ld",(long)tap.index.row];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(num.length, 1)];
    
    _titleLab.attributedText = string;
    
}

//调用拍照功能
-(void)buildCamera{
    
    if (![DefineSystemTool isGetCameraPermission]) {
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"你还未开启相机权限，请前往设置中心开启" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 1) {
                    
                    [strongSelf toCamera];
                    
                }
            }
        }];
        
        return;
    }
//    LMSTakePhotoController *vc = [[LMSTakePhotoController alloc]init];
//    
//    vc.delegate = self;
//    
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    
//    [self presentViewController:nav animated:YES completion:nil];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.sourceType = sourceType;
        _picker.mediaTypes = [NSArray arrayWithObjects: @"public.image", nil];
        
        [self presentViewController:_picker animated:YES completion:nil];
    }
}
- (void)toCamera{
    
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysVer >= 10.0) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
        }
        
    }else{
        
        NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
        
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }
}
-(void)didFinishPickingImage:(UIImage *)image{
    
    
//    if (![DefineSystemTool isGetCameraPermission]) {
//        
//        WEAKSELF
//        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"你还未开启相册权限，请前往设置中心开启" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
//            STRONGSELF
//            if (strongSelf) {
//                if (buttonIndex == 1) {
//                    
//                    [strongSelf toPhoto];
//                    
//                }
//            }
//        }];
//        
//        return;
//    }
    
    NSData *imageDate = UIImageJPEGRepresentation(image,ImageUpZScale);
    
    __block NSData *imageLocalData = UIImageJPEGRepresentation(image,ImageLocalScale);

    NSString *strMd5 = [DefineSystemTool md5StringWithData:imageDate];
    
    NSString *strFileName = [NSString stringWithFormat:@"%@.jpg",_loanType];
    
    if (strMd5) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *url =[NSString string];
        
        NSMutableDictionary * parmDic = [NSMutableDictionary dictionary];
        
        if ([_flowName isEqualToString:@"fromMoney"]) {
            
            url = @"app/appserver/attachUploadPersonByGetEd";
            [parmDic  setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
            [parmDic setObject:StringOrNull(_loanType) forKey:@"attachType"];
            [parmDic setObject:StringOrNull(_loanName) forKey:@"attachName"];
            [parmDic setObject:strMd5 forKey:@"md5"];
            [parmDic setObject:@"" forKey:@"commonCustNo"];
            
        }else{
            
        url = @"app/appserver/attachUploadPerson";
            [parmDic  setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
            [parmDic setObject:StringOrNull(_loanType) forKey:@"attachType"];
            [parmDic setObject:StringOrNull(_loanName)  forKey:@"attachName"];
            [parmDic setObject:strMd5 forKey:@"md5"];
            [parmDic setObject:@"" forKey:@"commonCustNo"];
        }
        WEAKSELF
        [[BSVKHttpClient shareInstance]putFile:url requestArgument:parmDic fileData:imageDate fileName:strFileName name:@"multipartFile" mimeType:@"image/jpeg" completion:^(id results, NSError *error) {
            if (!error) {
                STRONGSELF
                UpImagesResult *model = [UpImagesResult mj_objectWithKeyValues:results];
                //上传到collectionViewCell成功
                if ([model.head.retFlag isEqualToString:SucessCode]) {
                    
                    [[AppDelegate delegate].imagePutCache setObject:imageLocalData forKey:ImageUrl(model.body.ID)];
                    
                    
                    [strongSelf.imageArray addObject:model.body.ID];
                    
                    [strongSelf.numArray addObject:@"NO"];
                    
                    [strongSelf.imageCollection reloadData];
                    
                    [strongSelf.lookImgCollection reloadData];
                    
                }else {
                    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    [alter show];
                }
            }else {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alter show];
            }
            imageLocalData = nil;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

-(void)buildPhoto{
    if (![DefineSystemTool isGetPhotoPermission]) {
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"你还未开启相册权限，请前往设置中心开启" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 1) {
                    
                    [strongSelf toPhoto];
                    
                }
            }
        }];
        
        return;
    }
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    imagePickerController.showsCancelButton = YES;
    
    imagePickerController.allowsMultipleSelection = YES;
    
    imagePickerController.minimumNumberOfSelection = 1;
    
    imagePickerController.maximumNumberOfSelection = 10;

    imagePickerController.selectedAssetArray = nil;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    navigationController.navigationBar.translucent = NO;
    //改变导航栏背景色f
    [[UINavigationBar appearance] setBarTintColor:[UIColor UIColorWithHexColorString:@"0x32beff" AndAlpha:1.0]];
    [self presentViewController:navigationController animated:YES completion:NULL];
    
    
    
}
- (void)toPhoto{
    
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysVer >= 10.0) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
        }
        
    }else{
        
        NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
        
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }
}

#pragma mark --> tableView 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _selectNameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = _selectNameArray[section];
    
    return array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kiss"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kiss"];
        
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, DeviceWidth, 20)];
        
        label.font = [UIFont appFontRegularOfSize:15];
        
        label.tag = 190;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [cell.contentView addSubview:label];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 39.5, DeviceWidth, 0.5f);
        view.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:view];
    }
    
    UILabel *lab = (UILabel *)[cell.contentView viewWithTag:190];
    
    NSArray *array = _selectNameArray[indexPath.section];
    
    SelectNameBody *body = array[indexPath.row];
    
    lab.text = body.docDesc;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        tableView.frame = CGRectMake(0, 0, 0, 0);
        
        _lightView.hidden = YES;
        
    }else{
        
        tableView.frame = CGRectMake(0, 0, 0, 0);
        
        _lightView.hidden = YES;
        
        if (_usePhoto) {
            
            [self buildCamera];
            
        }else{
        
        WEAKSELF
        
        [RMUniversalAlert showActionSheetInViewController:self withTitle:@"选择一张照片" message:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册中选取"] popoverPresentationControllerBlock:^(RMPopoverPresentationController * _Nonnull popover) {
            popover.sourceView = self.view;
            popover.sourceRect = _imageCollection.frame;
            
        } tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            
            STRONGSELF
            
            if (strongSelf) {
                
                if (buttonIndex == 2) {
                    
                    [strongSelf buildCamera];
                    
                }else if (buttonIndex == 3){
                    
                    [strongSelf buildPhoto];
                    
                }
                
            }
            
        }];
        }
    }
}

#pragma mark - scrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:100];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    if (assets.count>0) {
        
        bUpFileNet = YES;
        
        
        [_tempMulitArray removeAllObjects];
        
        [_storeMulitArray removeAllObjects];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        for (int i = 0 ; i != assets.count; ++i) {
            
            JKAssets *kiss = [assets objectAtIndex:i];
            
            [_tempMulitArray addObject:kiss.photo];
            
        }
        
        putIndex = 0;
        
        NSData *imageDate = UIImageJPEGRepresentation(_tempMulitArray[putIndex],ImageUpZScale);
        
        NSString *strMd5 = [DefineSystemTool md5StringWithData:imageDate];
        
        NSString *strFileName = [NSString stringWithFormat:@"%@.jpg",_loanType];
        
        [BSVKHttpClient shareInstance].delegate = self;
        NSString *url =[NSString string];
         NSMutableDictionary * parmDic = [NSMutableDictionary dictionary];
        if ([_flowName isEqualToString:@"fromMoney"]) {
            
            url =@"app/appserver/attachUploadPersonByGetEd";
            [parmDic  setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
            [parmDic setObject:StringOrNull(_loanType) forKey:@"attachType"];
            [parmDic setObject:StringOrNull(_loanName) forKey:@"attachName"];
            [parmDic setObject:strMd5 forKey:@"md5"];
            [parmDic setObject:@"" forKey:@"commonCustNo"];
            
        }else{
        
            url = @"app/appserver/attachUploadPerson";
            [parmDic  setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
            [parmDic setObject:StringOrNull(_loanType) forKey:@"attachType"];
            [parmDic setObject:StringOrNull(_loanName) forKey:@"attachName"];
            [parmDic setObject:strMd5 forKey:@"md5"];
            [parmDic setObject:@"" forKey:@"commonCustNo"];
        
        }
        
        [[BSVKHttpClient shareInstance]puFileIndex:url requestArgument:parmDic  fileData:imageDate fileName:strFileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:10+putIndex arrIndex:putIndex requestClass:NSStringFromClass([self class])];
//
    }
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    //    self.imagePicker.selectedAssetArray = self.imagePicker.tempArray;
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - BSVKHttpClentDelegate

//请求成功
-(void)requestSucessWithParam:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className withParam:(NSDictionary *)dict{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (netFlow.bDeleteImage) {
            
            ++netFlow.handleCount;
            
            UpImagesResult *model = [UpImagesResult mj_objectWithKeyValues:responseObject];
            
            if ([model.head.retFlag isEqualToString:SucessCode]) {
                
                NSString *string = [dict objectForKey:@"id"];
                
                if (string && string.length > 0) {
                    
                    NSInteger num = [_imageArray indexOfObject:string];
                    
                    [_imageArray removeObject:string];
                    
                    [_numArray removeObjectAtIndex:num];
                    
                }
                
                [_imageCollection reloadData];
                
                [_lookImgCollection reloadData];
                
            }else{
                
                NSString *strRes = [NSString stringWithFormat:@"第%ld张删除失败，%@",(long)requestTag + 1,model.head.retMsg];
                
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:strRes delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alter show];
                
            }
            
        }
        
        if (netFlow.handleCount == netFlow.allCount) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            netFlow.bDeleteImage = NO;
        }
        
    }
    
    
}

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (!netFlow.bDeleteImage) {
            if (requestTag == 1000) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                LookImageModel *model = [LookImageModel mj_objectWithKeyValues:responseObject];
                
                if ([model.head.retFlag isEqualToString:@"00000"]) {
                    
                    if (model.body.count > 0) {
                        
                        for (LookImageBody *body in model.body) {
                            
                            [_imageArray addObject:body.ID];
                            
                            [_numArray addObject:@"NO"];
                            
                            _loanName = body.attachName;
                            
                            _loanType = body.attachType;
                            
                        }
                        
                        [_imageCollection reloadData];
                        
                        [_lookImgCollection reloadData];
                        
                    }
                    
                }else{
                    
                    [self buildHeadError:model.head.retMsg];
                    
                }
                
            }else if (requestTag == 2000){
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                PortraitImageModel *model = [PortraitImageModel mj_objectWithKeyValues:responseObject];
                
                if ([model.head.retFlag isEqualToString:@"00000"]) {
                    
                    
                }else{
                    
                    [self buildHeadError:model.head.retMsg];
                }
            }else if (requestTag == 405){
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                SelectNameModel *model = [SelectNameModel mj_objectWithKeyValues:responseObject];
                
                if ([model.head.retFlag isEqualToString:@"00000"]) {
                    
                    if (!_selectNameArray) {
                        
                        _selectNameArray = [NSMutableArray array];
                        
                    }else{
                        
                        [_selectNameArray removeAllObjects];
                        
                    }
                    
                    if (model.body.count > 0) {
                        
                        NSArray *array = [NSArray arrayWithArray:model.body];
                        
                        [_selectNameArray addObject:array];
                        
                        SelectNameBody *body = [[SelectNameBody alloc]init];
                        
                        body.docDesc = @"取消";
                        
                        [_selectNameArray addObject:@[body]];
                        
                    }
                    
                    [_selectTable reloadData];
                    
                }else{
                    
                    [self buildHeadError:model.head.retMsg];
                    
                }
                
            }

        }
    }
    
}
- (void)requestFailWithParam:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className withParam:(NSDictionary *)dict {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (netFlow.bDeleteImage) {
        ++netFlow.handleCount;
        
        NSString *strRes = [NSString stringWithFormat:@"第%ld张删除失败，原因：网络异常",(long)requestTag + 1];
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:strRes delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alter show];
        
        if (netFlow.handleCount == netFlow.allCount) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            netFlow.bDeleteImage = NO;
        }
    }
}

- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className {
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!netFlow.bDeleteImage) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSString *errorStr;
            if(httpCode != 0)
            {
                errorStr = [NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",httpCode];
            }
            else
            {
                errorStr = @"网络环境异常，请检查网络并重试";
            }
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:errorStr delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            
            [alter show];
        }
    }
}

- (void)putFileSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className arrIndex:(NSInteger)index {
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (bUpFileNet) {
            if (requestTag == 10+putIndex) {
                
                UpImagesResult *model = [UpImagesResult mj_objectWithKeyValues:responseObject];
                if ([model.head.retFlag isEqualToString:SucessCode]) {
                    //存入
                    [_storeMulitArray addObject:model.body.ID];
                    UIImage *imageTemp = [_tempMulitArray objectAtIndex:index];
                    NSData *imageLocalData = UIImageJPEGRepresentation(imageTemp, ImageLocalScale);
                    
                    //存本地
                    [[AppDelegate delegate].imagePutCache setObject:imageLocalData forKey:ImageUrl(model.body.ID)];
                    //更新数据源
                    [_imageArray addObject:model.body.ID];
                    
                    [_numArray addObject:@"NO"];
                    //释放
                    [_tempMulitArray replaceObjectAtIndex:index withObject:@""];
                    
                    
                }else {
                    //释放
                    [_tempMulitArray replaceObjectAtIndex:index withObject:@""];
                    NSString *strRes = [NSString stringWithFormat:@"第%ld张上传失败，%@",(long)index + 1,model.head.retMsg];
                    
                    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:strRes delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    [alter show];
                }
                
                ++putIndex;
                
                if (putIndex < _tempMulitArray.count) {
                    
                    NSData *imageDate = UIImageJPEGRepresentation(_tempMulitArray[putIndex],ImageUpZScale);

                    NSString *strMd5 = [DefineSystemTool md5StringWithData:imageDate];
                    
                    NSString *strFileName = [NSString stringWithFormat:@"%@.jpg",_loanType];
                    
                    [BSVKHttpClient shareInstance].delegate = self;
                    NSString *url =[NSString string];
                    NSMutableDictionary * parmDic = [NSMutableDictionary dictionary];
                    if ([_flowName isEqualToString:@"fromMoney"]) {
                        
                        url =@"app/appserver/attachUploadPersonByGetEd";
                        [parmDic  setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
                        [parmDic setObject:StringOrNull(_loanType) forKey:@"attachType"];
                        [parmDic setObject:StringOrNull(_loanName) forKey:@"attachName"];
                        [parmDic setObject:strMd5 forKey:@"md5"];
                        [parmDic setObject:@"" forKey:@"commonCustNo"];
                        
                    }else{
                        
                        url = @"app/appserver/attachUploadPerson";
                        [parmDic  setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
                        [parmDic setObject:StringOrNull(_loanType) forKey:@"attachType"];
                        [parmDic setObject:StringOrNull(_loanName) forKey:@"attachName"];
                        [parmDic setObject:strMd5 forKey:@"md5"];
                        [parmDic setObject:@"" forKey:@"commonCustNo"];
                        
                    }

                    [[BSVKHttpClient shareInstance]puFileIndex: url requestArgument: parmDic  fileData:imageDate fileName:strFileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:10+putIndex arrIndex:putIndex requestClass:NSStringFromClass([self class])];
                    
                    /*
                     [[BSVKHttpClient shareInstance]puFileIndex:@"app/appserver/attachUploadPerson" requestArgument:@{@"custNo":[AppDelegate delegate].userInfo.cusNum,@"attachType":_loanType,@"attachName":_loanName,@"md5":strMd5}  fileData:imageDate fileName:strFileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:10+putIndex arrIndex:putIndex requestClass:NSStringFromClass([self class])];

                     */
                    
                }
                
                if (putIndex == _tempMulitArray.count) {
                    
                    if (_storeMulitArray.count > 0) {
                        
                        [_imageCollection reloadData];
                        
                        [_lookImgCollection reloadData];
                        
                        [_tempMulitArray removeAllObjects];
                        
                        [_storeMulitArray removeAllObjects];
                        
                        bUpFileNet = NO;
                    }
                    
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                
            }
        }
    }
}
- (void)putFileFail:(NSInteger)requestTag requestError:(NSError *)error requestClass:(NSString *)className arrIndex:(NSInteger)index {
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (bUpFileNet) {
            //释放
            [_tempMulitArray replaceObjectAtIndex:index withObject:@""];
            
            NSString *strRes = [NSString stringWithFormat:@"第%ld张上传失败",(long)index + 1];
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:strRes delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alter show];
            
            ++putIndex;
            
            if (putIndex < _tempMulitArray.count) {
                
                NSData *imageDate = UIImageJPEGRepresentation(_tempMulitArray[putIndex],ImageUpZScale);

                NSString *strMd5 = [DefineSystemTool md5StringWithData:imageDate];
                
                NSString *strFileName = [NSString stringWithFormat:@"%@.jpg",_loanType];
                
                [BSVKHttpClient shareInstance].delegate = self;
                NSString *url =[NSString string];
                NSMutableDictionary * parmDic = [NSMutableDictionary dictionary];
                if ([_flowName isEqualToString:@"fromMoney"]) {
                    
                    url =@"app/appserver/attachUploadPersonByGetEd";
                    [parmDic  setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
                    [parmDic setObject:StringOrNull(_loanType) forKey:@"attachType"];
                    [parmDic setObject:StringOrNull(_loanName) forKey:@"attachName"];
                    [parmDic setObject:strMd5 forKey:@"md5"];
                    [parmDic setObject:@"" forKey:@"commonCustNo"];
                    
                }else{
                    
                    url = @"app/appserver/attachUploadPerson";
                    [parmDic  setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
                    [parmDic setObject:StringOrNull(_loanType) forKey:@"attachType"];
                    [parmDic setObject:StringOrNull(_loanName) forKey:@"attachName"];
                    [parmDic setObject:strMd5 forKey:@"md5"];
                    [parmDic setObject:@"" forKey:@"commonCustNo"];
                    
                }
                
                [[BSVKHttpClient shareInstance]puFileIndex: url requestArgument: parmDic  fileData:imageDate fileName:strFileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:10+putIndex arrIndex:putIndex requestClass:NSStringFromClass([self class])];
                
            }
            
            if (putIndex == _tempMulitArray.count) {
                
                if (_storeMulitArray.count > 0) {
                    
                    [_imageCollection reloadData];
                    
                    [_lookImgCollection reloadData];
                    
                    [_tempMulitArray removeAllObjects];
                    
                    [_storeMulitArray removeAllObjects];
                }
                
                bUpFileNet = NO;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }
    }
}

//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                nil;
            }
        }
    }];
    
    
}

- (BOOL)prefersStatusBarHidden
{
    return _isHiddenStatuBar;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self didFinishPickingImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end



