//
//  ChooseSendImageViewController.m
//  personMerchants
//
//  Created by LLM on 16/11/26.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "ChooseSendImageViewController.h"
#import "JKImagePickerController.h"
#import "CompileImageViewController.h"

#import "HCMacro.h"
#import "BSVKHttpClient.h"
#import "UIFont+AppFont.h"
#import "AppDelegate.h"
#import "DefineSystemTool.h"
#import "PostSuccessModel.h"
#import "SelectNameModel.h"
#import <MBProgressHUD.h>
#import "RMUniversalAlert.h"
#import <YYWebImage.h>

@interface ChooseSendImageViewController ()<BSVKHttpClientDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,JKImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) NSMutableDictionary *imageBodys;     //存储已经上传的选传影像

@property (nonatomic,strong) NSMutableArray *imageDatas;   //上传多张的时候所有图片数组
@property (nonatomic,strong) NSMutableArray *parms;        //参数数组

@property (nonatomic,strong) UICollectionView *chooseSendCollectionView; //影像视图

@property (nonatomic,strong) UIImagePickerController *picker;

@property (nonatomic,strong) NSMutableArray <NSArray *>*twoLevelImageTypes; //二级小类的影像列表
@property (nonatomic,strong) UITableView *selectTwoLevelImageTypeTableView;//供选择的tableView
@property (nonatomic,strong) UIView *baseView;            //背景View

@end

@implementation ChooseSendImageViewController
{
    CheckMsgQtyx *_selectType;    //当前选择的影像类型
    
    NSUInteger _chooseHttpCount;  //上传多张影像的时候上传到了第几张
    
    NSString *_fileName;          //文件名
}

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"更多影像信息";
    
    _imageBodys = [[NSMutableDictionary alloc] init];
    _imageDatas = [[NSMutableArray alloc] init];
    _parms = [[NSMutableArray alloc] init];
    _twoLevelImageTypes = [[NSMutableArray alloc] init];
    
    [self setNavi];
    
    [self initChooseSendCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //请求所有已经上传的影像信息
    [self requestHasUpImage];
}

#pragma mark - 初始化视图
- (void)initChooseSendCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(128*scaleAdapter, 155*scaleAdapter);
    layout.footerReferenceSize = CGSizeMake(DeviceWidth, 110*scaleAdapter);
    layout.headerReferenceSize = CGSizeMake(DeviceWidth, 40);
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    
    _chooseSendCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,DeviceWidth, DeviceHeight-64) collectionViewLayout:layout];
    
    _chooseSendCollectionView.dataSource = self;
    _chooseSendCollectionView.delegate = self;
    _chooseSendCollectionView.showsVerticalScrollIndicator = YES;
    _chooseSendCollectionView.backgroundColor = [UIColor whiteColor];
    [_chooseSendCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"lucky"];
    [_chooseSendCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_chooseSendCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:_chooseSendCollectionView];
}
//设置导航
- (void)setNavi
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSelectTwoLevelImageTypesTableView
{
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,DeviceWidth , DeviceHeight-64)];
    _baseView.backgroundColor  = UIColorFromRGB(0x7f7f7f, 0.8);
    [self.view addSubview:_baseView];
    
    _selectTwoLevelImageTypeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, DeviceHeight-40*(_twoLevelImageTypes[0].count+_twoLevelImageTypes[1].count)-64, DeviceWidth, 40*(_twoLevelImageTypes[0].count+_twoLevelImageTypes[1].count)+1) style:UITableViewStylePlain];
    _selectTwoLevelImageTypeTableView.dataSource = self;
    _selectTwoLevelImageTypeTableView.delegate = self;
    _selectTwoLevelImageTypeTableView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [_baseView addSubview:_selectTwoLevelImageTypeTableView];
}

