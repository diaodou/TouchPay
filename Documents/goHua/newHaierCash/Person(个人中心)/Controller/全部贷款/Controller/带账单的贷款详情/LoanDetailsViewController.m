//
//  LoanDetailsViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/18.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "LoanDetailsViewController.h"
#import "LoandetailsStagesTableViewCell.h"
#import "HCMacro.h"
#import "ConfirmPayViewController.h"
#import "LoanDetailCommonView.h"
#import "UIFont+AppFont.h"
#import "AnyTimeBackController.h"
#import "BackOverrViewController.h"
#import "ConfirmPayNoBankViewController.h"
#import "RMUniversalAlert.h"
#import "LoanTopView.h"
#import "HCRootNavController.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import <MJExtension.h>
#import <MBProgressHUD.h>
#import "LoanDetailModel.h"
#import "StageBillModel.h"
#import "ArrearsModel.h"
#import <YYWebImage.h>
#import "AppDelegate.h"
#import "AmountModel.h"
#import "ContractShowViewController.h"
#import "RepayDetailViewCcontroller.h"
#import "ReturnReasonViewController.h"
#import "ApprovalProgressViewController.h"
//#import "WareDetailViewController.h"
#import "ChangDefaultBankView.h"
#import "PayBackBottomView.h"
#import "AddBankViewController.h"
//#import "StageViewController.h"
#import "ChangeDefaultBankModel.h"
#import "WhiteSearchModel.h"
#import "IndetityStore.h"
#import "OrdeDetailsModel.h"
#import "CheckListModel.h"
static const CGFloat getCustIsPass = 1017;                //准入资格查询
static const CGFloat getInvitedCustByCustNo = 1018;       //查询邀请原因
static const CGFloat getCustInfoAndEdInfoPerson = 1019;   //录单校验
static const CGFloat getAppOrderAndGoods = 1013;          //查询订单详情

@interface LoanDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,BSVKHttpClientDelegate,ChoiceDefaultBankDelegate>
{
    NSString *numberStr;//贷款编号
    NSString *timeStr;//时间
    NSString *nameStr;//贷款编号
    NSString *moneyStr;
    
    StageBillModel  *_stageBillModel;//分期账单的model
    NSString *lateFees;//保存逾期费用
    NSInteger _settleCount;//保存已经结清的期数
    NSDecimalNumber *discountAmount;        //自己计算的总金额(到分期最后一天,只是显示)
    NSDecimalNumber *discountAmountOverData;//保存逾期金额
    NSMutableArray *overdueDateArr;//逾期数组
    UILabel *overDueLab ;//逾期label
    BOOL mixData ;//有逾期和非逾期混的
    NSString *payStyly;//还全部还是还全部逾期
    NSString *payMode ;//
    NSString *totalMoney;                   //保存请求下来的总金额(实际需要还款的)
    UIButton * contractBtn;//合同按钮
    BOOL alreadySearch;//是否已经走了欠款查询
    ArrearsModel *arrearsmodel;
    UIView *contractView;
    NSString *_paymaxMoney;//单期最大还款金额
    
    UIView *bjView;
    NSString *_bj;    //本金(全部还款)
    NSString *_sxf;   //手续费(全部还款)
    NSString *_xf;    //息费(全部还款)
}
@property (nonatomic,strong) UITableView *loanDetailTableView;
@property (nonatomic,strong) PayBackBottomView *bottom;//底部View
@property(nonatomic,strong) NSString *goodsName;//商品名字
@property (nonatomic, strong) UILabel *summary;  //底部总结
@property (nonatomic, strong) UIButton * returnBtn; //申请退货按钮
@property (nonatomic, strong) UILabel *interestDays; //利息天数
@property (nonatomic, strong) UILabel *totalManey; //总金额
@property (nonatomic, strong) UILabel *divManey; //利息
@property (nonatomic, strong) UILabel *priManey; //分期本金
@property(nonatomic, strong) NSMutableArray *cellArray;// 存放所有cell模型的数组
@property(nonatomic,strong)ChangDefaultBankView *changeBankView;
@property (nonatomic,copy)NSString *bankName;
@property (nonatomic,copy)NSString *bankNumber;
@property (nonatomic,copy)NSString *bankType;
@property (nonatomic,copy)NSString *changeBankType;
@property (nonatomic,strong) UIView * mbView;
@property (nonatomic,strong) NSMutableArray *choosedArr;//选择的还款金额数组
@property (nonatomic,copy) NSArray *dataArr;//存放每期详情的数组
@property (nonatomic,assign) BOOL showBtn;
@property (nonatomic,strong) UIImageView * returnImg;  //退货原因图标
@property (nonatomic,strong) WhiteSearchModel *searchModel;        //白名单Model

@end

@implementation LoanDetailsViewController
@synthesize loanDetailModel;
#pragma mark -- lift cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _choosedArr = [NSMutableArray array];
    self.title = @"贷款详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self setNavi];
    if (![_ifSettled isEqualToString:@"SE"]) {
          [self setBottomView];
    }else{
        [self creatEndView];
    }
    [AppDelegate delegate].userInfo.bReturn = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notShow) name:@"returnSuccess" object:nil];
    //贷款详情
    [self getLoanDetail];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
#pragma mark -- set view

- (void)setLoanDetailTableView
{
    _loanDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, DeviceWidth, DeviceHeight  - 64 - 49)];
    _loanDetailTableView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    _loanDetailTableView.delegate = self;
    _loanDetailTableView.dataSource = self;
    _loanDetailTableView.tableFooterView = [[UIView alloc]initWithFrame:(CGRectZero)];
    overdueDateArr = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UINib *LoanDetailsStagesnib = [UINib nibWithNibName:@"LoandetailsStagesTableViewCell" bundle:[NSBundle mainBundle]];
    [_loanDetailTableView registerNib:LoanDetailsStagesnib forCellReuseIdentifier:@"LoandetailsStagesTableViewCellcellID"];
    [self.view addSubview:_loanDetailTableView];
}

