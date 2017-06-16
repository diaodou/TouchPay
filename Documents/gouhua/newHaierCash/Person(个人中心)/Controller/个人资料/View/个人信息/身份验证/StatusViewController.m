//
//  StatusViewController.m
//  personMerchants
//
//  Created by 史长硕 on 17/2/22.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "StatusViewController.h"
#import "UIFont+AppFont.h"
#import "NSString+CheckConvert.h"
#import "HCMacro.h"
#import "StatusProvingView.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import "DefineSystemTool.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "PostSuccessModel.h"
#import "TypeClass.h"
#import "SCCaptureCameraController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "UserSettingModel.h"
static CGFloat const SaveScanInfo = 190;
static CGFloat const SendSacnImage = 210;
static CGFloat const SendSacnTwoImage = 220;
@interface StatusViewController ()<SendStatusOpenDelegate,BSVKHttpClientDelegate>

{
    
    StatusProvingView *_statusView;
    
    ShowPickViewType _typePicker;      //当前选择器的类型
    
    SCCaptureCameraController *_sccp;
    
    TouchType _provingType;
    
    UIView *_pickerBackView;
    
    UIPickerView *_pickerViw;
    
    UIButton *_saveButton;//保存按钮
    
    NSMutableDictionary *_scanParmDic;//扫描后的字典
    
    float _statusHeight;
    
    UIScrollView *_baseScroolView;//基础滑动视图
    
    BOOL _finishLeftImage;//身份证正面照片是否已完成
    
    BOOL _finishRightImage;//身份证反面照片是否已完成
    
    float x;
    
}

@property (nonatomic,strong) NSMutableArray <NSArray *>*pickDataArr;//选择器的数据源

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation StatusViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"身份验证";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    x = DeviceWidth/414.0;
    
    _scanParmDic = [[NSMutableDictionary alloc]init];

    [self creatBaseView];
    
    [self creatSaveButton];
    
}

-(MBProgressHUD *)hud{
    
    if (!_hud) {
        
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        
        
    }
    
    [self.view bringSubviewToFront:_hud];
    
    [self.view addSubview:_hud];
    
    return _hud;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> private Methods

//创建基本视图
-(void)creatBaseView{
    
    _baseScroolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64)];
    
    _baseScroolView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_baseScroolView];
    
    _statusView = [[StatusProvingView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 364+90*x)];
    
    _statusView.delegate = self;
    
    [_statusView creatBaseUI:CGRectMake(0, 0, DeviceWidth, 364+90*x)];
    
    [_statusView creatNameView];
    
    [_statusView creatBaseText];
    
    [_baseScroolView addSubview:_statusView];
    
}

