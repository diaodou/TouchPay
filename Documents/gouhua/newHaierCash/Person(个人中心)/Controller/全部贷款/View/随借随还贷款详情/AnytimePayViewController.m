//
//  AnytimePayViewController.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "AnytimePayViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "AddBankViewController.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "NSString+CheckConvert.h"
@interface AnytimePayViewController ()<UITextFieldDelegate,ChoiceDefaultBankDelegate,BSVKHttpClientDelegate>

{
    
    float x;//屏幕适配比例
    
}

@property(nonatomic,strong)UILabel *payCardNameLabel;//默认还款卡银行名称label

@property(nonatomic,strong)UILabel *payCardNumLabel;//默认还款卡卡号label

@property(nonatomic,strong)UIScrollView *baseScrollView;//基础滑动视图（主要是4s会用到）

@property(nonatomic,strong)UIButton *selectBtn;//选择全部还款或者部分还款

@property(nonatomic,strong)UITextField *payTextField;//部分还款的金额

@property(nonatomic,strong)UILabel *payMoneyLabel;//还款金额lab


@end
#pragma mark --> life Cycle
@implementation AnytimePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self creatHeaderView];
    
    [self creatCenterView];
    
    [self creatAllPayView];
    
    [self creatEndView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> private Methods

//创建基础滑动视图
-(UIScrollView *)baseScrollView{
    
    if (!_baseScrollView) {
        
        _baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64-50*x)];
        
        _baseScrollView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_baseScrollView];
        
    }
    
    return _baseScrollView;
    
}

//创建订单状态和默认还款卡一栏
-(void)creatHeaderView{
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
        
    }
    
    UIImageView *topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 42*x)];
    
    topImgView.image = [UIImage imageNamed:@"本月待还_背景"];
    
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(13*x, 10*x, 22*x, 22*x)];
    
    [topImgView addSubview:leftImg];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(45*x, 0, 100*x, 42*x)];
    
    nameLab.text = @"订单状态";
    
    nameLab.textColor = [UIColor whiteColor];
    
    nameLab.font = [UIFont appFontRegularOfSize:15*x];
    
    [topImgView addSubview:nameLab];
    
    UILabel *statusLab = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth-82*x, 0, 70*x, 42*x)];
    
    statusLab.text = @"已放款";
    
    statusLab.textAlignment = NSTextAlignmentRight;
    
    statusLab.textColor = [UIColor whiteColor];
    
    statusLab.font = [UIFont appFontRegularOfSize:15*x];
    
    [topImgView addSubview:statusLab];
    
    UIView *payCardView = [[UIView alloc]initWithFrame:CGRectMake(0, 42*x, DeviceWidth, 45*x)];
    
    payCardView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(13*x, 0, 85*x, 45*x)];
    
    titleLab.textColor = [UIColor blackColor];
    
    titleLab.text = @"默认还款卡";
    
    titleLab.font = [UIFont appFontRegularOfSize:15*x];
    
    [payCardView addSubview:titleLab];

    _payCardNameLabel = [self creatSameLabelFrame:CGRectMake(103*x, 0, 110*x, 45*x) fontNum:12*x text:@"中国工商银行" textColor:UIColorFromRGB(0x999999, 1.0)];

    [payCardView addSubview:_payCardNameLabel];
    
    
    _payCardNumLabel = [self creatSameLabelFrame:CGRectMake(DeviceWidth-100*x, 0, 70*x, 45*x) fontNum:12*x text:@"****1234" textColor:UIColorFromRGB(0x999999, 1.0)];
    
    _payCardNumLabel.textAlignment = NSTextAlignmentRight;
    
    [payCardView addSubview:_payCardNumLabel];
    
    UIImageView *rightImg = [self creatSameImgViewFrame:CGRectMake(DeviceWidth-20*x, 15*x, 9*x, 15*x) imageName:@"箭头_右_灰"];
    
    [payCardView addSubview:rightImg];
    
    UIButton *payButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 45*x)];
    
    payButton.backgroundColor = [UIColor clearColor];
    
    [payButton addTarget:self action:@selector(buildChoiceCard:) forControlEvents:UIControlEventTouchUpInside];
    
    [payCardView addSubview:payButton];
    
    if (IPHONE4) {
        
        [self.baseScrollView addSubview:topImgView];
        
        [self.baseScrollView addSubview:payCardView];
        
    }else{
        
        [self.view addSubview:topImgView];
        
        [self.view addSubview:payCardView];
        
    }
    
}