- (void)settableViewHeader
{
    
    bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 360)];
    bjView.backgroundColor = [UIColor whiteColor];
    
    _changeBankView = [[ChangDefaultBankView alloc]init];
    
    _changeBankView.frame = CGRectMake(0, 0, DeviceWidth, 104);
    
    [bjView addSubview:_changeBankView];
    
    
    _changeBankView.defaultBankLabel.text = StringOrNull(loanDetailModel.body.repayAccBankName);
    
    if (loanDetailModel.body.repayApplCardNo.length > 4) {
        NSString * message = [loanDetailModel.body.repayApplCardNo substringFromIndex:loanDetailModel.body.repayApplCardNo.length - 4];
        
        _changeBankView.bankNumberLabel.text = [NSString stringWithFormat:@"****%@",message];
    }else{
        
        _changeBankView.bankNumberLabel.text = @"";
    }
    
    if (![_ifSettled isEqualToString:@"SE"]) {
        _changeBankView.arrow.hidden = NO;
        
        UITapGestureRecognizer *tapGuest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBank)];
        
        [_changeBankView.bottomView addGestureRecognizer:tapGuest];
    }
    

    
    LoanTopView *topView = [[LoanTopView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_changeBankView.frame), DeviceWidth, 116)];
    topView.labelTime.hidden = NO;
    numberStr = @"";
    topView.labelTime.text = [NSString stringWithFormat:@"%@",numberStr];
    topView.labelTime.font = [UIFont appFontRegularOfSize:12];
    topView.labelTime.textColor = UIColorFromRGB(0x666666, 1.0);
    topView.labelState.hidden = NO;
    timeStr = @"";
    topView.labelState.text = [NSString stringWithFormat:@"%@",timeStr];
    topView.labelState.font = [UIFont appFontRegularOfSize:10];
    topView.labelState.textColor = UIColorFromRGB(0x666666, 1.0);
    topView.viewIcon.hidden = NO;
    topView.labelMidContent.hidden = NO;
    nameStr = @"";
    topView.labelMidContent.text = [NSString stringWithFormat:@"%@",nameStr];
    topView.labelMidContent.font = [UIFont appFontRegularOfSize:13];
    topView.labelMidContent.textColor = UIColorFromRGB(0x3d4244, 1.0);
    topView.labelRight.hidden = NO;
    topView.labelRight.font = [UIFont systemFontOfSize:12];
    if (moneyStr.length > 0 && moneyStr) {
        topView.labelRight.text = moneyStr;
    }
    topView.tag = 100;
    [bjView addSubview:topView];
    
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.viewIcon.frame) + 147, DeviceWidth, 1)];
    viewTop.backgroundColor=UIColorFromRGB(0xececec, 1.0);
    [bjView addSubview:viewTop];
    
    
    UILabel *_pricipalLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewTop.frame) + 20, DeviceWidth/3, 14)];
    
    _pricipalLabel.textAlignment=NSTextAlignmentCenter;
    
    _pricipalLabel.text=@"分期本金（元）";
    
    _pricipalLabel.font=[UIFont appFontRegularOfSize:12];
    
    _pricipalLabel.textColor=UIColorFromRGB(0x343434, 1.0);
    
    
    _priManey=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_pricipalLabel.frame) + 10, DeviceWidth/3, CGRectGetHeight(_pricipalLabel.frame))];
    
    _priManey.textAlignment=NSTextAlignmentCenter;
    
    _priManey.text = @"";
    
    _priManey.font = [UIFont appFontRegularOfSize:14];
    
    _priManey.textColor=UIColorFromRGB(0xff5500, 1.0);
    
    UILabel *_dividendLabel=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/3, CGRectGetMinY(_pricipalLabel.frame), DeviceWidth/3, CGRectGetHeight(_pricipalLabel.frame))];
    
    _dividendLabel.textAlignment=NSTextAlignmentCenter;
    
    _dividendLabel.text=@"息费（元）";
    
    _dividendLabel.font=[UIFont appFontRegularOfSize:12];
    
    _dividendLabel.textColor=UIColorFromRGB(0x343434, 1.0);
    
    _divManey=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/3, CGRectGetMaxY(_pricipalLabel.frame) + 10, DeviceWidth/3, CGRectGetHeight(_pricipalLabel.frame))];
    
    _divManey.textAlignment=NSTextAlignmentCenter;
    
    _divManey.text=@"";
    
    _divManey.font=[UIFont appFontRegularOfSize:14];
    
    _divManey.textColor=UIColorFromRGB(0xff5500, 1.0);
    
    
//    _interestDays = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_divManey.frame), CGRectGetMaxY(_divManey.frame), CGRectGetWidth(_divManey.frame), 14)];
//    _interestDays.textAlignment=NSTextAlignmentCenter;
//    
//    _interestDays.text=@"";
//    
//    _interestDays.font=[UIFont appFontRegularOfSize:14];
//    
//    _interestDays.textColor=UIColorFromRGB(0xff5500, 1.0);
    
    
    UILabel *_totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth*2/3, CGRectGetMinY(_pricipalLabel.frame), DeviceWidth/3, CGRectGetHeight(_pricipalLabel.frame))];
    
    _totalLabel.textAlignment=NSTextAlignmentCenter;
    
    _totalLabel.text=@"合计金额（元）";
    
    _totalLabel.font=[UIFont appFontRegularOfSize:12];
    
    _totalLabel.textColor=UIColorFromRGB(0x343434, 1.0);
    
    _totalManey=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth*2/3, CGRectGetMaxY(_pricipalLabel.frame) + 10, DeviceWidth/3, CGRectGetHeight(_pricipalLabel.frame))];
    
    _totalManey.textAlignment=NSTextAlignmentCenter;
    
    _totalManey.text=@"";
    
    _totalManey.font=[UIFont appFontRegularOfSize:14];
    
    _totalManey.textColor=UIColorFromRGB(0xff5500, 1.0);
    
    UIView *viewSep=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_totalManey.frame) + 20, DeviceWidth, 1)];
    viewSep.backgroundColor=UIColorFromRGB(0xececec, 1.0);
    [bjView addSubview:viewSep];
    
    _summary = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(viewSep.frame) +5, DeviceWidth - 30, 30)];
    if (iphone6P) {
        
        _summary.frame = CGRectMake(27, CGRectGetMaxY(viewSep.frame) +5, DeviceWidth - 30, 30);
    }
    _summary.font = [UIFont appFontRegularOfSize:12];
    _summary.textColor = UIColorFromRGB(0xa9a9a9, 1.0);
    _summary.text = @"";
    
    _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _returnBtn.frame = CGRectMake(DeviceWidth - 66, CGRectGetMaxY(viewSep.frame) +10, 56, 20);
    
    if (iphone6P) {
        
        _returnBtn.frame = CGRectMake(DeviceWidth - 76, CGRectGetMaxY(viewSep.frame) +10, 56, 20);
    }
    
    _returnBtn.titleLabel.font = [UIFont appFontRegularOfSize:12];
    
    [_returnBtn setTitle:@"申请退货" forState:UIControlStateNormal];
    
    [_returnBtn setTitleColor:UIColorFromRGB(0x32beff, 1.0) forState:UIControlStateNormal];
    
    [_returnBtn addTarget:self action:@selector(toReturnReason) forControlEvents:UIControlEventTouchUpInside];
    
    _returnBtn.layer.cornerRadius = 2.0f;
    
    _returnBtn.layer.borderColor = UIColorFromRGB(0x32beff, 1.0).CGColor;
    
    _returnBtn.layer.borderWidth = 0.5;
    
    _returnBtn.hidden = YES;
    
    [bjView addSubview:_returnBtn];
    
    [bjView addSubview:_summary];

    [bjView addSubview:_totalLabel];
    
    [bjView addSubview:_totalManey];
    
    [bjView addSubview:_dividendLabel];
    
    [bjView addSubview:_divManey];
    
    [bjView addSubview:_priManey];
    
    [bjView addSubview:_pricipalLabel];
    
    [bjView addSubview:_interestDays];
    if ([_ifSettled isEqualToString:@"SE"]) {
        _changeBankView.stateLabel.text = _stateStr;
        bjView.frame = CGRectMake(0, 0, DeviceWidth, _summary.frame.size.height+_summary.frame.origin.y);
        UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 30)];
        
        leftLab.backgroundColor = [UIColor clearColor];
        
//        leftLab.text = @"分期账单";
        
        leftLab.font = [UIFont appFontRegularOfSize:14];
        
        [_summary addSubview:leftLab];

        [self.view addSubview:bjView];
    }else{
        UIView *viewBot=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_summary.frame) + 5, DeviceWidth, 1)];
        viewBot.backgroundColor=UIColorFromRGB(0xececec, 1.0);
        [bjView addSubview:viewBot];
        
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewBot.frame), DeviceWidth, 10)];
        NSLog(@"viewBot = %f",viewBot.frame.origin.y);
        
        bottomView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
        
        [bjView addSubview:bottomView];

        _changeBankView.stateLabel.text = _stateStr;
        
        if ([_changeBankView.stateLabel.text isEqualToString:@"退货中"]) {
            
            _changeBankView.stateLabel.frame = CGRectMake(DeviceWidth/2, 0, DeviceWidth/2 - 40, 40);
            
            _returnImg = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 40, 12.5, 15, 15)];
            
            _returnImg.image = [UIImage imageNamed:@"退货疑问"];
            
            _returnImg.userInteractionEnabled = YES;
            
            [_changeBankView addSubview:_returnImg];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnSpeed:)];
            
            [_returnImg addGestureRecognizer:tap];
        }
        _loanDetailTableView.tableHeaderView = bjView;
    }
    
}

