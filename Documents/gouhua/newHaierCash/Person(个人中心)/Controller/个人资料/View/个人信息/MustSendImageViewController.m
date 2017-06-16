//
//  MustSendImageViewController.m
//  personMerchants
//
//  Created by LLM on 16/11/26.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "MustSendImageViewController.h"
#import "JKImagePickerController.h"
#import "CompileImageViewController.h"
//#import "SCCaptureCameraController.h"
#import "BSVKHttpClient.h"
#import "HCMacro.h"
#import "ChooseNameModel.h"
#import "AppDelegate.h"
#import "UIFont+AppFont.h"
#import "PortraitImageModel.h"
#import "DefineSystemTool.h"
#import "PostSuccessModel.h"
#import "SelectNameModel.h"
#import <MBProgressHUD.h>
#import "RMUniversalAlert.h"
#import <YYWebImage.h>

@interface MustSendImageViewController ()<BSVKHttpClientDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,JKImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic,strong) UICollectionView *mustSendCollectionView; //照片视图

@property (nonatomic,strong) NSMutableDictionary *imageBodys;     //存储已经上传的必传影像

@property (nonatomic,strong) NSMutableArray *imageDatas;   //上传多张的时候所有图片数组
@property (nonatomic,strong) NSMutableArray *parms;        //参数数组

@property (nonatomic,strong) UIImagePickerController *picker;

@property (nonatomic,strong) NSMutableArray <NSArray *>*twoLevelImageTypes; //二级小类的影像列表
@property (nonatomic,strong) UITableView *selectTwoLevelImageTypeTableView;//供选择的tableView
@property (nonatomic,strong) UIView *baseView;            //背景View

@end

@implementation MustSendImageViewController
{
    NSData *_saveSureData;      //临时存储上传的图片数据
    
    CheckMsgList *_selectType;  //当前选择要上传影像类型
    
    NSUInteger _mustHttpCount;  //上传多张影像的时候上传到了第几张
}

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"必传影像";
    
    _imageBodys = [[NSMutableDictionary alloc] init];
    _imageDatas = [[NSMutableArray alloc] init];
    _parms = [[NSMutableArray alloc] init];
    _twoLevelImageTypes = [[NSMutableArray alloc] init];
    
    [self setNavi];
    
    [self initMustSendCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //请求所有已经上传的影像信息
    [self requestHasUpImage];
}

#pragma mark - 初始化视图
- (void)initMustSendCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(128*scaleAdapter, 155*scaleAdapter);
    layout.footerReferenceSize = CGSizeMake(DeviceWidth, 110*scaleAdapter);
    layout.headerReferenceSize = CGSizeMake(DeviceWidth, 40);
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    
    _mustSendCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,DeviceWidth, DeviceHeight-64) collectionViewLayout:layout];
    
    _mustSendCollectionView.dataSource = self;
    _mustSendCollectionView.delegate = self;
    _mustSendCollectionView.showsVerticalScrollIndicator = YES;
    _mustSendCollectionView.backgroundColor = [UIColor whiteColor];
    [_mustSendCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"lucky"];
    [_mustSendCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_mustSendCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:_mustSendCollectionView];
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
#pragma mark - 点击事件
- (void)OnBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