//创建中间视图
-(void)creatCenterView{
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 97*x, DeviceWidth, 245*x)];
    
    centerView.backgroundColor = [UIColor whiteColor];
    
    if (IPHONE4) {
        
        [self.baseScrollView addSubview:centerView];
        
    }else{
        
        [self.view addSubview:centerView];
        
    }
    
    //贷款编号和时间
    UILabel *timeLab = [self creatSameLabelFrame:CGRectMake(13*x, 0, DeviceWidth-158*x, 28*x) fontNum:12*x text:@"2015-08-31" textColor:UIColorFromRGB(0xa0a0a0, 1.0)];
    
    [centerView addSubview:timeLab];
    
    UILabel *idNoLab = [self creatSameLabelFrame:CGRectMake(DeviceWidth-145*x, 0, DeviceWidth, 28*x) fontNum:12*x text:@"贷款编号:  1234567890" textColor:UIColorFromRGB(0xa0a0a0, 1.0)];
    
    [centerView addSubview:idNoLab];
    
    UIView *lineOne = [self creatLineViewFrame:27.5*x];
    
    [centerView addSubview:lineOne];
    
    //商品介绍
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(13*x, 40*x, 90*x, 68*x)];
    
    leftImg.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [centerView addSubview:leftImg];
    
    UILabel *nameLab = [self creatSameLabelFrame:CGRectMake(127*x, 46*x, DeviceWidth-127*x, 20*x) fontNum:15*x text:@"现金只用，随借随还" textColor:[UIColor blackColor]];
    
    [centerView addSubview:nameLab];
    
    UILabel *moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(127*x, 76*x, DeviceWidth-127*x, 20*x)];
    
    moneyLab.textColor = UIColorFromRGB(0xf37062, 1.0);
    
    moneyLab.font = [UIFont systemFontOfSize:13*x];
    
    NSString *money = @"¥ 6799.00";
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:money];
    
    [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18*x]} range:NSMakeRange(2, money.length-2)];
    
    moneyLab.attributedText = string;
    
    [centerView addSubview:moneyLab];
    
    UIView *lineTwo = [self creatLineViewFrame:118*x];
    
    [centerView addSubview:lineTwo];
    
    //创建分期本金 息费 合计金额
    float width = DeviceWidth/3.0;
    
    UILabel *stageLab = [self creatSameLabelFrame:CGRectMake(12*x, 130*x, width-12*x, 18*x) fontNum:12*x text:@"分期本金" textColor:UIColorFromRGB(0xa0a0a0, 1.0)];
    
    [centerView addSubview:stageLab];
    
    UILabel *stageMoney = [[UILabel alloc]initWithFrame:CGRectMake(12*x, 148*x, width-12*x, 20*x)];
    
    stageMoney.textColor = UIColorFromRGB(0xfda253, 1.0);
    
    stageMoney.font = [UIFont systemFontOfSize:17*x];
    
    stageMoney.text = [NSString stringWithFormat:@"¥%@",@"37000.00"];
    
    [centerView addSubview:stageMoney];
    
    UILabel *warnLab = [self creatSameLabelFrame:CGRectMake(width, 130*x, width, 18*x) fontNum:12*x text:@"息费" textColor:UIColorFromRGB(0xa0a0a0, 1.0)];
    
    warnLab.textAlignment = NSTextAlignmentCenter;
    
    [centerView addSubview:warnLab];
    
    UILabel *typeLab = [self creatSameLabelFrame:CGRectMake(width, 145*x, width, 26*x) fontNum:16*x text:@"按日计息" textColor:UIColorFromRGB(0xfda253, 1.0)];
    
    typeLab.textAlignment = NSTextAlignmentCenter;
    
    [centerView addSubview:typeLab];
    
    UILabel *everyDayPayLabel = [self creatSameLabelFrame:CGRectMake(width, 175*x, width, 18*x) fontNum:12*x text:@"1.2元/天" textColor:UIColorFromRGB(0xa0a0a0, 1.0)];
    
    everyDayPayLabel.textAlignment = NSTextAlignmentCenter;
    
    [centerView addSubview:everyDayPayLabel];
    
    UILabel *allMoneyLab = [self creatSameLabelFrame:CGRectMake(width*2, 130*x, width, 18*x) fontNum:12*x text:@"合计金额" textColor:UIColorFromRGB(0xa0a0a0, 1.0)];
    
    allMoneyLab.textAlignment = NSTextAlignmentCenter;
    
    [centerView addSubview:allMoneyLab];
    
    UILabel *allMoney = [[UILabel alloc]initWithFrame:CGRectMake(width*2, 148*x, width, 20*x)];
    
    allMoney.textColor = UIColorFromRGB(0xfda253, 1.0);
    
    allMoney.font = [UIFont systemFontOfSize:17*x];
    
    allMoney.textAlignment = NSTextAlignmentCenter;
    
    allMoney.text = [NSString stringWithFormat:@"¥%@",@"37000.00"];
    
    [centerView addSubview:allMoney];
    
    UILabel *allDayPayLabel = [self creatSameLabelFrame:CGRectMake(width*2, 175*x, width, 18*x) fontNum:12*x text:@"1.2元/天" textColor:UIColorFromRGB(0xa0a0a0, 1.0)];
    
    allDayPayLabel.textAlignment = NSTextAlignmentCenter;
    
    [centerView addSubview:allDayPayLabel];
    
    UIView *lineThree = [self creatLineViewFrame:199.5*x];
    
    [centerView addSubview:lineThree];
    
    //分期账单
    UILabel *stageName = [self creatSameLabelFrame:CGRectMake(13*x, 200*x, 90*x, 45*x) fontNum:14*x text:@"分期账单" textColor:[UIColor blackColor]];
    
    [centerView addSubview:stageName];
    
    UILabel *payMoneyLab = [self creatSameLabelFrame:CGRectMake(DeviceWidth-165*x, 200*x, 165*x, 45*x) fontNum:13*x text:[NSString stringWithFormat:@"已还¥%@,待还¥%@",@"8000",@"29000"] textColor:UIColorFromRGB(0xa0a0a0, 1.0)];
    
    payMoneyLab.font = [UIFont systemFontOfSize:13*x];
    
    [centerView addSubview:payMoneyLab];
    
}

