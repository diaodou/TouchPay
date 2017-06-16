//
//  PersonalDataViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/21.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "HCMacro.h"
#import "SecurityViewController.h"
#import "AddBankViewController.h"
#import "NSString+CheckConvert.h"
#import "UIFont+AppFont.h"
#import "RSKImageCropViewController.h"
#import "RSKImageCropper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "DefineSystemTool.h"
#import "UpLimitInfoViewController.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import "EnterAES.h"
#import "HeaderModel.h"
#import "WhiteSearchModel.h"
#import "QueryNumberModel.h"
#import "IndetityStore.h"
#import "UnlockAccountViewController.h"
#import "LoginViewController.h"
#import "UIButton+UnifiedStyle.h"
//#import "UpLimitInfoViewController.h"
#define ORIGINAL_MAX_WIDTH 640.0f
@interface PersonalDataViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,RSKImageCropViewControllerDelegate,BSVKHttpClientDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *controller;
@property (nonatomic, strong) UITableView *downTableView;
@property (nonatomic, strong) UIButton *btnOut;
@property (nonatomic, strong)UIImageView *imgIcon;
@property(nonatomic,strong)WhiteSearchModel *searchModel;
@end

@implementation PersonalDataViewController
//@synthesize controller;
#pragma mark -- lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"个人资料";
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self getHeadImage];  //初始化头像
    [self creatTableView];//表
    [self setNavi];       //返回
    [self setOutBtn];     //退出登录
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)logOut{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
#pragma mark - setting and getting
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
- (void)OnBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getHeadImage{
    self.imgIcon = [[UIImageView alloc]init];
    self.imgIcon.layer.cornerRadius = 25.0;
    self.imgIcon.layer.masksToBounds = YES;
    UIImage *image =  (UIImage *)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@app/uauth/getUserPic?userId=%@",baseUrl,[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId]]];
    NSLog(@"url = %@",[NSString stringWithFormat:@"%@app/uauth/getUserPic?userId=%@",baseUrl,[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId]]);
    if (image) {
        
        self.imgIcon.image = image;
    }else{
        
        self.imgIcon.image = [UIImage imageNamed:@"默认个人头像"];
    }
}
-(void)creatTableView{
    _downTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, .5, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    _downTableView.delegate = self;
    _downTableView.dataSource = self;
    _downTableView.scrollEnabled = NO;
    _downTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view  addSubview:_downTableView];
}
- (void)setOutBtn{
    
    UIView * bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 100)];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, .5)];
    
    lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 0.5);
    
    [bottomView addSubview:lineView];
    
    _btnOut = [UIButton buttonWithType:UIButtonTypeCustom];
    if (iphone6P) {
        
        _btnOut.frame = CGRectMake(47 , 40, DeviceWidth - 94, 50);
    }else{
        
        _btnOut.frame = CGRectMake(42 *DeviceWidth/375 , 40, DeviceWidth - 84 *DeviceWidth/375, 45*DeviceWidth/375);
    }
    
    [_btnOut setButtonTitle:@"退出登录" titleFont:15 buttonHeight:CGRectGetHeight(_btnOut.frame)];
    [_btnOut addTarget:self action:@selector(btnOutClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_btnOut];
    
    _downTableView.tableFooterView = bottomView;
}
#pragma mark  --数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 70;
    }else{
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSArray *array = @[@"嗨付头像",@"完善资料",@"银行卡",@"安全设置",@"收货地址"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellStyleValue1;
        cell.textLabel.text = array[indexPath.row];
        cell.textLabel.font = [UIFont appFontRegularOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(0x333333, 1.0);
    }
    if (indexPath.row == 0) {
        self.imgIcon.frame = CGRectMake(DeviceWidth-100, 10, 50, 50);
        [cell.contentView addSubview:self.imgIcon];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        [self didSelectOne];
    }else if (indexPath.row == 4){
        [self didSelectFive];
    }else{
        if ([AppDelegate delegate].userInfo.myRealNameState == realNameYes){
            if (indexPath.row == 1) {

                [self setAllowRequest];
            }else if (indexPath.row == 2){
                
                [self toAddBankViewController];
            }else{
                
                [self toSecurityViewController];
            }
        }else if ([AppDelegate delegate].userInfo.myRealNameState == realNameNo)
        {
            
            [self toRealName];
        }else{
            
            [self setRequest];
        }
    }
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_downTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_downTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_downTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_downTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - private Methods
- (void)didSelectOne{
    WEAKSELF
    [RMUniversalAlert showActionSheetInViewController:self withTitle:@"选择照片" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册中选取"] popoverPresentationControllerBlock:^(RMPopoverPresentationController * _Nonnull popover) {
        
    } tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            //
            if (buttonIndex == 2) {
                //拍照
                [strongSelf photoMake];
            }
            if (buttonIndex == 3) {
                //从相册中选择
                [strongSelf photoSelect];
            }
        }
    }];
}
- (void)didSelectFive{
//收货地址
}
- (void)toAddBankViewController{
    AddBankViewController *vc = [[AddBankViewController alloc]init];
//    vc.flowName = fromPersonalData;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)toSecurityViewController{
    SecurityViewController *vc = [[SecurityViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)photoMake {
    // 拍照
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]&&[self isCamareAuthorization]) {
        _controller = [[UIImagePickerController alloc] init];
        _controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            _controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
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
- (void)photoSelect {
    if ([self isPhotoLibraryAvailable]) {
        _controller = [[UIImagePickerController alloc] init];
        _controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        _controller.mediaTypes = mediaTypes;
        _controller.delegate = self;
        _controller.edgesForExtendedLayout = UIRectEdgeNone;
        _controller.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        
        _controller.navigationBar.barTintColor = UIColorFromRGB(0x32beff, 1.0);
        
        _controller.navigationBar.tintColor = [UIColor whiteColor];
        [self presentViewController:_controller animated:YES
                         completion:nil];
    }
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
- (void)toRealName{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请进行实名认证" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (buttonIndex == 0) {
            
            [strongSelf toRealNameViewController];
        }
    }];
}
- (void)toRealNameViewController
{
    
    UnlockAccountViewController *unlockVC = [[UnlockAccountViewController alloc] init];
    
    unlockVC.startType = FromRealName;
    
    unlockVC.showType = ShowRegAndRealInfo;
    
    [self.navigationController pushViewController:unlockVC animated:YES];
}
- (void)btnOutClick {

    LoginViewController *VC = [[LoginViewController alloc]init];
    
    HCRootNavController *nav = [[HCRootNavController alloc]initWithRootViewController:VC];
    
    VC.fromType = fromOther;
    
    [self presentViewController:nav animated:YES completion:^{
        [AppDelegate delegate].userInfo.bLoginOK = NO;
    }];
    
}
- (void)toNextController{
    UpLimitInfoViewController *vc = [[UpLimitInfoViewController alloc]init];
    vc.fromViewClass = FromPersonData;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - request
-(void)setAllowRequest{
    
    if ([AppDelegate delegate].userInfo.whiteType && [AppDelegate delegate].userInfo.whiteType != WhiteNoCheck) {
        
        [self toNextController];
        
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:StringOrNull([AppDelegate delegate].userInfo.realId) forKey:@"certNo"];
        
        [dic setObject:StringOrNull([AppDelegate delegate].userInfo.realName) forKey:@"custName"];
        
        [dic setObject:@"20" forKey:@"idTyp"];
        
        [dic setObject:[AppDelegate delegate].userInfo.userTel forKey:@"phonenumber"];
        
        [BSVKHttpClient shareInstance].delegate = self;
        
        [[BSVKHttpClient shareInstance] getInfo:@"app/appserver/crm/cust/getCustIsPass" requestArgument:dic requestTag:600 requestClass:NSStringFromClass([self class])];
    }
}
- (void)searchInviteReason {
    //                    查询邀请原因
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance] getInfo:@"app/appserver/crm/cust/getInvitedCustByCustNo" requestArgument:@{@"custNo":[AppDelegate delegate].userInfo.custNum} requestTag:1000 requestClass:NSStringFromClass([self class])];
}
-(void)setRequest{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    实名认证查询
    NSString *userStr =StringOrNull([AppDelegate delegate].userInfo.userId) ;
    
    NSMutableDictionary * userDic = [[NSMutableDictionary alloc]init];
    //#warning  等有登录 再放开
    [userDic setObject:userStr forKey:@"userId"];
    
    BSVKHttpClient * userClient = [BSVKHttpClient shareInstance];
    
    userClient.delegate = self;
    
    [userClient getInfo:@"app/appserver/crm/cust/queryPerCustInfo" requestArgument:userDic requestTag:210 requestClass:NSStringFromClass([self class])];
}
#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}
// --- 选中----
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    self.imgIcon.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSString *userName = [AppDelegate delegate].userInfo.userId;
    NSString *imageUrl = [self Base64:self.imgIcon.image];
    [dict setValue:[EnterAES simpleEncrypt:userName] forKey:@"userId"];
    [dict setValue:imageUrl forKey:@"avatarUrl"];
    [[BSVKHttpClient shareInstance] putInfo:@"app/appserver/uauth/avatarUrl" requestArgument:dict requestTag:1 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:portraitImg cropMode:RSKImageCropModeSquare];
        imageCropVC.delegate = self;
        imageCropVC.cropMode = RSKImageCropModeCircle;
        [imageCropVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:imageCropVC animated:YES];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // 退出当前界面
    [picker dismissViewControllerAnimated:YES completion:nil];
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

