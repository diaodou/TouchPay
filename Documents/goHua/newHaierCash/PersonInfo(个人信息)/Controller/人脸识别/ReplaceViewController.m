//
//  RplaceViewController.m
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/10/27.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "ReplaceViewController.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "ChooseNameModel.h"
#import <MBProgressHUD.h>
#import <YYWebImage.h>
#import "UIButton+UnifiedStyle.h"
#import "PortraitImageModel.h"
#import "CompileImageViewController.h"
#import "RMUniversalAlert.h"
#import "LMSTakePhotoController.h"
#import "SelectNameModel.h"
#import "DefineSystemTool.h"
#import "PostSuccessModel.h"
#import "SpecialButton.h"
#import "UpImagesTypes.h"
#import "UIImagePickControllerSelf.h"
#import "UnlockAccountViewController.h"

@interface ReplaceViewController ()<BSVKHttpClientDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SendImageDelegate,LMSTakePhotoControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

{
    
    UICollectionView *_imageCollectionView;//照片视图
    
    NSMutableDictionary *_sendIamgeDictory;//已上传的影像数据字典
    
    NSMutableArray *_selectNameArray;//影像小类名称数组
    
    NSMutableArray *_imageDataArray;//保存当前图片上传数据数组
    
    NSInteger _nowCount;
    
    NSString *_cardIdSring;//记录照片id
    
    NSString *_nowSelectName;//记录照片类型
    
    UIView *_lightView;//笼罩视图
    
    UILabel *_warnLabel;//警告信息
    
    UIButton *_nextButton;//确定按钮
    
    UIImagePickerController *_picker;
    
    float x;
    
}
@property (nonatomic, strong) UIImagePickControllerSelf *controller;

@property(nonatomic,strong)UITableView *selectTable;

@end

