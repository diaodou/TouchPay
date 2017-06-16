//
//  FaceVerityViewController.m
//  personMerchants
//
//  Created by 百思为科 on 16/4/5.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "FaceVerityViewController.h"
#import <HTJCFaceLiveDetectSdk/THIDMCHTJCViewManger.h>
#import "HTJCBeginView.h"
#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>
#import "UIFont+AppFont.h"
#import "DefineSystemTool.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import "HCMacro.h"
#import "MBProgressHUD.h"
#import "CheckMsgModel.h"
#import "PersonalDataViewController.h"
//#import "StageApplicationViewController.h"
//#import "StageViewController.h"
#import "ConfirmPayNoBankViewController.h"
#import "FaceSuccessModel.h"
#import "EnterAES.h"
#import "BSVKHttpClient.h"
#import "AllloanViewController.h"
#import "ReplaceViewController.h"

#define SCREENWIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT       [UIScreen mainScreen].bounds.size.height
#define CHANGEVIEW_HEIGHT  (SCREENHEIGHT-64)

#define LIVEDETECT_BGCOLOR [UIColor colorWithRed:(2/ 255.0) green:(105 / 255.0) blue:(134 / 255.0) alpha:1]
#define NAVIGATION_COLOR [UIColor colorWithRed:(0/ 255.0) green:(133 / 255.0) blue:(170 / 255.0) alpha:1]

@interface FaceVerityViewController ()<BSVKHttpClientDelegate>
{
    NSString * sourceFace; //人脸分数
    /*
     * yes 退入后台，保持界面
     * no  退入后台，初始界面
     */
    
    NSData * _newImageData;    
}
@property(nonatomic,strong)HTJCBeginView *faceView;
@property (nonatomic,strong)UILabel *naviTitleLb;
@property (nonatomic,strong)FaceSuccessModel *faceSuccessModel;
@property (nonatomic,assign)BOOL toReplce;
@property (nonatomic,assign)BOOL toPrompt;
@end

@implementation FaceVerityViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _naviTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    _naviTitleLb.text = @"身份检测";
    _naviTitleLb.font = [UIFont boldSystemFontOfSize:19];
    _naviTitleLb.textColor = [UIColor whiteColor];
    _naviTitleLb.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = _naviTitleLb;
    
    [self addSubView];
    
    [self setNavi];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
//设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - private Methods
- (void)addSubView
{
    self.faceView = [[HTJCBeginView alloc]init];
    [self.view addSubview:_faceView];
    
    __weak typeof(self) weakSelf = self;
    _faceView.beginBlock = ^(){
        STRONGSELF
        if (strongSelf -> _toReplce) {

            [RMUniversalAlert showAlertInViewController:strongSelf withTitle:@"提示" message:strongSelf -> _faceSuccessModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                STRONGSELF
                if (strongSelf) {
                    if (buttonIndex == 0) {
                        [strongSelf toReplaceViewController:strongSelf.faceSuccessModel];
                    }
                }
            }];
        }else if (strongSelf -> _toPrompt){
            
            [RMUniversalAlert showAlertInViewController:strongSelf withTitle:@"提示" message:strongSelf -> _faceSuccessModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                STRONGSELF
                if (strongSelf) {
                    if (buttonIndex == 0) {
                        [strongSelf backPerfectViewController];
                    }
                }
            }];
        }else{
        [strongSelf setDetect];
        }
    };
    
    _faceView.backBlock = ^() {
        [weakSelf.faceView changeToBeginView];
        weakSelf.naviTitleLb.text = @"身份检测";
        
    };
    _faceView.quitBlock = ^() {
        [weakSelf.faceView changeToBeginView];
        weakSelf.naviTitleLb.text = @"身份检测";
        
    };
    _faceView.againBlock = ^() {
        weakSelf.faceView.beginBlock();
    };
}