//初始化底部View
- (void)setBottomView
{
    NSString *text = @"还款总额:¥0.00";
    
    _bottom = [[PayBackBottomView alloc] initWithFrame:CGRectMake(0, DeviceHeight-49-64, DeviceWidth, 49)];
    [_bottom createViewWithPayBackMoney:[self fomatStr:text] andIconAction:@selector(isSelected) andDetailAction:@selector(toRepayDetail) andPayBackAction:@selector(sure:) andObject:self];
    _bottom.detailBtn.hidden = YES;
    [self.view addSubview:_bottom];
}

//设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

//返回上以页面
- (void)OnBackBtn:(UIButton *)btn
{
    
    [_mbView removeFromSuperview];
    
    _mbView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

//当订单状态是已结清的情况下，创建底部视图
-(void)creatEndView{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, DeviceHeight-45-64, DeviceWidth, 45)];
    
    button.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [button addTarget:self action:@selector(buildToGetMoney:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"再次申请" forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    
}

#pragma mark - private Methods
- (void)changeBank{
    
//    if (!_stageBillModel.body){
//        
//        [self getLoanBill];
//        
//    }else{
//       
//      
//    }
    
    AddBankViewController * bank = [[AddBankViewController alloc]init];
    
    bank.choiceBank = choiceDefaultCard;
    
    bank.choiceDefaultDelegate = self;
    
    //bank.payMaxMoney = _paymaxMoney;
    
    [self.navigationController pushViewController:bank animated:YES];

    
    
}
//选择默认还款卡代理
- (void)choiceBank:(BankInfo *)backinfo{
    
    _bankName = backinfo.bankName;
    
    _bankNumber = backinfo.cardNo;
    
    _changeBankType = backinfo.cardTypeName;
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/changeHkCard" requestArgument:@{@"applSeq":StringOrNull(loanDetailModel.body.applSeq),@"cardNo":StringOrNull(backinfo.cardNo)} requestTag:100 requestClass:NSStringFromClass([self class])];
}
// 跳转退货原因
- (void)toReturnReason{

    ReturnReasonViewController *vc = [[ReturnReasonViewController alloc]init];
    
    vc.applseq = _applseq;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)notShow{

    _showBtn = NO;
    
    _changeBankView.stateLabel.text = @"退货中";
    
    [self ifShowBtn];
}
- (void)ifShowBtn{

    if (_showBtn) {
        
        _returnBtn.hidden = NO;
        _returnBtn.userInteractionEnabled = YES;
        _changeBankView.stateLabel.frame = CGRectMake(DeviceWidth/2, 0, DeviceWidth/2 - 10, 40);
        _returnImg.hidden = YES;
    }else{
        
        if ([_changeBankView.stateLabel.text isEqualToString:@"退货中"]) {
            
            _changeBankView.stateLabel.frame = CGRectMake(DeviceWidth/2, 0, DeviceWidth/2 - 50, 40);
            
            if (_returnImg) {
                
                _returnImg.hidden = NO;
            }else{
                
                _returnImg = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 40, 12.5, 15, 15)];
                
                _returnImg.image = [UIImage imageNamed:@"还款明细"];
                
                [_changeBankView addSubview:_returnImg];
            }
        }
        
        _returnBtn.hidden = YES;
        _returnBtn.userInteractionEnabled = NO;
    }
}
- (void)returnSpeed:(UITapGestureRecognizer *)tap{

    [self buildHeadError:@"您的退货我们正在处理中，您可拨打400-018-7777详询退货进度，注意关注您的最近还款日期哦"];
}
- (void)contionToNext
{
    [self queryGetAppOrderAndGoods];
}
// 查询无额度用户审批进度
- (void)clicktoConPayfirmExamineViewController{
    
    ApprovalProgressViewController *vc = [[ApprovalProgressViewController alloc]init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark -- TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LoandetailsStagesTableViewCellcellID = @"LoandetailsStagesTableViewCellcellID";
    
    LoandetailsStagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoandetailsStagesTableViewCellcellID forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[LoandetailsStagesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoandetailsStagesTableViewCellcellID];
        if (iphone6P) {
            
            cell.iconBtn.frame = CGRectMake(20, 16, 30, 30);
            
            cell.MoneyLabel.frame = CGRectMake(54, 15, 170, 15);
            
            cell.DayPlaceLabel.frame = CGRectMake(54, 34, 170, 15);
            
            cell.SurplusDayLabel.frame = CGRectMake(DeviceWidth - 80, 25, 60, 13);
        }
    }
    
    [cell.iconBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.iconBtn setImage:[UIImage imageNamed:@"图标_未选中"] forState:(UIControlStateNormal)];
    [cell.iconBtn setImage:[UIImage imageNamed:@"图标_选中"] forState:(UIControlStateSelected)];
    cell.MoneyLabel.font = [UIFont appFontRegularOfSize:16];
    cell.DayPlaceLabel.font = [UIFont appFontRegularOfSize:12];
    cell.SurplusDayLabel.font = [UIFont appFontRegularOfSize:12];
    
    StageBillModelBody *body = _dataArr[indexPath.row];
    cell.iconBtn.selected = body.selected;
    cell.MoneyLabel.text = [NSString stringWithFormat:@"%.2f",[body.amount floatValue]];
    cell.MoneyLabel.textColor = UIColorFromRGB(0xff5500, 1.0);
    cell.DayPlaceLabel.textColor = UIColorFromRGB(0x666666, 1.0);
    cell.DayPlaceLabel.text = [NSString stringWithFormat:@"【%ld/%lu期】%@",(long)body.psPerdNo,(unsigned long)_dataArr.count,_goodsName];
    
    if (body.days < 0 && [body.setlInd isEqualToString:@"N"]) {
        
        cell.SurplusDayLabel.text = [NSString stringWithFormat:@"逾期%ld天",-((long)body.days)];
        cell.SurplusDayLabel.textColor = UIColorFromRGB(0xff5500, 1.0);
        if (lateFees && [lateFees floatValue] > 0) {
            cell.MoneyLabel.text = [NSString stringWithFormat:@"%.2f+%.2f(逾期费用)",[body.amount floatValue],[lateFees floatValue]];
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:cell.MoneyLabel.text];
            NSRange range = [[string string]rangeOfString:@"(逾期费用)"];
            [string addAttribute:NSFontAttributeName value:[UIFont appFontRegularOfSize:9] range:range];
            cell.MoneyLabel.attributedText = string;
        }
        
    }else if (body.days <= 0 && [body.setlInd isEqualToString:@"Y"]){
        
        cell.SurplusDayLabel.text = [NSString stringWithFormat:@"已完成"];
    }
    else{
        
        cell.SurplusDayLabel.text = [NSString stringWithFormat:@"剩余%ld天",(long)body.days];
        
    }
    cell.SurplusDayLabel.textAlignment = NSTextAlignmentRight;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_loanDetailTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_loanDetailTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_loanDetailTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_loanDetailTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_loanDetailTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