@implementation ReplaceViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"替代影像";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    x = DeviceWidth/375.0;
    
    _sendIamgeDictory = [[NSMutableDictionary alloc]init];
    
    [self setNavi];
    
    [self buildGetImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> private Methods

//根据订单号查询已上传的照片
-(void)buildGetImage{
    
    BSVKHttpClient *client  =[BSVKHttpClient shareInstance];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if ([AppDelegate delegate].userInfo.custNum && [AppDelegate delegate].userInfo.custNum.length > 0) {
        
        [parm setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
        
    }
    if ([AppDelegate delegate].userInfo.busFlowName == QuotaApply || [AppDelegate delegate].userInfo.busFlowName == QuotaReturned || _ifFromTE) {
        [parm setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"applSeq"];
    }
    client.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([AppDelegate delegate].userInfo.busFlowName == QuotaApply || [AppDelegate delegate].userInfo.busFlowName == QuotaReturned || _ifFromTE) {
        [client getInfo:@"app/appserver/getTeAttachSearchPerson" requestArgument:parm requestTag:250 requestClass:NSStringFromClass([self class])];
    }
    [client getInfo:@"app/appserver/attachSearchPerson" requestArgument:parm requestTag:250 requestClass:NSStringFromClass([self class])];
    
}

//创建笼罩视图
-(void)creatLightView{
    
    _lightView = [[UIView alloc]initWithFrame:CGRectMake(0, 20,DeviceWidth , DeviceHeight)];
    
    _lightView.backgroundColor  = UIColorFromRGB(0x7f7f7f, 0.8);
    
    _lightView.hidden = YES;
    
    [self.view addSubview:_lightView];
    
    
}


//创建底部视图
-(void)creatBaseView{
    
    //照片视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake(128*x, 155*x);
    
    layout.footerReferenceSize = CGSizeMake(DeviceWidth, 110*x);
    
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    
    _imageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10,DeviceWidth, DeviceHeight-64) collectionViewLayout:layout];
    
    _imageCollectionView.dataSource = self;
    
    _imageCollectionView.delegate = self;
    
    _imageCollectionView.showsVerticalScrollIndicator = YES;
    
    _imageCollectionView.backgroundColor = [UIColor whiteColor];
    
    [_imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"lucky"];
    
    [_imageCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    [self.view addSubview:_imageCollectionView];
    
}

//设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn:(UIButton *)btn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --> event Methods

//调用拍照功能
-(void)buildCamera{
    // 拍照
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]&&[DefineSystemTool isGetCameraPermission]) {
        _controller = [[UIImagePickControllerSelf alloc] init];
        _controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        /*前置摄像头
        if ([self isFrontCameraAvailable]) {
            _controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
         */
        //后置摄像头（这个判断不加也可以，默认也是后置摄像头）
        if ([self isRearCameraAvailable]) {
            _controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        _controller.mediaTypes = mediaTypes;
        _controller.delegate = self;
        [self presentViewController:_controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }else{
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"你还未开启相机权限，请前往设置中心开启" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 1) {
                    
                    [strongSelf toCamera];
                }
            }
        }];
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
//获取小类影像名称
-(void)buildGetSelectImage:(NSString *)docCde{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if (_typCde && _typCde.length > 0) {
        
        [parm setObject:_typCde forKey:@"typCde"];
        
    }
    
    if (docCde && docCde.length > 0) {
        
        [parm setObject:docCde forKey:@"docCde"];
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/cmis/typImagesList" requestArgument:parm requestTag:406 requestClass:NSStringFromClass([self class])];
    
    
}

//点击确定按钮所执行的方法
-(void)buildNextAction:(UIButton *)sender{
    
    if (_sendIamgeDictory.count >= _imageArray.count) {
        
        [self dismissViewControllerAnimated:NO completion:^{
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            
            [dic setObject:@"pass" forKey:@"face"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FaceSuccessState" object:dic];
        }];
        
        
    }else{
        
        [self buildHeadError:@"请上传所有影像信息"];
        
    }
    
    
}

#pragma mark --> 网络代理方法
//服务器连接成功
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 250){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            PortraitImageModel *model = [PortraitImageModel mj_objectWithKeyValues:responseObject];
            
            if ([model.head.retFlag isEqualToString:@"00000"]) {
                
                if (!_sendIamgeDictory) {
                    
                    _sendIamgeDictory = [[NSMutableDictionary alloc]init];
                    
                }else{
                    
                    [_sendIamgeDictory removeAllObjects];
                    
                }
                
                if (model.body.count > 0) {
                    
                    for (PortraitBody *body in model.body) {
                        
                        for (ChooseNameBody *name in _imageArray) {
                            
                            if ([name.docCde isEqualToString:body.attachType]) {
                                
                                [_sendIamgeDictory setObject:body forKey:body.attachType];
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                [self creatBaseView];
                
                [self creatLightView];
                
            }else{
                
                [self buildHeadError:model.head.retMsg];
                
            }
            
        }else if (requestTag == 406){
            
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
                
                if (_selectNameArray.count > 0) {
                    
                    self.selectTable.hidden = NO;
                    
                    NSArray *jack = _selectNameArray[0];
                    
                    NSInteger rose = jack.count+1;
                    
                    self.selectTable.frame = CGRectMake(0, DeviceHeight-rose*40-15-64, DeviceWidth, 40*rose+15);
                    
                    
                    _lightView.hidden = NO;
                    
                    [self.selectTable reloadData];
                    
                }
                
                
                
            }else{
                
                [self buildHeadError:model.head.retMsg];
                
            }
            
        }
        
    }
    
}

//服务器连接失败
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
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

-(void)putFileSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className arrIndex:(NSInteger)index{
    
        if ([className isEqualToString:NSStringFromClass([self class])]) {
            
            if (requestTag == 380) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                PostSuccessModel *model = [PostSuccessModel mj_objectWithKeyValues:responseObject];
                
                if ([model.head.retFlag isEqualToString:@"00000"]) {
                    
                    NSData *data = _imageDataArray[0];
                    
                    NSString *url = [NSString stringWithFormat:@"%ld",(long)model.body.ID];
                    
                    [[AppDelegate delegate].imagePutCache setObject:data forKey:ImageUrl(url)];
                    
                    [self buildGetImage];
                    
                }else{
                    
                    
                    [self buildHeadError:model.head.retMsg];
                    
                }
                
                
                
            }
            
        }
     }

-(void)putFileFail:(NSInteger)requestTag requestError:(NSError *)error requestClass:(NSString *)className arrIndex:(NSInteger)index{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        
        [self buildHeadError:@"网络环境异常，请检查网络并重试"];
    }
    
    
}

//连接服务器后，返回的报文头信息
-(void)buildHeadError:(NSString *)error{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                
                return ;
                
            }
        }
    }];
    
    
}