#pragma mark - collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.chooseSendTypeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lucky" forIndexPath:indexPath];
    
    for (UIView *sub in cell.contentView.subviews)
    {
        [sub removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 128*scaleAdapter, 83*scaleAdapter)];
    imageView.backgroundColor = UIColorFromRGB(0xf1f1f1, 1.0);
    [cell.contentView addSubview:imageView];
    
    UILabel *numLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, 83*scaleAdapter)];
    numLab.font = [UIFont appFontRegularOfSize:50*scaleAdapter];
    numLab.textAlignment = NSTextAlignmentCenter;
    numLab.backgroundColor  =  UIColorFromRGB(0x000000, 0.6);
    numLab.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:numLab];
    
    
    UILabel *titleLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 100*scaleAdapter, 128*scaleAdapter, 50*scaleAdapter)];
    titleLab.numberOfLines = 0;
    titleLab.text = self.chooseSendTypeArray[indexPath.row].docDesc;
    titleLab.font = [UIFont appFontRegularOfSize:15];
    titleLab.textColor = UIColorFromRGB(0x858585, 1.0);
    titleLab.textAlignment  =NSTextAlignmentCenter;
    [cell.contentView addSubview:titleLab];
    
    PortraitBody *body = [_imageBodys objectForKey:self.chooseSendTypeArray[indexPath.row].docCde];
    if(body)
    {
        if (body.ID)
        {
            NSData *tempData =(NSData *)[[AppDelegate delegate].imagePutCache objectForKey:ImageUrl(body.ID)];
            
            if (tempData)
            {
                imageView.image = [UIImage imageWithData:tempData];
            }else
            {
                [imageView yy_setImageWithURL:[NSURL URLWithString:ImageUrl(body.ID)] placeholder:[UIImage imageNamed:@"加载展位图"] options:YYWebImageOptionIgnoreDiskCache | YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    
                    [[AppDelegate delegate].imagePutCache setObject:UIImageJPEGRepresentation(image, 0.6) forKey:url.absoluteString];
                }];
            }
        }else
        {
            imageView.image = [UIImage imageNamed:@"默认照片"];
        }
        
        if(body.count == 0)
        {
            numLab.hidden = YES;
        }else
        {
            numLab.text = [NSString stringWithFormat:@"%ld",(long)body.count];
        }
    }else
    {
        imageView.image = [UIImage imageNamed:@"默认照片"];
        numLab.text = @"0";
        numLab.hidden = YES;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        for (UIView *sub in view.subviews)
        {
            [sub removeFromSuperview];
        }
        
        //标题
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30*scaleAdapter, 10, view.frame.size.width-30*scaleAdapter, 18*scaleAdapter)];
        titleLab.font = [UIFont appFontRegularOfSize:13];
        titleLab.textColor = UIColorFromRGB(0x028ce5, 1.0);
        if(_isFromTE)
        {
            titleLab.text = @"选传影像(上传更多的影像可获取更多额度)";
        }else
        {
            titleLab.text = @"选传影像";
        }
        [view addSubview:titleLab];
        view.backgroundColor = [UIColor whiteColor];
        
        return view;
    }else
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        for (UIView *sub in view.subviews)
        {
            [sub removeFromSuperview];
        }
        
        view.backgroundColor = [UIColor whiteColor];
        
        //提示信息
        UILabel *warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 20)];
        warnLabel.text = @"请保证照片上的信息清晰可见";
        warnLabel.font = [UIFont appFontRegularOfSize:12];
        warnLabel.textColor = UIColorFromRGB(0xc6c6c6, 1.0);
        warnLabel.backgroundColor = [UIColor whiteColor];
        warnLabel.numberOfLines = 0;
        warnLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:warnLabel];
        
        UIView *light =[[UIView alloc]initWithFrame:CGRectMake(0, 20, DeviceWidth, 45-20*scaleAdapter)];
        light.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
        [view addSubview:light];
        
        UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(10,45*scaleAdapter, DeviceWidth-20, 45*scaleAdapter)];
        [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        nextButton.titleLabel.font = [UIFont appFontRegularOfSize:18];
        nextButton.backgroundColor = UIColorFromRGB(0x028ce5, 1.0);
        nextButton.layer.cornerRadius = 3.0;
        [nextButton addTarget:self action:@selector(buildNextAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:nextButton];
        
        return view;
    }
    
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20*scaleAdapter, 0, 20*scaleAdapter);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(![_imageBodys objectForKey:self.chooseSendTypeArray[indexPath.row].docCde])
    {
        //记录当前选择要上传的影像类型
        _selectType = self.chooseSendTypeArray[indexPath.row];
    
        [self showActionSheet];
        
    }else
    {
        //去展示影像的页面
        //去影像展示页面
        CompileImageViewController *comVc = [[CompileImageViewController alloc]init];
        UpImageTypeBody *model = [[UpImageTypeBody alloc]init];
        model.docCde = self.chooseSendTypeArray[indexPath.row].docCde;
        model.docDesc = self.chooseSendTypeArray[indexPath.row].docDesc;
        comVc.imageType = model;
        if (_isFromTE) {
            comVc.flowName = @"fromMoney";
        }else{
            comVc.flowName = @"fromPersonData";
        }
        comVc.selectCount = [NSString stringWithFormat:@"%ld",(long)((PortraitBody *)[_imageBodys objectForKey:self.chooseSendTypeArray[indexPath.row].docCde]).count];
        
        [self.navigationController pushViewController:comVc animated:YES];
    }
}

