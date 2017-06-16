//
//  LeadToFaceVerifiViewController.m
//  personMerchants
//
//  Created by LLM on 2017/2/15.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "HCLeadFaveViewController.h"
#import "HCMacro.h"
#import "AppDelegate.h"
#import "RMUniversalAlert.h"
#import "ReplaceViewController.h"
#import "FaceVerityViewController.h"
@interface HCLeadFaveViewController ()

{
    
    float x;
    
    BOOL isFinish;
    
}

@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,strong) UIButton *nextBtn;

@end

@implementation HCLeadFaveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
    }
    
    isFinish = YES;
    
    [self initFaceVerificationView];
    
    [self buildChangeFaceView];
    
}


-(void)setFaceStatus:(FaceStatus)faceStatus{
    
    _faceStatus = faceStatus;
    
    if (isFinish) {
        
        [self buildChangeFaceView];
        
    }
    
}

#pragma mark - private methods

-(void)buildChangeFaceView{
    
    if(_faceStatus == FacePassed)
    {
        _tipLabel.text = @"您的人脸识别已通过，点击下一步继续";
        _tipLabel.font = [UIFont systemFontOfSize:12];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        
    }
    else if(_faceStatus == FaceNotDo)
    {
        _tipLabel.text = @"请将脸部正对镜头，保持光线充足";
        _tipLabel.font = [UIFont systemFontOfSize:12];
        [_nextBtn setTitle:@"开始拍摄" forState:UIControlStateNormal];
    }
    else if (_faceStatus == FaceNotPass)
    {
        //人脸识别页面
        _tipLabel.text = @"人脸检测失败，详情咨询4000187777";
        _tipLabel.font = [UIFont systemFontOfSize:12];
        [_nextBtn setTitle:@"开始拍摄" forState:UIControlStateNormal];
    }else if (_faceStatus == FaceReplaceImage)
    {
        _tipLabel.text = @"人脸检测失败，请上传替代影像";
        _tipLabel.font = [UIFont systemFontOfSize:12];
        [_nextBtn setTitle:@"替代影像" forState:UIControlStateNormal];
    }

}

//去人脸识别的页面
- (void)initFaceVerificationView
{
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 97*x, DeviceWidth, 10*x)];
    
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.view addSubview:lineView];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceWidth-268*x)/2, 120*x, 268*x, 320*x)];
    iv.image = [UIImage imageNamed:@"人脸扫描"];
    [self.view addSubview:iv];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((DeviceWidth-268*x)/2, 465*x, 268*x, 40*x);
    label.text = @"请将脸部正对镜头，保持光线充足";
    label.textColor = UIColorFromRGB(0xc6c6c6, 1.0);
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    _tipLabel = label;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((DeviceWidth-180*x)/2, 520*x, 180*x, 50*x);
    [btn setTitle:@"开始拍摄" forState:UIControlStateNormal];
    btn.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    btn.layer.cornerRadius = 2.0f;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(faceVerification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    if (IPHONE4) {
        
        iv.frame =CGRectMake((DeviceWidth-195*x)/2, 120*x, 195*x, 240*x);
        
       label.frame= CGRectMake((DeviceWidth-268*x)/2, 385*x, 268*x, 40*x);
        
        btn.frame= CGRectMake((DeviceWidth-180*x)/2, 430*x, 180*x, 50*x);

        
    }
    
    _nextBtn = btn;
}

- (void)faceVerification
{
    if(_faceStatus == FaceNotPass)
    {
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"人脸检测失败，详情咨询4000187777" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex)
         {
         }];
        
        return;
    }
    
    if (_faceStatus == FaceNotDo) {
       
        FaceVerityViewController *faceVc = [[FaceVerityViewController alloc]init];
        
        faceVc.typCde = _typCde;
        
        faceVc.ifFromUnlock = YES;
        
        HCRootNavController *nav = [[HCRootNavController alloc]initWithRootViewController:faceVc];
        
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if (_faceStatus == FaceReplaceImage){
        
        ReplaceViewController *vc = [[ReplaceViewController alloc]init];
        
        vc.imageArray = _imageArray;
        
        vc.typCde = _typCde;
        
        HCRootNavController *nav = [[HCRootNavController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
}
@end