#pragma mark --> 拍照后所调用的代理协议

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
   [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (!_imageDataArray) {
        
        _imageDataArray = [[NSMutableArray alloc]init];
        
    }else{
        
        [_imageDataArray removeAllObjects];
        
    }
    
    ChooseNameBody *body = _imageArray[_nowCount];
    
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc]init];
    
    NSData *data = UIImageJPEGRepresentation(image, ImageUpZScale);
    
    if (data && data.length > 0) {
        
        [_imageDataArray addObject:data];
        
        NSString *strm = [DefineSystemTool md5StringWithData:data];
        
        NSString *name = [NSString stringWithFormat:@"%@.jpg",body.docCde];
        
        if (dele.userInfo.custNum && dele.userInfo.custNum.length > 0) {
            
            [parmDic setObject:dele.userInfo.custNum forKey:@"custNo"];
            
        }
        
        if (body.docCde && body.docCde.length > 0) {
            
            [parmDic setObject:body.docCde forKey:@"attachType"];
            
        }
        
        if (body.docDesc && body.docDesc.length > 0) {
            
            [parmDic setObject:body.docDesc forKey:@"attachName"];
            
        }
        
        if (strm && strm.length > 0) {
            
            [parmDic setObject:strm forKey:@"md5"];
            
        }
        
        [parmDic setObject:@"" forKey:@"commonCustNo"];
        
        
        if (_cardIdSring.length > 0 && _cardIdSring) {
            
            [parmDic setObject:_cardIdSring forKey:@"id"];
            
        }
        
        BSVKHttpClient *client = [BSVKHttpClient shareInstance];
        
        client.delegate = self;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if ([AppDelegate delegate].userInfo.busFlowName == QuotaApply || [AppDelegate delegate].userInfo.busFlowName == QuotaReturned || _ifFromTE) {
            
            [client puFileIndex:@"app/appserver/attachUploadPersonByGetEd" requestArgument:parmDic fileData:data fileName:name name:@"multipartFile" mimeType:@"image/jpeg" requestTag:380 arrIndex:1 requestClass:NSStringFromClass([self class])];
        }else{
            
            [client puFileIndex:@"app/appserver/attachUploadPerson" requestArgument:parmDic fileData:data fileName:name name:@"multipartFile" mimeType:@"image/jpeg" requestTag:380 arrIndex:1 requestClass:NSStringFromClass([self class])];
        }
        
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)didFinishPickingImage:(UIImage *)image{
    
   }

#pragma mark --> tableView 代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000005;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 15;
        
    }
    
    return 0.000005;
}

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
        
    }
    
    UILabel *lab = (UILabel *)[cell.contentView viewWithTag:190];
    
    NSArray *array = _selectNameArray[indexPath.section];
    
    SelectNameBody *body = array[indexPath.row];
    
    lab.text = body.docDesc;
    
    SpecialButton *btn = (SpecialButton*)[cell.contentView viewWithTag:101];
    
    btn.storeName = body.docDesc;
    
    return cell;
}


-(void)buildTouchAction:(SpecialButton *)sender{
    
    if ([sender.storeName isEqualToString:@"取消"]) {
        
        self.selectTable.hidden = YES;
        
        _lightView.hidden = YES;
        
    }else{
        
        _lightView.hidden = YES;
        
        self.selectTable.hidden = YES;
        
        [self buildCamera];
        
    }
    
}