- (BOOL) isPhotoLibraryAvailable{
    //    return [UIImagePickerController isSourceTypeAvailable:
    //            UIImagePickerControllerSourceTypePhotoLibrary];
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied)
    {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"你还未开启相册权限，请前往设置中心开启" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 1) {
                    
                    [strongSelf toPhoto];
                }
            }
        }];
        return NO;
    }else{
        
        return YES;
    }
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

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        viewController.navigationController.navigationBar.translucent = NO;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}
// ---- 图片转码----
- (NSString *)Base64:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *_encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return _encodedImageStr;
}
#pragma mark - 解析 Model
- (void)analySisHeaderModel:(HeaderModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [[AppDelegate delegate].imagePutCache removeObjectForKey:[NSString stringWithFormat:@"%@app/uauth/getUserPic?userId=%@",baseUrl,[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId]]];
        [self buildErrWithString:@"头像设置成功"];
        [AppDelegate delegate].userInfo.userHeader = model.body.avatarUrl;
    }else{
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
    }
}
- (void)analySisQueryNumberModel:(QueryNumberModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]){
        
        [AppDelegate delegate].userInfo.myRealNameState = realNameYes;
        
        [[AppDelegate delegate].userInfo initRealNameInfo:model.body];
        
        
    }else if ([model.head.retFlag isEqualToString:@"C1120"]){
        
        [AppDelegate delegate].userInfo.myRealNameState = realNameNo;
        
        [self toRealName];
    }
    else{
        
        [self buildErrWithString:model.head.retMsg];
    }
}
- (void)analySisWhiteSearchModel:(WhiteSearchModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        _searchModel = model;
        if ([model.body.isPass isEqualToString:SocietyUser]){
             [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
            [self searchInviteReason];
        }
        else if ([model.body.isPass isEqualToString:@"1"]){
            if ([model.body.level isEqualToString:Auser]) {
                [AppDelegate delegate].userInfo.whiteType = WhiteA;
                 [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
                [self toNextController];
            }
            else if ([model.body.level isEqualToString:Buser]){
                
                [AppDelegate delegate].userInfo.whiteType = WhiteB;
                 [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
                [self toNextController];
                
            }else if ([model.body.level isEqualToString:Cuser]){
                //[AppDelegate delegate].userInfo.whiteType = WhiteC;
                 [AppDelegate delegate].userInfo.haierVipState = IsHaierVip;
                [self searchInviteReason];
            }
        }
        else if ([model.body.isPass isEqualToString:@"-1"]){
            
            [AppDelegate delegate].userInfo.whiteType = BlackMan;
             [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
            [self toNextController];
            
        }
    }else{
    
        [self buildErrWithString:model.head.retMsg];
    }
}
- (void)analySisIndetityStore:(IndetityStore *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        if (model.body.count > 0) {
          
            if ([_searchModel.body.isPass isEqualToString:@"1"]) {
                [AppDelegate delegate].userInfo.whiteType = WhiteCReason;
            }else{
                [AppDelegate delegate].userInfo.whiteType = WhiteSocityReason;
            }
            [self toNextController];
        }
        else{
            
            if ([_searchModel.body.isPass isEqualToString:@"1"]) {
                [AppDelegate delegate].userInfo.whiteType = WhiteCNoReason;
            }else{
                [AppDelegate delegate].userInfo.whiteType = WhiteSocityNoReason;
            }
            [self toNextController];
        }
    }else{
        [self buildErrWithString:model.head.retMsg];
    }
}
#pragma mark - BSVK Delegate
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if (requestTag == 1) {
            HeaderModel *model = [HeaderModel mj_objectWithKeyValues:responseObject];
            
            [self analySisHeaderModel:model];
            
        }else if (requestTag == 210){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            QueryNumberModel * model = [QueryNumberModel mj_objectWithKeyValues:responseObject];
            
            [self analySisQueryNumberModel:model];
                
        }else if (requestTag == 600){
            
            WhiteSearchModel *model = [WhiteSearchModel mj_objectWithKeyValues:responseObject];
            
            [self analySisWhiteSearchModel:model];
            
            
        }else if (requestTag == 1000){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            IndetityStore *model = [IndetityStore mj_objectWithKeyValues:responseObject];
            
            [self analySisIndetityStore:model];
            
        }
    }
}


- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if(httpCode != 0)
        {
            [self buildErrWithString:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",httpCode]];
        }
        else
        {
            [self buildErrWithString:@"网络环境异常，请检查网络并重试"];
        }
    }
}
//提示框
- (void)buildErrWithString:(NSString *)string{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:string cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            
        }
        
    }];
}

- (void)dealloc {
    _controller.delegate = nil;
}

@end
