//
//  AnyTimeBackController.m
//  personMerchants
//
//  Created by 张久健 on 16/4/13.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "AnyTimeBackController.h"
#import "LoanTopView.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "LoanDetailCommonView.h"
#import "ConfirmPayViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import "LoanDetailModel.h"
#import <MJExtension.h>
#import "StageBillModel.h"
#import "StageApplicationModel.h"
#import <YYWebImage.h>
#import "AmountModel.h"
#import <MJExtension.h>
#import "ContractShowViewController.h"
#import "RepayDetailViewCcontroller.h"
#import "ChangDefaultBankView.h"
#import "AddBankViewController.h"
#import "ChangeDefaultBankModel.h"
#import "UILabel+SizeForStr.h"
#import "LoanDetailModel.h"
@interface AnyTimeBackController ()<BSVKHttpClientDelegate,UITextFieldDelegate,ChoiceDefaultBankDelegate>{
    NSString *_bj;    //本金(全部还款)
    NSString *_sxf;   //手续费(全部还款)
    NSString *_xf;    //息费(全部还款)
    NSString *_bankName;
    NSString *_bankNumber;
    NSString *_bankType;
    NSString *_changeBankType;
    NSString *_totalMoney;//保存总额
    NSString *_payMoney;//还款金额

}
@property(nonatomic,strong) UIView * contractView;
@property(nonatomic,strong) UIButton * contractBtn;//合同按钮
@property(nonatomic,strong) UITextField * money;
@property(nonatomic,strong) UISwitch *swt;
@property(nonatomic,strong) LoanDetailCommonView *loanView;
@property(nonatomic,strong) NSString * payMode;//还款模式
@property(nonatomic,strong) ChangDefaultBankView *changeBankView;
@property(nonatomic,strong) UIView * mbView;
@property(nonatomic,strong) LoanDetailModel * loanDtailModel;//贷款详情model
@property(nonatomic,strong) UIButton *detailBtn;     //详情按钮
@property(nonatomic,strong) UILabel *moneyLabel;     //还款金额label
@property(nonatomic,strong) UILabel *feeLabel;       //息费label
@end