#pragma mark ---- 点击提交-------------
-(void)sure:(UIButton *)btn{
    
    //    还款金额小于总额
    if (!arrearsmodel.msgall.OD_AMT)
    {
        [self arrearsSearch];
        return;
    }
    
    if([_bottom.moneyLabel.attributedText.string isEqualToString:@"还款总额:¥0.00"])
    {
        [self buildHeadError:@"请选择还款金额"];
        return;
    }
    
    if ( [payStyly isEqualToString:@"逾期"])
    {
        if (lateFees && [lateFees floatValue] > 0)
        {
            //逾期费用查询成功并且大于0
            if (!totalMoney)
            {
                //如果总金额为空,查询还款金额
                [self searchAmonutByLoanNo:_loanNo Amount:[NSString stringWithFormat:@"%@",discountAmountOverData] AndPayMode:@"NM"];
                payMode = @"NM";
                return;
            }
            
            payMode = @"NM";
        }
        else if (!lateFees)
        {
            [self arrearsSearch];
        }
        else if (lateFees && [lateFees isEqualToString:@"0"])
        {
            //有逾期且逾期费用为0
            if (!totalMoney)
            {
                [self searchAmonutByLoanNo:_loanNo Amount:[NSString stringWithFormat:@"%@",discountAmountOverData] AndPayMode:@"ER"];
                return;
            }
            payMode = @"ER";
        }
        
        ConfirmPayViewController *vc = [[ConfirmPayViewController alloc]init];
        vc.loanNo = _loanNo;//借据号
        vc.totalAmt = [NSString stringWithFormat:@"%@",totalMoney];//总额
        vc.parmCard = loanDetailModel.body.repayApplCardNo;//卡号
        vc.bankName = loanDetailModel.body.repayAccBankName;//卡名
        vc.bankTyp = _bankType;//卡类型
        vc.payMode = payMode;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if ([payStyly isEqualToString:@"全部"])
    {
        //全部
        if (!totalMoney)
        {
            
            [self searchAmonutByLoanNo:_loanNo Amount:[NSString stringWithFormat:@"%@",discountAmount]];
            
            payMode = @"FS";
            
            return;
        }
        payMode = @"FS";
        ConfirmPayViewController *vc = [[ConfirmPayViewController alloc]init];
        _bottom.moneyLabel.attributedText = [self fomatStr:[NSString stringWithFormat:@"还款总额:¥%.2f",[totalMoney floatValue]]];
        vc.loanNo = _loanNo;//借据号
        vc.totalAmt = [NSString stringWithFormat:@"%@",totalMoney];//总额
        vc.parmCard = loanDetailModel.body.repayApplCardNo;//卡号
        vc.bankName = loanDetailModel.body.repayAccBankName;//卡名
        vc.bankTyp = _bankType;//卡类型
        vc.payMode = payMode;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark-----根据流水号查询贷款详情 6.61-----
- (void)getLoanDetail
{
    BSVKHttpClient * detailClient = [BSVKHttpClient shareInstance];
    detailClient.delegate = self;
    //    查询贷款详情
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:StringOrNull(_applseq) forKey:@"applSeq"];
    [detailClient getInfo:@"app/appserver/apporder/queryAppLoanAndGoods" requestArgument:parmDic requestTag:1 requestClass:NSStringFromClass([self class])];
    NSLog(@"贷款详情%@",_applseq);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
#pragma mark -----根据流水号查询分期账单 6.54------
- (void)getLoanBill{
    BSVKHttpClient * billClient = [BSVKHttpClient shareInstance];
    billClient.delegate = self;
    //    查询贷款详情分期账单
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:StringOrNull(_applseq) forKey:@"applseq"];
    [billClient getInfo:@"app/appserver/queryApplListBySeq" requestArgument:parmDic requestTag:2 requestClass:NSStringFromClass([self class])];
    NSLog(@"分期账单%@",_applseq);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
// 白名单查询
// 查询白名单
- (void)querySetAllowRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    if ([AppDelegate delegate].userInfo.realId.length > 0)
    {
        [dic setObject:[AppDelegate delegate].userInfo.realId forKey:@"certNo"];
    }
    
    if ([AppDelegate delegate].userInfo.realName.length > 0)
    {
        [dic setObject:[AppDelegate delegate].userInfo.realName forKey:@"custName"];
    }
    
    if ([AppDelegate delegate].userInfo.userTel.length > 0)
    {
        [dic setObject:[AppDelegate delegate].userInfo.userTel forKey:@"phonenumber"];
    }
    
    [dic setObject:@"20" forKey:@"idTyp"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    [client getInfo:@"app/appserver/crm/cust/getCustIsPass" requestArgument:dic requestTag:getCustIsPass requestClass:NSStringFromClass([self class])];
}
//查询邀请原因
- (void)querySearchInviteReason
{
    //查询邀请原因
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/crm/cust/getInvitedCustByCustNo" requestArgument:@{@"custNo":[AppDelegate delegate].userInfo.custNum} requestTag:getInvitedCustByCustNo requestClass:NSStringFromClass([self class])];
}
//录单校验
- (void)queryCheckList{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    if ([AppDelegate delegate].userInfo.whiteType == WhiteA || [AppDelegate delegate].userInfo.whiteType == WhiteSocityReason || [AppDelegate delegate].userInfo.whiteType == WhiteCReason) {
        
        [dic setObject:@"" forKey:@"cityCode"];
        
        [dic setObject:@"" forKey:@"provinceCode"];
        
    }else
    {
        [dic setObject:StringOrNull([AppDelegate delegate].mapLocation.strCityCode) forKey:@"cityCode"];
        
        [dic setObject:StringOrNull([AppDelegate delegate].mapLocation.strProvinceCode) forKey:@"provinceCode"];
    }
    
    [dic setObject:[AppDelegate delegate].userInfo.userId forKey:@"userId"];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/getCustInfoAndEdInfoPerson" requestArgument:dic requestTag:getCustInfoAndEdInfoPerson requestClass:NSStringFromClass([self class])];
}
//查询订单详情
- (void)queryGetAppOrderAndGoods
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/getAppOrderAndGoods" requestArgument:@{@"orderNo":StringOrNull([AppDelegate delegate].userInfo.orderNo)} requestTag:getAppOrderAndGoods requestClass:NSStringFromClass([self class])];
}
#pragma mark - BSVKClientDelegate
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if (requestTag == 1) {//查询贷款详情
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([_haveContract isEqualToString:@"1"])
            {
                contractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                contractBtn.frame = CGRectMake(DeviceWidth - 40, 10, 40, 40);
                [contractBtn setImage:[UIImage imageNamed:@"邀请圆"] forState:UIControlStateNormal];
                [contractBtn addTarget:self action:@selector(comeContract) forControlEvents:UIControlEventTouchUpInside];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:contractBtn];
            }
            
            loanDetailModel = [LoanDetailModel mj_objectWithKeyValues:responseObject];
            if ([loanDetailModel.head.retFlag isEqualToString:@"00000"])
            {
                [AppDelegate delegate].userInfo.applSeq = loanDetailModel.body.applSeq;
                _loanNo = loanDetailModel.body.loanNo;
                //给贷款详情赋值
                if (![_ifSettled isEqualToString:@"SE"]) {
                     [self setLoanDetailTableView];
                }
               
                [self settableViewHeader];
                [self setVauleForDeatailView];
                if (!alreadySearch)
                {
                    if (_loanNo && _loanNo.length > 0 && !arrearsmodel.msgall.OD_AMT)
                    {
                        //查询欠款
                        
                        [self arrearsSearch];
                    }
                }
                if ([loanDetailModel.body.isAllowReturn isEqualToString:@"Y"]) {
                    
                    _showBtn = YES;
                }else{
                
                    _showBtn = NO;
                }
                [self ifShowBtn];
            }else{
                
                [self buildErrWithString:loanDetailModel.head.retMsg];
            }
            
        }
        else if (requestTag == 2)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            _stageBillModel = [StageBillModel mj_objectWithKeyValues:responseObject];
            //解析model
            [self analysisStageBillModel];
        }
        else if (requestTag == 5)
        {
            //欠款查询
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            arrearsmodel = [ArrearsModel mj_objectWithKeyValues:responseObject];
            if ([arrearsmodel.msgall.errorCode isEqualToString:SucessCode])
            {
                alreadySearch = YES;
                //查询分期账单
                if (!_stageBillModel.body)
                {
                    [self getLoanBill];
                }

                
                //逾期费用
                if (!lateFees)
                {
                    lateFees =[NSString stringWithFormat:@"%@",[NSDecimalNumber decimalNumberWithString: arrearsmodel.msgall.OD_AMT]];
                }
                
            }else
            {
                [self buildErrWithString:arrearsmodel.msgall.errorMsg];
            }
        }else if (requestTag == 103){//还款金额查询
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AmountModel *model = [AmountModel mj_objectWithKeyValues:responseObject];
            if ([model.head.retFlag isEqualToString:@"00000"])
            {
                totalMoney = [NSString stringWithFormat:@"%@",model.body.zdhkFee];
            }else{
                totalMoney = nil;
                [self buildErrWithString:model.head.retMsg];
            }
            
        }else if (requestTag == 104){//还款金额查询
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AmountModel *model = [AmountModel mj_objectWithKeyValues:responseObject];
            if ([model.head.retFlag isEqualToString:@"00000"])
            {
                totalMoney = [NSString stringWithFormat:@"%@",model.body.ze];
                _bj = model.body.bj;
                _sxf = model.body.sxf;
                _xf = model.body.xf;
            }else{
                totalMoney = nil;
                [self buildErrWithString:model.head.retMsg];
            }
            
        }else if (requestTag == 100){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            ChangeDefaultBankModel *model = [ChangeDefaultBankModel mj_objectWithKeyValues:responseObject];
            if ([model.head.retFlag isEqualToString:SucessCode]) {
                _changeBankView.defaultBankLabel.text = _bankName;
                loanDetailModel.body.repayApplCardNo = _bankNumber;
                loanDetailModel.body.repayAccBankName = _bankName;
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
        else if (requestTag == getCustIsPass){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            WhiteSearchModel *allowModel = [WhiteSearchModel mj_objectWithKeyValues:responseObject];
            [self analySisGetCustIsPass:allowModel];
        }
        else if (requestTag == getInvitedCustByCustNo)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            IndetityStore *model = [IndetityStore mj_objectWithKeyValues:responseObject];
            [self analySisGetInvitedCustByCustNo:model];
        }
        else if (requestTag == getCustInfoAndEdInfoPerson)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            CheckListModel *checkListModel = [CheckListModel mj_objectWithKeyValues:responseObject];
            
            [self analySisGetCustInfoAndEdInfoPerson:checkListModel];
            
        }
        else if (requestTag == getAppOrderAndGoods)//订单详情
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            OrdeDetailsModel *ordeDetailsModel = [OrdeDetailsModel mj_objectWithKeyValues:responseObject];
            
            [self analySisGetAppOrderAndGoods:ordeDetailsModel];
            
        }
    }
}

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

