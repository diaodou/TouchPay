//
//  NewNumberViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "NewNumberViewController.h"
#import "HCMacro.h"
#import "RMUniversalAlert.h"
#import "WriteVerificationViewController.h"
#import "RealNameViewController.h"
#import "UIFont+AppFont.h"
//#import "LittleToolClass.h"
#import "NSString+CheckConvert.h"
#import "UIButton+LazyButton.h"
@interface NewNumberViewController ()
@property (nonatomic,strong)UIView *bjView;
@property (nonatomic,strong)UITextField * numTextField;
@property(nonatomic,strong)UIButton *nextBtn;
@end

@implementation NewNumberViewController
#pragma mark -- lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"输入新的手机号";
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self creatTextField];//输入框
    [self creatLineView];//底线
    [self creatBtn];//按钮
    [self setLineView];
}

#pragma mark - setting and getting
- (void)setLineView{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self.view addSubview:lineView];
}
// -- 输入框
-(void)creatTextField{
    
    UIView * bjView = [[UIView alloc]init];
    
    _numTextField = [[UITextField alloc]init];
    
    _numTextField.secureTextEntry = YES;
    
    bjView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    if (iphone6P) {
        
        bjView.frame = CGRectMake(47,47, DeviceWidth - 94, 50);
        
        bjView.layer.cornerRadius = 25;
        
        _numTextField.frame = CGRectMake(20,0, bjView.frame.size.width - 30, 50);
    }else{
        
        bjView.frame = CGRectMake(42 *DeviceWidth/375,42*DeviceWidth/375, DeviceWidth - 82*DeviceWidth/375, 45*DeviceWidth/375);
        
        bjView.layer.cornerRadius = 22.5*DeviceWidth/374;
        
        _numTextField.frame = CGRectMake(16 *DeviceWidth/375,0, bjView.frame.size.width - 16*DeviceWidth/375, 45*DeviceWidth/375);
    }
    
    [self.view addSubview:bjView];
    _numTextField.placeholder = @"请输入新的手机号";
    _numTextField.font = [UIFont appFontRegularOfSize:13];
    _numTextField.keyboardType = UIKeyboardTypeDefault;
    
    _numTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bjView addSubview:_numTextField];
    
    
}
// -- 按钮
-(void)creatBtn{
    _nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    if (iphone6P) {
        _nextBtn.frame = CGRectMake(47 , 120, DeviceWidth - 94, 50);
        _nextBtn.layer.cornerRadius = 25;
        
    }else{
        _nextBtn.frame = CGRectMake(42 *DeviceWidth/375 , 110, DeviceWidth - 84 *DeviceWidth/375, 45*DeviceWidth/375);
        _nextBtn.layer.cornerRadius = 22.5*DeviceWidth/374;
    }
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:UIColorFromRGB(0x32beff, 1.0)];
    [_nextBtn addTarget:self action:@selector(ToNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    _nextBtn.bIgnoreEvent = NO;
    _nextBtn.lazyEventInterval = 0.5;
}

// set lineView
-(void)creatLineView{
    UIView *lineView = [[UIView alloc]init];
    if (IPHONE4) {
        lineView.frame = CGRectMake(30 , 70, _bjView.frame.size.width - 60, 1);
        lineView.backgroundColor = [UIColor colorWithRed:0.9647 green:0.9686 blue:0.9765 alpha:1.0];
        [_bjView addSubview:lineView];
    }
    if (iPhone5) {
        lineView.frame = CGRectMake(30 , 70, _bjView.frame.size.width - 60, 1);
        lineView.backgroundColor = [UIColor colorWithRed:0.9647 green:0.9686 blue:0.9765 alpha:1.0];
        [_bjView addSubview:lineView];
    }if (iphone6) {
        lineView.frame = CGRectMake(30 , 70, _bjView.frame.size.width - 60, 1);
        lineView.backgroundColor = [UIColor colorWithRed:0.9647 green:0.9686 blue:0.9765 alpha:1.0];
        [_bjView addSubview:lineView];
    }if (iphone6P) {
        lineView.frame = CGRectMake(30 , 70, _bjView.frame.size.width - 60, 1);
        lineView.backgroundColor = [UIColor colorWithRed:0.9647 green:0.9686 blue:0.9765 alpha:1.0];
        [_bjView addSubview:lineView];
    }
}
#pragma mark - private Methods
-(void)ToNext{
    
    NSString * numberStr = [_numTextField.text deleteSpeaceString];
    
    _numTextField.text = numberStr;
    
    if (![self checkNumberVaildMobile:_numTextField.text]) {//判断11位纯数字
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请输入11位手机号" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];

        return;
    }
    
    if (_numTextField.text.length == 0) {
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请输入新的手机号" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
    }else if(_numTextField.text.length < 11 || _numTextField.text.length > 11){
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"手机号码格式不正确" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
    }else{
        [_numTextField resignFirstResponder];
        NSString *title = NSLocalizedString(@"确认手机号码", nil);
        NSString *message = [NSString stringWithFormat:@"我们将发送短信验证码到这个手机号：%@",_numTextField.text];
        
        if (self.chageBindNumType == ChangeBindPhoneNumByRealNameType)
        {
            RealNameViewController *realNameVC = [[RealNameViewController alloc]init];
            realNameVC.strTel = _numTextField.text;
            realNameVC.realNameChageBindPhoneNumType = RealNameChageBindPhoneNumByRealNameType;
            [self.navigationController pushViewController:realNameVC animated:YES];
        }
        else
        {
            [RMUniversalAlert showAlertInViewController:self withTitle:title message:message cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"好"] tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                if (buttonIndex == 2)
                {
                    WriteVerificationViewController *vc = [[WriteVerificationViewController alloc]init];
                    vc.writeVerificationChageBindPhoneNumType = WriteVerificationChangeSecondTelByCheckCode;
                    vc.strTel = _numTextField.text;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_numTextField resignFirstResponder];
}
//dian话验证
-(BOOL)checkNumberVaildMobile:(NSString *)number{
    if ( number == nil || [number isEqualToString:@""]) {
        return NO;
    }
    NSString *temp = number;
    number = [number  stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(number.length > 0) {
        //包含非数字
        return NO;
    } else {
        //都是数字
        
        if (temp.length == 11) {
            
            return YES;
            
        }else{
            
            return NO;
        }
        
        
    }
    
}


@end