//创建选择全部还款，部分还款视图
-(void)creatAllPayView{
    
    UIView *payView = [[UIView alloc]initWithFrame:CGRectMake(0, 352*x, DeviceWidth, 90*x)];
    
    payView.backgroundColor = [UIColor whiteColor];
    
    if (IPHONE4) {
        
        [self.baseScrollView addSubview:payView];
        
        self.baseScrollView.contentSize = CGSizeMake(DeviceWidth, 460*x);
        
    }else{
        
        [self.view addSubview:payView];
        
    }
    
    UILabel *allLab = [self creatSameLabelFrame:CGRectMake(13*x, 0, 75*x, 45*x) fontNum:14*x text:@"全部还清" textColor:[UIColor blackColor]];
    
    [payView addSubview:allLab];
    
    UILabel *dayLab = [self creatSameLabelFrame:CGRectMake(88*x, 0, 150*x, 45*x) fontNum:12*x text:[NSString stringWithFormat:@"剩余%@天",@"5"] textColor:UIColorFromRGB(0xa0a0a0, 1.0)];
    
    [payView addSubview:dayLab];
    
    _selectBtn= [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-50*x, 12.5*x, 36*x, 20*x)];
    
    _selectBtn.backgroundColor = [UIColor clearColor];
    
    [_selectBtn setImage:[UIImage imageNamed:@"随借随还_绿"] forState:UIControlStateNormal];
    
    [_selectBtn addTarget:self action:@selector(buildSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [payView addSubview:_selectBtn];
    
    UIView *lineOne = [self creatLineViewFrame:44.5*x];
    
    [payView addSubview:lineOne];
    
    UILabel *titleLab = [self creatSameLabelFrame:CGRectMake(13*x, 45*x, 75*x, 45*x) fontNum:14*x text:@"还款本金" textColor:[UIColor blackColor]];
    
    [payView addSubview:titleLab];
    
    _payTextField = [[UITextField alloc]initWithFrame:CGRectMake(88*x, 45*x, DeviceWidth-88*x, 45*x)];
    
    _payTextField.placeholder = @"可部分还款";
    
    _payTextField.delegate = self;
    
    _payTextField.font = [UIFont appFontRegularOfSize:12*x];
    
    _payTextField.backgroundColor = [UIColor clearColor];
    
    _payTextField.textColor = UIColorFromRGB(0xa0a0a0, 1.0);
    
    _payTextField.userInteractionEnabled = NO;
    
    [payView addSubview:_payTextField];
}

//创建底部还款按钮视图
-(void)creatEndView{
    
    UIView *endView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight-64-50*x, DeviceWidth, 50*x)];
    
    endView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:endView];
    
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(13*x, 15*x, 20*x, 20*x)];
    
    leftImg.image = [UIImage imageNamed:@"图标_选中"];
    
    [endView addSubview:leftImg];
    
    UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(44*x, 0, 65*x, 50*x)];
    
    leftLab.backgroundColor = [UIColor whiteColor];
    
    leftLab.textColor = [UIColor blackColor];
    
    leftLab.font = [UIFont appFontRegularOfSize:15*x];
    
    leftLab.text = @"还款总额";
    
    [endView addSubview:leftLab];
    
    _payMoneyLabel = [self creatSameLabelFrame:CGRectMake(105*x, 0, 85*x, 50*x) fontNum:15*x text:[NSString stringWithFormat:@"¥%@",@"29000"] textColor:UIColorFromRGB(0xf15a4a, 1.0)];
    
    _payMoneyLabel.font = [UIFont systemFontOfSize:15*x];
    
    [endView addSubview:_payMoneyLabel];
    
    UIButton *patButton = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-125*x, 0, 125*x, 50*x)];
    
    patButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [patButton setTitle:@"立即还款" forState:UIControlStateNormal];
    
    patButton.titleLabel.font = [UIFont appFontRegularOfSize:15*x];
    
    [patButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [patButton addTarget:self action:@selector(buildPayMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [endView addSubview:patButton];

}

//创建模板label
-(UILabel *)creatSameLabelFrame:(CGRect)frame fontNum:(NSInteger)font text:(NSString *)string textColor:(UIColor *)color{
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:frame];
    
    titleLab.textColor = color;
    
    titleLab.text = string;
    
    titleLab.font = [UIFont appFontRegularOfSize:font];
    
    return titleLab;

}

//创建模板imageview
-(UIImageView *)creatSameImgViewFrame:(CGRect)frame imageName:(NSString *)name{
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:frame];
    
    imgView.image = [UIImage imageNamed:name];
    
    return imgView;
    
}

