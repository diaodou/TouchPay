//
//  LoanGetDetailsViewController.m
//  personMerchants
//
//  Created by 百思为科 on 16/6/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "LoanGetDetailsViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
//#import "StageApplicationViewController.h"
#import "BSVKHttpClient.h"
#import <MBProgressHUD.h>
#import "RMUniversalAlert.h"
#import "ConfirmPayNoBankViewController.h"
#import "AppDelegate.h"
//#import "StageViewController.h"
#import "ApprovalProgressViewController.h"
#import "UILabel+SizeForStr.h"
#import "PickUpCodeViewController.h"
//#import "GoodsStageDetailViewController.h"
#import <YYWebImage.h>
#import "ContractShowViewController.h"
#import "ChangDefaultBankView.h"
#import "AddBankViewController.h"
#import "ChangeDefaultBankModel.h"
#import "UpdateMsgStatusModel.h"
#import "InquiryModel.h"
#import "SubSignContModel.h"
#import "LoanDetailModel.h"
#import "OrdeDetailsModel.h"
#import "StageApplicationModel.h"
//#import "WareDetailModel.h"
#import "SubSignContractModel.h"
@interface LoanGetDetailsViewController ()<UITableViewDelegate,UITableViewDataSource, BSVKHttpClientDelegate,ChoiceDefaultBankDelegate>
{
    
    NSString * _applSeqStr;
    
    NSString * _stateStr; //判断
    
    NSString * _haveMenu; //判断有无套餐
    
    NSString * _bankName;
    
    NSString * _bankNumber;
    
    NSString * _bankType;
    
    NSString * _changeBankType;
}
@property (nonatomic, strong) UIView * contractView;

@property (nonatomic, strong) UIButton * contractBtn;//合同按钮

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ChangDefaultBankView *changeBankView;

@property (nonatomic, strong) UIView * mbView;

@property (nonatomic, strong) OrdeDetailsModel *orderDetailsModel;

@property (nonatomic, strong) LoanDetailModel * loanDetailModel;

@property (nonatomic, strong) NSArray *arrGoods;

@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation LoanGetDetailsViewController
#pragma mark -- lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"贷款详情";
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    if (_msgId) {
        
        [self updateMsgStatus];
    }
    if (_loanName == waitCashDischarge) {
        [AppDelegate delegate].userInfo.bReturn = NO;
    }else{
        [AppDelegate delegate].userInfo.bReturn = YES;
    }
    [self creatDetailReq]; // 贷款详情
    
    [self setNavi];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark -- setting and getting