#pragma mark - 解析model
- (void)analysisStageBillModel
{
    if ([_stageBillModel.head.retFlag isEqualToString:@"00000"])
    {
        //重新给贷款详情view的 本金*期数 赋值
        LoanTopView *topView;
        if ([_ifSettled isEqualToString:@"SE"]) {
            
            topView = [bjView viewWithTag:100];
        }else{
            
            topView = [_loanDetailTableView.tableHeaderView viewWithTag:100];
        }
        if (_stageBillModel.body.count > 0)
        {
            if ([loanDetailModel.body.payMtd isEqualToString:@"02"])
            {
                moneyStr = [NSString stringWithFormat:@"%@X%@期",loanDetailModel.body.mthAmt ,loanDetailModel.body.applyTnr];
                topView.labelRight.text = [NSString stringWithFormat:@"%@",moneyStr];
            }
            else
            {
                moneyStr = [NSString stringWithFormat:@"%.2f元",[[NSString stringWithFormat:@"%@", [NSDecimalNumber decimalNumberWithString:loanDetailModel.body.apprvAmt]] floatValue]];//待还
                topView.labelRight.text = [NSString stringWithFormat:@"%@",moneyStr];
            }
        }
        
        //数据管理者
        NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
        
        //把请求下来的数据赋值给数据数组
        _dataArr = _stageBillModel.body;
        discountAmount = [NSDecimalNumber decimalNumberWithString:@"0"];
        //遍历数组给  未结清
        _paymaxMoney = @"0";
        for (StageBillModelBody * body in _dataArr)
        {
            if ([body.setlInd isEqualToString:@"N"])
            {
                discountAmount = [discountAmount decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:body.amount]withBehavior:roundUp];
                
                if ([self isJudgeOneString:body.amount twoString:_paymaxMoney]) {
                    
                    _paymaxMoney = body.amount;
                    
                }
                
                if (body.days > 0)
                {
                    body.selected = NO;
                    [_choosedArr addObject:body];
                }
                
                
                if (body.days < 0)
                {
                    //将逾期的放入一个数组
                    body.selected = YES;
                    [overdueDateArr addObject:body];
                }
                
                if (overdueDateArr.count == 0)
                {
                    //逾期为0，那么将出了wei结清的全部设为选中
                    //                    for (StageBillModelBody * body in choosedArr)
                    //                    {
                    //                        body.selected = YES;
                    //                    }
                    payStyly = @"全部";
                }
                else
                {
                    //逾期的不为0，那么纪录逾期的金额
                    discountAmountOverData = [NSDecimalNumber decimalNumberWithString:@"0"];
                    for (StageBillModelBody * body in overdueDateArr)
                    {
                        body.selected = YES;
                        discountAmountOverData = [discountAmountOverData decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:body.amount]withBehavior:roundUp];
                    }
                    payStyly = @"逾期";
                }
                
            }
            
        }
        
        if (overdueDateArr.count > 0)
        {
            mixData = YES;//有逾期
        }else
        {
            mixData = NO;//没有逾期
        }
        
        
        // 期供已包含息费 所有未结清期供 = 还款总额
        //还款期供包含了息费，所以只加逾期费用就可
        if (lateFees)
        {
            //未还款总额 ＝ 待还期供 ＋ 逾期费用
            discountAmount = [discountAmount decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:StringOrNull(lateFees)]];
        }
        
        if (overdueDateArr.count > 0)
        {
            //如果逾期数组大于0 说明有逾期
            if (lateFees)
            {
                //逾期金额 ＝ 应还期供 ＋ 逾期费用
                discountAmountOverData = [discountAmountOverData decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:lateFees]];
            }
            
            
            overDueLab = [[UILabel alloc]initWithFrame:(CGRectMake(8, 0, DeviceWidth - 16 , 30))];
            overDueLab.font = [UIFont appFontRegularOfSize:13];
            StageBillModelBody * body = overdueDateArr[0];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您已逾期%ld天,请尽快还款。您的逾期情况将会影响您的征信报告。",(long)-body.days]];
            NSRange rage = [[attr string] rangeOfString:[NSString stringWithFormat:@"%ld",(long)-body.days]];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rage];
            //                    NSRange rage2 = [[attr string] rangeOfString:[NSString stringWithFormat:@"%@",lateFees]];
            //                    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rage2];
            overDueLab.numberOfLines = 0;
            overDueLab.attributedText = attr;
            UIView *bgView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, DeviceWidth, 30))];
            bgView.backgroundColor = UIColorFromRGB(0x24cefc, 1.0);
            [self.view addSubview:bgView];
            [bgView addSubview:overDueLab];
            [UIView animateWithDuration:0.5 animations:^{
                _loanDetailTableView.frame = CGRectMake(0, CGRectGetMaxY(overDueLab.frame) , DeviceWidth, DeviceHeight - 64 - 58 - 30);
            }];
        }
        
        /*
         
         FS : 没有逾期天数，查询一次性全部还款
         
         NM ： 有逾期天数，逾期费用 ，查询一次性逾期还款，不包含剩余待还金额
         
         ER ： 有逾期天数，没有逾期费用，查询一次性待还期供，不包含剩余待还款
         
         */
        
        if (overdueDateArr.count == 0)
        {
            
            [self searchAmonutByLoanNo:_loanNo Amount:[NSString stringWithFormat:@"%@",discountAmount]];
        }else if(overdueDateArr.count > 0 && [lateFees floatValue] > 0)
        {
            //有逾期并产生了费用
            [self searchAmonutByLoanNo:_loanNo Amount:[NSString stringWithFormat:@"%@",discountAmountOverData] AndPayMode:@"NM"];
        }else if (overdueDateArr.count > 0 && [lateFees floatValue] == 0)
        {
            //有逾期 ，但是未产生费用
            [self searchAmonutByLoanNo:_loanNo Amount:[NSString stringWithFormat:@"%@",discountAmountOverData] AndPayMode:@"ER"];
        }
        [_loanDetailTableView reloadData];
        
        
    }else{
        
        [self buildErrWithString:_stageBillModel.head.retMsg];
    }
}
//白名单解析
- (void)analySisGetCustIsPass:(WhiteSearchModel *)_allowModel
{
    //白名单
    NSLog(@"实名回执%@",_allowModel.head.retFlag);
    
    if ([_allowModel.head.retFlag isEqualToString:@"00000"])
    {
        _searchModel = _allowModel;
        // 社会化顾客
        if ([_allowModel.body.isPass isEqualToString:SocietyUser])
        {
            
            [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
            
            [self querySearchInviteReason];
        }
        else if ([_allowModel.body.isPass isEqualToString:@"1"])
        {
            //优质白名单  海尔、电信员工
            if ([_allowModel.body.level isEqualToString:Auser])
            {
                [AppDelegate delegate].userInfo.whiteType = WhiteA;
                
                [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
                
                [self queryCheckList];
            }
            //其他白名单
            else if ([_allowModel.body.level isEqualToString:Buser])
            {
                [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
                [AppDelegate delegate].userInfo.whiteType = WhiteB;
                // 判断地理位置
                [self judgeGeography];
                
            }else if ([_allowModel.body.level isEqualToString:Cuser]){
                
                [AppDelegate delegate].userInfo.haierVipState = IsHaierVip;
                
                [self querySearchInviteReason];
                
            }
        }
        else if ([_allowModel.body.isPass isEqualToString:@"-1"])
        {
            [AppDelegate delegate].userInfo.whiteType = BlackMan;
            [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
            WEAKSELF
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"此账号无贷款权限，详情请拨打4000187777" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                STRONGSELF
                if (strongSelf) {
                    if (buttonIndex == 0) {
                        
                    }
                }
            }];
        }
    }else
    {
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:_allowModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex)
         {
             STRONGSELF
             if (strongSelf) {
                 if (buttonIndex == 0) {
                     
                 }
             }
         }];
    }
}
//社会化接续
- (void)analySisGetInvitedCustByCustNo:(IndetityStore *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"])
    {
        if (model.body.count > 0)
        {
            //有邀请原因 继续走
            if ([_searchModel.body.isPass isEqualToString:@"1"]) {
                
                [AppDelegate delegate].userInfo.whiteType = WhiteCReason;
            }else{
                
                [AppDelegate delegate].userInfo.whiteType = WhiteSocityReason;
            }
            
            [self queryCheckList];
        }
        //没有邀请原因  获取贷款品种 用来判断每日额度
        else
        {
            if ([_searchModel.body.isPass isEqualToString:@"1"]) {
                
                [AppDelegate delegate].userInfo.whiteType = WhiteCNoReason;
            }else{
                
                [AppDelegate delegate].userInfo.whiteType = WhiteSocityNoReason;
            }
            //地理位置判断
            [self judgeGeography];
            
        }
    }else
    {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
        
    }
}
- (void)analySisGetCustInfoAndEdInfoPerson:(CheckListModel *)checkListModel{
    
    if ([checkListModel.head.retFlag isEqualToString:SucessCode])
    {
        [self contionToNext];;
    }else if ([checkListModel.head.retFlag isEqualToString:@"A1185"])
    {
        [AppDelegate delegate].userInfo.applSeq = checkListModel.body.crdSeq;
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:checkListModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    [strongSelf clicktoConPayfirmExamineViewController];
                }
            }
        }];
    }else
    {
        
        [self buildHeadError:checkListModel.head.retMsg];
    }
}
//解析订单详情model
- (void)analySisGetAppOrderAndGoods:(OrdeDetailsModel *)orderDetailsModel{
    
    if ([orderDetailsModel.head.retFlag isEqualToString:SucessCode])
    {
        [AppDelegate delegate].userInfo.orderNo = orderDetailsModel.body.orderNo;
        
        
//        if ([orderDetailsModel.body.typGrp isEqualToString:CashCode])
//        {
//            //跳转到现金贷
//            StageViewController * vc = [[StageViewController alloc]init];
//            
//            vc.orderDetailsBody = orderDetailsModel.body;
//            vc.flowName = WaitSubmitCashLoan;
//            //待提交保存流水号
//            [AppDelegate delegate].userInfo.applSeq = orderDetailsModel.body.applseq;
//            
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else
//        {
//            [AppDelegate delegate].userInfo.applSeq = orderDetailsModel.body.applseq;
//            
//            NSString * packAgeStr;//套餐名
//            
//            if([orderDetailsModel.body.goods[0].goodsName rangeOfString:@"goodname"].location != NSNotFound)
//            {
//                NSRange range  = [orderDetailsModel.body.goods[0].goodsName rangeOfString:@"goodname"];
//                
//                packAgeStr = [orderDetailsModel.body.goods[0].goodsName substringToIndex:range.location];  //套餐
//            }
//            else
//            {
//                packAgeStr = @"";
//            }
//            
//            if (_onLine) {
//                
//                WareDetailViewController *vc = [[WareDetailViewController alloc]init];
//                
//                vc.flowName = advertStage;
//                vc.salerCode = orderDetailsModel.body.crtUsr;
//                vc.goodsCode = orderDetailsModel.body.goods[0].goodsCode;
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                
//                StageApplicationViewController *goods = [[StageApplicationViewController alloc]init];
//                
//                goods.flowName = WaitSubmitStage;
//                
//                if (packAgeStr.length > 0)
//                {
//                    goods.scantype = goodHasMenuEnter;
//                }else
//                {
//                    goods.scantype = goodNoMenuEnter;
//                }
//                
//                goods.noUpdateOrder = YES;
//                
//                goods.merchantCode = orderDetailsModel.body.merchNo;
//                
//                goods.strManagerID = orderDetailsModel.body.crtUsr;
//                
//                goods.ordeDetailsBody = orderDetailsModel;
//                
//                goods.scanInfoModel = [[ScanTableModel alloc]init];
//                
//                goods.scanInfoModel.goodBrand = orderDetailsModel.body.goods[0].goodsBrand;
//               
//                goods.scanInfoModel.goodKind = orderDetailsModel.body.goods[0].goodsKind;
//                
//                [self.navigationController pushViewController:goods animated:YES];
//            }
//        }
    }
    else
    {
        [self buildHeadError:orderDetailsModel.head.retMsg];
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

#pragma mark --- 给贷款详情的view赋值----
- (void)setVauleForDeatailView
{
    //    数据管理者
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    //    分期本金  = 待还 + 已还
    self.priManey.text = [NSString stringWithFormat:@"%.2f",[NSDecimalNumber decimalNumberWithString:loanDetailModel.body.apprvAmt].floatValue];//审批金额
    
    //借款总额 + 利息 + 费用 (合计金额)
    _totalManey.text = [NSString stringWithFormat:@"%.2f",[[[NSDecimalNumber decimalNumberWithString:self.priManey.text] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:loanDetailModel.body.psNormIntAmt] withBehavior:roundUp] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:loanDetailModel.body.feeAmt] withBehavior:roundUp].floatValue];
    //    上部view
    LoanTopView *topView;
    if ([_ifSettled isEqualToString:@"SE"]) {
        
       topView = [bjView viewWithTag:100];
    }else{
        
        topView = [_loanDetailTableView.tableHeaderView viewWithTag:100];
    }
    
    //本金*期数
    if ([loanDetailModel.body.payMtd isEqualToString:@"02"]) {
        moneyStr = [NSString stringWithFormat:@"%@X%@期",loanDetailModel.body.mthAmt ,loanDetailModel.body.applyTnr];
        topView.labelRight.text = [NSString stringWithFormat:@"%@",moneyStr];
    }
    
    //    申请日期
    timeStr = loanDetailModel.body.applyDt;
    
    topView.labelState.text = [NSString stringWithFormat:@"%@",timeStr];
    //贷款编号
    
    numberStr = [NSString stringWithFormat:@"贷款编号:%@",[AppDelegate delegate].userInfo.applSeq];
    topView.labelTime.text = [NSString stringWithFormat:@"%@",numberStr];
    if (loanDetailModel.body.goods.count > 0) {
        if(loanDetailModel.body.goods[0].goodsCode && loanDetailModel.body.goods[0].goodsCode.length > 0)
        {
            if([(id)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,loanDetailModel.body.goods[0].goodsCode]] isKindOfClass:[UIImage class]])
            {
                UIImage *tempData =(UIImage *)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,loanDetailModel.body.goods[0].goodsCode]];
                topView.viewIcon.image = tempData;
            }else if ([(id)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,loanDetailModel.body.goods[0].goodsCode]] isKindOfClass:[NSData class]])
            {
                NSData *tempData =(NSData *)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,loanDetailModel.body.goods[0].goodsCode]];
                topView.viewIcon.image = [UIImage imageWithData:tempData];
            }else
            {
                topView.viewIcon.image = [UIImage imageNamed:@"贷款列表默认图片"];
                [[YYWebImageManager sharedManager]requestImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,loanDetailModel.body.goods[0].goodsCode]] options:YYWebImageOptionShowNetworkActivity progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    if (image) {
                        [[AppDelegate delegate].imagePutCache setObject:image forKey:url.absoluteString];
                        topView.viewIcon.image = image;
                    }
                }];
            }
        }
        else
        {
            topView.viewIcon.image = [UIImage imageNamed:@"贷款列表默认图片"];
        }
    }else{
        topView.viewIcon.image = [UIImage imageNamed:@"贷款列表默认图片"];
    }

    //商品名称
    if ([loanDetailModel.body.typGrp isEqualToString:@"02"])
    {
        if([loanDetailModel.body.applyTnrTyp isEqualToString:@"D"] || [loanDetailModel.body.applyTnrTyp isEqualToString:@"d"])
        {
            _goodsName = @"现金随借随还";
        }else
        {
            _goodsName = @"现金支用";
        }
    }else if ([loanDetailModel.body.typGrp isEqualToString:@"01"]){
        
        if([loanDetailModel.body.goods[0].goodsName rangeOfString:@"goodname"].location !=NSNotFound)//_roaldSearchText
        {
            NSRange range  = [loanDetailModel.body.goods[0].goodsName rangeOfString:@"goodname"];
            
            _goodsName = [loanDetailModel.body.goods[0].goodsName substringFromIndex:range.location+range.length];  //名称
        }
        else
        {
            _goodsName = loanDetailModel.body.goods[0].goodsName;
        }
        
    }else{
        
        _goodsName = @"";
    }
    
    
    _summary.text = [NSString stringWithFormat:@"分期账单：已还本金%.2f,待还本金%.2f",[loanDetailModel.body.setlPrcpAmt floatValue], [loanDetailModel.body.repayPrcpAmt floatValue]];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:_summary.text];
    NSRange range = [[string string]rangeOfString:@"分期账单："];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x343434, 1.0) range:range];
    _summary.attributedText = string;
    topView.labelMidContent.text = [NSString stringWithFormat:@"%@",_goodsName];
    
    //利息天数
    if ([loanDetailModel.body.applyTnrTyp isEqualToString:@"D"])
    {
        //息费 = 利息 + 费用
        _divManey.text = [NSString stringWithFormat:@"%.2f(%@天)",[[NSDecimalNumber decimalNumberWithString:loanDetailModel.body.psNormIntAmt] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:loanDetailModel.body.feeAmt] withBehavior:roundUp].floatValue,loanDetailModel.body.applyTnr];