@implementation AnyTimeBackController
#pragma mark - lift cucly
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    self.title = @"随借随还(待还款)";
    [self setNavi];
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    查询贷款详情
    [self creatDetailReq];
}
#pragma mark - setting and getting
//设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn:(UIButton *)btn
{
    
    [AppDelegate delegate].userInfo.bReturn = YES;
    [_mbView removeFromSuperview];
    _mbView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUI
{
    //底部的滚动视图
    UIScrollView *baseSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64 - 49)];
    [self.view addSubview:baseSV];
    
    
    _changeBankView = [[ChangDefaultBankView alloc]init];
    _changeBankView.frame = CGRectMake(0, 0, DeviceWidth, 104);
    [baseSV addSubview:_changeBankView];
    
    _changeBankView.stateLabel.text = @"待还款";
    _changeBankView.arrow.hidden = NO;
    
    UITapGestureRecognizer *tapGuest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBank)];
    [_changeBankView.bottomView addGestureRecognizer:tapGuest];
    
    LoanDetailCommonView * loanView = [[LoanDetailCommonView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_changeBankView.frame), DeviceWidth, [LoanDetailCommonView heightView:loanProductDetailCommit])];
    loanView.loanHandlingType = loanProductDetailCommit;
    loanView.loanTopView.labelMidContent.font = [UIFont appFontRegularOfSize:14];
    loanView.loanTopView.labelRight.font = [UIFont systemFontOfSize:12];
    _loanView = loanView;
    [baseSV addSubview:loanView];
    
    //填充的view
    UIView *temp = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(loanView.frame), DeviceWidth, 10))];
    temp.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    [baseSV addSubview:temp];
    
    //全部还清的view
    UIView *first = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(loanView.frame) + 10, DeviceWidth, 52))];
    UILabel * allBack = [[UILabel alloc]initWithFrame:(CGRectMake(30, 18, 60, 16))];
    allBack.text = @"全部还清";
    allBack.textAlignment = NSTextAlignmentCenter;
    allBack.font = [UIFont appFontRegularOfSize:14];
    first.backgroundColor = [UIColor whiteColor];
    [first addSubview:allBack];
    [baseSV addSubview:first];
    first.tag = 10000;
    
    //开关
    UISwitch * swt = [[UISwitch alloc]initWithFrame:(CGRectMake(308 * DeviceWidth/375, 12, 0, 0))];
    swt.transform = CGAffineTransformMakeScale(0.75, 0.75);
    if(self.swt)
    {
        swt.on = self.swt.on;
        [self swtChangeAction];
    }
    self.swt = swt;
    [swt addTarget:self action:@selector(swtChangeAction) forControlEvents:(UIControlEventTouchUpInside)];
    [first addSubview:swt];
    
    //剩余几天
    UILabel * day = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(allBack.frame) + 20, 18, 100, 16))];
    day.textColor = UIColorFromRGB(0x999999, 1.0);
    day.font = [UIFont appFontRegularOfSize:11];
    [first addSubview:day];
    day.tag = 10001;
    
    //线条
    UIView *line = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(first.frame), DeviceWidth, 1))];
    line.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    [baseSV addSubview:line];
    
    //下部View
    UIView *sencond = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(line.frame), DeviceWidth, 52))];
    sencond.backgroundColor = [UIColor whiteColor];
    
    //还款金额
    UILabel * moneylab = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMinX(allBack.frame), 18, CGRectGetWidth(allBack.frame), 16))];
    moneylab.font = [UIFont appFontRegularOfSize:14];
    moneylab.text = @"还款本金";
    [sencond addSubview:moneylab];
    
    //可部分还款
    UITextField * textField = [[UITextField alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(moneylab.frame) + 20, 18, 100, 16))];
    textField.font = [UIFont appFontRegularOfSize:14];
    textField.textColor = UIColorFromRGB(0x999999, 1.0);
    textField.placeholder = @"可部分还款";
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.money = textField;
    self.money.delegate = self;
    [sencond addSubview:self.money];
    [baseSV addSubview:sencond];
    
    [self createBottomView];
    
    if(CGRectGetMaxY(sencond.frame) > DeviceHeight - 64 - 49)
    {
        baseSV.contentSize = CGSizeMake(DeviceWidth, CGRectGetMaxY(sencond.frame));
    }
    else
    {
        baseSV.contentSize = CGSizeMake(DeviceWidth, DeviceHeight - 64 - 49);
    }
}