//创建模板线条
-(UIView *)creatLineViewFrame:(float)frame{
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, frame, DeviceWidth, 0.5*x)];
    
    line.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    return line;
    
}

#pragma mark --> event Methods

//选择默认还款卡
-(void)buildChoiceCard:(UIButton *)sender{
    
    AddBankViewController *bankVc = [[AddBankViewController alloc]init];
    
    bankVc.choiceBank = choicePayCard;
    
    bankVc.choiceDefaultDelegate = self;
    
    [self.navigationController pushViewController:bankVc animated:YES];
    
}

//选择开关方法
-(void)buildSelectAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        _payTextField.userInteractionEnabled = YES;
        
        _payMoneyLabel.text = @"";
        
        [_selectBtn setImage:[UIImage imageNamed:@"随借随还_灰"] forState:UIControlStateSelected];
        
    }else{
        
        _payTextField.userInteractionEnabled = NO;
        
        _payTextField.text = @"";
        
        [_selectBtn setImage:[UIImage imageNamed:@"随借随还_绿"] forState:UIControlStateSelected];
        
    }
    
}

//点击立即还款方法
-(void)buildPayMoneyAction:(UIButton *)sender{
    
    
    
}

#pragma mark --> 选择还款卡代理方法

-(void)choiceBank:(BankInfo *)backinfo{
    
    _payCardNameLabel.text = backinfo.bankName;
    
    NSString *string = [backinfo.cardNo substringFromIndex:backinfo.cardNo.length-4];
    
    _payCardNumLabel.text = [NSString stringWithFormat:@"****%@",string];
    
}

#pragma mark --> textField代理

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length > 0 && [textField.text isValidateMoneyInput]) {
        
        _payMoneyLabel.text = [NSString stringWithFormat:@"¥%@",textField.text];
        
    }else if (![textField.text isValidateMoneyInput]){
      
        [self buildHeadError:@"请输入正确的还款金额"];
        
        _payTextField.text = @"";
        
        _payMoneyLabel.text = @"";
        
    }else{
        
        _payMoneyLabel.text = @"";
        
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark --> 网络请求代理协议

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        
        
    }
    
}

//连接失败
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *errorStr;
        
        if(httpCode  != 0)
        {
            errorStr = [NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode ];
        }
        else
        {
            errorStr = @"网络环境异常，请检查网络并重试";
        }
        
        [self buildHeadError:errorStr];
        
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


@end