//创建保存按钮
-(void)creatSaveButton{
    
    _saveButton = [[UIButton alloc]initWithFrame:CGRectMake(15, _statusView.frame.origin.y+_statusView.frame.size.height+30,DeviceWidth-30, 45)];
    
    [_saveButton setTitle:@"保存"forState:UIControlStateNormal];
    
    [_saveButton addTarget:self action:@selector(buildSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _saveButton.backgroundColor = UIColorFromRGB(0x028ce5, 1.0);
    
    _saveButton.layer.cornerRadius = 5.0;
    
    _baseScroolView.contentSize = CGSizeMake(DeviceWidth, _saveButton.frame.origin.y+_saveButton.frame.size.height+50);
    
    [_baseScroolView addSubview:_saveButton];
    
}

#pragma mark --> event Response

// 扫描
- (void)scanning{
    
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]&&[self isCamareAuthorization]) {
        _sccp = [[SCCaptureCameraController alloc] init];
        _sccp.scNaigationDelegate = self;
        _sccp.iCardType = TIDCARD2;
        _sccp.isDisPlayTxt = YES;
        [self presentViewController:_sccp animated:YES completion:NULL];
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


//点击保存按钮方法
-(void)buildSaveAction:(UIButton *)sender{
    
    if ([self buildJudgeCertInfo]) {
        
        [self buildSendScanImage];
        
        //[self buildSaveScanInfo];
        
    }
    
}

//判断身份验证信息是否完善
-(BOOL)buildJudgeCertInfo{
    
    if (!_statusView.leftimage.image) {
        
        [self buildHeadError:@"请上传身份验证的身份证正面照片"];
        
        return NO;
        
    }else if (!_statusView.rightImage.image){
        
        [self buildHeadError:@"请上传身份验证的身份证反面照片"];
        
        return NO;
        
    }else if (_statusView.genderLabel.text.length == 0 || !_statusView.genderLabel.text){
        
        [self buildHeadError:@"请选择身份验证的性别"];
        
        return NO;
        
    }else if (_statusView.birthLabel.text.length == 0 || !_statusView.birthLabel.text){
        
        [self buildHeadError:@"请上传身份验证的出生年月"];
        
        return NO;
        
    }else if (_statusView.addressText.text.length == 0 || !_statusView.addressText.text){
        
        [self buildHeadError:@"请输入身份验证的家庭住址"];
        
        return NO;
        
    }else if (_statusView.officeText.text.length == 0 || !_statusView.officeText.text){
        
        [self buildHeadError:@"请输入身份验证的签发机关"];
        
        return NO;
        
    }else if (_statusView.validLabel.text.length == 0 || !_statusView.validLabel.text){
        
        [self buildHeadError:@"请选择身份验证的有效期"];
        
        return NO;
        
    }else{
        
        return YES;
    }
    
}


#pragma mark --> 视图代理方法

-(void)sendSelectType:(TouchType)type{
    
    _provingType = type;
    
     [self scanning];
    
}

-(void)sendTextViewHeight:(float)height{
    
    _statusHeight = height-50;
    
    _statusView.baseView.frame = CGRectMake(0, 0, DeviceWidth, height-50);
    
    _statusView.frame = CGRectMake(0, 0, DeviceWidth, height-50);
    
    _saveButton.frame = CGRectMake(15, _statusView.frame.origin.y+_statusView.frame.size.height+30,DeviceWidth-30, 45);
    
    _baseScroolView.contentSize = CGSizeMake(DeviceWidth, _saveButton.frame.origin.y+_saveButton.frame.size.height+50);
    
}

#pragma mark --> 扫描身份证之后的代理方法

//获取拍照的图片
- (void)sendTakeImage:(TCARD_TYPE) iCardType image:(UIImage *)cardImage
{
    
    if (cardImage) {
        
        if (_provingType == LeftImage || _provingType == Address || _provingType == Gender || _provingType == Time) {
            
            if (_finishLeftImage) {
                 _statusView.leftimage.image = cardImage;
            }
        
            
        }else{
            if (_finishRightImage) {
             _statusView.rightImage.image = cardImage;
            }
            
            
        }
        
    }else{
        
        [self buildHeadError:@"获取照片失败，请重新拍摄"];
        
    }
    
    
}


// 获取身份证正面信息
- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *) address NUM:(NSString *)num{
    
    if (_provingType != Camera) {
                
        if (_provingType == Office || _provingType == Valid || _provingType == RightImage) {
            
            _finishLeftImage = NO;
            
           // [_sccp dismissBtnPressed:NULL];
            
            [self buildHeadError:@"请扫描身份证正面"];
            
        }else{
           
            if ([[AppDelegate delegate].userInfo.realId isEqualToString:[num deleteSpeaceString]]) {
                
                _finishLeftImage = YES;
                
                _statusView.genderLabel.text = [sex deleteSpeaceString];
                
                if (_statusView.genderLabel.text.length > 0 && _statusView.genderLabel.text) {
                    
                    if ([_statusView.genderLabel.text isEqualToString:@"男"]) {
                        
                        [_scanParmDic setObject:@"10" forKey:@"gender"];
                        
                    }else{
                        
                        [_scanParmDic setObject:@"20" forKey:@"gender"];
                        
                    }
                    
                    
                    
                }
                
                if (folk.length > 0) {
                    
                    [_scanParmDic setObject:folk forKey:@"ethnic"];
                    
                }
                
                _statusView.birthLabel.text = [birthday deleteSpeaceString];
                
                NSString *string = [_statusView.birthLabel.text buildChangeDay];
                
                if (string.length > 0 && string) {
                    
                    [_scanParmDic setObject:string forKey:@"birthDt"];
                    
                }
                
                if (_statusView.addressText.text.length > 0 && _statusView.addressText.text) {
                    [_scanParmDic setObject:_statusView.addressText.text forKey:@"regAddr"];
                }
                
                [_statusView buildNowTimeChangeViewHeight:address];
                
                
            }else{
                
                [self buildHeadError:@"扫描后的身份证信息不匹配"];
                
            }

            
        }
        
        
    }
    
    
}

#pragma mark --> 身份证反面识别

// 获取身份证反面信息
- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period{
    
    if (_provingType != Camera) {
        
        if (_provingType == LeftImage || _provingType == Gender || _provingType == Time || _provingType == Address) {
            
            _finishRightImage = NO;
            
          //  [_sccp dismissBtnPressed:NULL];
            
            [self buildHeadError:@"请扫描身份证反面"];
            
        }else{
          
            _finishRightImage = YES;
            
            _statusView.officeText.text = [issue deleteSpeaceString];
            
            if (_statusView.officeText.text.length > 0 && _statusView.officeText.text) {
                [_scanParmDic setObject:_statusView.officeText.text forKey:@"certOrga"];
            }
            
            _statusView.validLabel.text = [period deleteSpeaceString];
            
            NSString *string = [period buildReplaceCertStartDt];
            
            if (string.length > 0 && string) {
                
                [_scanParmDic setObject:string forKey:@"certStrDt"];
                
            }
            
            NSString *stringTwo = [period buildReplaceCertEndDt];
            
            if (stringTwo.length > 0 && stringTwo) {
                
                [_scanParmDic setObject:stringTwo forKey:@"certEndDt"];
                
            }

            
        }
        
        
        
    }
    
    
}

#pragma mark - camer utility
- (BOOL) isCameraAvailable{
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}
//判断相机的访问权限
- (BOOL)isCamareAuthorization{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        return NO;
        
    }else{
        return YES;
    }
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


#pragma mark --> 发起网络请求

//发起保存扫描后的身份验证信息
-(void)buildSaveScanInfo{
    
    if ([AppDelegate delegate].userInfo.realId.length > 0 && [AppDelegate delegate].userInfo.realId) {
        
        [_scanParmDic setObject:[AppDelegate delegate].userInfo.realId forKey:@"certNo"];
        
    }
    
    if ([AppDelegate delegate].userInfo.realName.length > 0 && [AppDelegate delegate].userInfo.realName) {
        
        [_scanParmDic setObject:[AppDelegate delegate].userInfo.realName forKey:@"custName"];
        
    }
    
    //AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (![[_scanParmDic objectForKey:@"regAddr"]isEqualToString:_statusView.addressText.text]) {
        
        if (_statusView.addressText.text > 0) {
            
            [_scanParmDic setObject:_statusView.addressText.text forKey:@"afterRegAddr"];
            
        }
        
    }
    
    if (![[_scanParmDic objectForKey:@"gender"]isEqualToString:_statusView.genderLabel.text]) {
        
        if (_statusView.genderLabel.text.length > 0) {
            
            if ([_statusView.genderLabel.text isEqualToString:@"男"]) {
                
                [_scanParmDic setObject:@"10" forKey:@"afterGender"];
                
            }else{
                
                [_scanParmDic setObject:@"20" forKey:@"afterGender"];
                
            }
            
        }
        
    }
    
    
    
    NSString *stringTwo = [_statusView.birthLabel.text buildChangeDay];
    
    
    if (![[_scanParmDic objectForKey:@"birthDt"]isEqualToString:stringTwo]) {
        
        if (stringTwo.length > 0) {
            
            [_scanParmDic setObject:stringTwo forKey:@"afterBirthDt"];
            
        }
    }
    
    if (![[_scanParmDic objectForKey:@"certOrga"]isEqualToString:_statusView.officeText.text]) {
        
        if (_statusView.officeText.text > 0) {
            
            [_scanParmDic setObject:_statusView.officeText.text forKey:@"afterCertOrga"];
            
        }
        
    }
    
    
    NSString *start = [_statusView.validLabel.text buildReplaceCertStartDt];
    
    if (![[_scanParmDic objectForKey:@"certStrDt"]isEqualToString:start]) {
        
        if (start.length > 0) {
            
            [_scanParmDic setObject:start forKey:@"afterCertStrDt"];
            
        }
    }
    
    
    
    NSString *end = [_statusView.validLabel.text buildReplaceCertEndDt];
    
    if (![[_scanParmDic objectForKey:@"certEndDt"]isEqualToString:end]) {
        
        if (end.length > 0) {
            
            [_scanParmDic setObject:end forKey:@"afterCertEndDt"];
            
        }
        
    }
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    [client postInfo:@"app/appserver/saveCardMsg" requestArgument:_scanParmDic requestTag:SaveScanInfo requestClass:NSStringFromClass([self class])];
    
    
}