- (void)createBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, DeviceHeight-49-64, DeviceWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderWidth = 0.5f;
    bottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:bottomView];
    
    //金额
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.attributedText = [self fomatMoney:@"0"];
    moneyLabel.frame = CGRectMake(10, 0, DeviceWidth-145*scaleAdapter-30, 49);
    [bottomView addSubview:moneyLabel];
    
    self.moneyLabel = moneyLabel;
    
    UILabel *feeLabel = [[UILabel alloc] init];
    feeLabel.frame = CGRectMake(10, 25, DeviceWidth-145*scaleAdapter-30, 19);
    feeLabel.attributedText = [self fomatCountFee:@"0"];
    feeLabel.hidden = YES;
    [bottomView addSubview:feeLabel];
    
    self.feeLabel = feeLabel;
    
    //还款明细按钮
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(DeviceWidth-145*scaleAdapter-30, (49-18)/2, 18, 18);
    [detailBtn setImage:[UIImage imageNamed:@"还款明细"] forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(toRepayDetail) forControlEvents:UIControlEventTouchUpInside];
    detailBtn.hidden = YES;
    [bottomView addSubview:detailBtn];
    
    self.detailBtn = detailBtn;
    //确认还款
    UIButton *payBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBackBtn.frame = CGRectMake(DeviceWidth-145*scaleAdapter, 7, 130*scaleAdapter, 36);
    payBackBtn.backgroundColor = UIColorFromRGB(0x028de5, 1.0);
    [payBackBtn setTitle:@"立即还款" forState:UIControlStateNormal];
    [payBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBackBtn addTarget:self action:@selector(payBack:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:payBackBtn];
}
- (void)creatContractBtn
{
    _contractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _contractBtn.frame = CGRectMake(DeviceWidth - 40, 10, 40, 40);
    [_contractBtn setImage:[UIImage imageNamed:@"邀请圆"] forState:UIControlStateNormal];
    [_contractBtn addTarget:self action:@selector(comeContract) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_contractBtn];
}
#pragma mark - private Methods
- (void)changeBank{
    
//    if (self.swt.on) {
//      
//       
//
//        
//    }else{
//       
//        if (_payMoney) {
//            
//            NSString *result = [self buildResultMoney:_totalMoney jack:_payMoney];
//            
//            AddBankViewController * bank = [[AddBankViewController alloc]init];
//            
//            bank.choiceBank = choicePayCard;
//            
//            bank.choiceDefaultDelegate = self;
//            
//            if ([self isJudgeOneString:result twoString:_payMoney]) {
//                
//                bank.payMaxMoney = result;
//                
//            }else{
//                
//                bank.payMaxMoney = _payMoney;
//            }
//            
//            [self.navigationController pushViewController:bank animated:YES];
//            
//        }
//        
//    }
    
    AddBankViewController * bank = [[AddBankViewController alloc]init];
    
    bank.choiceBank = choiceDefaultCard;
    
    bank.choiceDefaultDelegate = self;
    
    //bank.payMaxMoney = _totalMoney;
    
    [self.navigationController pushViewController:bank animated:YES];
    
    
}
-(NSString *)buildResultMoney:(NSString*)number  jack:(NSString*)rose{
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *like = [[NSDecimalNumber alloc]initWithString:number];
    
    NSDecimalNumber *look = [[NSDecimalNumber alloc]initWithString:rose];
    
    return [like decimalNumberBySubtracting:look withBehavior:roundUp].stringValue;
    
}
-(BOOL)isJudgeOneString:(NSString *)jack twoString:(NSString *)rose{
    
    NSDecimalNumber *kiss = [[NSDecimalNumber alloc]initWithString:jack];
    
    NSDecimalNumber *kill  =[[NSDecimalNumber alloc]initWithString:rose];
    
    if (([kiss compare:kill] == NSOrderedDescending)) {
        
        return YES;
        
    }else{
        
        return NO;
    }
}
//选择默认还款卡代理
- (void)choiceBank:(BankInfo *)backinfo{
    
    _bankName = backinfo.bankName;
    
    _bankNumber = backinfo.cardNo;
    
    _changeBankType = backinfo.cardTypeName;
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/changeHkCard" requestArgument:@{@"applSeq":StringOrNull(_loanDtailModel.body.applSeq),@"cardNo":StringOrNull(backinfo.cardNo)} requestTag:100 requestClass:NSStringFromClass([self class])];
}
-(void)payBack:(UIButton *)btn{
    
    if ([_payMoney floatValue] > 0 &&([[NSDecimalNumber decimalNumberWithString:_payMoney] compare:[NSDecimalNumber decimalNumberWithString:_loanDtailModel.body.repayPrcpAmt]] == NSOrderedAscending)) {
        ConfirmPayViewController *vc = [[ConfirmPayViewController alloc]init];
        vc.loanNo = _loanNoStr;//借据号
        vc.totalAmt = _payMoney;//总额
        vc.parmCard = _loanDtailModel.body.repayApplCardNo;//卡号
        vc.bankName = _loanDtailModel.body.repayAccBankName;//卡名
        vc.bankTyp = _bankType;//卡类型
        vc.payMode = @"ER";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (([[NSDecimalNumber decimalNumberWithString:_payMoney] compare:[NSDecimalNumber decimalNumberWithString:_loanDtailModel.body.repayPrcpAmt]] == NSOrderedSame)){
        ConfirmPayViewController *vc = [[ConfirmPayViewController alloc]init];
        vc.loanNo = _loanNoStr;//借据号
        vc.totalAmt = _totalMoney;//总额
        vc.parmCard = _loanDtailModel.body.repayApplCardNo;//卡号
        vc.bankName = _loanDtailModel.body.repayAccBankName;//卡名
        vc.bankTyp = _bankType;//卡类型
        vc.payMode = @"FS";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        [self buildHeadError:@"请检查还款总额是否正确！"];
        
    }
    
}
//开关的打开关闭
- (void)swtChangeAction
{
    //数据管理者
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    if (self.swt.on)
    {
        self.detailBtn.hidden = NO;
        self.money.textColor = [UIColor blackColor];
        self.money.textAlignment = NSTextAlignmentLeft;
        self.money.font = [UIFont appFontBoldOfSize:14];
        NSString *textMoney = @"";
        //关闭交互
        self.money.userInteractionEnabled = NO;
        self.money.text = _loanDtailModel.body.repayPrcpAmt;
        
        _payMoney = _loanDtailModel.body.repayPrcpAmt;
        //剩余本金 + 费用 + 利息
        if (_loanDtailModel.body.repayPrcpAmt && _loanDtailModel.body.repayPrcpAmt.length > 0 && _loanDtailModel.body.psNormIntAmt && _loanDtailModel.body.psNormIntAmt.length > 0 && _loanDtailModel.body.feeAmt && _loanDtailModel.body.feeAmt.length > 0)
        {
            textMoney = [NSString stringWithFormat:@"%@",[[[NSDecimalNumber decimalNumberWithString:StringOrNull(_loanDtailModel.body.repayPrcpAmt)] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:StringOrNull(_loanDtailModel.body.psNormIntAmt)]] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:StringOrNull(_loanDtailModel.body.feeAmt) ]withBehavior:roundUp]];
        }
        
        //主动查询还款金额
        [self searchAmonutByLoanNo:_loanNoStr Amount:textMoney AndPayMode:@"FS"];
        _payMode = @"FS";
    }else
    {
        self.moneyLabel.attributedText = [self fomatMoney:@"0"];
        self.feeLabel.attributedText = [self fomatCountFee:@"0"];
        self.detailBtn.hidden = YES;
        self.money.textColor = UIColorFromRGB(0x3333333, 1.0);
        self.money.font = [UIFont appFontRegularOfSize:14];
        self.money.text = @"";
        self.money.placeholder = @"可部分还款";
        self.money.textAlignment = NSTextAlignmentLeft;
        //打开用户交互
        self.money.userInteractionEnabled = YES;
        if (!(self.money.text.length > 0))
        {
            self.moneyLabel.attributedText = [self fomatMoney:@"0"];
            self.feeLabel.attributedText = [self fomatCountFee:@"0"];
            _payMoney = @"0";
        }
    }
}
- (void)setValuesForLoanView:(LoanDetailModel*)model
{
    //数据管理者
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    //分期本金
    _loanView.priManey.text = [NSString stringWithFormat:@"%.2f",[NSDecimalNumber decimalNumberWithString:model.body.apprvAmt].floatValue];
    //息费
    _loanView.divManey.text = [NSString stringWithFormat:@"按日计息\n每日%@元",model.body.rlx];
    _loanView.divManey.numberOfLines = 0;
    CGFloat labelHeight = [_loanView.divManey boundingRectWithSize:CGSizeMake(DeviceWidth/3,0)].height;
    if (labelHeight < 14) {
        labelHeight = 14;
    }
    _loanView.divManey.frame = CGRectMake(DeviceWidth/3, CGRectGetMinY(_loanView.priManey.frame) - 5, DeviceWidth/3, labelHeight);
    
    _loanView.totalManey.text = [NSString stringWithFormat:@"本金+%@元/日",model.body.rlx];
    CGFloat totalManeyHeight = [_loanView.totalManey boundingRectWithSize:CGSizeMake(DeviceWidth/3,0)].height;
    if (totalManeyHeight < 14) {
        totalManeyHeight = 14;
    }
    _loanView.totalManey.numberOfLines = 0;
    _loanView.totalManey.frame = CGRectMake(DeviceWidth*2/3,CGRectGetMinY(_loanView.divManey.frame), DeviceWidth/3, totalManeyHeight);
    //保存全部金额
    //分期本金 + 息费
    _totalMoney =[NSString stringWithFormat:@"%.2f", [[[NSDecimalNumber decimalNumberWithString:_loanDtailModel.body.repayPrcpAmt] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:_loanDtailModel.body.psNormIntAmt] withBehavior:roundUp] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:_loanDtailModel.body.feeAmt] withBehavior:roundUp].floatValue];
    
    //日期
    _loanView.loanTopView.labelTime.text = model.body.applyDt;
    //贷款编号
    _loanView.loanTopView.labelState.text = [NSString stringWithFormat:@"贷款编号%@",[AppDelegate delegate].userInfo.applSeq];
    _loanView.loanTopView.viewIcon.backgroundColor = [UIColor yellowColor];
    
    //中间的标题
    if ( [model.body.typGrp isEqualToString:@"02"])
    {
        _loanView.loanTopView.labelMidContent.text = @"现金随借随还";
        
    }else if ([model.body.typGrp isEqualToString:@"01"])
    {
        if([model.body.goods[0].goodsName rangeOfString:@"goodname"].location !=NSNotFound)
        {
            NSRange range  = [model.body.goods[0].goodsName rangeOfString:@"goodname"];
            
            _loanView.loanTopView.labelMidContent.text = [model.body.goods[0].goodsName substringFromIndex:range.location+range.length];  //名称
        }
        else
        {
            _loanView.loanTopView.labelMidContent.text = model.body.goods[0].goodsName;
        }
    }else{
         _loanView.loanTopView.labelMidContent.text = @"";
        
    }
    
    //model中无图片url
    [_loanView.loanTopView.viewIcon yy_setImageWithURL:[NSURL URLWithString:@""] placeholder:[UIImage imageNamed:@"贷款列表默认图片"] options:YYWebImageOptionProgressiveBlur completion:nil];
    //头部的view
    //每期多少钱
    _loanView.loanTopView.labelRight.text = [NSString stringWithFormat:@"¥%.2f",[model.body.repayPrcpAmt floatValue]];
    
    //暂时 剩余本金  待还
    _loanView.loanTopView.labelRight.font = [UIFont systemFontOfSize:12];
    _loanView.summary.text = [NSString stringWithFormat:@"已还%.2f元，待还本金%.2f元",[model.body.setlPrcpAmt floatValue],[model.body.repayPrcpAmt floatValue]];
    //底部View赋值  利息 + 费用
}