//        _interestDays.text = [NSString stringWithFormat:@"(%@天)", loanDetailModel.body.applyTnr];
    }else
    {
        //息费 = 利息 + 费用
        _divManey.text = [NSString stringWithFormat:@"%.2f(%@月)",[[NSDecimalNumber decimalNumberWithString:loanDetailModel.body.psNormIntAmt] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:loanDetailModel.body.feeAmt] withBehavior:roundUp].floatValue,loanDetailModel.body.applyTnr];
//        _interestDays.text = [NSString stringWithFormat:@"(%@月)", loanDetailModel.body.applyTnr];
    }
    
    if(_stageBillModel)
    {
        [_loanDetailTableView reloadData];
    }
}
//提示框
- (void)buildErrWithString:(NSString *)string{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:string cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            
        }
        
    }];
}
#pragma mark ---选择分期账单----
- (void)btnClick:(UIButton*)sender{
    UITableViewCell *  cell;
    
    if([sender.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell*)sender.superview.superview;
    }else
    {
        cell = (UITableViewCell*)sender.superview.superview.superview;
    }
    
    NSIndexPath *index = [_loanDetailTableView indexPathForCell:cell];
    
    StageBillModelBody *body = [_dataArr objectAtIndex:index.row];
    
    if ([body.setlInd isEqualToString:@"N"] && ((body.days > 0 )))
    {
        //如果未结清再做加减
        if (!mixData)
        {
            for (StageBillModelBody *body in _choosedArr)
            {
                body.selected = YES;
            }
            
            [_loanDetailTableView reloadData];
            
            _bottom.iconButton.selected = YES;
            _bottom.moneyLabel.attributedText = [self fomatStr:[NSString stringWithFormat:@"还款总额:¥%.2f",[totalMoney floatValue]]];
            _bottom.detailBtn.hidden = NO;
            //没有逾期的
            [self buildErrWithString:[NSString stringWithFormat:@"此贷款仅支持全部还款，当前全部应还%.2f，包括本金、提前还款手续费、息费等",[totalMoney floatValue]]];
        }else
        {
            //有逾期
            body.selected = !body.selected;
            
            if (body.selected)
            {
                for (StageBillModelBody *body in _choosedArr)
                {
                    body.selected = YES;
                }
                payStyly = @"全部";
                _bottom.detailBtn.hidden = NO;
                [self searchAmonutByLoanNo:_loanNo Amount:[NSString stringWithFormat:@"%@",discountAmount]];
                payMode = @"FS";
                
                [_loanDetailTableView reloadData];
                
            }else
            {
                for (StageBillModelBody *body in _choosedArr)
                {
                    body.selected = NO;
                }
                _bottom.detailBtn.hidden = YES;
                payStyly = @"逾期";
                if (lateFees && [lateFees floatValue] > 0)
                {
                    [self searchAmonutByLoanNo:_loanNo Amount:[NSString stringWithFormat:@"%@",discountAmountOverData] AndPayMode:@"NM"];
                }else if (lateFees && [lateFees isEqualToString:@"0"])
                {
                    [self searchAmonutByLoanNo:_loanNo Amount:[NSString stringWithFormat:@"%@",discountAmountOverData] AndPayMode:@"ER"];
                }
                [_loanDetailTableView reloadData];
            }
        }
    }else if([body.setlInd isEqualToString:@"N"]&&(body.days < 0))
    {
        [self buildErrWithString:@"已逾期，不能取消"];
    }else if ( [body.setlInd isEqualToString:@"Y"])
    {
        [self buildErrWithString:@"已结清"];
    }
}

