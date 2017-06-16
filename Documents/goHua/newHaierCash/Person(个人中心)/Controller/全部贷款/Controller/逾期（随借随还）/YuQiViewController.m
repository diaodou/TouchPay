//
//  YuQiViewController.m
//  personMerchants
//
//  Created by 张久健 on 16/4/3.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "YuQiViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "LoanDetailCommonView.h"
#import "PayBackBottomView.h"
#import "ConfirmPayViewController.h"
#import "BSVKHttpClient.h"
#import "LoanDetailModel.h"//贷款详情的model
#import <MJExtension.h>
#import <MBProgressHUD.h>
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
#import "ArrearsModel.h"
#import "StageBillModel.h"
#import <YYWebImage.h>
#import "AmountModel.h"
#import "ContractShowViewController.h"
#import "ChangDefaultBankView.h"
#import "AddBankViewController.h"
#import "ChangeDefaultBankModel.h"
#import "RepayDetailViewCcontroller.h"
#import "UILabel+SizeForStr.h"
@interface YuQiViewController ()<UITableViewDataSource,UITableViewDelegate,BSVKHttpClientDelegate,UITextFieldDelegate,ChoiceDefaultBankDelegate>{
    
    NSInteger currentDay;
    
    NSString *_bj;    //本金(全部还款)
    
    NSString *_sxf;   //手续费(全部还款)
    
    NSString *_xf;    //息费(全部还款)
    
    NSString *_payMoney;//还款金额
    
    NSString *_total;//全部金额

    NSString *_bankName;
    
    NSString *_bankNumber;
    
    NSString *_bankType;
    
    NSString *_changeBankType;
}
@property(nonatomic,strong) UIView * contractView;
@property(nonatomic,strong) UIButton * contractBtn;//合同按钮
@property(nonatomic,strong) UITableView *yuQiTable;//下部的table
@property(nonatomic,strong) LoanDetailCommonView *loanView;//中部的loanview
@property(nonatomic,strong) PayBackBottomView * bottom;//底部的View
@property(nonatomic,strong) UITextField *money;//可部分还款
@property(nonatomic,strong) LoanDetailModel *detailModel;//贷款详情model
@property(nonatomic,assign) BOOL alreadySearch;//是否已经走了欠款查询
@property(nonatomic,strong) ChangDefaultBankView *changeBankView;//默认还款卡UI


@property (nonatomic,strong) UIView * mbView;

@end

@implementation YuQiViewController

#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xebeaea, 1.0);
    self.title = @"贷款详情";
    
    [self setNavi];
   
    //    消息已读标示
    if (_msgId) {
        
        [self updateMsgStatus];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    查询贷款详情
    [self creatDetailReq];
}