//建表
-(void)setTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,DeviceWidth, DeviceHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    [self setTableViewHeaderView];
    
    [self setTableViewFooterView];
}
// 表头
-(void)setTableViewHeaderView{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 134)];
    _changeBankView = [[ChangDefaultBankView alloc]init];
    
    _changeBankView.frame = CGRectMake(0, 0, DeviceWidth, 104);
    
    [headerView addSubview:_changeBankView];
    
    if (_loanName == BeReturnCash || _loanName == BeReturnLoan) {
        _changeBankView.stateLabel.textAlignment = NSTextAlignmentRight;
        _changeBankView.stateLabel.text = @"审批退回";
        
        UILabel *reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_changeBankView.stateImage.frame), CGRectGetMaxY(_changeBankView.stateImage.frame)+5, DeviceWidth - 20, 20)];
        reasonLabel.text = [NSString stringWithFormat:@"退回原因:%@",_loanDetailModel.body.appOutAdvice];
        
        reasonLabel.textColor = [UIColor whiteColor];
        
        reasonLabel.font = [UIFont appFontRegularOfSize:14];
        
        CGFloat labelHeight = [reasonLabel boundingRectWithSize:CGSizeMake(DeviceWidth - 20,0)].height;
        
        reasonLabel.frame = CGRectMake(CGRectGetMinX(_changeBankView.stateImage.frame), CGRectGetMaxY(_changeBankView.stateImage.frame)+5, DeviceWidth - 20, labelHeight);
        
        reasonLabel.numberOfLines = 0;
        
        [_changeBankView.topView addSubview:reasonLabel];
        
        headerView.frame = CGRectMake(0, 0, DeviceWidth, 134 + 5 + labelHeight);
        
        _changeBankView.frame = CGRectMake(0, 0, DeviceWidth, 104 + 5 + labelHeight);
        
        _changeBankView.topView.frame = CGRectMake(0, 0, DeviceWidth, 40 + 5 +labelHeight);
        
        _changeBankView.bottomImage.frame = CGRectMake(0, 0, DeviceWidth, 40 + 5 +labelHeight);
        
        _changeBankView.topView.backgroundColor = [UIColor whiteColor];

        _changeBankView.bottomView.frame = CGRectMake(0, CGRectGetMaxY(_changeBankView.topView.frame), DeviceWidth, 54);
        
        _changeBankView.thirdView.frame = CGRectMake(0, CGRectGetMaxY(_changeBankView.bottomView.frame), DeviceWidth, 10);
    }else if (_loanName == BeCancelLoan){
        _changeBankView.stateLabel.text = @"取消放款";
    }
    else if (_loanName == ExaminationLoan || _loanName == ExaminationCash ||_loanName == MsgExaminationLoan|| _loanName == MsgExaminationCash) {
        _changeBankView.stateLabel.text = @"审批中";
    }
    else if (_loanName == waitCashDischarge){
        _changeBankView.stateLabel.text = @"等待放款";
    }
    else if (_loanName == WaitCashHaveExamination){
        _changeBankView.stateLabel.text = @"审批通过，等待放款";
    }
    else if (_loanName == CashHaveCancel || _loanName == LoanHaveCancel){
        _changeBankView.stateLabel.text = @"贷款已取消";
    }
    else if (_loanName == AuditCash){
        _changeBankView.stateLabel.text = @"放款审核中";
    }
    else if (_loanName == WaitPickUp){
        _changeBankView.stateLabel.text = @"待取货";
    }
    else if (_loanName == LoanBeRefuse){
        _changeBankView.stateLabel.textAlignment = NSTextAlignmentRight;
        _changeBankView.stateLabel.text = @"贷款被拒绝";
        
        UILabel *reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_changeBankView.stateImage.frame), CGRectGetMaxY(_changeBankView.stateImage.frame)+5, DeviceWidth - 20, 20)];
        reasonLabel.text = [NSString stringWithFormat:@"拒绝原因:%@",_loanDetailModel.body.appOutAdvice];
        
        reasonLabel.textColor = UIColorFromRGB(0x32beff, 1.0);
        
        reasonLabel.font = [UIFont appFontRegularOfSize:14];
        
        CGFloat labelHeight = [reasonLabel boundingRectWithSize:CGSizeMake(DeviceWidth - 20,0)].height;
        
        reasonLabel.frame = CGRectMake(CGRectGetMinX(_changeBankView.stateImage.frame), CGRectGetMaxY(_changeBankView.stateImage.frame)+5, DeviceWidth - 20, labelHeight);
        
        reasonLabel.numberOfLines = 0;
        
        [_changeBankView.topView addSubview:reasonLabel];
        
        headerView.frame = CGRectMake(0, 0, DeviceWidth, 134 + 5 + labelHeight);
        
        _changeBankView.frame = CGRectMake(0, 0, DeviceWidth, 104 + 5 + labelHeight);
        
        _changeBankView.topView.frame = CGRectMake(0, 0, DeviceWidth, 40 + 5 +labelHeight);
        
        _changeBankView.bottomImage.frame = CGRectMake(0, 0, DeviceWidth, 40 + 5 +labelHeight);
        
        _changeBankView.topView.backgroundColor = [UIColor whiteColor];
        
        _changeBankView.bottomView.frame = CGRectMake(0, CGRectGetMaxY(_changeBankView.topView.frame), DeviceWidth, 54);
        
        _changeBankView.thirdView.frame = CGRectMake(0, CGRectGetMaxY(_changeBankView.bottomView.frame), DeviceWidth, 10);
    }
    
    _changeBankView.defaultBankLabel.text = StringOrNull(_loanDetailModel.body.repayAccBankName);
    
    if (_loanDetailModel.body.repayApplCardNo.length > 4) {
        NSString * message = [_loanDetailModel.body.repayApplCardNo substringFromIndex:_loanDetailModel.body.repayApplCardNo.length - 4];
        
        _changeBankView.bankNumberLabel.text = [NSString stringWithFormat:@"****%@",message];
    }else{
        
        _changeBankView.bankNumberLabel.text = @"";
    }
    if (_loanName == BeReturnCash || _loanName == BeReturnLoan) {
        
        _changeBankView.arrow.hidden = NO;
        UITapGestureRecognizer *tapGuest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBank)];
        
        [_changeBankView.bottomView addGestureRecognizer:tapGuest];
    }else{
        if (iphone6P) {
            _changeBankView.bankNumberLabel.frame = CGRectMake(DeviceWidth - 220 *scaleAdapter,0, 200 *scaleAdapter, 54);
        }else{
            _changeBankView.bankNumberLabel.frame = CGRectMake(DeviceWidth - 210 *scaleAdapter,0, 200 *scaleAdapter, 54);
        }
        
        _changeBankView.arrow.hidden = YES;
    }
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_changeBankView.frame), 160, 30)];
    if (iphone6P) {
        
        timeLabel.frame = CGRectMake(20, CGRectGetMaxY(_changeBankView.frame), 160, 30);
    }
    UILabel * applCdeLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth - 200 , CGRectGetMaxY(_changeBankView.frame), 190, 30)];
    if (iphone6P) {
        
        applCdeLabel.frame = CGRectMake(DeviceWidth - 210 , CGRectGetMaxY(_changeBankView.frame), 190, 30);
    }
    applCdeLabel.textAlignment = NSTextAlignmentRight;
    if (iphone6P || iphone6) {
        timeLabel.font = [UIFont appFontRegularOfSize:12];
        applCdeLabel.font = [UIFont appFontRegularOfSize:12];
    }else{
        timeLabel.font = [UIFont appFontRegularOfSize:11];
        applCdeLabel.font = [UIFont appFontRegularOfSize:11];
    }
    applCdeLabel.text = _applSeqStr;
    timeLabel.text = _timeLabel.text;
    [headerView addSubview:applCdeLabel];
    [headerView addSubview:timeLabel];
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth - 160, CGRectGetMaxY(_changeBankView.frame), 140, 30)];
    numberLabel.font = [UIFont appFontRegularOfSize:12];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:numberLabel];
    _tableView.tableHeaderView = headerView;
}
// 表尾
-(void)setTableViewFooterView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 110)];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 0.5)];
    topView.backgroundColor = UIColorFromRGB(0xececec,1.0);
    [footView addSubview:topView];
    
    UILabel *pricipalLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + 15 , DeviceWidth/3, 14)];
    
    pricipalLabel.textAlignment=NSTextAlignmentCenter;
    
    pricipalLabel.text=@"分期本金（元）";
    
    pricipalLabel.font=[UIFont appFontRegularOfSize:13];
    
    pricipalLabel.textColor=UIColorFromRGB(0x343434, 1.0);
    
    [footView addSubview:pricipalLabel];
    
    UILabel *priManey=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(pricipalLabel.frame) +13, DeviceWidth/3, CGRectGetHeight(pricipalLabel.frame))];
    
    priManey.textAlignment=NSTextAlignmentCenter;
    //     分期本金 = 借款总额
    priManey.text =[NSString stringWithFormat:@"%.2f",[_loanDetailModel.body.apprvAmt floatValue]];
    
    priManey.font = [UIFont appFontRegularOfSize:13];
    
    priManey.textColor=UIColorFromRGB(0xff5500, 1.0);
    
    [footView addSubview:priManey];
    
    UILabel *dividendLabel=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/3, CGRectGetMinY(pricipalLabel.frame), DeviceWidth/3, CGRectGetHeight(pricipalLabel.frame))];
    
    dividendLabel.textAlignment=NSTextAlignmentCenter;
    
    dividendLabel.text=@"息费（元）";
    
    dividendLabel.font=[UIFont appFontRegularOfSize:13];
    
    dividendLabel.textColor=UIColorFromRGB(0x333333, 1.0);
    
    [footView addSubview:dividendLabel];
    
    UILabel *divManey=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/3, CGRectGetMaxY(pricipalLabel.frame) + 13, DeviceWidth/3, CGRectGetHeight(pricipalLabel.frame))];
    
    divManey.textAlignment=NSTextAlignmentCenter;
    
    divManey.font=[UIFont appFontRegularOfSize:13];
    
    if ([_loanDetailModel.body.applyTnrTyp isEqualToString:@"D"]||[_loanDetailModel.body.applyTnrTyp isEqualToString:@"d"]) {
        divManey.text = [NSString stringWithFormat:@"按日计息\n每日%@元",_loanDetailModel.body.rlx];
        CGFloat totalManeyHeight = [divManey boundingRectWithSize:CGSizeMake(DeviceWidth/3,0)].height;
        if (totalManeyHeight < 14) {
            totalManeyHeight = 14;
        }
        divManey.numberOfLines = 0;
        divManey.frame = CGRectMake(DeviceWidth/3, CGRectGetMaxY(pricipalLabel.frame) + 8, DeviceWidth/3, totalManeyHeight);
    }else{
    //    息费总额
    divManey.text= [NSString stringWithFormat:@"%.2f",[_loanDetailModel.body.psNormIntAmt floatValue] + [_loanDetailModel.body.feeAmt floatValue]];
    }
    
    
    divManey.textColor=UIColorFromRGB(0xff5500, 1.0);
    
    [footView addSubview:divManey];
    
    
    UILabel *totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth*2/3, CGRectGetMinY(pricipalLabel.frame), DeviceWidth/3, CGRectGetHeight(pricipalLabel.frame))];
    
    totalLabel.textAlignment=NSTextAlignmentCenter;
    
    totalLabel.text=@"合计金额（元）";
    
    totalLabel.font=[UIFont appFontRegularOfSize:13];
    
    totalLabel.textColor=UIColorFromRGB(0x343434, 1.0);
    
    [footView addSubview:totalLabel];
    
    UILabel *totalManey=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth*2/3, CGRectGetMaxY(pricipalLabel.frame) + 13, DeviceWidth/3, CGRectGetHeight(pricipalLabel.frame))];
    
    totalManey.textAlignment=NSTextAlignmentCenter;
    totalManey.font=[UIFont appFontRegularOfSize:13];
    //    合计金额 =  总还款额totalAmt + 费用总额totalFeeAmt
    if ([_loanDetailModel.body.applyTnrTyp isEqualToString:@"D"]||[_loanDetailModel.body.applyTnrTyp isEqualToString:@"d"]) {
        totalManey.text= [NSString stringWithFormat:@"本金+%@元/日",_loanDetailModel.body.rlx];
        CGFloat totalManeyHeight = [totalManey boundingRectWithSize:CGSizeMake(DeviceWidth/3,0)].height;
        if (totalManeyHeight < 14) {
            totalManeyHeight = 14;
        }
        totalManey.numberOfLines = 0;
        totalManey.frame = CGRectMake(DeviceWidth*2/3, CGRectGetMaxY(pricipalLabel.frame) + 13, DeviceWidth/3, totalManeyHeight);
    }else{
        totalManey.text=[NSString stringWithFormat:@"%.2f",[_loanDetailModel.body.apprvAmt floatValue] + [_loanDetailModel.body.psNormIntAmt floatValue] + [_loanDetailModel.body.feeAmt floatValue]];
    }
    
    
    totalManey.textColor=UIColorFromRGB(0xff5500, 1.0);
    
    [footView addSubview:totalManey];
    
    UIView *viewSep=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(totalManey.frame) + 21, DeviceWidth, 1)];
    
    viewSep.backgroundColor=UIColorFromRGB(0xececec, 1.0);
    
    [footView addSubview:viewSep];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button.frame = CGRectMake(DeviceWidth - 90, CGRectGetMaxY(viewSep.frame) + 5, 80, 30);
    
    if (iphone6P) {
        
        button.frame = CGRectMake(DeviceWidth - 100, CGRectGetMaxY(viewSep.frame) + 5, 80, 30);
    }
    [button setBackgroundColor:UIColorFromRGB(0x32beff, 1.0)];
    if (_loanName == BeReturnCash) {  //退回  现金贷
        [button setTitle:@"修改提交" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(toStage) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (_loanName == BeReturnLoan){ //被退回   商品贷
        [button setTitle:@"修改提交" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(toStageViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (_loanName == waitCashDischarge){ //等待放款
        [button setTitle:@"申请放款" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(toSignContract) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if (_loanName == MsgExaminationCash || _loanName == MsgExaminationLoan){
        [button setTitle:@"审批进度" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(toExamination) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if (_loanName == WaitPickUp){
        
        [button setTitle:@"确认取货" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(toPickUpCodeViewController) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else{
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    
    [button setTintColor:[UIColor whiteColor]];
    
    button.titleLabel.font = [UIFont appFontRegularOfSize:13];
    
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    
    button.layer.borderWidth = 0.5f;
    
    [footView addSubview:button];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + 5, DeviceWidth, 0.5)];
    
    bottomView.backgroundColor = UIColorFromRGB(0xececec, 1.0);
    
    [footView addSubview:bottomView];
    
    _tableView.tableFooterView = footView;
}
- (void)creatContractBtn{
    _contractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _contractBtn.frame = CGRectMake(DeviceWidth - 40, 10, 40, 40);
    [_contractBtn setImage:[UIImage imageNamed:@"邀请圆"] forState:UIControlStateNormal];
    [_contractBtn addTarget:self action:@selector(comeContract) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_contractBtn];
    
    if(self.loanName == waitCashDischarge && ![_loanDetailModel.body.applyAmt isEqualToString:_loanDetailModel.body.apprvAmt])
    {
        _contractBtn.hidden = YES;
    }
    else
    {
        _contractBtn.hidden = NO;
    }
}
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
#pragma mark -- tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrGoods.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90 * scaleAdapter;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 80*scaleAdapter)];
        bjView.tag = 1;
        [cell.contentView addSubview:bjView];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5*scaleAdapter, 80*scaleAdapter, 70*scaleAdapter)];
        if (iphone6P) {
            img.frame = CGRectMake(20, 5*scaleAdapter, 80*scaleAdapter, 70*scaleAdapter);
        }
        img.tag = 10;
        [bjView addSubview:img];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame) + 3, 0, 150, 80*scaleAdapter)];
        nameLabel.tag = 11;
        nameLabel.font = [UIFont appFontRegularOfSize:13];
        [bjView addSubview:nameLabel];
        
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth -  120, 0, 110, 80*scaleAdapter)];
        if (iphone6P) {
            
            moneyLabel.frame = CGRectMake(DeviceWidth -  130, 0, 110, 80*scaleAdapter);
        }
        moneyLabel.tag = 12;
        moneyLabel.textAlignment = NSTextAlignmentRight;
        moneyLabel.font = [UIFont systemFontOfSize:12];
        [bjView addSubview:moneyLabel];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 80*scaleAdapter, DeviceWidth, 10*scaleAdapter)];
        bottomView.tag = 13;
        [cell.contentView addSubview:bottomView];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *bjView = [(UIView *)cell.contentView viewWithTag:1];
    
    bjView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    UIImageView *img = [(UIImageView *)bjView viewWithTag:10];
    
    img.image = [UIImage imageNamed:@"1.jpg"];
    
    UILabel *nameLabel = [(UILabel *)bjView viewWithTag:11];
    
    NSString * nameStr;
    
    if([_loanDetailModel.body.goods[indexPath.row].goodsName rangeOfString:@"goodname"].location !=NSNotFound)//_roaldSearchText
    {
        NSRange range  = [_loanDetailModel.body.goods[indexPath.row].goodsName rangeOfString:@"goodname"];
        
        nameStr = [_loanDetailModel.body.goods[indexPath.row].goodsName substringFromIndex:range.location+range.length];  //名称
    }
    else
    {
        nameStr = _loanDetailModel.body.goods[indexPath.row].goodsName;
    }
    nameLabel.text = [NSString stringWithFormat:@"%@ x %ld",nameStr,(long)_loanDetailModel.body.goods[indexPath.row].goodsNum];
    
    if (_loanDetailModel.body.goods.count > 0) {
        
        if(_loanDetailModel.body.goods[indexPath.row].goodsCode && _loanDetailModel.body.goods[indexPath.row].goodsCode.length > 0)
        {
            if([(id)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,_loanDetailModel.body.goods[indexPath.row].goodsCode]] isKindOfClass:[UIImage class]])
            {
                UIImage *tempData =(UIImage *)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,_loanDetailModel.body.goods[indexPath.row].goodsCode]];
                img.image = tempData;
            }else if ([(id)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,_loanDetailModel.body.goods[indexPath.row].goodsCode]] isKindOfClass:[NSData class]])
            {
                NSData *tempData =(NSData *)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,_loanDetailModel.body.goods[indexPath.row].goodsCode]];
                img.image = [UIImage imageWithData:tempData];
            }else
            {
                img.image = [UIImage imageNamed:@"贷款列表默认图片"];
                [[YYWebImageManager sharedManager]requestImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,_loanDetailModel.body.goods[indexPath.row].goodsCode]] options:YYWebImageOptionShowNetworkActivity progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    if (image) {
                        [[AppDelegate delegate].imagePutCache setObject:image forKey:url.absoluteString];
                        img.image = image;
                    }
                }];
            }
        }
        else
        {
            img.image = [UIImage imageNamed:@"贷款列表默认图片"];
        }   
    }else{
        
        img.image = [UIImage imageNamed:@"贷款列表默认图片"];
    }

    UILabel *moneyLabel = [(UILabel *)bjView viewWithTag:12];
    
    moneyLabel.text = [NSString stringWithFormat:@"%.2f元",_loanDetailModel.body.goods[indexPath.row].goodsPrice];
    
    UIView *bottomView = [(UIView *)cell.contentView viewWithTag:13];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -private Methods