#pragma mark ---- 欠款查询----
- (void)arrearsSearch
{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:StringOrNull(_loanNo) forKey:@"LOAN_NO"];
    [client postInfo:@"app/appserver/customer/getQFCheck" requestArgument:parmDict requestTag:5 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
#pragma mark -----主动还款金额查询－－－－－

- (void)searchAmonutByLoanNo:(NSString *)loanNo Amount:(NSString *)amount AndPayMode:(NSString *)onePayMode
{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:loanNo forKey:@"LOAN_NO"];
    [parmDict setObject:amount forKey:@"ACTV_PAY_AMT"];
    [parmDict setObject:onePayMode forKey:@"PAYM_MODE"];
    [client postInfo:@"app/appserver/customer/checkZdhkMoney" requestArgument:parmDict requestTag:103 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//查询全部还款的还款金额
- (void)searchAmonutByLoanNo:(NSString *)loanNo Amount:(NSString *)amount
{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:loanNo forKey:@"loanNo"];
    [parmDict setObject:amount forKey:@"actvPayAmt"];
    [client getInfo:@"app/appserver/newZdhkMoney" requestArgument:parmDict requestTag:104 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
#pragma private Methods

- (void)comeContract
{
    _mbView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64)];
    
    _mbView.backgroundColor = [UIColor colorWithRed:0.30f green:0.30f blue:0.30f alpha:0.50f];
    
    [self.view addSubview:_mbView];
    contractBtn.userInteractionEnabled = NO;
    contractView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight - 85 - 64, DeviceWidth, 85)];
    contractView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [_mbView addSubview:contractView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 4.5, DeviceWidth, 38)];
    topView.backgroundColor = [UIColor whiteColor];
    [contractView addSubview:topView];
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelbutton.frame = CGRectMake(0, 0, DeviceWidth, 38);
    [cancelbutton setTitle:@"查看合同" forState:UIControlStateNormal];
    [cancelbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelbutton addTarget:self action:@selector(seeContract) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelbutton];
    
    UIView *bbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 47.5, DeviceWidth, 38)];
    
    bbottomView.backgroundColor = [UIColor whiteColor];
    [contractView addSubview:bbottomView];
    
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
    contractBtn.userInteractionEnabled = YES;
    
    [contractView removeFromSuperview];
    
    contractView = nil;
}
- (void)seeContract
{
    [_mbView removeFromSuperview];
    _mbView = nil;
    //个人借款合同
    contractView.hidden = YES;
    contractBtn.userInteractionEnabled = YES;
    //File Url
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* fileUrl = [NSString stringWithFormat:@"%@app/appserver/downContractPdf?applseq=%@",baseUrl,[AppDelegate delegate].userInfo.applSeq];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance]downFile:fileUrl requestArgument:@{@"applseq":[AppDelegate delegate].userInfo.applSeq} requestTag:1000 requestClass:NSStringFromClass([self class])];
}