- (void)comeContract
{
    _mbView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64)];
    
    _mbView.backgroundColor = [UIColor colorWithRed:0.30f green:0.30f blue:0.30f alpha:0.50f];
    
    [self.view addSubview:_mbView];
    _contractBtn.userInteractionEnabled = NO;
    _contractView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight - 85 - 64, DeviceWidth, 85)];
    _contractView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [_mbView addSubview:_contractView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 4.5, DeviceWidth, 38)];
    topView.backgroundColor = [UIColor whiteColor];
    [_contractView addSubview:topView];
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelbutton.frame = CGRectMake(0, 0, DeviceWidth, 38);
    [cancelbutton setTitle:@"查看合同" forState:UIControlStateNormal];
    [cancelbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelbutton addTarget:self action:@selector(seeContract) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelbutton];
    
    UIView *bbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 47.5, DeviceWidth, 38)];
    
    bbottomView.backgroundColor = [UIColor whiteColor];
    [_contractView addSubview:bbottomView];
    
    UIButton *disAppearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    disAppearBtn.frame = CGRectMake(0, 0, DeviceWidth, 40);
    [disAppearBtn setTitle:@"取消" forState:UIControlStateNormal];
    [disAppearBtn addTarget:self action:@selector(disappear:) forControlEvents:UIControlEventTouchUpInside];
    [bbottomView addSubview:disAppearBtn];
}

