//
//  CashLoanViewController.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCCashLoanViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import <MBProgressHUD.h>
#import "RMUniversalAlert.h"
#import <MJExtension.h>

#import "HCCashLoanCostTableViewCell.h"
#import "HCCashLoanPlanTableViewCell.h"
#import "HCCashLoanTimeTableViewCell.h"
#import "HCCashLoanMoneyTableViewCell.h"
#import "HCCashLoanCouponTableViewCell.h"
#import "HCCashLoanReceivablesTableViewCell.h"
#import "HCOpeningBranchTableViewCell.h"

#import "HCBorrowingMethodsViewController.h"
#import "BankChoiceViewController.h"
#import "HCMyCouponViewController.h"

#import "ApplyModel.h"
#import "WhiteSearchModel.h"
#import "IndetityStore.h"
#import "LimitAmountModel.h"
#import "BankLIstMode.h"
static CGFloat const getCustLoanCodeAndLel = 1;          //贷款品种查询
static CGFloat const getCustIsPass = 2;                  //准入资格查询
static CGFloat const getEdCheck = 3;                     //额度查询
static CGFloat const getInvitedCustByCustNo = 4;         //邀请原因查询
static CGFloat const queryBeyondContral = 5;             //每日限额
static CGFloat const checkCity = 6;                      //准入城市查询
@interface HCCashLoanViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SendBankNameDelegate,BSVKHttpClientDelegate,ChoiceCashLoanTypeDelegate>{

    CGFloat _maxLoanAmount; //最高借款金额
    
    CGFloat _minLoanAmount; //最低借款金额
    
    NSString * _moneyStr;   //借款金额
    
    NSString * _timeStr;    //借款期限
    
    NSString * _totalStr;   //息费总额
    
    NSString * _couponStr;  //优惠券
    
    NSString * _creditCardNumber;             //收款银行卡号
    
    NSString * _creditBankCardNameStr;        //收款银行名
    
    NSString * _creditBankCardCode;           //收款银行代码
    
    NSString * _creditBankCardBranchName;     //收款银行支行名字
    
    NSString * _creditBankCardBranchCode;     //收款银行支行代码
    
    float x;
    
    BOOL _showAllData;                         //是否展示全部信息
}

@property (nonatomic,strong) UITableView *loanTableView;

@property(nonatomic,strong) UITextField *moneyTextField;//金额

@property (nonatomic,strong) NSMutableDictionary *cardDic;  //银行卡字典信息

@property (nonatomic,strong) UILabel * allMoneyLabel;       //应还总额

@property (nonatomic,strong) WhiteSearchModel *whiteSearchModel;//白名单
@end