//设置导航
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
    
    NSArray * array = self.navigationController.viewControllers;
    
    for(UIViewController *vc in array)
    {
        if ([vc isKindOfClass:[ApprovalProgressViewController class]])
        {
            [AppDelegate delegate].userInfo.bReturn = NO;
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)toStage{
    //跳转到现金贷
//    StageViewController * vc = [[StageViewController alloc]init];
//    
//    vc.loanDetailBody = _loanDetailModel.body;
//    
//    vc.flowName = beReturnCashLoan;
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)toExamination{   //审批进度
    ApprovalProgressViewController * vc = [[ApprovalProgressViewController alloc]init];
//    vc.stateStr = @"审批中";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)toSignContract{
    // 判断 状态
    if ([_loanDetailModel.body.applyAmt isEqualToString:_loanDetailModel.body.apprvAmt]) {
        
        [self subSignCont];//等值 直接申请放款
    }else{
        _stateStr = @"申请放款";
        [self changeLoan];
    }
}

// 跳转确认支付
-(void)toConfirmPayNoBankViewController{
    ConfirmPayNoBankViewController * vc  = [[ConfirmPayNoBankViewController alloc]init];
//    vc.flowName = waitLoan;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)toPickUpCodeViewController{
    PickUpCodeViewController *vc = [[PickUpCodeViewController alloc]init];
    vc.codeStr = _loanDetailModel.body.applCde;
    [self.navigationController pushViewController:vc animated:YES];
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
- (void)changeBank{
    
//    if (_LoanName == WaitCashHaveExamination) {
//       
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        
//        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//        
//        if ([_loanDetailModel.body.applyTnrTyp isEqualToString:@"D"] || [_loanDetailModel.body.applyTnrTyp isEqualToString:@"d"]) {
//            [parmDic setObject:_loanDetailModel.body.applyTnrTyp forKey:@"applyTnrTyp"];//期限类型
//        }else{
//            [parmDic setObject:StringOrNull(_loanDetailModel.body.applyTnr) forKey:@"applyTnrTyp"];//期限类型
//        }
//        [parmDic setObject:StringOrNull(_loanDetailModel.body.applyAmt) forKey:@"apprvAmt"];//贷款金额
//        [parmDic setObject:StringOrNull(_loanDetailModel.body.applyTnr)  forKey:@"applyTnr"];//贷款期限
//        [parmDic setObject:StringOrNull(_loanDetailModel.body.loanTyp) forKey:@"typCde"];//贷款品种代码
//        
//        [BSVKHttpClient shareInstance].delegate = self;
//        
//        [[BSVKHttpClient shareInstance] postInfo:@"app/appserver/customer/getPaySs" requestArgument:parmDic requestTag:101 requestClass:NSStringFromClass([self class])];
//        
//    }else{
//     
//        
//    }
//
    
    AddBankViewController * bank = [[AddBankViewController alloc]init];
    
    bank.choiceBank = choiceDefaultCard;

    bank.choiceDefaultDelegate = self;
    
    [self.navigationController pushViewController:bank animated:YES];

    
   
    
}
//选择默认还款卡代理
- (void)choiceBank:(BankInfo *)backinfo{
    if (_loanName == WaitCashHaveExamination) {
        _bankNumber = backinfo.cardNo;
        _bankName = backinfo.bankName;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [BSVKHttpClient shareInstance].delegate = self;
        
        [[BSVKHttpClient shareInstance]postInfo:@"app/appserver/appInfo/setHkNo" requestArgument:@{@"orderNo":StringOrNull(_orderDetailsModel.body.orderNo),@"cardNo":StringOrNull(backinfo.cardNo)} requestTag:100 requestClass:NSStringFromClass([self class])];
    }else{
    _changeBankView.defaultBankLabel.text = backinfo.bankName;
    _loanDetailModel.body.repayApplCardNo = backinfo.cardNo;
    _loanDetailModel.body.repayAccBankName = backinfo.bankName;
    
    if (backinfo.cardNo.length > 4) {
        NSString * message = [backinfo.cardNo substringFromIndex:backinfo.cardNo.length - 4];
        
        _changeBankView.bankNumberLabel.text = [NSString stringWithFormat:@"****%@",message];
    }else{
        
        _changeBankView.bankNumberLabel.text = @"";
        }
    }
}
// 被退回  商品贷
-(void)toStageViewController{
    _stateStr = @"商品贷";
    [self changeLoan];
}
#pragma mark -- 请求
- (void)creatDetailReq{
    BSVKHttpClient * detailClint = [BSVKHttpClient shareInstance];
    detailClint.delegate = self;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"applSeq"];
    [detailClint getInfo:@"app/appserver/apporder/queryAppLoanAndGoods" requestArgument:dict requestTag:10 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
// 合同签约提交
-(void)subSignContract{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[AppDelegate delegate].userInfo.applSeq forKey:@"applSeq"];
    [dic setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
    [dic setObject:@"123" forKey:@"verifiCode"];
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/subSignContract" requestArgument:dic requestTag:205 requestClass:NSStringFromClass([self class])];
}

// 修改订单
-(void)changeLoan{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/customer/getReturnOrder" requestArgument:@{@"applSeq":[AppDelegate delegate].userInfo.applSeq,@"source":@"2",@"version":@"2"} requestTag:207 requestClass:NSStringFromClass([self class])];
}
//申请放款
-(void)subSignCont{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance] getInfo:@"app/appserver/subSignCont" requestArgument:@{@"applSeq":[AppDelegate delegate].userInfo.applSeq} requestTag:260 requestClass:NSStringFromClass([self class])];
    
}
- (void)updateMsgStatus{
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]postInfo:@"app/appserver/message/updateMsgStatus" requestArgument:@{@"msgId":_msgId} completion:^(id results, NSError *error) {
        if (results) {
            NSLog(@"成功");
        }
    }];
}
#pragma mark - BSVKHttpClientDelegate
//成功
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 10)
        {
            _loanDetailModel = [LoanDetailModel mj_objectWithKeyValues:responseObject];
            
            //如果是等待放款且是审批降额的情况，不展示合同
            if ([_haveContract isEqualToString:@"1"]) {
                
                [self creatContractBtn];
            }
            
            [self analySisLoanDetailModel];
            
        }else if (requestTag == 205){
            
            SubSignContractModel *model = [SubSignContractModel mj_objectWithKeyValues:responseObject];
            
            [self analySisSubSignContractModel:model];

        }else if (requestTag == 207){
            
            _orderDetailsModel = [OrdeDetailsModel mj_objectWithKeyValues:responseObject];
            
            [self analySisOrdeDetailsModel];
            
        }else if (requestTag == 260){
            
            SubSignContModel * model = [SubSignContModel mj_objectWithKeyValues:responseObject];
            
            [self analySisSubSignContModel:model];
            
        }else if (requestTag == 100){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            ChangeDefaultBankModel *model = [ChangeDefaultBankModel mj_objectWithKeyValues:responseObject];
            
            [self analySisChangeDefaultBankModel:model];
            
        }else if (requestTag == 101){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            StageApplicationModel *model = [StageApplicationModel mj_objectWithKeyValues:responseObject];
            
            [self setValuesForBottom:model];
        }
    }
}
//失败
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if(httpCode != 0)
        {
            [self buildHeadError:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",httpCode]];
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
- (void)buildAndReturn:(NSString *)Msg{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:Msg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}
#pragma mark - Model 解析

//底部view赋值
- (void)setValuesForBottom:(StageApplicationModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        NSString *_payMaxMoney = @"0";
        
        for (StageApplicationModelMx *max in model.body.mx) {
            
            if ([self isJudgeOneString:max.instmAmt twoString:_payMaxMoney]) {
                
                _payMaxMoney = max.instmAmt;
                
            }
            
        }
        
        AddBankViewController * bank = [[AddBankViewController alloc]init];
        
        bank.choiceBank = choiceDefaultCard;
        
        bank.choiceDefaultDelegate = self;
        
        [self.navigationController pushViewController:bank animated:YES];

        
    }else{
        
        [self buildHeadError:model.head.retMsg];
    }
    
    
}

//比较字符串大小 jack > rose
-(BOOL)isJudgeOneString:(NSString *)jack twoString:(NSString *)rose{
    
    NSDecimalNumber *kiss = [[NSDecimalNumber alloc]initWithString:jack];
    
    NSDecimalNumber *kill  =[[NSDecimalNumber alloc]initWithString:rose];
    
    if (([kiss compare:kill] == NSOrderedDescending)) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}

- (void)analySisLoanDetailModel{
    if ([_loanDetailModel.head.retFlag isEqualToString:SucessCode]) {
        
        _arrGoods = _loanDetailModel.body.goods;  //商品组
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = _loanDetailModel.body.applyDt;
        _applSeqStr =_loanDetailModel.body.applCde;
        if (!self.formTyp) {
            
            self.formTyp = _loanDetailModel.body.formTyp;
        }
        [self setTableView];
    }else{
        [self buildAndReturn:_loanDetailModel.head.retMsg];
    }
}
- (void)analySisSubSignContractModel:(SubSignContractModel *)model{
    if ([model.head.retFlag isEqualToString:SucessCode]) {
    
        [self buildAndReturn:@"申请放款成功"];
    }else{
        [self buildHeadError:model.head.retMsg];
    }
}
- (void)analySisOrdeDetailsModel{
    if ([_orderDetailsModel.head.retFlag isEqualToString:SucessCode]) {
        
        [AppDelegate delegate].userInfo.orderNo = _orderDetailsModel.body.orderNo;
        
        if ([_stateStr isEqualToString:@"申请放款"]) {
            
            [self toConfirmPayNoBankViewController]; //跳转确认支付
            
        }else if([_stateStr isEqualToString:@"商品贷"]){
            
            [AppDelegate delegate].userInfo.orderNo = _orderDetailsModel.body.orderNo;
            
            [AppDelegate delegate].userInfo.applSeq = _orderDetailsModel.body.applseq;
            
            NSString * packAgeStr;
            
            if([_orderDetailsModel.body.goods[0].goodsName rangeOfString:@"goodname"].location !=NSNotFound)
            {
                NSRange range  = [_orderDetailsModel.body.goods[0].goodsName rangeOfString:@"goodname"];
                
                packAgeStr = [_orderDetailsModel.body.goods[0].goodsName substringToIndex:range.location];  //套餐
            }
            else{
                packAgeStr = @"";
            }
//            if ([self.formTyp isEqualToString:@"20"]) {
//                GoodsStageDetailViewController *goods = [[GoodsStageDetailViewController alloc]init];
//                
//                goods.flowName = BeReturnAdvertStage;
//                
//                goods.merchantCode = _orderDetailsModel.body.merchNo;
//                
//                goods.strManagerID = _orderDetailsModel.body.crtUsr;
//                
//                goods.ordeDetailsBody = _orderDetailsModel;
//                
//                goods.returnLastView = _returnLastView;
//                
//                [self.navigationController pushViewController:goods animated:YES];
//            }else{
//                
//                StageApplicationViewController *goods = [[StageApplicationViewController alloc]init];
//                
//                if (_LoanName == BeReturnLoan) {
//                    
//                    goods.flowName = BeReTurnStage;
//                }else{
//                    
//                    goods.flowName = BeReturnLoanByMerchant;
//                }
//                                
//                if (packAgeStr.length > 0)
//                {
//                    goods.scantype = goodHasMenuEnter;
//                }else
//                {
//                    goods.scantype = goodNoMenuEnter;
//                    
//                }
//                goods.merchantCode = _orderDetailsModel.body.merchNo;
//                
//                goods.strManagerID = _orderDetailsModel.body.crtUsr;
//                
//                goods.ordeDetailsBody = _orderDetailsModel;
//                
//                goods.scanInfoModel = [[ScanTableModel alloc]init];
//               
//                goods.scanInfoModel.goodBrand = _orderDetailsModel.body.goods[0].goodsBrand;
//                
//                goods.scanInfoModel.goodKind = _orderDetailsModel.body.goods[0].goodsKind;
//                
//                [self.navigationController pushViewController:goods animated:YES];
//            }
        }
    }else{
        [self buildHeadError:_orderDetailsModel.head.retMsg];
    }
}
- (void)analySisSubSignContModel:(SubSignContModel *)model{
    if ([model.head.retFlag isEqualToString:SucessCode]) {
       
        [self buildAndReturn:@"申请放款成功"];
    }else{
        [self buildAndReturn:model.head.retMsg];
    }
}

- (void)analySisChangeDefaultBankModel:(ChangeDefaultBankModel *)model{
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        _changeBankView.defaultBankLabel.text = _bankName;
        _orderDetailsModel.body.repayApplCardNo = _bankNumber;
        _orderDetailsModel.body.repayAccBankName = _bankName;
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
@end