- (void)disappear:(UIButton *)btn
{
    NSLog(@"取消");
    [_mbView removeFromSuperview];
    _mbView = nil;
    _contractBtn.userInteractionEnabled = YES;
    [_contractView removeFromSuperview];
    _contractView = nil;
}
- (void)seeContract{//个人借款合同
    [_mbView removeFromSuperview];
    _mbView = nil;
    _contractView.hidden = YES;
    _contractBtn.userInteractionEnabled = YES;
    //File Url
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* fileUrl = [NSString stringWithFormat:@"%@app/appserver/downContractPdf?applseq=%@",baseUrl,[AppDelegate delegate].userInfo.applSeq];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance]downFile:fileUrl requestArgument:@{@"applseq":[AppDelegate delegate].userInfo.applSeq} requestTag:1000 requestClass:NSStringFromClass([self class])];
    
}
- (void)jumpShowPdf:(NSURL *)targetPath {
    
    ContractShowViewController *vc = [[ContractShowViewController alloc]init];
    vc.path = targetPath;
    vc.title = @"个人借款合同";
    vc.quote = zhanshi;
    vc.showState = @"show";
    HCRootNavController *navi = [[HCRootNavController alloc]initWithRootViewController:vc];
    [self.navigationController presentViewController:navi animated:YES completion:^{
    } ];
}