@implementation HCCashLoanViewController
#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取现";
    x = DeviceWidth/375;
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    _cardDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if ([AppDelegate delegate].userInfo.busFlowName == CashLoanWait || [AppDelegate delegate].userInfo.busFlowName == CashLoanReturned) {
        
        [self setBottomView];
    }else{
        // 判断是否为单张银行卡
        [self queryBankInfo];
        // 简版界面
        [self setTableViewFootView];
    }
    [self setTableView];
    [self setDummyData];
    [self setNavi];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setRequest];
}
#pragma mark - custom Methods
- (void)clickPlan{
    NSLog(@"点击了计划");
}
- (void)getAllDate{

    [_moneyTextField resignFirstResponder];
    
    if (isEmptyString(_moneyStr)) {
        
        [self buildHeadError:@"请先输入金额"];
        
        return;
    }else if (isEmptyString(_timeStr)){
        
        [self buildHeadError:@"请先选择借多久"];
        
        return;
    }else if (isEmptyString(_totalStr)){
    
        [self queryCalculation];
        
        return;
    }else{
    
        _showAllData = YES;
        
        [self setBottomView];
        
        self.loanTableView.tableFooterView = [[UIView alloc]init];
        
        [self.loanTableView reloadData];
    }
}
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
#pragma mark - private Methods
- (void)setDummyData{
//    _timeStr = @"对对对";
//    _totalStr = @"111";
//    _moneyStr = @"1111";
//    [_cardDic setObject:@"中国建设银行" forKey:@"cardName"];
//    [_cardDic setObject:@"6227002282306418869" forKey:@"cardNumber"];
//    [_cardDic setObject:@"中国建设银行" forKey:@"cardImage"];
//    [self.loanTableView reloadData];
    if (_moneyStr.length > 0 && _timeStr.length > 0 && _totalStr.length > 0 && _showAllData) {
        [self setBottomView];
    }else{
        [self setTableViewFootView];
    }
    
}
- (void)setTableView{

    self.loanTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    self.loanTableView.delegate = self;
    self.loanTableView.dataSource = self;
    self.loanTableView.showsVerticalScrollIndicator = NO;
    self.loanTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.loanTableView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    [self.view addSubview:self.loanTableView];
}
- (void)setBottomView{

    UIView * bottomView = [[UIView alloc]init];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bottomView];
    
    _allMoneyLabel = [[UILabel alloc]init];
    
    _allMoneyLabel.textAlignment = NSTextAlignmentCenter;
    
    _allMoneyLabel.text = @"应还总额(元):23344.00";

    _allMoneyLabel.textColor = UIColorFromRGB(0xfda253, 1.0);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_allMoneyLabel.text];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333, 1.0) range:NSMakeRange(0, 8)];
    
    _allMoneyLabel.attributedText = attributedString;
    
    [bottomView addSubview:_allMoneyLabel];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];

    [btn setBackgroundColor:UIColorFromRGB(0x32beff, 1.0)];
    
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [bottomView addSubview:btn];
    if (iphone6P) {
        bottomView.frame = CGRectMake(0, DeviceHeight - 162, DeviceWidth, 98);
        
        _allMoneyLabel.frame = CGRectMake(0, 0, DeviceWidth, 48);
        
        _allMoneyLabel.font = [UIFont appFontRegularOfSize:15];
        
        btn.frame = CGRectMake(0, 50, DeviceWidth, 48);
        
    }else{
        bottomView.frame = CGRectMake(0, DeviceHeight - 64 - 90 *x, DeviceWidth, 90 *x);
        
        _allMoneyLabel.frame = CGRectMake(0, 0, DeviceWidth, 44 *x);
        
        _allMoneyLabel.font = [UIFont appFontRegularOfSize:15 *x];
        
        btn.frame = CGRectMake(0, 45 *x, DeviceWidth, 45 *x);
        
    }
}
- (void)setTableViewFootView{
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (iphone6P) {
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 90)];
        
        sureBtn.frame = CGRectMake(DeviceWidth/2 - 158.5, 40, 317, 50);
        
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        [sureBtn setBackgroundColor:UIColorFromRGB(0x32beff, 1.0)];
        
        sureBtn.layer.cornerRadius = 25;
        
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [bottomView addSubview:sureBtn];
        
        self.loanTableView.tableFooterView = bottomView;

    }else{
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 82 *x)];
        
        sureBtn.frame = CGRectMake(43 *x, 36.5 *x, DeviceWidth - 86 *x, 45 *x);
        
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        [sureBtn setBackgroundColor:UIColorFromRGB(0x32beff, 1.0)];
        
        sureBtn.layer.cornerRadius = 22.5 *x;
        
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [bottomView addSubview:sureBtn];
        
        self.loanTableView.tableFooterView = bottomView;
        
    }
    
    [sureBtn addTarget:self action:@selector(getAllDate) forControlEvents:UIControlEventTouchUpInside];
}
// 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.loanTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.loanTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.loanTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.loanTableView setLayoutMargins:UIEdgeInsetsZero];
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
- (void)clickNextBtn{
    if (!_creditBankCardNameStr) {
        [self buildHeadError:@"请选择收款账户"];
        return;
    }else if (!_creditBankCardBranchName){
        [self buildHeadError:@"请选择支行"];
        return;
    }else{
        if ([AppDelegate delegate].userInfo.limitState == LimitNoApply) {
            [self buildHeadError:@"当前暂无额度，请先进行额度申请"];
        }else{
        
        }
    }
}
//  跳转
- (void)jumpJudge {
//    if (_applyModel && [_applyModel.body.crdSts isEqualToString:LimitStateFreeze]) {
//        WEAKSELF
//        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"额度被冻结,无法进行贷款" cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
//            STRONGSELF
//            if (strongSelf) {
//                if (buttonIndex == 0) {
//                    
//                }
//            }
//        }];
//    }
//    else if (_applyModel && [_applyModel.head.retFlag isEqualToString:NoLimitMoney]) {
//        [AppDelegate delegate].userInfo.litmiState = LimitNoApply;
//        //没有额度
//        //保存订单
//        [self saveAppOrderInfo];
//        
//    }
//    else if (_applyModel && [_applyModel.head.retFlag isEqualToString:SucessCode]) {
//        if ([_applyModel.body.crdNorAvailAmt floatValue] < [_money floatValue]) {
//            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"额度不够，请到个人中心提额或修改借款金额" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
//        }else {
//            //额度够了保存订单
//            [self saveAppOrderInfo];
//        }
//    }else {
//        //再去查询额度
//        [self setRequest];
//    }
}
#pragma mark - request Methods
- (void)queryCalculation{
    NSLog(@"还款试算");
}
// 获取贷款品种
-(void)loanVarietyRequest{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/crm/cust/getCustLoanCodeAndLel" requestArgument:@{@"custNo":[AppDelegate delegate].userInfo.custNum,@"typGrp":@"02"} requestTag:getCustLoanCodeAndLel requestClass:NSStringFromClass([self class])];
}
// 白名单过滤
-(void)setAllowRequest{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:[AppDelegate delegate].userInfo.realId forKey:@"certNo"];
    
    [dic setObject:[AppDelegate delegate].userInfo.realName forKey:@"custName"];
    
    [dic setObject:@"20" forKey:@"idTyp"];
    
    [dic setObject:[AppDelegate delegate].userInfo.userTel forKey:@"phonenumber"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/crm/cust/getCustIsPass" requestArgument:dic requestTag:getCustIsPass requestClass:NSStringFromClass([self class])];
    
}
// 额度查询
-(void)setRequest{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary * userDic = [[NSMutableDictionary alloc]init];
    
    [userDic setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
    
    [userDic setObject:@"20" forKey:@"idTyp"];
    
    BSVKHttpClient * userClient = [BSVKHttpClient shareInstance];
    
    userClient.delegate = self;
    
    [userClient getInfo:@"app/appserver/getEdCheck" requestArgument:userDic requestTag:getEdCheck requestClass:NSStringFromClass([self class])];
    
    
}
- (void)searchInviteReason {
    //                    查询邀请原因
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/crm/cust/getInvitedCustByCustNo" requestArgument:@{@"custNo":[AppDelegate delegate].userInfo.custNum} requestTag:getInvitedCustByCustNo requestClass:NSStringFromClass([self class])];
}
//10万额度
-(void)limitAmount{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
//    [dic setObject:self.selectLoanType.typCde forKey:@"typCde"];
    
    [dic setObject:dateString forKey:@"date"];
    
    [dic setObject:_moneyStr forKey:@"applyAmt"];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance] getInfo:@"app/appserver/apporder/queryBeyondContral" requestArgument:dic requestTag:queryBeyondContral requestClass:NSStringFromClass([self class])];
    
}
//获得允许城市
-(void)getAllowCity{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
//    [dic setObject:StringOrNull(_typLevelTwo) forKey:@"typLevelTwo"];
    
    [dic setObject:StringOrNull([AppDelegate delegate].mapLocation.strCityCode) forKey:@"cityCode"];
    
    [dic setObject:StringOrNull([AppDelegate delegate].mapLocation.strProvinceCode) forKey:@"provinceCode"];
    
    [[BSVKHttpClient shareInstance] getInfo:@"app/appmanage/citybean/checkCity" requestArgument:dic requestTag:checkCity requestClass:NSStringFromClass([self class])];
    
}
//查询是否单张银行卡
- (void)queryBankInfo{
    
    [BSVKHttpClient shareInstance].delegate = self;
    WEAKSELF
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/crm/cust/getBankCard" requestArgument:@{@"custNo":StringOrNull([AppDelegate delegate].userInfo.custNum)} completion:^(id results, NSError *error) {
        if (results) {
            
            STRONGSELF
            
            BankLIstMode *model = [BankLIstMode mj_objectWithKeyValues:results];
            if ([model.head.retFlag isEqualToString:SucessCode]) {
                
                if (model.body.info.count == 1) {
                    
                    _creditCardNumber = StringOrNull(model.body.info[0].cardNo);  //收款卡号
                    
                    _creditBankCardCode = model.body.info[0].bankCode;//收款银行代码
                    
                    _creditBankCardNameStr = StringOrNull(model.body.info[0].bankName);//收款银行名
                    
                    [strongSelf.loanTableView reloadData];

                }
            }
        }
    }];
}