//调用SDK
-(void)setDetect{
    
    THIDMCHTJCViewManger *manager = [THIDMCHTJCViewManger sharedManager:self];
    
    NSString *sdkVersion = [manager getSDKVersion];
    NSString *bundleVersion = [manager getBundleVersion];
    
    NSLog(@"sdkVersion:%@ ,bundleVersion:%@",sdkVersion,bundleVersion);
    
    NSMutableArray *detectTypes = [NSMutableArray arrayWithArray:@[@0, @1, @2]];
    
    [manager isNeedRandom:YES];
    [manager liveDetectTypeArray:detectTypes];
    WEAKSELF
    [manager getLiveDetectCompletion:^(BOOL sueccess, NSData *imageData) {
        [manager dismissTakeCaptureSessionViewController];
        UIImage *image = [UIImage imageWithData:imageData];
        [self.faceView changeToSuccessView:image];
        _naviTitleLb.text = @"检测结果";
        _newImageData = imageData;
        STRONGSELF
        [strongSelf check:_newImageData];
    } cancel:^(BOOL sueccess, NSString *error) {
        
        STRONGSELF
        
        if (strongSelf) {
            
            [strongSelf.faceView changeToBeginView];
            
            strongSelf.naviTitleLb.text = @"身份检测";
            
            
        }
    }failed:^(NSString *error) {
        
        STRONGSELF
        
        if (strongSelf) {
            
            if(error) {
                [strongSelf.faceView changeToFailView:error];
                strongSelf.naviTitleLb.text = @"检测结果";
                
            }
            
        }
        
        
    }];
}
- (void)check:(NSData *)imageData {
    if (self) {
        
        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        
        if ([AppDelegate delegate].userInfo.realId && [AppDelegate delegate].userInfo.realId.length > 0) {
            
            [parm setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realId] forKey:@"idNumber"];
            
        }
        if ([AppDelegate delegate].userInfo.realTel && [AppDelegate delegate].userInfo.realTel.length > 0) {
            
            [parm setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realTel] forKey:@"mobile"];
            
        }
        if ([AppDelegate delegate].userInfo.realName && [AppDelegate delegate].userInfo.realName.length > 0) {
            
            NSString *name = [NSString stringWithUTF8String:[[AppDelegate delegate].userInfo.realName UTF8String]];
            
            [parm setObject:[EnterAES simpleEncrypt:name] forKey:@"name"];
            
        }
        
        if ([AppDelegate delegate].userInfo.busFlowName == CashLoanCreate||[AppDelegate delegate].userInfo.busFlowName == CashLoanWait||[AppDelegate delegate].userInfo.busFlowName == CashLoanReturned||[AppDelegate delegate].userInfo.busFlowName == GoodsLoanWait||[AppDelegate delegate].userInfo.busFlowName == GoodsLoanCreate||[AppDelegate delegate].userInfo.busFlowName == GoodsReturnedByMerchant || [AppDelegate delegate].userInfo.busFlowName == GoodsReturnedByCredit) {
            [parm setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"applSeq"];
        }
        if (_ifFromTE || [AppDelegate delegate].userInfo.busFlowName == QuotaApply || [AppDelegate delegate].userInfo.busFlowName == QuotaReturned) {
            
            [parm setObject:@"0" forKey:@"applSeq"];
            
        }
        [parm setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];//提额 额度申请必传
        [parm setObject:@"2" forKey:@"source"];
        
        [parm setObject:[DefineSystemTool md5StringWithData:imageData] forKey:@"MD5"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        WEAKSELF
        BSVKHttpClient *clienta = [BSVKHttpClient shareInstance];
        
        [clienta putFile:@"app/appserver/faceCheck2" requestArgument:parm fileData:imageData fileName:@"fielname.jpg" name:@"file" mimeType:@"image/jpeg" completion:^(id results, NSError *error) {
            STRONGSELF
            _faceSuccessModel = [FaceSuccessModel mj_objectWithKeyValues:results];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(!error)
            {
                if ([_faceSuccessModel.body.isOK isEqualToString:@"Y"]) {
                    
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    strongSelf.faceView.hidden = NO;
                    
                    [strongSelf.faceView changeToSuccessView:image];
                    
                    strongSelf.naviTitleLb.text = @"检测结果";
                    
                    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(backPerfectViewController) userInfo:nil repeats:NO];
                }
                else if([_faceSuccessModel.body.isRetry isEqualToString:@"Y"])
                {
                    
                    strongSelf.faceView.hidden = NO;
                    
                    [strongSelf.faceView changeToBeginView];
                    
                    strongSelf.naviTitleLb.text = @"检测结果";
                    WEAKSELF
                    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:_faceSuccessModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                        STRONGSELF
                        if (strongSelf) {
                            if (buttonIndex == 0) {
                                
                            }
                        }
                    }];
                    
                }else if ([_faceSuccessModel.body.isResend isEqualToString:@"Y"])
                {
                    
                    WEAKSELF
                    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:_faceSuccessModel.head.retMsg cancelButtonTitle:@"取消" destructiveButtonTitle:@"重新发送" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                        STRONGSELF
                        if (strongSelf) {
                            if (buttonIndex == 1) {
                                [strongSelf check:_newImageData];
                            }
                        }
                    }];
                    
                }else{
                    
                    strongSelf.faceView.hidden = NO;
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                        [strongSelf.faceView changeToImageCheckFailView:image errorInfo:_faceSuccessModel.head.retMsg];
                   
                    [self judgeIfHavePlace:_faceSuccessModel];
                }
            }
            else
            {
                NSDictionary *dict = error.userInfo;
                if (dict)
                {
                    if ([[dict valueForKey:@"NSLocalizedDescription"]isEqualToString:TkokenError])
                    {
                        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"token失效,请重新登录" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                        }];
                    }else
                    {
                        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"网络环境异常，请检查网络并重试" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                        }];
                    }
                }
                else
                {

                    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"网络环境异常，请检查网络并重试" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    }];
                }
            }
        }];
        
        
    }
    
}
-(void)creatBtn{
    
    
    //重新检测
    UIButton * againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    againBtn.frame = CGRectMake(SCREENWIDTH/9, CHANGEVIEW_HEIGHT/13*10, SCREENWIDTH/9*3, 45);
    [againBtn setImage:[UIImage imageNamed:@"HTJCData.bundle/againBtn-n.png"] forState:UIControlStateNormal];
    againBtn.tag = 203;
    
    [againBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:againBtn];
    
    //退出
    UIButton * quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBtn.frame = CGRectMake(SCREENWIDTH/9*5, CHANGEVIEW_HEIGHT/13*10, SCREENWIDTH/9*3, 45);
    [quitBtn setImage:[UIImage imageNamed:@"HTJCData.bundle/quitBtn-n.png"] forState:UIControlStateNormal];
    quitBtn.tag = 204;
    [quitBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitBtn];
    
    
}