#pragma mark - tableView 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _twoLevelImageTypes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _twoLevelImageTypes[section];
    
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kiss"];
    
    if (cell == nil)
    {
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
    
    NSArray *array = _twoLevelImageTypes[indexPath.section];
    
    SelectNameBody *body = array[indexPath.row];
    lab.text = body.docDesc;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        _baseView.hidden = YES;
    }else
    {
        [self showActionSheet];
        _baseView.hidden = YES;
    }
}

#pragma mark - 创建网络请求
//请求已经上传的所有照片
- (void)requestHasUpImage
{
    [BSVKHttpClient shareInstance].delegate = self;
    
    if(_isFromTE)
    {
        if(self.firstMentionQuote)
        {
            [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/getTeAttachSearchPerson" requestArgument:@{@"custNo":StringOrNull([AppDelegate delegate].userInfo.custNum)} requestTag:21 requestClass:NSStringFromClass([self class])];
        }else
        {
            [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/getTeAttachSearchPerson" requestArgument:@{@"custNo":StringOrNull([AppDelegate delegate].userInfo.custNum),@"applSeq":StringOrNull([AppDelegate delegate].userInfo.applSeq)} requestTag:21 requestClass:NSStringFromClass([self class])];
        }
    }else
    {
        [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/attachSearchPerson" requestArgument:@{@"custNo":StringOrNull([AppDelegate delegate].userInfo.custNum)} requestTag:21 requestClass:NSStringFromClass([self class])];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//上传多张图片的方法
- (void)uploadMultiplePictures
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    if (_isFromTE)
    {
        [client puFileIndex:@"app/appserver/attachUploadPersonByGetEd" requestArgument:_parms[_chooseHttpCount] fileData:_imageDatas[_chooseHttpCount] fileName:_fileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:300+_chooseHttpCount arrIndex:_chooseHttpCount requestClass:NSStringFromClass([self class])];
    }else
    {
        [client puFileIndex:@"app/appserver/attachUploadPerson" requestArgument:_parms[_chooseHttpCount] fileData:_imageDatas[_chooseHttpCount] fileName:_fileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:300+_chooseHttpCount arrIndex:_chooseHttpCount requestClass:NSStringFromClass([self class])];
    }
}

//请求影像类型的小类
- (void)getTwoLevelImageTypeList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    [parm setObject:StringOrNull(_selectType.docCde) forKey:@"docCde"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/cmis/typImagesList" requestArgument:parm requestTag:400 requestClass:NSStringFromClass([self class])];
}

#pragma mark - private methods
- (void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择一张照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取",nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark - ActionsheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self buildCamera];
    }else if (buttonIndex == 1)
    {
        [self buildPhoto];
    }
}

//调用拍照功能
-(void)buildCamera
{
    if (![DefineSystemTool isGetCameraPermission]) {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"你还未开启相机权限，请前往设置中心开启" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 1)
                {
                    [strongSelf toCamera];
                }
            }
        }];
        return;
    }
    
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

//去相册
- (void)buildPhoto
{
    if (![DefineSystemTool isGetPhotoPermission])
    {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"你还未开启相册权限，请前往设置中心开启" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 1)
                {
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
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x028ce5, 1.0)];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

