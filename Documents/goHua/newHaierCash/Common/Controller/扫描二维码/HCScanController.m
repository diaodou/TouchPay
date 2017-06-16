//
//  HCScanController.m
//  newHaierCash
//
//  Created by Will on 2017/6/3.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "DefineSystemTool.h"
#import "UIColor+DefineNew.h"

#import <AVFoundation/AVFoundation.h>

#import "HCScanController.h"
#import "HCScanBackgroundView.h"
#import "RMUniversalAlert.h"

static NSString *MoveLineAnimationKey = @"MoveLineAnimation";

@interface HCScanController ()<AVCaptureMetadataOutputObjectsDelegate> {
    UIImageView *_moveLine;
    HCScanBackgroundView *_backView;
    
    AVCaptureSession *_session;   //输入输出的中间桥梁
    CGRect _scanRect;


    
}

@end

@implementation HCScanController
- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat viewWidth = DeviceHeight > DeviceWidth ? DeviceWidth :DeviceHeight;
    _scanRect = CGRectMake(viewWidth / 6, viewWidth / 6, 2 * viewWidth / 3, 2 * viewWidth / 3);
    self.title = @"扫码分期";
    
    [self _generateAVCap];
    
    [self _createScanView];
    
    
    
    if (_session) {
        [_session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_session) {
        [_session stopRunning];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Method
- (void)authority {
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
}

- (void)toCamera{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
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
#pragma mark --配置扫码选项
//拍照权限判断
- (void)_generateAVCap {
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
        
    } else {
        [self _opentAVCaptureSession];
    }
}

- (void)_opentAVCaptureSession {
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    //    设置扫码区域
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    [output setRectOfInterest:[self getScanRect]];

    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [_session addInput:input];
    }
    if (output) {
        [_session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64); //self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
}

/** 配置扫码范围 */
-(CGRect)getScanRect{
    
    
    /** 扫描是默认是横屏, 原点在[右上角]
     *  rectOfInterest = CGRectMake(0, 0, 1, 1);
     *  AVCaptureSessionPresetHigh = 1920×1080   摄像头分辨率
     *  需要转换坐标 将屏幕与 分辨率统一
     */
    
    //剪切出需要的大小位置
    CGRect shearRect = CGRectMake(_scanRect.origin.y,
                                  _scanRect.origin.x,
                                  _scanRect.size.height,
                                  _scanRect.size.height);
    
    CGSize layerViewSize = CGSizeMake(DeviceWidth, DeviceHeight - 64);
    CGFloat deviceProportion = 1920.0 / 1080.0;
    CGFloat screenProportion = layerViewSize.height / layerViewSize.width;
    
    //分辨率比> 屏幕比 ( 相当于屏幕的高不够)
    if (deviceProportion > screenProportion) {
        //换算出 分辨率比 对应的 屏幕高
        CGFloat finalHeight = layerViewSize.width * deviceProportion;
        // 得到 偏差值
        CGFloat addNum = (finalHeight - layerViewSize.height) / 2;
        
        // (对应的实际位置 + 偏差值)  /  换算后的屏幕高
        return CGRectMake((shearRect.origin.y + addNum) / finalHeight,
                                                shearRect.origin.x / layerViewSize.width,
                                                shearRect.size.height/ finalHeight,
                                                shearRect.size.width/ layerViewSize.width);
        
    }else{
        
        CGFloat finalWidth = layerViewSize.height / deviceProportion;
        
        CGFloat addNum = (finalWidth - layerViewSize.width) / 2;
        
        return CGRectMake(shearRect.origin.y / layerViewSize.height,
                                                (shearRect.origin.x + addNum) / finalWidth,
                                                shearRect.size.height /layerViewSize.height,
                                                shearRect.size.width / finalWidth);
    }
    
}

#pragma mark --UI和动画--

//UI
- (void)_createScanView {
    _backView = [[HCScanBackgroundView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64)];
    [self.view addSubview:_backView];
    
    _moveLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _scanRect.origin.y, DeviceWidth, 2)];
    UIImage *moveLineImg = [UIImage imageNamed:@"line_scan"];
    UIImage *newImage = [moveLineImg resizableImageWithCapInsets:UIEdgeInsetsMake(moveLineImg.size.height / 2, moveLineImg.size.width / 2, moveLineImg.size.height / 2, moveLineImg.size.width / 2) resizingMode:UIImageResizingModeStretch];
    
    _moveLine.image = newImage;
    _moveLine.contentMode = UIViewContentModeScaleAspectFill;
    _moveLine.backgroundColor = [UIColor clearColor];
    [self addAnimation];
    [self.view addSubview:_moveLine];
}

- (void)addAnimation
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:@(0)];
    [animationMove setToValue:@(2 * DeviceWidth / 3)];
    animationMove.duration = 2;
    animationMove.repeatCount  = OPEN_MAX;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [_moveLine.layer addAnimation:animationMove forKey:MoveLineAnimationKey];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate 
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    [_moveLine.layer removeAnimationForKey:MoveLineAnimationKey];

    if (metadataObjects.count>0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        NSLog(@"%@",metadataObject.stringValue);
        //输出扫描字符串
        NSString *searchDataWhole = metadataObject.stringValue;

    }
}




@end