- (NSAttributedString *)fomatMoney:(NSString *)money
{
    NSString *newMoney = [NSString stringWithFormat:@"%.2f",money.floatValue];
    NSString *moneyStr = [NSString stringWithFormat:@"还款总额:%@",newMoney];
    NSRange moneyRange = [moneyStr rangeOfString:newMoney];
    
    NSMutableAttributedString *attiText = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    
    [attiText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, moneyRange.location-1)];
    
    [attiText addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}  range:NSMakeRange(moneyRange.location, moneyRange.length)];
    
    return attiText;
}

- (NSAttributedString *)fomatCountFee:(NSString *)countFee
{
    NSString *newCountFee = [NSString stringWithFormat:@"%.2f",countFee.floatValue];
    NSString *countFeeStr = [NSString stringWithFormat:@"含%@元息费",newCountFee];
    NSRange countFeeRange = [countFeeStr rangeOfString:newCountFee];
    
    NSMutableAttributedString *attiText = [[NSMutableAttributedString alloc] initWithString:countFeeStr];
    
    [attiText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0, 1)];
    
    [attiText addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:11]}  range:NSMakeRange(countFeeRange.location, countFeeRange.length)];
    
    [attiText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(countFeeRange.location+countFeeRange.length, countFeeStr.length-(countFeeRange.location+countFeeRange.length))];
    
    return attiText;
}

- (void)toRepayDetail
{
    //先查询详情
    [self searchAmonutByLoanNo:_loanNoStr Amount:_payMoney AndTag:103];
}

- (void)toDetailViewController
{
    if ([_payMoney floatValue] > 0 &&([[NSDecimalNumber decimalNumberWithString:_payMoney] compare:[NSDecimalNumber decimalNumberWithString:_loanDtailModel.body.repayPrcpAmt]] == NSOrderedAscending))
    {
        RepayDetailViewCcontroller *rePayVC = [[RepayDetailViewCcontroller alloc] init];
        rePayVC.isOverdue = NO;
        //分期本金
        rePayVC.principal = _bj;
        //手续费
        rePayVC.counterFee = _sxf;
        //息费
        rePayVC.interest = _xf;
        rePayVC.loanNo = _loanNoStr;//借据号
        rePayVC.totalAmt = _payMoney;//总额
        rePayVC.payMode = @"ER";
        [self.navigationController pushViewController:rePayVC animated:YES];
    }else if (([[NSDecimalNumber decimalNumberWithString:_payMoney] compare:[NSDecimalNumber decimalNumberWithString:_loanDtailModel.body.repayPrcpAmt]] == NSOrderedSame))
    {
        RepayDetailViewCcontroller *rePayVC = [[RepayDetailViewCcontroller alloc] init];
        rePayVC.isOverdue = NO;
        //分期本金
        rePayVC.principal = _bj;
        //手续费
        rePayVC.counterFee = _sxf;
        //息费
        rePayVC.interest = _xf;
        rePayVC.loanNo = _loanNoStr;//借据号
        rePayVC.totalAmt = _totalMoney;//总额
        rePayVC.payMode = @"FS";
        [self.navigationController pushViewController:rePayVC animated:YES];
    }else
    {
        [self buildHeadError:@"请检查还款总额是否正确！"];
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

#pragma mark -- BSVK delegate
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if (requestTag == 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([_haveContract isEqualToString:@"1"]) {
                
                [self creatContractBtn];
            }
            //查询剩余天数
            StageBillModel *model = [StageBillModel mj_objectWithKeyValues:responseObject];
            
            [self analySisStageBillModel:model];
            
        }else if (requestTag == 103){//还款试算
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AmountModel *model = [AmountModel mj_objectWithKeyValues:responseObject];
            [self analySisAmountModel:model];

        }else if (requestTag == 2){//可能输入的金额刚好等于试算的金额
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AmountModel *model = [AmountModel mj_objectWithKeyValues:responseObject];
            
            if ([model.head.retFlag isEqualToString:@"00000"])
            {
                
                _totalMoney = model.body.ze;
                _bj = model.body.bj;
                _sxf = model.body.sxf;
                _xf = model.body.xf;
            }else
            {
                
                [self buildHeadError:model.head.retMsg];
            }
        }else if (requestTag == 100){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            ChangeDefaultBankModel *model = [ChangeDefaultBankModel mj_objectWithKeyValues:responseObject];
            [self analySisChangeDefaultBankModel:model];
            
        }else if (requestTag == 10){//贷款详情查询
            
           _loanDtailModel = [LoanDetailModel mj_objectWithKeyValues:responseObject];
            
            if ([_haveContract isEqualToString:@"1"]) {
                
                [self creatContractBtn];
            }
            
            [self analySisLoanDetailModel];
        }
        else if (requestTag == 104)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AmountModel *model = [AmountModel mj_objectWithKeyValues:responseObject];
            [self analySisAmountModelPayMode:model];
        }
    }
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error);
        
        NSLog(@"%ld",(long)requestTag);
        
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
}