//返回上一个页面
- (void)buildNextAction:(UIButton *)btn
{
    if(!_imageBodys || _imageBodys.count != self.mustSendTypeArray.count)
    {
        [self buildHeadError:@"请上传所有必传影像"];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 创建网络请求
//请求所有图片
- (void)requestHasUpImage
{
    [BSVKHttpClient shareInstance].delegate = self;
    
    if(_ifFromTE)
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

//如果之前是有图片的先删除在上传
- (void)upLoadImageAfterDeleteOidImageWithImage:(UIImage *)newImage
{
    PortraitBody *body = [_imageBodys objectForKey:_selectType.docCde];
    
    if(_ifFromTE)
    {
        //如果是提额,先删除再上传
        [BSVKHttpClient shareInstance].delegate = self;
        
        NSString *url = [NSString stringWithFormat:@"app/appserver/attachDeletePerson?id=%@",body.ID];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[BSVKHttpClient shareInstance]deleteInfo:url requestArgument:nil requestTag:102 requestClass:NSStringFromClass([self class])];
    }else
    {
        NSString *strFileName = [NSString stringWithFormat:@"%@.jpg",body.attachName];
        
        NSData *imageData = UIImageJPEGRepresentation(newImage, ImageUpZScale);
        NSString *strMd5 = [DefineSystemTool md5StringWithData:imageData];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [BSVKHttpClient shareInstance].delegate = self;
        
        NSMutableDictionary * parmDic = [NSMutableDictionary dictionary];
        
        [parmDic  setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
        [parmDic setObject:body.attachType forKey:@"attachType"];
        [parmDic setObject:body.attachName forKey:@"attachName"];
        [parmDic setObject:strMd5 forKey:@"md5"];
        [parmDic setObject:@"" forKey:@"commonCustNo"];
        [parmDic setObject:body.ID forKey:@"id"];
        [[BSVKHttpClient shareInstance] puFile:@"app/appserver/attachUploadPerson" requestArgument:parmDic fileData:imageData fileName:strFileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:101 requestClass:NSStringFromClass([self class])];
    }
}

//上传图片
- (void)upLoadImage:(UIImage *)newImage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, ImageUpZScale);
    NSString *strMd5 = [DefineSystemTool md5StringWithData:imageData];
    NSString *strFileName = [NSString stringWithFormat:@"%@.jpg",_selectType.docDesc];
    
    NSString * url = [NSString string];
    NSMutableDictionary * parmDic = [NSMutableDictionary dictionary];
    if (_ifFromTE)
    {
        url = @"app/appserver/attachUploadPersonByGetEd";
        [parmDic  setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
        [parmDic setObject:_selectType.docCde forKey:@"attachType"];
        [parmDic setObject:_selectType.docDesc forKey:@"attachName"];
        [parmDic setObject:strMd5 forKey:@"md5"];
        [parmDic setObject:@"" forKey:@"commonCustNo"];
        
    }else{
        
        url = @"app/appserver/attachUploadPerson";
        [parmDic  setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
        [parmDic setObject:_selectType.docCde forKey:@"attachType"];
        [parmDic setObject:_selectType.docDesc forKey:@"attachName"];
        [parmDic setObject:strMd5 forKey:@"md5"];
        [parmDic setObject:@"" forKey:@"commonCustNo"];
        
    }
    [[BSVKHttpClient shareInstance] puFile:url requestArgument: parmDic fileData:imageData fileName:strFileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:101 requestClass:NSStringFromClass([self class])];
}

//上传多张
- (void)upLoadImageMoreThanOne
{
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",_selectType.docCde];
    
    NSMutableDictionary *parm = _parms[_mustHttpCount];
    
    NSData *data = _imageDatas[_mustHttpCount];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (_ifFromTE)
    {
        [client puFileIndex:@"app/appserver/attachUploadPersonByGetEd" requestArgument:parm fileData:data fileName:fileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:400+_mustHttpCount arrIndex:_mustHttpCount requestClass:NSStringFromClass([self class])];
    }else
    {
        [client puFileIndex:@"app/appserver/attachUploadPerson" requestArgument:parm fileData:data fileName:fileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:400+_mustHttpCount arrIndex:_mustHttpCount requestClass:NSStringFromClass([self class])];
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
        else if(requestTag == 101)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            PostSuccessModel *model = [PostSuccessModel mj_objectWithKeyValues:responseObject];
            //解析
            [self analysisPostSuccessModel:model];
        }
        else if (requestTag == 102)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            PostSuccessModel *model = [PostSuccessModel mj_objectWithKeyValues:responseObject];
            //提额先删除再上传
            [self analysisTePostSuccessModel:model];
        }
        else if (requestTag == 400)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            SelectNameModel *model = [SelectNameModel mj_objectWithKeyValues:responseObject];
            //解析二级影像model
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
        if(requestTag == 400+_mustHttpCount)
        {
            [MBProgressHUD hideHUDForView: self.view animated:YES];
            PostSuccessModel *model = [PostSuccessModel mj_objectWithKeyValues:responseObject];
            
            if ([model.head.retFlag isEqualToString:@"00000"])
            {
                NSData *data = _imageDatas[_mustHttpCount];
                
                NSString *url = [NSString stringWithFormat:@"%ld",(long)model.body.ID];
                
                [[AppDelegate delegate].imagePutCache setObject:data forKey:ImageUrl(url)];
                
                
            }else
            {
                [self buildHeadError:[NSString stringWithFormat:@"第%ld张图片上传失败,原因:%@",(long)_mustHttpCount+1,model.head.retMsg]];
            }
            
            _mustHttpCount++;
            
            if (_mustHttpCount >= _parms.count)
            {
                //上传完成刷新数据
                [self requestHasUpImage];
            }else
            {
                //继续上传
                [self upLoadImageMoreThanOne];
            }
        }
    }
}

-(void)requestFailWithParam:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className withParam:(NSDictionary *)dict{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
        if (requestTag == 400+_mustHttpCount || requestTag == 250) {
            
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
- (void)analysisPortraitImageModel:(PortraitImageModel *)model
{
    if ([model.head.retFlag isEqualToString:SucessCode])
    {
        //先清空已有的数据
        [_imageBodys removeAllObjects];
        
        for(PortraitBody *body in model.body)
        {
            for(CheckMsgList *imageBody in self.mustSendTypeArray)
            {
                if([body.attachType isEqualToString:imageBody.docCde])
                {
                    //这是已经上传的必传影像
                    [_imageBodys setObject:body forKey:imageBody.docCde];
                }
            }
        }
        
        [_mustSendCollectionView reloadData];
    }else
    {
        [self buildHeadError:model.head.retMsg];
    }
}

//影像上传成功model
- (void)analysisPostSuccessModel:(PostSuccessModel *)model
{
    if ([model.head.retFlag isEqualToString:SucessCode])
    {
        [[AppDelegate delegate].imagePutCache setObject:_saveSureData forKey:ImageUrl(model.body.ID)];
        
        //刷新
        [self requestHasUpImage];
        
    }else
    {
        [self buildHeadError:model.head.retMsg];
    }
    _saveSureData = nil;
}

//提额先删除影像的model
- (void)analysisTePostSuccessModel:(PostSuccessModel *)model
{
    if ([model.head.retFlag isEqualToString:SucessCode])
    {
        PortraitBody *body = [_imageBodys objectForKey:_selectType.docCde];
        
        NSString *strMd5 = [DefineSystemTool md5StringWithData:_saveSureData];
        
        NSString *strFileName = [NSString stringWithFormat:@"%@.jpg",body.attachName];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [BSVKHttpClient shareInstance].delegate = self;
        
        NSMutableDictionary * parmDic = [NSMutableDictionary dictionary];
        if (_ifFromTE) {//app/appserver/attachUploadPersonByGetEd
            [parmDic  setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
            [parmDic setObject:body.attachType forKey:@"attachType"];
            [parmDic setObject:body.attachName forKey:@"attachName"];
            [parmDic setObject:strMd5 forKey:@"md5"];
            [parmDic setObject:@"" forKey:@"commonCustNo"];
            [[BSVKHttpClient shareInstance] puFile:@"app/appserver/attachUploadPersonByGetEd" requestArgument: parmDic fileData:_saveSureData fileName:strFileName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:101 requestClass:NSStringFromClass([self class])];
        }
    }else {
        [self buildHeadError:@"操作失败"];
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

#pragma mark - collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.mustSendTypeArray.count;
    
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
    if ([self.mustSendTypeArray[indexPath.row].docDesc isEqualToString:@"身份证正面"] ||[self.mustSendTypeArray[indexPath.row].docDesc isEqualToString:@"身份证反面"])
    {
        numLab.hidden = YES;
    }
    
    numLab.font = [UIFont appFontRegularOfSize:50*scaleAdapter];
    numLab.textAlignment = NSTextAlignmentCenter;
    numLab.backgroundColor  =  UIColorFromRGB(0x000000, 0.6);
    numLab.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:numLab];
    
    
    UILabel *titleLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 100*scaleAdapter, 128*scaleAdapter, 50*scaleAdapter)];
    titleLab.numberOfLines = 0;
    titleLab.text = self.mustSendTypeArray[indexPath.row].docDesc;
    titleLab.font = [UIFont appFontRegularOfSize:15];
    titleLab.textColor = UIColorFromRGB(0x858585, 1.0);
    titleLab.textAlignment  =NSTextAlignmentCenter;
    [cell.contentView addSubview:titleLab];
    
    PortraitBody *body = [_imageBodys objectForKey:self.mustSendTypeArray[indexPath.row].docCde];
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
        titleLab.textColor = UIColorFromRGB(0x535353, 1.0);
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"必传影像"];
        [string addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x028ce5, 1.0),NSFontAttributeName:[UIFont appFontRegularOfSize:16]} range:NSMakeRange(0, 4)];
        titleLab.attributedText = string;
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
        warnLabel.text = @"请保证身份证上的信息清晰可见";
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
    if([self.mustSendTypeArray[indexPath.row].docDesc isEqualToString:@"身份证正面"] || [self.mustSendTypeArray[indexPath.row].docDesc isEqualToString:@"身份证反面"])
    {
        //记录当前选择要上传的影像类型
        _selectType = self.mustSendTypeArray[indexPath.row];
        
        [self scanning];
    }else
    {
        if(![_imageBodys objectForKey:self.mustSendTypeArray[indexPath.row].docCde])
        {
            //记录当前选择要上传的影像类型
            _selectType = self.mustSendTypeArray[indexPath.row];
            
           [self showActionSheet];
            
        }else
        {
            //去展示影像的页面
            //去影像展示页面
            CompileImageViewController *comVc = [[CompileImageViewController alloc]init];
            UpImageTypeBody *model = [[UpImageTypeBody alloc]init];
            model.docCde = self.mustSendTypeArray[indexPath.row].docCde;
            model.docDesc = self.mustSendTypeArray[indexPath.row].docDesc;
            comVc.imageType = model;
            if (_ifFromTE) {
                comVc.flowName = @"fromMoney";
            }else{
                comVc.flowName = @"fromPersonData";
            }
            comVc.selectCount = self.mustSendTypeArray[indexPath.row].countMaterial;
            
            [self.navigationController pushViewController:comVc animated:YES];
        }
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

#pragma mark - private methods
- (void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择一张照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取",nil];
    
    [actionSheet showInView:self.view];
}

- (void)scanning
{
//    SCCaptureCameraController *con = [[SCCaptureCameraController alloc] init];
//    con.scNaigationDelegate = self;
//    con.iCardType = TIDCARD2;
//    [self presentViewController:con animated:YES completion:NULL];
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
    
    if([_selectType.docDesc isEqualToString:@"身份证正面"] || [_selectType.docDesc isEqualToString:@"身份证反面"])
    {
        imagePickerController.maximumNumberOfSelection = 1;
    }else
    {
        imagePickerController.maximumNumberOfSelection = 10;
    }
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
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self didFinishPickingImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFinishPickingImage:(UIImage *)image
{
    _saveSureData = UIImageJPEGRepresentation(image,ImageLocalScale);
    
    //如果之前已经有图片了
    if([_imageBodys objectForKey:_selectType.docCde])
    {
        //先删除再上传
        [self upLoadImageAfterDeleteOidImageWithImage:image];
    }else
    {
        //直接上传
        [self upLoadImage:image];
    }
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    if (assets.count != 0)
    {
        if([_selectType.docDesc isEqualToString:@"身份证正面"] || [_selectType.docDesc isEqualToString:@"身份证反面"])
        {
            JKAssets *asset = assets[0];
            
            if (asset.photo)
            {
                _saveSureData = UIImageJPEGRepresentation(asset.photo,ImageLocalScale);
                //如果之前已经有图片了
                if([_imageBodys objectForKey:_selectType.docCde])
                {
                    //先删除再上传
                    [self upLoadImageAfterDeleteOidImageWithImage:asset.photo];
                }
                else
                {
                    //直接上传
                    [self upLoadImage:asset.photo];
                }
            }
        }
        else
        {
            [_imageDatas removeAllObjects];
            [_parms removeAllObjects];
            
            for(JKAssets *asset in assets)
            {
                NSData *data = UIImageJPEGRepresentation(asset.photo, ImageUpZScale);
                NSString *md5 = [DefineSystemTool md5StringWithData:data];
                
                NSMutableDictionary *parmDic = [[NSMutableDictionary alloc]init];
                [parmDic setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
                [parmDic setObject:StringOrNull(_selectType.docCde) forKey:@"attachType"];
                [parmDic setObject:StringOrNull(_selectType.docDesc) forKey:@"attachName"];
                [parmDic setObject:md5 forKey:@"md5"];
                [parmDic setObject:@"" forKey:@"commonCustNo"];
                
                [_imageDatas addObject:data];
                [_parms addObject:parmDic];
            }
            
            _mustHttpCount = 0;
            
            //上传多张
            [self upLoadImageMoreThanOne];
            
        }
    }
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SCNavigationControllerDelegate



@end