//去手机通用->设置->相机
- (void)toCamera
{
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysVer >= 10.0)
    {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication]openURL:url];
        }
        
    }else
    {
        NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
        
        if ([[UIApplication sharedApplication]canOpenURL:url])
        {
            
            [[UIApplication sharedApplication]openURL:url];
        }
        
    }
}

//手机通用->设置->相册
- (void)toPhoto
{
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysVer >= 10.0) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
        }
        
    }else{
        
        NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
        
        if ([[UIApplication sharedApplication]canOpenURL:url])
        {
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}

#pragma mark - 系统相机的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
 
    WEAKSELF
    [self dismissViewControllerAnimated:YES completion:^{
       STRONGSELF
        
        if (strongSelf) {
          
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            
            if (image) {
             
                [strongSelf didFinishPickingImage:image];
                
            }else{
                
                [strongSelf buildHeadError:@"图片获取失败，请重新拍照"];
                
            }
            
            
            
        }
        
        
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFinishPickingImage:(UIImage *)image
{
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc]init];
    
    NSData *data = UIImageJPEGRepresentation(image, ImageUpZScale);
    
    NSString *strm = [DefineSystemTool md5StringWithData:data];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",_selectType.docCde];
    
    if (dele.userInfo.custNum && dele.userInfo.custNum.length > 0)
    {
        [parmDic setObject:dele.userInfo.custNum forKey:@"custNo"];
    }
    
    if (_selectType.docCde && _selectType.docCde.length > 0)
    {
        [parmDic setObject:_selectType.docCde forKey:@"attachType"];
    }
    
    if (_selectType.docDesc && _selectType.docDesc.length > 0)
    {
        [parmDic setObject:_selectType.docDesc forKey:@"attachName"];
    }
    
    if (strm && strm.length > 0)
    {
        [parmDic setObject:strm forKey:@"md5"];
    }
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (_isFromTE) {
        [parmDic setObject:@"" forKey:@"commonCustNo"];
        [client puFileIndex:@"app/appserver/attachUploadPersonByGetEd" requestArgument:parmDic fileData:data fileName:fileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:250 arrIndex:0 requestClass:NSStringFromClass([self class])];
        
    }else{
        
        [parmDic setObject:@"" forKey:@"commonCustNo"];
        [client puFileIndex:@"app/appserver/attachUploadPerson" requestArgument:parmDic fileData:data fileName:fileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:250 arrIndex:0 requestClass:NSStringFromClass([self class])];
    }
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    [_imageDatas removeAllObjects];
    [_parms removeAllObjects];
    
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _fileName = [NSString stringWithFormat:@"%@.jpg",_selectType.docCde];
    
    if (assets.count>0)
    {
        for (JKAssets *kiss in assets)
        {
            NSMutableDictionary *parmDic = [[NSMutableDictionary alloc]init];
            
            NSData *data = UIImageJPEGRepresentation(kiss.photo, ImageUpZScale);
            
            NSString *strm = [DefineSystemTool md5StringWithData:data];
            
            if (dele.userInfo.custNum && dele.userInfo.custNum.length > 0)
            {
                [parmDic setObject:dele.userInfo.custNum forKey:@"custNo"];
            }
            
            if (_selectType.docCde && _selectType.docCde.length > 0)
            {
                [parmDic setObject:_selectType.docCde forKey:@"attachType"];
            }
            
            if (_selectType.docDesc && _selectType.docDesc.length > 0)
            {
                [parmDic setObject:_selectType.docDesc forKey:@"attachName"];
            }
            
            if (strm && strm.length > 0)
            {
                [parmDic setObject:strm forKey:@"md5"];
            }
            
            [parmDic setObject:@"" forKey:@"commonCustNo"];
            
            [_parms addObject:parmDic];
            
            [_imageDatas addObject:data];
        }
        
        _chooseHttpCount = 0;
        
        //开始上传
        [self uploadMultiplePictures];
    }
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}


- (void)buildNextAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BSVKDelagate
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className
{
    [MBProgressHUD hideHUDForView: self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
        if (requestTag == 21)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //已传影像
            PortraitImageModel *model = [PortraitImageModel mj_objectWithKeyValues:responseObject];
            //解析
            [self analysisPortraitImageModel:model];
        }
        else if (requestTag == 400)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            SelectNameModel *model = [SelectNameModel mj_objectWithKeyValues:responseObject];
            //解析二级小类
            [self analysisSelectNameModel:model];
        }
    }
}

- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
        if(httpCode != 0)
        {
            [self buildHeadError:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode]];
        }
        else
        {
            [self buildHeadError:@"网络环境异常，请检查网络并重试"];
        }
    }
}

- (void)requestSucessWithParam:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className withParam:(NSDictionary *)dict
{
    
    [MBProgressHUD hideHUDForView: self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
        if (requestTag == 250)
        {
            [MBProgressHUD hideHUDForView: self.view animated:YES];
            
            PostSuccessModel *model = [PostSuccessModel mj_objectWithKeyValues:responseObject];
            //上传单张影像model解析
            [self analysisPostSuccessModel:model];
        }else if (requestTag == 300+_chooseHttpCount)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            PostSuccessModel *model = [PostSuccessModel mj_objectWithKeyValues:responseObject];
            //上传多张影像model
            [self analysisUpLoadMoreThanOnePostSuccessModel:model];
        }
    }
}

-(void)requestFailWithParam:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className withParam:(NSDictionary *)dict{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
       if(requestTag == 250)
       {
           [self buildHeadError:@"上传失败"];
       }
    }
}

//连接服务器成功后，返回的报文头信息
- (void)buildHeadError:(NSString *)error
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                
            }
        }
    }];
}

#pragma mark - model解析
//解析所有影像的model
- (void)analysisPortraitImageModel:(PortraitImageModel *)model
{
    if ([model.head.retFlag isEqualToString:SucessCode])
    {
        //先清空已有的数据
        [_imageBodys removeAllObjects];
        
        for(PortraitBody *body in model.body)
        {
            for(CheckMsgQtyx *imageBody in self.chooseSendTypeArray)
            {
                if([body.attachType isEqualToString:imageBody.docCde])
                {
                    //这是已经上传的必传影像
                    [_imageBodys setObject:body forKey:imageBody.docCde];
                }
            }
        }
        
        [_chooseSendCollectionView reloadData];
    }else
    {
        [self buildHeadError:model.head.retMsg];
    }
}

//解析影像二级小类
- (void)analysisSelectNameModel:(SelectNameModel *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"])
    {
        [_twoLevelImageTypes removeAllObjects];
        
        if (model.body.count > 0)
        {
            NSArray *array = [NSArray arrayWithArray:model.body];
            
            [_twoLevelImageTypes addObject:array];
            
            SelectNameBody *body = [[SelectNameBody alloc]init];
            body.docDesc = @"取消";
            
            [_twoLevelImageTypes addObject:@[body]];
            
            if(_baseView && _baseView.hidden == YES)
            {
                _baseView.hidden = NO;
                [_selectTwoLevelImageTypeTableView reloadData];
            }else
            {
                [self createSelectTwoLevelImageTypesTableView];
            }
        }else
        {
            [self showActionSheet];
        }
    }else
    {
        [self buildHeadError:model.head.retMsg];
    }
}

//解析上传影像
- (void)analysisPostSuccessModel:(PostSuccessModel *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"])
    {
        //刷新数据
        [self requestHasUpImage];
    }else
    {
        [self buildHeadError:model.head.retMsg];
    }
}

//解析上传多张影像的model
- (void)analysisUpLoadMoreThanOnePostSuccessModel:(PostSuccessModel *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"])
    {
        NSData *data = _imageDatas[_chooseHttpCount];
        NSString *url = [NSString stringWithFormat:@"%ld",(long)model.body.ID];
        [[AppDelegate delegate].imagePutCache setObject:data forKey:ImageUrl(url)];
    }else
    {
        [self buildHeadError:[NSString stringWithFormat:@"第%ld张图片上传失败",(long)_chooseHttpCount+1]];
    }
    
    _chooseHttpCount++;
    
    if (_chooseHttpCount >= _parms.count)
    {
        //刷新数据
        [self requestHasUpImage];
    }
    else
    {
        //继续上传
        [self uploadMultiplePictures];
    }
}
@end