- (void)downFile:(NSInteger)requestTag theFilePath:(NSURL *)filePath requestError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (error.code == 200 || !error) {
        [self jumpShowPdf:filePath];
    }else if (error.code == 404){
        [self buildHeadError:@"文件不存在"];
    }else {
        [self buildHeadError:error.localizedDescription];
    }
}

#pragma mark textField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //改变还款总额
    if(textField.text.length > 0)
    {
        _payMoney = textField.text;
        if([[NSDecimalNumber decimalNumberWithString:_payMoney] compare:[NSDecimalNumber decimalNumberWithString:_loanDtailModel.body.repayPrcpAmt]] == NSOrderedSame)
        {
            self.detailBtn.hidden = NO;
            _payMode = @"FS";
            [self searchAmonutByLoanNo:_loanNoStr Amount:_payMoney AndPayMode:@"FS"];
        }else if(textField.text.intValue > 0 && [[NSDecimalNumber decimalNumberWithString:_payMoney] compare:[NSDecimalNumber decimalNumberWithString:_loanDtailModel.body.repayPrcpAmt]] == NSOrderedAscending)
        {
            self.detailBtn.hidden = YES;
            _payMode = @"ER";
             [self searchAmonutByLoanNo:_loanNoStr Amount:_payMoney AndPayMode:@"ER"];
        }else
        {
            textField.text = @"";
            [self buildHeadError:@"还款金额不正确,请重新输入"];
        }
    }else
    {
        self.moneyLabel.attributedText = [self fomatMoney:@"0"];
        self.feeLabel.attributedText = [self fomatCountFee:@"0"];
        _payMoney = @"0";
    }
}