- (void)jumpShowPdf:(NSURL *)targetPath
{
    ContractShowViewController *vc = [[ContractShowViewController alloc]init];
    vc.path = targetPath;
    vc.title = @"个人借款合同";
    vc.quote = zhanshi;
    vc.showState = @"show";
    HCRootNavController *navi = [[HCRootNavController alloc]initWithRootViewController:vc];
    [self.navigationController presentViewController:navi animated:YES completion:^{
    } ];
}

#pragma mark - private method
- (NSAttributedString *)fomatStr:(NSString *)money
{
    NSMutableAttributedString *attiText = [[NSMutableAttributedString alloc] initWithString:money];
    
    [attiText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, 5)];
    
    [attiText addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}  range:NSMakeRange(5, money.length-5)];
    
    return attiText;
}

-(void)buildToGetMoney:(UIButton *)sender{
    
//    if ([loanDetailModel.body.typGrp isEqualToString:CashCode]) {
//        
//        StageViewController *stageVc = [[StageViewController alloc]init];
//        
//        stageVc.noCreateMoneyCulculationReq = YES;
//        
//        [self.navigationController pushViewController:stageVc animated:YES];
//    }else{
//    
//        if (_onLine) {
//            [self querySetAllowRequest];
//        }else{
//            
//            if ([loanDetailModel.body.typGrp isEqualToString:CashCode]) {
//                
//                StageViewController *stageVc = [[StageViewController alloc]init];
//                
//                stageVc.noCreateMoneyCulculationReq = YES;
//                
//                [self.navigationController pushViewController:stageVc animated:YES];
//            }else{
//                
//                [self querySetAllowRequest];
//            }
//        }
//    }
}

//底部view的对勾
- (void)isSelected
{
    if(_choosedArr.count == 0)
    {
        [self buildHeadError:@"该笔欠款已还清"];
        return;
    }
    
    if (!mixData)
    {
        for (StageBillModelBody *body in _choosedArr)
        {
            body.selected = !body.selected;
        }
        
        [_loanDetailTableView reloadData];
        
        BOOL iselected = ((StageBillModelBody *)_choosedArr[0]).selected;
        if(iselected)
        {
            _bottom.moneyLabel.attributedText = [self fomatStr:[NSString stringWithFormat:@"还款总额:¥%.2f",[totalMoney floatValue]]];
            _bottom.detailBtn.hidden = NO;
            //没有逾期的
            [self buildErrWithString:[NSString stringWithFormat:@"此贷款仅支持全部还款，当前全部应还%.2f，包括本金、提前还款手续费、息费等",[totalMoney floatValue]]];
        }else
        {
            _bottom.moneyLabel.attributedText = [self fomatStr:@"还款总额:¥0.00"];
            _bottom.detailBtn.hidden = YES;
        }
        
        _bottom.iconButton.selected = iselected;
    }
}

//去还款明细页面
- (void)toRepayDetail
{
    if (!arrearsmodel.msgall.OD_AMT)
    {
        [self arrearsSearch];
        return ;
    }
    
    if([_bottom.moneyLabel.attributedText.string isEqualToString:@"还款总额:¥0.00"])
    {
        [self buildHeadError:@"请选择还款金额"];
        return;
    }

    if ( [payStyly isEqualToString:@"逾期"])
    {
        if (lateFees && [lateFees floatValue] > 0)
        {
            //逾期费用查询成功并且大于0
            if (!totalMoney)
            {
                //如果总金额为空,查询还款金额
                [self searchAmonutByLoanNo:_loanNo Amount:[NSString stringWithFormat:@"%@",discountAmountOverData] AndPayMode:@"NM"];
                payMode = @"NM";
                return;
            }
            
            payMode = @"NM";
        }
        else if (!lateFees)
        {
            [self arrearsSearch];
        }
        else if (lateFees && [lateFees isEqualToString:@"0"])
        {
            //有逾期且逾期费用为0
            if (!totalMoney)
            {
                [self searchAmonutByLoanNo:_loanNo Amount:[NSString stringWithFormat:@"%@",discountAmountOverData] AndPayMode:@"ER"];
                return;
            }
            payMode = @"ER";
        }
        
    }else if ([payStyly isEqualToString:@"全部"])
    {
        //全部
        if (!totalMoney)
        {
            
            [self searchAmonutByLoanNo:_loanNo Amount:[NSString stringWithFormat:@"%@",discountAmount]];
            
            payMode = @"FS";
            
            return;
        }
        payMode = @"FS";
    }
    
    RepayDetailViewCcontroller *rePayVC = [[RepayDetailViewCcontroller alloc] init];
    rePayVC.payMode = payMode;
    rePayVC.loanNo = _loanNo;
    rePayVC.totalAmt = totalMoney;
    if ( [payStyly isEqualToString:@"逾期"])
    {
        rePayVC.isOverdue = YES;
    }else
    {
        rePayVC.isOverdue = NO;
    }
    //本金
    rePayVC.principal = _bj;
    //息费
    rePayVC.interest = _xf;
    //手续费
    rePayVC.counterFee = _sxf;
    [self.navigationController pushViewController:rePayVC animated:YES];
}
#pragma mark - 卡地理位置的方法
- (void)judgeGeography
{
    //地理位置加判断
    if([AppDelegate delegate].mapLocation.locationStatus == LocationNoAuthority)
    {
        //提示没有权限
        [self showNoAuthorityAlert];
    }
    else if ([AppDelegate delegate].mapLocation.locationStatus == LocationNotInChina)
    {
        //提示不在中国
        [self showNotInChinaAlert];
    }else if([AppDelegate delegate].mapLocation.locationStatus == LocationGeoCitySucess)
    {
        //录单校验
        [self queryCheckList];
    }else
    {
        //提示无法获取到位置
        [self showLocationFailAlert];
    }
}
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