#pragma mark - setting and getting
- (void)setTabelView{
    
    _changeBankView = [[ChangDefaultBankView alloc]init];
    
    _changeBankView.frame = CGRectMake(0, 0, DeviceWidth, 104);
    
    [self.view addSubview:_changeBankView];
    
    _changeBankView.stateLabel.text = @"已逾期";
    
    _changeBankView.stateLabel.text = [NSString stringWithFormat:@"您已逾期%ld天,请尽快还款。您的逾期情况将会影响您的征信报告。",(long)(-currentDay)];
    
    _changeBankView.stateLabel.frame = CGRectMake(DeviceWidth/3, 0, DeviceWidth*2/3 - 20, 40);
    
    _changeBankView.stateLabel.textAlignment = NSTextAlignmentLeft;
    _changeBankView.defaultBankLabel.text = StringOrNull(_detailModel.body.repayAccBankName);
    
    if (_detailModel.body.repayApplCardNo.length > 4) {
        NSString * message = [_detailModel.body.repayApplCardNo substringFromIndex:_detailModel.body.repayApplCardNo.length - 4];
        
        _changeBankView.bankNumberLabel.text = [NSString stringWithFormat:@"****%@",message];
    }else{
        
        _changeBankView.bankNumberLabel.text = @"";
    }
    
    _changeBankView.arrow.hidden = NO;
    
    UITapGestureRecognizer *tapGuest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBank)];
    
    [_changeBankView.bottomView addGestureRecognizer:tapGuest];
    
    _loanView = [[LoanDetailCommonView alloc ]initWithFrame:(CGRectMake(0,CGRectGetMaxY(_changeBankView.frame), DeviceWidth, [LoanDetailCommonView heightView:(loanOutDate)]))];
    _loanView.loanHandlingType = loanOutDate;
    UIImageView *img = [[UIImageView alloc]init];
    _loanView.loanTopView.labelTime.font = [UIFont appFontRegularOfSize:10];
    _loanView.loanTopView.labelMidContent.font = [UIFont appFontRegularOfSize:12];
    _loanView.loanTopView.labelRight.font = [UIFont systemFontOfSize:12];
    _loanView.loanTopView.labelState.font = [UIFont appFontRegularOfSize:11];
    _loanView.loanTopView.viewIcon.image = img.image;
    _loanView.priManey.font = [UIFont appFontRegularOfSize:12];
    _loanView.divManey.font = [UIFont appFontRegularOfSize:12];
    _loanView.totalManey.font = [UIFont appFontRegularOfSize:12];
    _loanView.interestDays.font = [UIFont appFontRegularOfSize:12];
    _loanView.summary.font = [UIFont appFontRegularOfSize:12];
    
    self.yuQiTable = [[UITableView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(_loanView.frame) + 10, DeviceWidth, 100)) style:(UITableViewStylePlain)];
    [self.yuQiTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    self.yuQiTable.delegate = self;
    self.yuQiTable.dataSource = self;
    [self.view addSubview:self.yuQiTable];
    self.yuQiTable.tableFooterView = [[UIView alloc]initWithFrame:(CGRectZero)];
    self.yuQiTable.scrollEnabled = NO;
    //底部View
    NSString *text = @"还款总额:¥0.00";
    
    _bottom = [[PayBackBottomView alloc] initWithFrame:CGRectMake(0, DeviceHeight-49-64, DeviceWidth, 49)];
    _bottom.backgroundColor = [UIColor whiteColor];
    [_bottom createViewWithPayBackMoney:[self fomatStr:text] andIconAction:nil andDetailAction:@selector(toRepayDetail) andPayBackAction:@selector(submit:) andObject:self];
    _bottom.iconButton.hidden = YES;
    _bottom.detailBtn.hidden = YES;
    [self.view addSubview:_bottom];
    
    
    [self.view addSubview:_bottom];
    [self.view addSubview:self.yuQiTable];
    [self.view addSubview:_loanView];
    
    [self setValuesForLoanView:_detailModel];
}
// 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.yuQiTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.yuQiTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_yuQiTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_yuQiTable setLayoutMargins:UIEdgeInsetsZero];
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
// 设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
// 返回
- (void)OnBackBtn:(UIButton *)btn {
    [_mbView removeFromSuperview];
    _mbView = nil;
    if (_yuqiType == fromMsg) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [AppDelegate delegate].userInfo.bReturn = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - setting and getting
-(void)comeContract{
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
#pragma mark - privite Methods
// 立即提交
-(void)submit:(UIButton *)btn{
    //    数据管理者
    if (!_total) {//如果总额为空继续请求
        
        [self searchAmonutByLoanNo:_loanNoStr Amount:@"0" AndTag:111];
        
        return;
    }
    if([[NSDecimalNumber decimalNumberWithString:_payMoney] compare: [NSDecimalNumber decimalNumberWithString:_total]] == NSOrderedSame){
        ConfirmPayViewController *vc = [[ConfirmPayViewController alloc]init];
        vc.loanNo = _loanNoStr;//借据号
        vc.totalAmt = _payMoney;//总额
        vc.parmCard = _detailModel.body.repayApplCardNo;//卡号
        vc.bankName = _detailModel.body.repayAccBankName;//卡名
        vc.bankTyp = _bankType;//卡类型
        vc.payMode = @"FS";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        [self buildHeadError:@"请检查还款金额是否正确!"];
    }
}
- (void)changeBank{
    
    AddBankViewController * bank = [[AddBankViewController alloc]init];
    
    bank.choiceBank = choiceDefaultCard;
    
    bank.choiceDefaultDelegate = self;
    
    [self.navigationController pushViewController:bank animated:YES];
    
}
- (void)setValuesForLoanView:(LoanDetailModel*)model
{
    //    赋值
    //    数据管理者
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    //    分期本金
    //    _loanView.priManey.text = [NSString stringWithFormat:@"%@",[[NSDecimalNumber decimalNumberWithString:model.body.setlPrcpAmt] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:model.body.repayPrcpAmt] withBehavior:roundUp]];
    _loanView.priManey.text = [NSString stringWithFormat:@"%.2f",[NSDecimalNumber decimalNumberWithString:model.body.apprvAmt].floatValue];//审批金额
    //    息费
    if ([model.body.applyTnrTyp isEqualToString:@"D"]||[model.body.applyTnrTyp isEqualToString:@"d"]) {
        _loanView.divManey.text = [NSString stringWithFormat:@"按日计息\n每日%@元",model.body.rlx];
        _loanView.divManey.numberOfLines = 0;
        CGFloat height = [_loanView.divManey boundingRectWithSize:CGSizeMake(DeviceWidth/3,0)].height;
        if (height < 14) {
            height = 14;
        }
        _loanView.divManey.frame = CGRectMake(DeviceWidth/3, CGRectGetMinY(_loanView.priManey.frame) - 5, DeviceWidth/3, height);
        _loanView.interestDays.hidden = YES;
    }else{
        
        _loanView.divManey.text = [NSString stringWithFormat:@"%.2f",[[NSDecimalNumber decimalNumberWithString:model.body.psNormIntAmt] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:model.body.feeAmt]withBehavior:roundUp].floatValue];
    }
    //    合计金额
    if ([model.body.applyTnrTyp isEqualToString:@"D"]||[model.body.applyTnrTyp isEqualToString:@"d"]) {
        _loanView.totalManey.text = [NSString stringWithFormat:@"本金+%@元/日",model.body.rlx];
        CGFloat totalManeyHeight = [_loanView.totalManey boundingRectWithSize:CGSizeMake(DeviceWidth/3,0)].height;
        if (totalManeyHeight < 14) {
            totalManeyHeight = 14;
        }
        _loanView.totalManey.numberOfLines = 0;
        _loanView.totalManey.frame = CGRectMake(DeviceWidth*2/3,CGRectGetMinY(_loanView.priManey.frame), DeviceWidth/3, totalManeyHeight);
    }else{
    _loanView.totalManey.text = [NSString stringWithFormat:@"%.2f",[[[[NSDecimalNumber decimalNumberWithString:model.body.setlPrcpAmt] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:model.body.psNormIntAmt] withBehavior:roundUp] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:model.body.feeAmt]withBehavior:roundUp] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:model.body.repayPrcpAmt] withBehavior:roundUp].floatValue];
    }
    
    //日期
    _loanView.loanTopView.labelTime.text = model.body.applyDt;
    //贷款编号
    _loanView.loanTopView.labelState.text = @"已逾期";
    
    [_loanView.loanTopView.viewIcon yy_setImageWithURL:[NSURL URLWithString:@""] placeholder:[UIImage imageNamed:@"贷款列表默认图片"] options:YYWebImageOptionProgressiveBlur completion:nil];
    
    
    if ([model.body.typGrp isEqualToString:@"02"]) {
        
        _loanView.loanTopView.labelMidContent.text = @"现金随借随还";
        
    }else if ([model.body.goods[0].goodsName rangeOfString:@"goodname"].location != NSNotFound){
        NSRange range  = [model.body.goods[0].goodsName rangeOfString:@"goodname"];
        
        _loanView.loanTopView.labelMidContent.text = [model.body.goods[0].goodsName substringFromIndex:range.location+range.length];  //名称
    }else{
        _loanView.loanTopView.labelMidContent.text = model.body.goods[0].goodsName;
    }
    //    头部的view
    //    每期多少钱
    _loanView.loanTopView.labelRight.text = [NSString stringWithFormat:@"¥%.2f", [model.body.repayPrcpAmt floatValue]];
    //    底部view赋值
    //利息
    //    _bottom.labelInterest.text = [NSString stringWithFormat:@"含息费%@元", [[NSDecimalNumber decimalNumberWithString:model.body.psNormIntAmt] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:model.body.feeAmt]]];
    //还款金额
    _bottom.moneyLabel.attributedText = [self fomatStr:[NSString stringWithFormat:@"还款总额:¥0.00"]];
    _payMoney = @"0";
    //       已还待还字段已经填加
    
    _loanView.summary.text = [NSString stringWithFormat:@"已还%.2f元，待还本金%.2f元",[model.body.setlPrcpAmt floatValue],[model.body.repayPrcpAmt floatValue]];
    
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
//开关的打开关闭
- (void)swtChangeAction:(UISwitch *)swt{
    [self buildHeadError:@"您已逾期请还清全部贷款!"];
    swt.on = YES;
}
-(void)disappear:(UIButton *)btn{
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
- (void)toRepayDetail
{
    if (!_total) {//如果总额为空继续请求
        
        [self searchAmonutByLoanNo:_loanNoStr Amount:@"0" AndTag:111];
        
        return;
    }
    
    if([[NSDecimalNumber decimalNumberWithString:_payMoney] compare: [NSDecimalNumber decimalNumberWithString:_total]] == NSOrderedSame)
    {
        RepayDetailViewCcontroller *rePayVC = [[RepayDetailViewCcontroller alloc] init];
        rePayVC.payMode = @"FS";
        rePayVC.loanNo = _loanNoStr;//借据号
        rePayVC.totalAmt = _payMoney;//总额
        rePayVC.isOverdue = YES;
        //借款本金
        rePayVC.principal = _bj;
        //手续费
        rePayVC.counterFee = _sxf;
        //息费
        rePayVC.interest = _xf;
        [self.navigationController pushViewController:rePayVC animated:YES];
    }else
    {
        [self buildHeadError:@"请检查还款金额是否正确!"];
    }
}
#pragma mark - request
//选择默认还款卡代理
- (void)choiceBank:(BankInfo *)backinfo{
    
    _bankName = backinfo.bankName;
    
    _bankNumber = backinfo.cardNo;
    
    _changeBankType = backinfo.cardTypeName;

    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/changeHkCard" requestArgument:@{@"applSeq":StringOrNull(_detailModel.body.applSeq),@"cardNo":StringOrNull(backinfo.cardNo)} requestTag:100 requestClass:NSStringFromClass([self class])];
}
// 消息已读
- (void)updateMsgStatus{
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]postInfo:@"app/appserver/message/updateMsgStatus" requestArgument:@{@"msgId":_msgId} completion:^(id results, NSError *error) {
        if (results) {
            NSLog(@"成功");
        }
    }];
}