#pragma mark -- 请求
//查询剩余天数
- (void)searchRemainDays
{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:StringOrNull(_applSeq) forKey:@"applseq"];
    [client getInfo:@"app/appserver/queryApplListBySeq" requestArgument:parmDict requestTag:1 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//#pragma mark -----主动还款金额查询
- (void)searchAmonutByLoanNo:(NSString *)loanNo Amount:(NSString *)amount AndTag:(NSInteger)tag
{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:loanNo forKey:@"loanNo"];
    [parmDict setObject:amount forKey:@"actvPayAmt"];
    [client getInfo:@"app/appserver/newZdhkMoney" requestArgument:parmDict requestTag:tag requestClass:NSStringFromClass([self class])];
    
}
- (void)creatDetailReq{
    BSVKHttpClient * detailClint = [BSVKHttpClient shareInstance];
    detailClint.delegate = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:StringOrNull(_applSeq) forKey:@"applSeq"];
    
    [detailClint getInfo:@"app/appserver/apporder/queryAppLoanAndGoods" requestArgument:dict requestTag:10 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
- (void)searchAmonutByLoanNo:(NSString *)loanNo Amount:(NSString *)amount AndPayMode:(NSString *)onePayMode
{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:loanNo forKey:@"LOAN_NO"];
    [parmDict setObject:amount forKey:@"ACTV_PAY_AMT"];
    [parmDict setObject:onePayMode forKey:@"PAYM_MODE"];
    [client postInfo:@"app/appserver/customer/checkZdhkMoney" requestArgument:parmDict requestTag:104 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
#pragma mark - Model 解析
- (void)analySisStageBillModel:(StageBillModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        StageBillModelBody *body =  [model.body lastObject];
        UIView * aView = (UIView *)[self.view viewWithTag:10000];
        UILabel *day = (UILabel *)[aView viewWithTag:10001];
        if (body.days > 0) {
            
            day.text = [NSString stringWithFormat:@"剩余%ld天",(long)body.days];
        }
    }else{
        
        [self buildHeadError:model.head.retMsg];
    }
}
- (void)analySisAmountModel:(AmountModel *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"])
    {
        self.payMode = @"FS";
        
        _totalMoney = model.body.ze;
        _bj = model.body.bj;
        _sxf = model.body.sxf;
        _xf = model.body.xf;
        
        [self toDetailViewController];
    }else{
        [self buildHeadError:model.head.retMsg];
    }
}
- (void)analySisChangeDefaultBankModel:(ChangeDefaultBankModel *)model
{
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        _changeBankView.defaultBankLabel.text = _bankName;
        _loanDtailModel.body.repayApplCardNo = _bankNumber;
        _loanDtailModel.body.repayAccBankName = _bankName;
        _bankType = _changeBankType;
        if (_bankNumber.length > 4) {
            NSString * message = [_bankNumber substringFromIndex:_bankNumber.length - 4];
            
            _changeBankView.bankNumberLabel.text = [NSString stringWithFormat:@"****%@",message];
        }else{
            
            _changeBankView.bankNumberLabel.text = @"";
        }
    }else{
        
        [self buildHeadError:model.head.retMsg];
    }
}
- (void)analySisLoanDetailModel
{
    if ([_loanDtailModel.head.retFlag isEqualToString:@"00000"]) {
        [AppDelegate delegate].userInfo.applSeq = _loanDtailModel.body.applSeq;
        
        _changeBankView.defaultBankLabel.text = StringOrNull(_loanDtailModel.body.repayAccBankName);
        
        if (_loanDtailModel.body.repayApplCardNo.length > 4) {
            NSString * message = [_loanDtailModel.body.repayApplCardNo substringFromIndex:_loanDtailModel.body.repayApplCardNo.length - 4];
            
            _changeBankView.bankNumberLabel.text = [NSString stringWithFormat:@"****%@",message];
        }else{
            
            _changeBankView.bankNumberLabel.text = @"";
        }
        
        [self setValuesForLoanView:_loanDtailModel];
        [self searchRemainDays];
        
    }else{
        
        [self buildHeadError:_loanDtailModel.head.retMsg];
    }
}
- (void)analySisAmountModelPayMode:(AmountModel *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"])
    {
        //self.money.text = [NSString stringWithFormat:@"%.2f",model.body.zdhkFee.floatValue];
        
        if([_payMode isEqualToString:@"FS"])
        {
            self.feeLabel.hidden = YES;
            self.moneyLabel.frame = CGRectMake(10, 0, DeviceWidth-145*scaleAdapter-30, 49);
            _totalMoney = [NSString stringWithFormat:@"%.2f",model.body.zdhkFee.floatValue];
        }else
        {
            self.feeLabel.hidden = NO;
            self.feeLabel.attributedText = [self fomatCountFee:model.body.zdhkXf];
            self.moneyLabel.frame = CGRectMake(10, 0, DeviceWidth-145*scaleAdapter-30, 25);
        }
        
        self.moneyLabel.attributedText = [self fomatMoney:model.body.zdhkFee];
    }else{
        _totalMoney = nil;
        self.swt.on = NO;
        [self swtChangeAction];
        [self buildHeadError:model.head.retMsg];
    }
}
@end