//上传身份验证正反面图片
-(void)buildSendScanImage{
    
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    NSData *data = UIImageJPEGRepresentation(_statusView.leftimage.image, ImageUpZScale);
    
    
    NSString *strm = [DefineSystemTool md5StringWithData:data];
    
    NSString *name = @"DOC53.jpg";
    
    if ([AppDelegate delegate].userInfo.custNum.length > 0 && [AppDelegate delegate].userInfo.custNum) {
        
        [parm setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
        
    }
    
    [parm setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
    
    [parm setObject:@"DOC53" forKey:@"attachType"];
    
    [parm setObject:@"身份证正面" forKey:@"attachName"];
    
    
    if (strm.length > 0 && strm) {
        
        [parm setObject:strm forKey:@"md5"];
        
    }
    
    [parm setObject:@"" forKey:@"commonCustNo"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    [client puFile:@"app/appserver/attachUploadPerson" requestArgument:parm fileData:data fileName:name name:@"multipartFile" mimeType:@"image/jpeg" requestTag:SendSacnImage requestClass:NSStringFromClass([self class])];
    
    
}

//上传扫描后的身份证反面照片
-(void)buildSendScanTwoImage{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    NSData *data = UIImageJPEGRepresentation(_statusView.rightImage.image, ImageUpZScale);
    
    NSString *strm = [DefineSystemTool md5StringWithData:data];
    
    NSString *name = @"DOC54.jpg";
    
    if ([AppDelegate delegate].userInfo.custNum.length > 0 && [AppDelegate delegate].userInfo.custNum) {
        
        [parm setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
        
    }
    
    [parm setObject:@"DOC54" forKey:@"attachType"];
    
    [parm setObject:@"身份证反面" forKey:@"attachName"];
    
    [parm setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
    
    if (strm.length > 0 && strm) {
        
        [parm setObject:strm forKey:@"md5"];
        
    }
    
    [parm setObject:@"" forKey:@"commonCustNo"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    [client puFile:@"app/appserver/attachUploadPerson" requestArgument:parm fileData:data fileName:name name:@"multipartFile" mimeType:@"image/jpeg" requestTag:SendSacnTwoImage requestClass:NSStringFromClass([self class])];
    
    
}

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
         if (requestTag == SaveScanInfo){
            
            [self.hud hideAnimated:YES];
            
            UserSettingModel *model = [UserSettingModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSaveScanInfo:model];
            
        }else if (requestTag == SendSacnImage){
            
            [self.hud hideAnimated:YES];
            
            PostSuccessModel *model = [PostSuccessModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSendSacnImage:model];
            
        }else{
            
            [self.hud hideAnimated:YES];
            
            PostSuccessModel *model = [PostSuccessModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSendSacnTwoImage:model];
            
            
        }
        
    }
    
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [self.hud hideAnimated:YES];
        
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


//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                return;
            }
        }
    }];
    
    
}

//上传扫描后的身份证反面
-(void)buildHandleSendSacnTwoImage:(PostSuccessModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [self buildSaveScanInfo];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}
//上传扫描后的身份证正面
-(void)buildHandleSendSacnImage:(PostSuccessModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [self buildSendScanTwoImage];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}


-(void)buildHandleSaveScanInfo:(UserSettingModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"保存成功" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }];

        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}


@end
