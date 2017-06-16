//
//  BindBankCardViewController.m
//  personMerchants
//
//  Created by 百思为科 on 16/4/6.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "BindBankCardViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "AddBankViewController.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import "MJExtension.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "AddNewBankViewController.h"
#import "BankTypeModel.h"
#import "NSString+CheckConvert.h"
@interface BindBankCardViewController ()<BSVKHttpClientDelegate>

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic, strong)BankTypeModel *bankTypeModel;
@property (nonatomic,strong) UIView * bottomView;
@end

@implementation BindBankCardViewController
#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    self.navigationItem.title = @"银行卡";
    
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    }
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)dealloc
{
    
}
- (void)setUI{
    if (IPHONE4 || iPhone5) {
        self.nameLabel.font = [UIFont appFontRegularOfSize:14];
        self.typeLabel.font = [UIFont appFontRegularOfSize:14];
        self.cardNumberLabel.font = [UIFont appFontRegularOfSize:14];
        self.cardNumberLabel.frame = CGRectMake(80*DeviceWidth/375, CGRectGetMaxY(_nameLabel.frame) + 21 + 15, 211*DeviceWidth/375,21*DeviceWidth/375 );
    }
    
    self.defaultBtn.layer.cornerRadius = 22.5;
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(DeviceWidth - 40, 10, 40, 40);
    [_cancelBtn setImage:[UIImage imageNamed:@"邀请圆"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(comeApper:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_cancelBtn];
    self.cardNumberLabel.textAlignment = NSTextAlignmentLeft;
    self.typeLabel.text = _cardType;
   
    self.cardNumberLabel.text = [_cardNumber convertToBankNum];
    self.nameLabel.text = [AppDelegate delegate].userInfo.realName;
}
#pragma mark - request
- (IBAction)btnClick:(UIButton *)sender {
    // 在此处验证设置默认还款银行卡接口
        //         在此处验证设置默认还款银行卡接口
        NSMutableDictionary *defauleBankDict = [NSMutableDictionary dictionary];
        
        if ([AppDelegate delegate].userInfo.custNum != nil && _cardNumber != nil) {
            [defauleBankDict setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
            [defauleBankDict setObject:_cardNumber forKey:@"cardNo"];
        }
        BSVKHttpClient *client = [BSVKHttpClient shareInstance];
        client.delegate = self;
        
        [client putInfo:@"app/appserver/crm/cust/saveDefaultBankCard" requestArgument:defauleBankDict requestTag:200 requestClass:NSStringFromClass([self class])];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
-(void)cancelBinding:(UIButton *)btn{
    //7.13-解除绑定还款卡
    NSMutableDictionary *deleDict = [[NSMutableDictionary alloc]init];
    _cancelBtn.userInteractionEnabled = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [deleDict setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
    [deleDict setObject:StringOrNull(_cardNumber) forKey:@"cardNo"];
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    [client getInfo:@"app/appserver/deleteBankCard" requestArgument:deleDict requestTag:100 requestClass:NSStringFromClass([self class])];
    
    _cancelBtn.userInteractionEnabled = YES;
}
#pragma mark - private Methods
-(void)comeApper:(UIButton *)btn{
    
    _cancelBtn.userInteractionEnabled = NO;
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight - 130 - 64, DeviceWidth, 130)];
    _bottomView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    //    bottomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_bottomView];
    UIView *editView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 40)];
    editView.backgroundColor = [UIColor whiteColor];
    
    [_bottomView addSubview:editView];
    
    UIButton *editbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    editbutton.frame = CGRectMake(0, 0, DeviceWidth, 40);
    
    [editbutton setTitle:@"编辑" forState:UIControlStateNormal];
    
    [editbutton setTitleColor:UIColorFromRGB(0x32beff, 1.0) forState:UIControlStateNormal];
    
    [editbutton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    
    [editView addSubview:editbutton];
    
    UIView *cancelView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, DeviceWidth, 40)];
    
    cancelView.backgroundColor = [UIColor whiteColor];
    
    [_bottomView addSubview:cancelView];
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    cancelbutton.frame = CGRectMake(0, 0, DeviceWidth, 40);
    
    [cancelbutton setTitle:@"解除绑定" forState:UIControlStateNormal];
    
    [cancelbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [cancelbutton addTarget:self action:@selector(cancelBinding:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelView addSubview:cancelbutton];
    
    UIView *bbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 90, DeviceWidth, 40)];
    
    bbottomView.backgroundColor = [UIColor whiteColor];
    
    [_bottomView addSubview:bbottomView];
    
    UIButton *disAppearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    disAppearBtn.frame = CGRectMake(0, 0, DeviceWidth, 40);
    
    [disAppearBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [disAppearBtn setTitleColor:UIColorFromRGB(0x32beff, 1.0) forState:UIControlStateNormal];
    
    [disAppearBtn addTarget:self action:@selector(disappear:) forControlEvents:UIControlEventTouchUpInside];
    
    [bbottomView addSubview:disAppearBtn];
    
}
- (void)edit:(UIButton *)btn{
    _cancelBtn.userInteractionEnabled = YES;
    _bottomView.hidden  = YES;
    AddNewBankViewController *vc = [[AddNewBankViewController alloc]init];
    vc.bankCard = _cardNumber;
    vc.mobile = _mobie;
    vc.provinceCode = _provinceCode;
    vc.cityCode = _cityCode;
    vc.areaCode = _areaCode;//可能为空
    vc.bankType = FromEditBank;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)disappear:(UIButton *)btn{
    
    _cancelBtn.userInteractionEnabled = YES;
    
    [_bottomView removeFromSuperview];
    
    _bottomView = nil;
}
#pragma mark - Model解析
- (void)analySisDeleteBankTypeModel{
    // 默认选项卡
    if ([_bankTypeModel.head.retFlag isEqualToString:@"00000"]) {
        
        _cancelBtn.userInteractionEnabled = YES;
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:_bankTypeModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                    if (_cancelDelegate && [_cancelDelegate respondsToSelector:@selector(cancelBankBinding:)]) {
                        [_cancelDelegate cancelBankBinding:YES];
                    }
                    
                    if (_delegate && [_delegate respondsToSelector:@selector(sendBankNumber:)]) {
                        [_delegate sendBankNumber:YES];
                    }
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                    
                }
            }
        }];
        
    }else{
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:_bankTypeModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    [strongSelf disappear:nil];
                    strongSelf.cancelBtn.userInteractionEnabled = YES;
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                    if (strongSelf.cancelDelegate && [strongSelf.cancelDelegate respondsToSelector:@selector(cancelBankBinding:)]) {
                        [strongSelf.cancelDelegate cancelBankBinding:YES];
                        
                    }
                }
            }
            
        }];
        
    }
}
- (void)analySisDefaultBankTypeModel{
    if ([_bankTypeModel.head.retFlag isEqualToString:@"00000"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *str = _bankTypeModel.head.retMsg;
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:str cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *str = _bankTypeModel.head.retMsg;
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:str cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(sendBankNumber:)]) {
                        [strongSelf.delegate sendBankNumber:YES];
                    }
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}
#pragma mark -- BSVK delegate
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if (requestTag == 100) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            _bankTypeModel = [BankTypeModel mj_objectWithKeyValues:responseObject];
            
            [self analySisDeleteBankTypeModel];
            
        }else if (requestTag == 200) {
        
            _bankTypeModel = [BankTypeModel mj_objectWithKeyValues:responseObject];
            
            [self analySisDefaultBankTypeModel];
            
        }
    }
}
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
//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                
            }
        }
    }];
}
@end