// 查询贷款详情
- (void)creatDetailReq{
    BSVKHttpClient * detailClint = [BSVKHttpClient shareInstance];
    detailClint.delegate = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (_yuqiType == RecentlySevenDay) {//来自近七日
        [dict setValue:_applSeq forKey:@"applSeq"];
    }else{
        
        [dict setValue:[AppDelegate delegate].userInfo.applSeq forKey:@"applSeq"];
    }
    [detailClint getInfo:@"app/appserver/apporder/queryAppLoanAndGoods" requestArgument:dict requestTag:10 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
//查询逾期费用
- (void)overdueSearch{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:StringOrNull( StringOrNull(_loanNoStr)) forKey:@"LOAN_NO"];
    [client postInfo:@"app/appserver/customer/getQFCheck" requestArgument:parmDict requestTag:11 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
//查询剩余天数
- (void)searchRemainDays{
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    if(_yuqiType == RecentlySevenDay)
    {
        [parmDict setObject:StringOrNull(_applSeq) forKey:@"applseq"];
    }else
    {
        [parmDict setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"applseq"];
    }
    
    [client getInfo:@"app/appserver/queryApplListBySeq" requestArgument:parmDict requestTag:1 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

// 主动还款金额查询－－－－－

- (void)searchAmonutByLoanNo:(NSString *)loanNo Amount:(NSString *)amount AndTag:(NSInteger)tag{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:loanNo forKey:@"loanNo"];
    [parmDict setObject:amount forKey:@"actvPayAmt"];
    [client getInfo:@"app/appserver/newZdhkMoney" requestArgument:parmDict requestTag:tag requestClass:NSStringFromClass([self class])];
    
}

#pragma mark -- BSVK Delegate
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if (requestTag == 10) {//贷款详情查询
            
            LoanDetailModel *model = [LoanDetailModel mj_objectWithKeyValues:responseObject];
            
            [self analySisLoanDetailModel:model];
            
        }else if (requestTag == 11){//查询逾期费用
            ArrearsModel *model = [ArrearsModel mj_objectWithKeyValues:responseObject];
            [self analySisArrearsModel:model];
            
        }else if (requestTag == 1){//查询逾期天数
            //            查询逾期天数
            StageBillModel *model = [StageBillModel mj_objectWithKeyValues:responseObject];
            
            [self analySisStageBillModel:model];
            
        }else if (requestTag == 111){
            AmountModel *model = [AmountModel mj_objectWithKeyValues:responseObject];
            [self analySisAmountModel:model];
            
        }else if (requestTag == 100){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            ChangeDefaultBankModel *model = [ChangeDefaultBankModel mj_objectWithKeyValues:responseObject];
            
            [self analySisChangeDefaultBankModel:model];
        }
    }
}
//失败
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
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
#pragma Model 解析
- (void)analySisLoanDetailModel:(LoanDetailModel *)model{

    _detailModel = model;//保存贷款详情model
    self.loanNoStr =model.body.loanNo;
    
    if (!_alreadySearch) {
        
        [self overdueSearch];
    }
    if ([_haveContract isEqualToString:@"1"]) {
        
        _contractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _contractBtn.frame = CGRectMake(DeviceWidth - 40, 10, 40, 40);
        [_contractBtn setImage:[UIImage imageNamed:@"邀请圆"] forState:UIControlStateNormal];
        [_contractBtn addTarget:self action:@selector(comeContract) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_contractBtn];
    }
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        [AppDelegate delegate].userInfo.applSeq = model.body.applSeq;
        
        [self setTabelView];
        
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
    }
}
- (void)analySisArrearsModel:(ArrearsModel *)model{

    if ([model.msgall.errorCode isEqualToString:@"00000"]) {
        //                全部金额 = 应还本金 + 应还里息  应还费用 + 逾期利息 + 应还复利
        _total = [NSString stringWithFormat:@"%@",[[[NSDecimalNumber decimalNumberWithString: model.msgall.OD_INT] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:model.msgall.COMM_INT]] decimalNumberByAdding:[[[NSDecimalNumber decimalNumberWithString:model.msgall.PRCP_AMT] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:model.msgall.NORM_INT]] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:model.msgall.FEE_AMT]]]];
        UITableViewCell *cell = [_yuQiTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UITableViewCell *cell2 = [_yuQiTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UISwitch * swtch = [cell.contentView viewWithTag:200];
        //    数据管理者
        NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
        UITextField *money = [cell2.contentView viewWithTag:222];
        
        if (swtch.on) {
            money.textColor = [UIColor blackColor];
            money.textAlignment = NSTextAlignmentLeft;
            money.font = [UIFont appFontBoldOfSize:14];
            //        关闭交互
            money.userInteractionEnabled = NO;
            //          全部金额 = 应还本金 + 应还里息  应还费用 + 逾期利息 + 应还复利
            NSDecimalNumber *overFee = [[[[NSDecimalNumber decimalNumberWithString: model.msgall.OD_AMT] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:model.msgall.PRCP_AMT]] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:model.msgall.NORM_INT]] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:model.msgall.FEE_AMT]];
            
            money.text = [NSString stringWithFormat:@"%@",overFee];
            NSString *str = [NSString stringWithFormat:@"%@",overFee];
            
            if ([str isEqualToString:@"0"])
            {
                //            如果计算出来的金额为0，说明逾期费用为0 ，那么全部还款，就换待还 + 利息 + 费用
                NSDecimalNumber *moneyAll = [[[NSDecimalNumber decimalNumberWithString:_detailModel.body.repayPrcpAmt] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:_detailModel.body.psNormIntAmt] withBehavior:roundUp] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:_detailModel.body.feeAmt] withBehavior:roundUp];
                money.text = [NSString stringWithFormat:@"%@",moneyAll];
            }
            
            _payMoney = [NSString stringWithFormat:@"%@",money.text];
            [self searchAmonutByLoanNo:StringOrNull(_loanNoStr) Amount:_payMoney AndTag:111];
            
        }
        
        [self searchRemainDays];//查询逾期天数
    }else{
        
        [self buildHeadError:@"逾期费用查询失败"];
    }
}
- (void)analySisStageBillModel:(StageBillModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        for (StageBillModelBody * body in model.body) {
            if (body.days < 0) {
                
                currentDay = body.days;
                
            }
        }
        
        UITableViewCell *cell = [_yuQiTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UILabel *overDay = (UILabel *)[cell.contentView viewWithTag:100];
        overDay.text = [NSString stringWithFormat:@"逾期%ld天",(long)-(currentDay)];
        [_yuQiTable reloadData];
    }else{
        //                如果有问题，那么将问题抛出
        [self buildHeadError:model.head.retMsg];
    }
}
- (void)analySisAmountModel:(AmountModel *)model{

    if ([model.head.retFlag isEqualToString:@"00000"]) {
        _total = model.body.ze;
        _bottom.moneyLabel.attributedText = [self fomatStr:[NSString stringWithFormat:@"还款总额:¥%.2f",[model.body.ze floatValue]]];
        _payMoney = model.body.ze;
        _bj = model.body.bj;
        _sxf = model.body.sxf;
        _xf = model.body.xf;
    }else{
        
        [self buildHeadError:model.head.retMsg];
    }
}
- (void)analySisChangeDefaultBankModel:(ChangeDefaultBankModel *)model{

    if ([model.head.retFlag isEqualToString:SucessCode]) {
        _changeBankView.defaultBankLabel.text = _bankName;
        _detailModel.body.repayApplCardNo = _bankNumber;
        _detailModel.body.repayAccBankName = _bankName;
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
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseID
                ];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UILabel *quanBuHuanQing = [[UILabel alloc]initWithFrame:(CGRectMake(23 * DeviceWidth/375, CGRectGetMidY(cell.bounds) - 9, 62, 18))];
        quanBuHuanQing.text = @"全部还清";
        quanBuHuanQing.font = [UIFont appFontRegularOfSize:15];
        quanBuHuanQing.textColor = UIColorFromRGB(0x000000, 1.0);
        [cell.contentView addSubview:quanBuHuanQing];
        UILabel *YuQiData = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(quanBuHuanQing.frame) + 7 * DeviceWidth/375 , (cell.contentView.frame.size.height - 13)/2, 100, 13))];
        YuQiData.text = @"";
        YuQiData.tag = 100;
        YuQiData.textAlignment = NSTextAlignmentLeft;
        YuQiData.font = [UIFont appFontRegularOfSize:12];
        YuQiData.textColor = UIColorFromRGB(0xe9211d, 1.0);
        [cell.contentView addSubview:YuQiData];
        
        UISwitch *swt = [[UISwitch alloc]initWithFrame:(CGRectMake(308 * DeviceWidth/375, CGRectGetMidY(cell.bounds) -  15, 0, 0))];
        swt.transform = CGAffineTransformMakeScale(0.80, 0.80);
        
        //        给开关添加点击事件
        [swt addTarget:self action:@selector(swtChangeAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.contentView addSubview:swt];
        swt.tag = 200;
        swt.on = YES;
    }else if (indexPath.row == 1){
        UILabel *zhiHang = [[UILabel alloc]initWithFrame:(CGRectMake(23 * DeviceWidth/375, CGRectGetMidY(cell.bounds) - 9, 62, 18))];
        zhiHang.text = @"还款本金";
        zhiHang.font = [UIFont appFontRegularOfSize:15];
        zhiHang.textColor = UIColorFromRGB(0x000000, 1.0);
        [cell.contentView addSubview:zhiHang];
        //    可部分还款
        UITextField * textField = [[UITextField alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(zhiHang.frame) + 20, 18, 100, 16))];
        textField.font = [UIFont appFontRegularOfSize:14];
        textField.textColor = UIColorFromRGB(0x999999, 1.0);
        textField.tag = 222;
        [cell.contentView addSubview:textField];
        textField.delegate = self;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 48;
    }
    return 53;
    
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    return 0;
}


#pragma mark - textField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //改变还款总额
    _bottom.moneyLabel.attributedText = [self fomatStr:[NSString stringWithFormat:@"还款总额:¥%.2f",[textField.text floatValue]]];
    //    保存还款金额
    _payMoney = textField.text;
    
}

- (NSAttributedString *)fomatStr:(NSString *)money
{
    NSMutableAttributedString *attiText = [[NSMutableAttributedString alloc] initWithString:money];
    
    [attiText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, 5)];
    
    [attiText addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}  range:NSMakeRange(5, money.length-5)];

    return attiText;
}
@end