//按钮点击事件
-(void)btnAction:(UIButton *)btn{
    if (btn.tag == 203) {
        //重新检测
        if (_toReplce) {
            WEAKSELF
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:_faceSuccessModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                STRONGSELF
                if (strongSelf) {
                    if (buttonIndex == 0) {
                        [strongSelf toReplaceViewController:_faceSuccessModel];
                    }
                }
            }];
        }else if (_toPrompt){
            WEAKSELF
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:_faceSuccessModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                STRONGSELF
                if (strongSelf) {
                    if (buttonIndex == 0) {
                        [strongSelf backPerfectViewController];
                    }
                }
            }];
        }else{
        _againBlock();
        }
    }else if (btn.tag == 204) {
        //退出
        _quitBlock();
        
        //        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 判断是否有替代影像
- (void)judgeIfHavePlace:(FaceSuccessModel *)model{

    if (model.body.attachList && model.body.attachList.count > 0)
    {
        
        
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < model.body.attachList.count; i ++)
        {
            CheckMsgAttachlist *checkMsgAttach = [[CheckMsgAttachlist alloc] initWith:model.body.attachList[i]];
            [mArray addObject:checkMsgAttach];
        }
        
        if (_ifFromUnlock) {
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
            
            [parm setObject:@"image" forKey:@"face"];
            
            [parm setObject:mArray forKey:@"image"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FaceSuccessState" object:parm];
            
        }
        
        _toReplce = YES;
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    [strongSelf toReplaceViewController:model];
                }
            }
        }];
    }else{
        _toPrompt = YES;
        if (_ifFromUnlock) {
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
            
            [parm setObject:@"notPass" forKey:@"face"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FaceSuccessState" object:parm];
            
        }
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                   
                    [strongSelf dismissViewControllerAnimated:YES completion:nil];
                }
            }
        }];
    }
    
}
- (void)toReplaceViewController:(FaceSuccessModel *)model{
    
    _toReplce = NO;
    
    ReplaceViewController *vc = [[ReplaceViewController alloc]init];
    
    vc.imageArray = model.body.attachList;
    
    if (_typCde.length > 0) {
        
        vc.typCde = _typCde;
        
    }
    
    vc.ifFromTE = _ifFromTE;
    
    vc.ifFromPerson = _ifFromPerson;
    
    [self.navigationController pushViewController:vc animated:YES];
}
//返回完善信息
- (void)backPerfectViewController
{
    
    [self dismissViewControllerAnimated:NO completion:^{
        NSLog(@"发送");
        
        if (_ifFromUnlock) {
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
            
            [parm setObject:@"pass" forKey:@"face"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FaceSuccessState" object:parm];
            
        }
    }];
}

@end