#pragma mark --> collectionView的代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _imageArray.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lucky" forIndexPath:indexPath];
    
    for (UIView *sub in cell.contentView.subviews) {
        
        [sub removeFromSuperview];
        
    }
    
    ChooseNameBody *body  =  _imageArray[indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 128*x, 83*x)];
    
    imageView.backgroundColor = UIColorFromRGB(0xf1f1f1, 1.0);
    
    [cell.contentView addSubview:imageView];
    
    UILabel *numLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 20, cell.bounds.size.width, 83*x)];
    
    PortraitBody *imgBody = [_sendIamgeDictory objectForKey:body.docCde];
    
    if (imgBody) {
        
        NSString *url = [NSString stringWithFormat:@"%@",imgBody.ID];
        
        NSData *tempData =(NSData *)[[AppDelegate delegate].imagePutCache objectForKey:ImageUrl(url)];
        
        if (tempData) {
            
            imageView.image = [UIImage imageWithData:tempData];
            
        }else{
            
            [imageView yy_setImageWithURL:[NSURL URLWithString:ImageUrl(url)] placeholder:[UIImage imageNamed:@"加载"] options:YYWebImageOptionIgnoreDiskCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
                [[AppDelegate delegate].imagePutCache setObject:UIImageJPEGRepresentation(image, 0.6) forKey:url.absoluteString];
                
            }];
        }
        
        if ([body.docDesc isEqualToString:@"身份证正面"]||[body.docDesc isEqualToString:@"身份证反面"]) {
            
            numLab.hidden = YES;
            
        }else{
            
            numLab.hidden = NO;
            
            numLab.text = [NSString stringWithFormat:@"%ld",(long)imgBody.count];
        }
        
    }else{
        
        imageView.image = [UIImage imageNamed:@"默认照片"];
        
        numLab.hidden = YES;
        
        
    }
    
    numLab.font = [UIFont appFontRegularOfSize:50*x];
    
    numLab.textAlignment = NSTextAlignmentCenter;
    
    numLab.backgroundColor  =  UIColorFromRGB(0x000000, 0.6);
    
    numLab.textColor = [UIColor whiteColor];
    
    [cell.contentView addSubview:numLab];
    
    
    UILabel *titleLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 100*x, 128*x, 50*x)];
    
    titleLab.numberOfLines = 0;
    
    titleLab.text = body.docDesc;
    
    titleLab.font = [UIFont appFontRegularOfSize:13];
    
    titleLab.textColor = UIColorFromRGB(0x858585, 1.0);
    
    titleLab.textAlignment  =NSTextAlignmentCenter;
    
    [cell.contentView addSubview:titleLab];
    
    
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 20*x, 0, 20*x);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _cardIdSring = @"";
    
    ChooseNameBody *body  =  _imageArray[indexPath.row];
    
    PortraitBody *imgBody = [_sendIamgeDictory objectForKey:body.docCde];
    
    _nowCount = indexPath.row;
    
    if (imgBody) {
        
        if ([body.docDesc isEqualToString:@"身份证正面"]||[body.docDesc isEqualToString:@"身份证反面"]) {
            
            _cardIdSring = imgBody.ID;
            
            [self buildCamera];
            
        }else{
            
            _cardIdSring = @"";
            
            CompileImageViewController *comVc = [[CompileImageViewController alloc]init];
            
            UpImageTypeBody *model = [[UpImageTypeBody alloc]init];
            
            model.docCde = body.docCde;
            
            model.docDesc = body.docDesc;
            
            comVc.imageType = model;
            
            comVc.typCde = _typCde;
            
            if (_ifFromTE) {
                
                comVc.flowName = @"fromMoney";
                
            }
            
            if (_ifFromPerson) {
                comVc.flowName = @"fromPersonalData";
            }
            
            comVc.delegate = self;
            
            comVc.usePhoto = YES;
            
            comVc.selectCount = body.countMaterial;
            
            [self.navigationController pushViewController:comVc animated:YES];
            
            
        }
        
        
        
    }else{
        
        _cardIdSring = @"";
        
        _nowSelectName = body.docDesc;
        
        if ([body.countMaterial integerValue] > 0) {
            
            [self buildGetSelectImage:body.docCde];
            
        }else{
            
            [self buildCamera];
            
        }
        
        
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
    
    
    for (UIView *sub in view.subviews) {
        
        [sub removeFromSuperview];
        
    }
    
    view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    //提示信息
    _warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 20)];
    
    _warnLabel.text = @"请确保照片上的信息清晰可见";
    
    _warnLabel.font = [UIFont appFontRegularOfSize:12];
    
    _warnLabel.textColor = UIColorFromRGB(0xc6c6c6, 1.0);
    
    _warnLabel.backgroundColor = [UIColor whiteColor];
    
    _warnLabel.numberOfLines = 0;
    
    _warnLabel.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:_warnLabel];
    
    _nextButton = [[UIButton alloc]initWithFrame:CGRectMake(10,45*x, DeviceWidth-20, 45*x)];

    [_nextButton setButtonTitle:@"确定" titleFont:18 buttonHeight:45 *x];
    
    [_nextButton addTarget:self action:@selector(buildNextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:_nextButton];
    
    return view;
    
    
}


#pragma mark --> 代理协议


-(void)sendResultNumber:(NSInteger)number array:(NSMutableArray *)imgArray{
    
    [self buildGetImage];
    
}
#pragma mark camera utility
- (BOOL) isCameraAvailable{
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

@end