#pragma mark - BSVK Delegate
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if (requestTag == getEdCheck){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            ApplyModel *model = [ApplyModel mj_objectWithKeyValues:responseObject];
            
            [self analysisApplyModel:model];
            
        }else if (requestTag == getCustLoanCodeAndLel){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            HCBorrowingMethodsViewController * vc = [[HCBorrowingMethodsViewController alloc]init];
            
            vc.choiceCashloanTypedelegate = self;
            
            [self.navigationController pushViewController:vc animated:YES];
        }else if (requestTag == getCustIsPass) { //白名单过滤
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            _whiteSearchModel = [WhiteSearchModel mj_objectWithKeyValues:responseObject];
            
            [self synalizeAllowModel];
            
        }else if (requestTag == getInvitedCustByCustNo) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            IndetityStore *model = [IndetityStore mj_objectWithKeyValues:responseObject];
            
            [self synalizeIndetityStoreModel:model];
            
        }else if (requestTag == queryBeyondContral) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            LimitAmountModel * model = [LimitAmountModel mj_objectWithKeyValues:responseObject];
            
            [self synalizeLimitAmountModel:model];
            
        }
    }
}
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
    }
}
#pragma mark - Model 解析
- (void)analysisApplyModel:(ApplyModel *)model{
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        
        _maxLoanAmount = [model.body.crdNorAvailAmt floatValue];
    }else{//没有额度申请
        
        if ([AppDelegate delegate].recordedInfo.cashMaxLoanMoneyNoLimit) {
            _maxLoanAmount = [[AppDelegate delegate].recordedInfo.cashMaxLoanMoneyNoLimit floatValue];
            _minLoanAmount = [[AppDelegate delegate].recordedInfo.cashMinLoanMoneyNoLimit floatValue];
        }else{
            _maxLoanAmount = 200000;
            _minLoanAmount = 3000;
        }
    }
    [self.loanTableView reloadData];
}
//白名单解析
- (void)synalizeAllowModel{
    
    if ([_whiteSearchModel.head.retFlag isEqualToString:@"00000"]) {
        
        if ([_whiteSearchModel.body.isPass isEqualToString:SocietyUser]){//社会化顾客
            [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
            [self searchInviteReason];
        }else if ([_whiteSearchModel.body.isPass isEqualToString:@"1"]){
            //优质白名单  海尔、电信员工
            if ([_whiteSearchModel.body.level isEqualToString:Auser]) {
                
                [AppDelegate delegate].userInfo.whiteType = WhiteA;
                [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
                if ([AppDelegate delegate].userInfo.busFlowName == CashLoanReturned) {
                    if (_pushType == loanTime) {
                        [self loanVarietyRequest];//查询贷款品种
                    }else{
                        [self jumpJudge];
                    }
                }else{
                    [self loanVarietyRequest];
                }
            }else if ([_whiteSearchModel.body.level isEqualToString:Buser]){//其他白名单
                [AppDelegate delegate].userInfo.whiteType = WhiteB;
                [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
                if ([AppDelegate delegate].userInfo.busFlowName == CashLoanReturned)
                {
                    if (_pushType == loanTime)
                    {
                        [self loanVarietyRequest];//查询贷款品种
                    }else
                    {
                        //地理位置加中国判断
                        if([AppDelegate delegate].mapLocation.locationStatus == LocationNoAuthority)
                        {
                            //提示没有权限
                            [self showNoAuthorityAlert];
                        }else if ([AppDelegate delegate].mapLocation.locationStatus == LocationNotInChina)
                        {
                            //提示不在中国
                            [self showNotInChinaAlert];
                        }else if([AppDelegate delegate].mapLocation.locationStatus == LocationGeoCitySucess )
                        {
                            [self jumpJudge];
                        }else
                        {
                            //提示定位失败
                            [self showLocationFailAlert];
                        }
                    }
                }else{
                    [self loanVarietyRequest];
                }
            }else if ([_whiteSearchModel.body.level isEqualToString:Cuser]){
                [AppDelegate delegate].userInfo.haierVipState = IsHaierVip;
                [self searchInviteReason];
            }
        }else if ([_whiteSearchModel.body.isPass isEqualToString:@"-1"]){
            [AppDelegate delegate].userInfo.whiteType = BlackMan;
            [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
            [self buildHeadError:@"此账号无贷款权限，详情请拨打4000187777"];
        }
    }else{
        
        [self buildHeadError:_whiteSearchModel.head.retMsg];
    }
}
//社会化接续
- (void)synalizeIndetityStoreModel:(IndetityStore *)model {
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        if (model.body.count > 0) {
            //有邀请原因 继续走
            if ([_whiteSearchModel.body.isPass isEqualToString:@"1"]) {
                [AppDelegate delegate].userInfo.whiteType = WhiteCReason;
            }else{
                [AppDelegate delegate].userInfo.whiteType = WhiteSocityReason;
            }
            if ([AppDelegate delegate].userInfo.busFlowName == CashLoanReturned) {
                if (_pushType == loanTime) {
                    [self loanVarietyRequest];//查询贷款品种
                }else{
                    [self jumpJudge];
                }
            }else{
                [self loanVarietyRequest];
            }
            
        }
        //没有邀请原因  获取贷款品种 用来判断每日额度
        else{
            
            if ([_whiteSearchModel.body.isPass isEqualToString:@"1"]) {
                [AppDelegate delegate].userInfo.whiteType = WhiteCNoReason;
            }else{
                [AppDelegate delegate].userInfo.whiteType = WhiteSocityNoReason;
            }
            if ([AppDelegate delegate].userInfo.busFlowName == CashLoanReturned) {
                if (_pushType == loanTime) {
                    [self loanVarietyRequest];//查询贷款品种
                }else{
                    if ([AppDelegate delegate].userInfo.whiteType == WhiteSocityNoReason) {
                        
                        [self limitAmount];
                    }else{
                        
                        [self getAllowCity];
                    }
                }
            }else{
                [self loanVarietyRequest];
            }
        }
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
    }
}
- (void)synalizeLimitAmountModel:(LimitAmountModel*) model{
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        //额度足够  继续走
        if ([model.body.flag isEqualToString:@"Y"]) {
            
            if([AppDelegate delegate].mapLocation.locationStatus == LocationNoAuthority){
                //提示没有权限
                [self showNoAuthorityAlert];
            }else if ([AppDelegate delegate].mapLocation.locationStatus == LocationNotInChina){
                //提示不在中国
                [self showNotInChinaAlert];
            }else if([AppDelegate delegate].mapLocation.locationStatus == LocationGeoCitySucess){
                if ([AppDelegate delegate].userInfo.busFlowName == CashLoanReturned) {
                    if (_pushType == loanTime) {
                        [self loanVarietyRequest];//查询贷款品种
                    }else{
                        [self getAllowCity];
                    }
                }else{
                    //   跳转
                    [self jumpJudge];
                }
            }else{
                //提示定位失败
                [self showLocationFailAlert];
            }
        }else if ([model.body.flag isEqualToString:@"N"]){
            [self buildHeadError:@"当前申请人数较多，请稍候"];
        }
    }else{
        [self buildHeadError:model.head.retMsg];
    }
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (_moneyStr.length > 0 && _timeStr.length > 0 && _totalStr.length > 0 && _showAllData) {
        
        return 9;
    }else{
    
        return 4;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (iphone6P) {
            return 103;
        }else{
            return 93 *x;
        }
    }else if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 8){
        if (iphone6P) {
            return 50;
        }else{
            return 45 *x;
        }
    }else if(indexPath.row == 7){
        if (iphone6P) {
            return 73;
        }else{
            return 66 *x;
        }
    }else {
        if (iphone6P) {
            return 10;
        }else{
            return 9.5 *x;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HCCashLoanMoneyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"moneyCell"];
        if (cell == nil) {
            cell = [[HCCashLoanMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moneyCell"];
        }
        cell.moneyTextField.placeholder = [NSString stringWithFormat:@"最高借款%.2f元",_maxLoanAmount];
        cell.moneyTextField.text = _moneyStr;
        cell.moneyTextField.delegate = self;
        _moneyTextField = cell.moneyTextField;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2){
        HCCashLoanTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
        if (cell == nil) {
            cell = [[HCCashLoanTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeCell"];
        }
        cell.timeLabel.text = _timeStr;
        return cell;
    }else if(indexPath.row == 3){
        HCCashLoanCostTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"costCell"];
        if (cell == nil) {
            cell = [[HCCashLoanCostTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"costCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.costLabel.text = _totalStr;
        return cell;
    }else if (indexPath.row == 4){
        HCCashLoanCouponTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"couponCell"];
        if (cell == nil) {
            cell = [[HCCashLoanCouponTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"couponCell"];
        }
        cell.couponLabel.text = _couponStr;
        return cell;
    }else if (indexPath.row == 5){
        HCCashLoanPlanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"planCell"];
        if (cell == nil) {
            cell = [[HCCashLoanPlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"planCell"];
        }
        cell.tapLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPlan)];
        [cell.tapLabel addGestureRecognizer:tap];
        return cell;
    }else if(indexPath.row == 7){
        HCCashLoanReceivablesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"bankCell"];
        if (cell == nil) {
            cell = [[HCCashLoanReceivablesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bankCell"];
        }
        cell.cardImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"还款卡_%@",_creditBankCardNameStr]];
        if (_creditBankCardNameStr && _creditBankCardNameStr.length > 0) {
            cell.cardNameLabel.text = _creditBankCardNameStr;
            cell.cardNameLabel.textColor = UIColorFromRGB(0x666666, 1.0);

        }else{
            cell.cardNameLabel.text = @"请选择收款账户";
            cell.cardNameLabel.textColor = UIColorFromRGB(0x999999, 1.0);
        }
        if (_creditCardNumber && _creditCardNumber.length > 0) {
            cell.cardNumberLabel.text = _creditCardNumber;
            NSString * message = [cell.cardNumberLabel.text substringFromIndex:cell.cardNumberLabel.text.length - 4];
            
            cell.cardNumberLabel.text = [NSString stringWithFormat:@"****%@",message];
        }
        
        return cell;
    }else if (indexPath.row == 8){
        HCOpeningBranchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"branchCell"];
        if (cell == nil) {
            cell = [[HCOpeningBranchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"branchCell"];
        }        
        if (_creditBankCardBranchName.length > 0) {
            
            cell.branchLabel.text = _creditBankCardBranchName;
            cell.branchLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        }else{
        
            cell.branchLabel.text = @"选择开户行";
            cell.branchLabel.textColor = UIColorFromRGB(0x999999, 1.0);

        }
        return cell;
    }else{
        static NSString *BottomcellID = @"BottomcellIDDefault";
        UITableViewCell *Bottomcell = [tableView dequeueReusableCellWithIdentifier:BottomcellID];
        
        if (!Bottomcell) {
            Bottomcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BottomcellID];
        }
        
        Bottomcell.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
        Bottomcell.selectionStyle = UITableViewCellSelectionStyleNone;
        return Bottomcell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.loanTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        
        [_moneyTextField resignFirstResponder];
        
        if (_moneyStr && _moneyStr.length > 0) {
            if ([AppDelegate delegate].userInfo.whiteType && [AppDelegate delegate].userInfo.whiteType != WhiteNoCheck) {
                
                [self loanVarietyRequest];//查询贷款品种
            }else{
                
                [self setAllowRequest];
            }
        }else{
        
            [self buildHeadError:@"请先输入金额"];
        }
        
    }else if (indexPath.row == 4){
    
        HCMyCouponViewController *vc = [[HCMyCouponViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 8){
        BankChoiceViewController * bank = [[BankChoiceViewController alloc]init];
        bank.strBackNo = _creditBankCardCode;//银行类型编码，例如农行103
        bank.delegate = self;
        [self.navigationController pushViewController:bank animated:YES];
    }
}

#pragma mark - textField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{

    _moneyStr = textField.text;
    
    if (_moneyStr.length > 0 && _timeStr.length > 0) {
        [self queryCalculation];
        [self.loanTableView reloadData];
    }
}
#pragma mark - private Delegate
- (void)choiceCashLoanType:(NSString *)type{

    _timeStr = type;
    
    _totalStr = @"111";
    
    [self.loanTableView reloadData];
}
-(void)sendBankInfo:(BankChoiceBody *)body{
    
    _creditBankCardBranchName = body.bchName;
    
    _creditBankCardBranchCode = body.bchCde;
    
    [self.loanTableView reloadData];
}
#pragma mark - 卡地理位置的方法
//没有权限的提示框
- (void)showNoAuthorityAlert
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"尚未获取您的位置，请开启定位服务或移动至开阔地带！" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 1)
            {
                //去设置页面
                [strongSelf toSetLocation];
            }
        }
    }];
}

//不在中国的提示框
- (void)showNotInChinaAlert
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"当前业务仅支持在中国" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0)
            {
                
            }
        }
    }];
}

//解析失败或者定位失败的提示框
- (void)showLocationFailAlert
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"当前无法确认您的位置，请检查网络并重试" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                [[AppDelegate delegate].mapLocation openLocationService];
            }
        }
    }];
}

//设置定位
- (void)toSetLocation
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end

