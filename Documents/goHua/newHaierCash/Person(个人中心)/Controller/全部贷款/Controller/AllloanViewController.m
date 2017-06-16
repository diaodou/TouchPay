//
//  AllloanViewController.m
//  personMerchants
//
//  Created by LLM on 16/11/8.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "AllloanViewController.h"
#import "LoanTopView.h"
#import "LoanBottomView.h"
#import "AppDelegate.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "BSVKHttpClient.h"
#import <MBProgressHUD.h>
#import "RMUniversalAlert.h"
#import <MJRefresh.h>
#import <YYWebImage.h>
#import "UIButton+UnifiedStyle.h"
//#import "GoodsStageDetailViewController.h"
//#import "StageViewController.h"
#import "OrderGetDetailsViewController.h"
#import "ApprovalProgressViewController.h"   //审批进度
#import "AnyTimeBackController.h"
#import "LoanDetailsViewController.h"
#import "YuQiViewController.h"
#import "LoanGetDetailsViewController.h"
#import "BackOverrViewController.h"
#import "ConfirmPayNoBankViewController.h"
#import "PickUpCodeViewController.h"
#import "LogisticsViewController.h"
//#import "WareDetailViewController.h"
#import "GoodsRejectedViewController.h"
//
#import "WaitComNumberModel.h"
#import "ExaminationNumberModel.h"
#import "AllLoanModel.h"
#import "WaitCommitListModel.h"
#import "AllReimbursementModel.h"
#import "ExaminingModel.h"
#import "OrdeDetailsModel.h"
#import "DeleteModel.h"
#import "WhiteSearchModel.h"
#import "IndetityStore.h"
#import "CheckListModel.h"
#import "LoanDetailModel.h"
#import "SubSignContModel.h"
static const CGFloat getDateAppOrderPerson = 1003;        //获取全部订单
static const CGFloat getWtjAppOrderCust = 1004;           //获取待提交订单
static const CGFloat queryApplAllByIdNo = 1005;           //获取待还款订单
static const CGFloat queryApplListPersonExamining = 1006; //获取审批中订单
static const CGFloat queryApplListPersonWaitPick = 1007;  //获取待取货订单
static const CGFloat getDateAppOrderPersonNewData = 1008; //全部订单下拉加载
static const CGFloat getWtjAppOrderNewData = 1009;        //待提交订单下拉加载
static const CGFloat queryApplAllByIdNoNewData = 1010;    //待还款订单下拉加载
static const CGFloat queryApplListPersonExaminingNewData = 1011;   //审批中订单下拉加载
static const CGFloat queryApplListPersonWaitPickNewData = 1012;    //待取货订单下拉加载
static const CGFloat getAppOrderAndGoods = 1013;          //查询订单详情
static const CGFloat deleteAppOrder = 1014;               //取消订单
static const CGFloat queryAppLoanAndGoods = 1015;         //查询贷款详情
static const CGFloat getReturnOrder = 1016;               //退回订单修改
static const CGFloat getCustIsPass = 1017;                //准入资格查询
static const CGFloat getInvitedCustByCustNo = 1018;       //查询邀请原因
static const CGFloat getCustInfoAndEdInfoPerson = 1019;   //录单校验
static const CGFloat subSignCont = 1020;                  //申请放款
@interface AllloanViewController()<BSVKHttpClientDelegate,UITableViewDelegate,UITableViewDataSource>
/*
 界面
 */
@property (nonatomic,strong) UIView *bottomOtherView;    //如果没有订单,显示的视图
@property (nonatomic,strong) UIView *bottomLineView;     //按钮底部做动画的底图
@property (nonatomic,strong) UITableView *LoanTableView; //公用的tableVIew
@property (nonatomic,strong) UIView *allView;            //全部 红点
@property (nonatomic,strong) UIView *pendingView;        //待提交红点
@property (nonatomic,strong) UIView *repaymentView;      //待还款红点
@property (nonatomic,strong) UIView *approvalView;       //审批中红点
@property (nonatomic,strong) UIView *deliveryView;       //待取货红点
@property (nonatomic,strong) UIButton *selectBtn;        //记录上次选择的按钮

/*
 数据
 */
@property (nonatomic,strong) NSMutableArray *allArray;         //全部贷款
@property (nonatomic,strong) NSMutableArray *pendingArray;     //待提交
@property (nonatomic,strong) NSMutableArray *repaymentArray;   //待货款
@property (nonatomic,strong) NSMutableArray *approvalArry;     //审批中
@property (nonatomic,strong) NSMutableArray *deliveryArray;    //待取货

/*
 Model
 */
@property (nonatomic,strong) WhiteSearchModel *searchModel;        //白名单Model

@end

@implementation AllloanViewController
{
    NSInteger _nowOrderIndex;            //当前选择的是第几列
    
    NSInteger _selectIndex;              //待提交记录当前选择的是第几行,做完准入之后通过这个值拿数据
    
    int _pageNumber;                     //分页
    
    NSString *_stateStr;                 //按钮状态，区分不同状态点击按钮走相同流程时的处理
    
    NSString *_ifSettled;                //该订单是否已完成
    
    NSString *_fromTyp;                  //订单类型
    
    BOOL _toWare;                        //跳转wareDatailViewController界面

    BOOL _onLine;                        //是否是线上
}

#pragma mark - lifeCircle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"全部贷款";
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    if (_showList == showBeReturnList) {
        _nowOrderIndex = 2;
    }else{
        _nowOrderIndex = 0;
    }
    
    _pageNumber = 1;
    
    [self setNavi];

    [self creatBtn];

    [self initLoanTableView];
    
    //初始化没有订单的视图
    [self initNoOrderView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //重置流水号,订单号
    [AppDelegate delegate].userInfo.applSeq = nil;
    [AppDelegate delegate].userInfo.orderNo = nil;
    
    //得到订单数量
    [self getLoanNumber];
    
    //只是看订单的话不刷新(从订单详情回来)
    if ([AppDelegate delegate].userInfo.bReturn)
    {
        [AppDelegate delegate].userInfo.bReturn = NO;
    }else
    {
        [self loadNewData];
    }
}

#pragma mark - private Methods
//设置导航
- (void)setNavi
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

//创建顶部的按钮(全部,待提交,待还款,审批中,待取货)
- (void)creatBtn
{
    CGFloat btnHeight = 30;
    CGFloat btnWidth = DeviceWidth / 5;
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 1)];
    viewTop.backgroundColor = UIColorFromRGB(0xe7e7e7, 1.0);
    [self.view addSubview:viewTop];
    //q全部
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 30)];
    [self.view addSubview:baseView];
    
    NSArray *titleArray = @[@"全部",@"待提交",@"待还款",@"审批中",@"待取货"];
    for(int i = 0; i < 5; i++)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*DeviceWidth/5, 9*DeviceWidth/375, btnWidth, btnHeight)];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont appFontRegularOfSize:14];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+100;
        [baseView addSubview:btn];

        
        UIView *pointView = [[UIView alloc] init];
        if(i == 0)
        {
            pointView.frame = CGRectMake(btnWidth*2/3 - 2, 7, 6, 6);
        }else
        {
            pointView.frame = CGRectMake(btnWidth*2/3 + 4, 7, 6, 6);
        }
        pointView.backgroundColor = [UIColor redColor];
        pointView.layer.cornerRadius = 3;
        pointView.hidden = YES;
        [btn addSubview:pointView];
        
        if(i == 0)
        {
            //初始化的时候记录下第一个按钮
            if (_nowOrderIndex == 0) {
                _selectBtn = btn;
                [btn setTitleColor:UIColorFromRGB(0x32beff, 1) forState:UIControlStateNormal];
            }
            //全部贷款的红点
            _allView = pointView;
        }else if(i == 1)
        {
            //待提交
            _pendingView = pointView;
        }else if (i == 2)
        {
            if (_nowOrderIndex == 2) {
                _selectBtn = btn;
                [btn setTitleColor:UIColorFromRGB(0x32beff, 1) forState:UIControlStateNormal];
            }
            //待还款
            _repaymentView = pointView;
        }else if (i == 3)
        {
            //审批中
            _approvalView = pointView;
        }else if (i == 4)
        {
            _deliveryView = pointView;
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(i *DeviceWidth/5, 0, 1, 40)];
        
        lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
        
        [self.view addSubview:lineView];
    }
    
    //按钮底部用来做动画的View
    _bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(_nowOrderIndex *DeviceWidth/5, 9*DeviceWidth/375+btnHeight, btnWidth, 2)];
    _bottomLineView.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    [self.view addSubview:_bottomLineView];
    
    //灰色的线
    UIView *viewSep = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bottomLineView.frame), DeviceWidth, 1)];
    viewSep.backgroundColor = UIColorFromRGB(0xe7e7e7, 1.0);
    [self.view addSubview:viewSep];
}

//创建公用的TableView
- (void)initLoanTableView
{
    _LoanTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bottomLineView.frame) +1, DeviceWidth, DeviceHeight - 64 - CGRectGetMaxY(_bottomLineView.frame))style:UITableViewStylePlain];
    _LoanTableView.delegate = self;
    _LoanTableView.dataSource = self;
    _LoanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _LoanTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    // MJ
    _LoanTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _LoanTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(queryGetNewData)];
    [self.view addSubview:_LoanTableView];
}

//当前栏没有订单显示的View
- (void)initNoOrderView
{
    _bottomOtherView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bottomLineView.frame) +1, DeviceWidth, DeviceHeight - 103)];
    _bottomOtherView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    UIImageView * image = [[UIImageView alloc]init];
    CGRect rect = image.frame;
    rect.size = CGSizeMake(100,105);
    image.frame = rect;
    image.center = CGPointMake(DeviceWidth/2, 120*scale6PAdapter);
    image.image = [UIImage imageNamed:@"无订单"];
    [_bottomOtherView addSubview:image];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0,205 *scale6PAdapter, DeviceWidth, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"什么都没有哎~ ~快去申请吧~ ~";
    label.font = [UIFont appFontRegularOfSize:14];
    label.textColor = UIColorFromRGB(0x666666, 1.0);
    [_bottomOtherView addSubview:label];
    
    UIButton * applyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    applyBtn.frame = CGRectMake(120* scale6PAdapter, 240 *scale6PAdapter, DeviceWidth - 240 *scale6PAdapter , 30);
    [applyBtn setButtonTitle:@"申 请 分 期" titleFont:14 buttonHeight:30];
    [applyBtn addTarget:self action:@selector(clickToApply) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomOtherView addSubview:applyBtn];
    
    [self.view addSubview:_bottomOtherView];
    _bottomOtherView.hidden = YES;
}
- (void)loadNewData{
    
    [self getLoanNumber];
    
    _pageNumber = 1;
    
    [_allArray removeAllObjects];
    
    [_approvalArry removeAllObjects];
    
    [_pendingArray removeAllObjects];
    
    [_repaymentArray removeAllObjects];
    
    [_deliveryArray removeAllObjects];
    
    [_LoanTableView  reloadData];
    
    if (0 == _nowOrderIndex)
    {
        [self queryAllLoan];
    }
    
    if (1 == _nowOrderIndex)
    {
        [self queryWaitCommit];
    }
    
    if (2 == _nowOrderIndex)
    {
        [self queryWaitRepayment];
    }
    
    if (3 == _nowOrderIndex)
    {
        [self queryExamining];
    }
    
    if (4 == _nowOrderIndex)
    {
        [self queryWaitPick];
    }
    
    [_LoanTableView.mj_header endRefreshing];
    [_LoanTableView.mj_footer resetNoMoreData];
}
//获取订单数量
- (void)getLoanNumber
{
    //待提交
    [self queryLoanNumber];
    //审批中  待取货  待还款
    [self queryExamination];
}
- (void)contionToNext
{
    if(_nowOrderIndex == 0)
    {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:_selectIndex];
        _fromTyp = allLoanModel.formTyp;
        if ([_stateStr isEqualToString:@"再次申请"]) {
            _stateStr = @"再次申请";
        }else{
            _stateStr = @"待提交";
        }
        
        [AppDelegate delegate].userInfo.orderNo = allLoanModel.orderNo;
        [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
        
        [self queryGetAppOrderAndGoods];
    }else if (_nowOrderIndex == 1)
    {
        WaitCommitListOrders *waitModel = [_pendingArray objectAtIndex:_selectIndex];
        [AppDelegate delegate].userInfo.orderNo = waitModel.orderNo;
        _fromTyp = waitModel.formTyp;
        _stateStr = @"待提交";
        [self queryGetAppOrderAndGoods];//查询订单详情
    }
}


//跳转支付
-(void)toPayNoBank{
    
    ConfirmPayNoBankViewController * vc  = [[ConfirmPayNoBankViewController alloc]init];
    
//    vc.flowName = ApplyForLoan;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)removeBtnWithBottomView:(LoanBottomView *)bottomView{
    
    //  右侧按钮
    //继续申请
    [bottomView.rightBottomButton removeTarget:self action:@selector(clickContinued:) forControlEvents:UIControlEventTouchUpInside];
    
    //审批进度
    [bottomView.rightBottomButton removeTarget:self action:@selector(clickSpeed:) forControlEvents:UIControlEventTouchUpInside];
    
    //取货
    [bottomView.rightBottomButton removeTarget:self action:@selector(clickPick:) forControlEvents:UIControlEventTouchUpInside];
    
    //取消订单
    [bottomView.rightBottomButton removeTarget:self action:@selector(clickDeleLoan:) forControlEvents:UIControlEventTouchUpInside];
    
    //还款
    [bottomView.rightBottomButton removeTarget:self action:@selector(clickPayBack:) forControlEvents:UIControlEventTouchUpInside];
    //中间按钮
    //审批进度
    [bottomView.centerBottomButton removeTarget:self action:@selector(clickSpeed:) forControlEvents:UIControlEventTouchUpInside];
    
    //取消订单
    [bottomView.centerBottomButton removeTarget:self action:@selector(clickDeleLoan:) forControlEvents:UIControlEventTouchUpInside];
    
    //左侧按钮
    
    //取消订单
    [bottomView.leftBottomButton removeTarget:self action:@selector(clickDeleLoan:) forControlEvents:UIControlEventTouchUpInside];
}
//使用全部贷款model给view赋值
- (NSString *)setLoanView:(LoanTopView *)loanView WithObject:(NSObject *)obj withFormTyp:(NSString *)formTyp
{
    NSString *moneyLabel;
    
    if(_nowOrderIndex == 0)
    {
        AllLoanOrders *allLoanModel = (AllLoanOrders *)obj;
        loanView.labelState.text = allLoanModel.outSts;
        loanView.labelTime.text = allLoanModel.applyDt;
        if ([allLoanModel.outSts isEqualToString:@"00"])
        {
            loanView.labelState.text = @"待提交";
        }else if ([allLoanModel.outSts isEqualToString:@"1"])
        {
            loanView.labelState.text = @"待提交";
        }else if ([allLoanModel.outSts isEqualToString:@"2"])
        {
            loanView.labelState.text = @"商户确认中";
        }
        else if ([allLoanModel.outSts isEqualToString:@"3"])
        {
            loanView.labelState.text = @"商户退回";
        }
        else if ([allLoanModel.outSts isEqualToString:@"01"] || [allLoanModel.outSts isEqualToString:@"4"])
        {
            loanView.labelState.text = @"审批中";
        }
        else if ([allLoanModel.outSts isEqualToString:@"02"])
        {
            loanView.labelState.text = @"贷款被拒绝";
        }
        else if ([allLoanModel.outSts isEqualToString:@"03"])
        {
            loanView.labelState.text = @"贷款已取消";
        }
        else if ([allLoanModel.outSts isEqualToString:@"04"])
        {
            loanView.labelState.text = @"等待放款";
        }
        else if ([allLoanModel.outSts isEqualToString:@"05"])
        {
            loanView.labelState.text = @"审批通过，等待放款";
        }
        else if ([allLoanModel.outSts isEqualToString:@"06"])
        {
            if ([allLoanModel.ifSettled isEqualToString:@"SE"]) {
                loanView.labelState.text = @"已完成";
            }else{
                loanView.labelState.text = @"还款中";
            }
            
        }
        else if ([allLoanModel.outSts isEqualToString:@"20"])
        {
            loanView.labelState.text = @"待放款";
        }
        else if ([allLoanModel.outSts isEqualToString:@"22"])
        {
            loanView.labelState.text = @"审批退回";
        }
        else if ([allLoanModel.outSts isEqualToString:@"23"])
        {
            loanView.labelState.text = @"等待放款";
        }
        else if ([allLoanModel.outSts isEqualToString:@"24"])
        {
            loanView.labelState.text = @"放款审核中";
        }
        else if ([allLoanModel.outSts isEqualToString:@"25"])
        {
            loanView.labelState.text = @"额度申请被拒";
        }
        else if ([allLoanModel.outSts isEqualToString:@"26"])
        {
            loanView.labelState.text = @"额度申请已取消";
        }
        else if ([allLoanModel.outSts isEqualToString:@"27"])
        {
            loanView.labelState.text = @"已通过";
        }
        else if ([allLoanModel.outSts isEqualToString:@"AA"])
        {
            loanView.labelState.text = @"取消放款";
        }
        else if ([allLoanModel.outSts isEqualToString:@"OD"])
        {
            loanView.labelState.text = @"已逾期";
        }
        else if ([allLoanModel.outSts isEqualToString:@"30"])
        {
            if ([formTyp isEqualToString:@"20"]) {
                loanView.labelState.text = @"已付款待发货";
            }else{
                loanView.labelState.text = @"待取货";
            }
        }
        else if ([allLoanModel.outSts isEqualToString:@"31"])
        {
            loanView.labelState.text = @"已发货";
        }
        else if ([allLoanModel.outSts isEqualToString:@"80"])
        {
            loanView.labelState.text = @"还款中";
        }
        else if ([allLoanModel.outSts isEqualToString:@"81"])
        {
            loanView.labelState.text = @"已完成";
        }
        else if ([allLoanModel.outSts isEqualToString:@"90"])
        {
            loanView.labelState.text = @"被退回";
        }
        else if ([allLoanModel.outSts isEqualToString:@"91"])
        {
            loanView.labelState.text = @"已取消";
        }
        else if ([allLoanModel.outSts isEqualToString:@"92"])
        {
            loanView.labelState.text = @"退货中";
        }
        else if ([allLoanModel.outSts isEqualToString:@"93"])
        {
            loanView.labelState.text = @"已退货";
        }
        else if ([allLoanModel.outSts isEqualToString:@"SS"])
        {
            loanView.labelState.text = @"客户暂存";
        }
        if ([allLoanModel.typGrp isEqualToString:CashCode])
        {
            if([allLoanModel.applyTnrTyp isEqualToString:@"D"] || [allLoanModel.applyTnrTyp isEqualToString:@"d"])
            {
                loanView.labelMidContent.text = @"现金随借随还";
            }else if([allLoanModel.applyTnrTyp isEqualToString:allLoanModel.applyTnr])
            {
                loanView.labelMidContent.text = @"现金支用";
            }
        }
        else
        {
            if([allLoanModel.goodsName rangeOfString:@"goodname"].location !=NSNotFound)
            {
                NSRange range  = [allLoanModel.goodsName rangeOfString:@"goodname"];
                
                loanView.labelMidContent.text = [allLoanModel.goodsName substringFromIndex:range.location+range.length];  //名称
            }
            else
            {
                loanView.labelMidContent.text = allLoanModel.goodsName;
            }
        }
        
        loanView.labelMidContent.hidden = NO;
        loanView.labelTopContent.hidden = NO;
        loanView.labelBottomContent.hidden = NO;
        loanView.labelTime.text = allLoanModel.applyDt;
        
        //        订单号
        loanView.orderNo = allLoanModel.orderNo;
        
        if (allLoanModel.apprvAmt)
        {
            moneyLabel = [NSString stringWithFormat:@"借款金额:¥%.2f元",[allLoanModel.apprvAmt floatValue]];
        }else{
            moneyLabel = [NSString stringWithFormat:@"借款金额:¥%.2f元",[allLoanModel.applyAmt floatValue]];
        }
    }
    else if (_nowOrderIndex == 1)
    {
        WaitCommitListOrders *waitModel = (WaitCommitListOrders *)obj;
        loanView.labelState.text = @"待提交";
        loanView.labelTime.text = waitModel.applyDt;
        
        loanView.labelMidContent.hidden = NO;
        loanView.labelTopContent.hidden = NO;
        loanView.labelBottomContent.hidden = NO;
        if ([waitModel.typGrp isEqualToString:CashCode])
        {
            if([waitModel.applyTnrTyp isEqualToString:@"D"] || [waitModel.applyTnrTyp isEqualToString:@"d"])
            {
                loanView.labelMidContent.text = @"现金随借随还";
            }else if([waitModel.applyTnrTyp isEqualToString:waitModel.applyTnr])
            {
                loanView.labelMidContent.text = @"现金支用";
            }
        }
        else
        {
            if([waitModel.goodsName rangeOfString:@"goodname"].location !=NSNotFound)//_roaldSearchText
            {
                NSRange range  = [waitModel.goodsName rangeOfString:@"goodname"];
                
                loanView.labelMidContent.text = [waitModel.goodsName substringFromIndex:range.location+range.length];  //名称
            }
            else
            {
                loanView.labelMidContent.text = waitModel.goodsName;
            }
        }
        
        moneyLabel = [NSString stringWithFormat:@"借款金额:¥%.2f元",[waitModel.applyAmt floatValue]];
    }
    else if (_nowOrderIndex == 2)
    {
        AllReimbursementBodyItem *waitRePayModel = (AllReimbursementBodyItem *)obj;
        if ([waitRePayModel.remainDays intValue] < 0) {
            loanView.labelState.text = @"已逾期";
        }else{
            loanView.labelState.text = @"待还款";
        }
        loanView.labelMidContent.hidden = NO;
        loanView.labelTopContent.hidden = YES;
        loanView.labelBottomContent.hidden = YES;
        loanView.labelTime.text = waitRePayModel.applyDt;
        if ([waitRePayModel.typGrp isEqualToString:CashCode])
        {
            if([waitRePayModel.applyTnrTyp isEqualToString:@"D"] || [waitRePayModel.applyTnrTyp isEqualToString:@"d"])
            {
                loanView.labelMidContent.text = @"现金随借随还";
            }else if([waitRePayModel.applyTnrTyp isEqualToString:waitRePayModel.applyTnr])
            {
                loanView.labelMidContent.text = @"现金支用";
            }
        }
        else
        {
            if([waitRePayModel.goodsName rangeOfString:@"goodname"].location !=NSNotFound)//_roaldSearchText
            {
                NSRange range  = [waitRePayModel.goodsName rangeOfString:@"goodname"];
                
                loanView.labelMidContent.text = [waitRePayModel.goodsName substringFromIndex:range.location+range.length];  //名称
            }
            else
            {
                loanView.labelMidContent.text = waitRePayModel.goodsName;
            }
        }
        
        NSString * money = [NSString stringWithFormat:@"%.2f",waitRePayModel.sybj];
        moneyLabel = [NSString stringWithFormat:@"剩余还款:¥%@元",money];
    }
    else if (_nowOrderIndex == 3)
    {
        ExaminingBody *examingModel = (ExaminingBody *)obj;
        if ([examingModel.status isEqualToString:@"2"])
        {
            loanView.labelState.text = @"商户确认中";
        }else
        {
            loanView.labelState.text = @"审批中";
        }
        
        loanView.labelTime.text = examingModel.applyDt;
        loanView.labelMidContent.hidden = NO;
        loanView.labelTopContent.hidden = YES;
        loanView.labelBottomContent.hidden = YES;
        if ([examingModel.typGrp isEqualToString:CashCode])
        {
            if([examingModel.applyTnrTyp isEqualToString:@"D"] || [examingModel.applyTnrTyp isEqualToString:@"d"])
            {
                loanView.labelMidContent.text = @"现金随借随还";
            }else if([examingModel.applyTnrTyp isEqualToString:examingModel.applyTnr])
            {
                loanView.labelMidContent.text = @"现金支用";
            }
        }else
        {
            if([examingModel.goodsName rangeOfString:@"goodname"].location !=NSNotFound)//_roaldSearchText
            {
                NSRange range  = [examingModel.goodsName rangeOfString:@"goodname"];
                
                loanView.labelMidContent.text = [examingModel.goodsName substringFromIndex:range.location+range.length];  //名称
            }
            else
            {
                loanView.labelMidContent.text = examingModel.goodsName;
            }
        }
        
        moneyLabel = [NSString stringWithFormat:@"借款金额:¥%.2f元",[examingModel.applyAmt floatValue]];
    }
    else if (_nowOrderIndex == 4)
    {
        ExaminingBody *examingModel = (ExaminingBody *)obj;
        loanView.labelState.text = @"待取货";
        loanView.labelTime.text = examingModel.applyDt;
        if([examingModel.goodsName rangeOfString:@"goodname"].location !=NSNotFound)//_roaldSearchText
        {
            NSRange range  = [examingModel.goodsName rangeOfString:@"goodname"];
            
            loanView.labelMidContent.text = [examingModel.goodsName substringFromIndex:range.location+range.length];  //名称
        }
        else
        {
            loanView.labelMidContent.text = examingModel.goodsName;
        }
        
        loanView.labelMidContent.hidden = NO;
        loanView.labelTopContent.hidden = YES;
        loanView.labelBottomContent.hidden = YES;
        moneyLabel = [NSString stringWithFormat:@"借款金额:¥%.2f元",[examingModel.applyAmt floatValue]];
    }
    
    return moneyLabel;
}

//根据不同的状态为按钮添加事件
- (void)addTagartForLoanBottomView:(LoanBottomView *)bottomView WithLoanState:(NSString *)state WithFormTyp:(NSString *)formTyp
{
    if ([state isEqualToString:@"待提交"])
    {
        [bottomView.centerBottomButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [bottomView.centerBottomButton addTarget:self action:@selector(clickCancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        bottomView.centerBottomButton.hidden = NO;
        
        [bottomView.rightBottomButton setTitle:@"继续提交" forState:UIControlStateNormal];
        [bottomView.rightBottomButton addTarget:self action:@selector(clickContinued:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
    }
    else if ([state isEqualToString:@"待还款"])//待还款
    {
        [bottomView.rightBottomButton setTitle:@"还款" forState:UIControlStateNormal]
        ;
        [bottomView.rightBottomButton addTarget:self action:@selector(clickPayBack:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
        
        if ([formTyp isEqualToString:@"20"]) {
            [bottomView.centerBottomButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [bottomView.centerBottomButton addTarget:self action:@selector(clickLogistics:) forControlEvents:UIControlEventTouchUpInside];
            bottomView.centerBottomButton.hidden = NO;
        }
    }
    else if ([state isEqualToString:@"审批中"] || [state isEqualToString:@"商户确认中"])//审批中
    {
        [bottomView.rightBottomButton setTitle:@"审批进度" forState:UIControlStateNormal];
        [bottomView.rightBottomButton addTarget:self action:@selector(clickSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
    }
    else if ([state isEqualToString:@"商户退回"]||[state isEqualToString:@"审批退回"])//被退回
    {
        [bottomView.centerBottomButton setTitle:@"审批进度" forState:UIControlStateNormal];
        [bottomView.centerBottomButton addTarget:self action:@selector(clickSpeed:) forControlEvents:UIControlEventTouchUpInside];
        bottomView.centerBottomButton.hidden = NO;
        
        [bottomView.rightBottomButton setTitle:@"修改提交" forState:UIControlStateNormal];
        bottomView.rightBottomButton.titleLabel.font = [UIFont appFontRegularOfSize:12];
        [bottomView.rightBottomButton addTarget:self action:@selector(clickReturnTo:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
        
    }
    else if([state isEqualToString:@"已逾期"])
    {
        [bottomView.rightBottomButton setTitle:@"还款" forState:UIControlStateNormal];
        [bottomView.rightBottomButton addTarget:self action:@selector(clickPayBack:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
    }
    else if([state isEqualToString:@"待取货"])//待取货
    {
        [bottomView.centerBottomButton setTitle:@"审批进度" forState:UIControlStateNormal];
        [bottomView.centerBottomButton addTarget:self action:@selector(clickSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        //        bottomView.rightBottomButton.hidden = NO;
        [bottomView.rightBottomButton setTitle:@"确认取货" forState:UIControlStateNormal];
        
        [bottomView.rightBottomButton addTarget:self action:@selector(clickPick:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.centerBottomButton.hidden = NO;
        
        bottomView.rightBottomButton.hidden = NO;
    }
    else if ([state isEqualToString:@"等待放款"])
    {
        [bottomView.centerBottomButton setTitle:@"审批进度" forState:UIControlStateNormal];
        
        [bottomView.centerBottomButton addTarget:self action:@selector(clickSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.centerBottomButton.hidden = NO;
        
        [bottomView.rightBottomButton setTitle:@"申请放款" forState:UIControlStateNormal];
        
        [bottomView.rightBottomButton addTarget:self action:@selector(clickWaitLoan:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
        
    }
    else if ([state isEqualToString:@"放款审核中"])
    {
        [bottomView.rightBottomButton setTitle:@"审批进度" forState:UIControlStateNormal];
        [bottomView.rightBottomButton addTarget:self action:@selector(clickSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
        
    }
    else if ([state isEqualToString:@"审批通过，等待放款"])
    {
        [bottomView.rightBottomButton setTitle:@"审批进度" forState:UIControlStateNormal];
        [bottomView.rightBottomButton addTarget:self action:@selector(clickSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
        
    }
    else if ([state isEqualToString:@"还款中"] && ![formTyp isEqualToString:@"20"])
    {
        [bottomView.centerBottomButton setTitle:@"审批进度" forState:UIControlStateNormal];
        
        [bottomView.centerBottomButton addTarget:self action:@selector(clickSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.centerBottomButton.hidden = NO;
        
        [bottomView.rightBottomButton setTitle:@"还款" forState:UIControlStateNormal];
        [bottomView.rightBottomButton addTarget:self action:@selector(clickPayBack:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
    }else if ([state isEqualToString:@"贷款被拒绝"])
    {
        [bottomView.rightBottomButton setTitle:@"审批进度" forState:UIControlStateNormal];
        
        [bottomView.rightBottomButton addTarget:self action:@selector(clickSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
    }else if ([state isEqualToString:@"已完成"]){
        [bottomView.rightBottomButton setTitle:@"再次申请" forState:UIControlStateNormal];
        
        [bottomView.rightBottomButton addTarget:self action:@selector(clickSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
        
        if ([formTyp isEqualToString:@"20"]) {
            [bottomView.centerBottomButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [bottomView.centerBottomButton addTarget:self action:@selector(clickLogistics:) forControlEvents:UIControlEventTouchUpInside];
            bottomView.centerBottomButton.hidden = NO;
        }
        
    }else if ([state isEqualToString:@"还款中"] && [formTyp isEqualToString:@"20"]){
        [bottomView.centerBottomButton setTitle:@"查看物流" forState:UIControlStateNormal];
        
        [bottomView.centerBottomButton addTarget:self action:@selector(clickLogistics:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.centerBottomButton.hidden = NO;
        
        [bottomView.rightBottomButton setTitle:@"还款" forState:UIControlStateNormal];
        [bottomView.rightBottomButton addTarget:self action:@selector(clickPayBack:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
    }
    else if ([state isEqualToString:@"已发货"]){
        [bottomView.rightBottomButton setTitle:@"查看物流" forState:UIControlStateNormal];
        
        [bottomView.rightBottomButton addTarget:self action:@selector(clickLogistics:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView.rightBottomButton.hidden = NO;
        
        
    }
}
//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex)
     {
         STRONGSELF
         if (strongSelf)
         {
             if (buttonIndex == 0)
             {
                 
             }
         }
     }];
}
#pragma mark - custom Methods
// 返回
- (void)OnBackBtn:(UIButton *)btn{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//顶部按钮的点击事件
- (void)btnClick:(UIButton *)btn{
    
    [btn setTitleColor:UIColorFromRGB(0x018de7, 1) forState:UIControlStateNormal];
    
    if(_selectBtn && ![_selectBtn isEqual:btn])
    {
        [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    _nowOrderIndex = btn.tag-100;
    _pageNumber = 0;
    _bottomOtherView.hidden = YES;
    
    [AppDelegate delegate].userInfo.applSeq = nil;
    [AppDelegate delegate].userInfo.orderNo = nil;
    
    [self loadNewData];
    
    [UIView animateWithDuration:0.5 animations:^{
        _bottomLineView.frame = CGRectMake(btn.frame.origin.x, CGRectGetMinY(_bottomLineView.frame), btn.frame.size.width, 2);
        
    } completion:^(BOOL finished) {
        //[btn setTitleColor:UIColorFromRGB(0x018de7, 1) forState:UIControlStateNormal];
    }];
    
    _selectBtn = btn;
}
//去主页
- (void)clickToApply{
    
    for (UIView *subview in self.view.subviews) {
        [subview removeFromSuperview];
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
}
// 继续申请 跳转
- (void)clickContinued:(UIButton *)btn
{
    //获取按钮所在cell的IndexPath
    UITableViewCell *  cell;
    if([btn.superview.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell*)btn.superview.superview.superview;
    }else
    {
        cell = (UITableViewCell*)btn.superview.superview.superview.superview;
    }
    NSIndexPath * indexPath = [_LoanTableView indexPathForCell:cell];
    
    //不管是全部贷款中的待提交还是待提交中的待提交(先判断准入)
    _selectIndex = indexPath.row;
    
    [self querySetAllowRequest];
}

// 取消订单
-(void)clickCancelOrder:(UIButton *)btn
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"确定取消订单？" cancelButtonTitle:@"确定" destructiveButtonTitle:@"取消" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                [strongSelf clickDeleLoan:btn];
            }
        }
    }];
}
// 还款 跳转
- (void)clickPayBack:(UIButton *)btn
{
    UITableViewCell *  cell;
    
    if([btn.superview.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell*)btn.superview.superview.superview;
    }else
    {
        cell = (UITableViewCell*)btn.superview.superview.superview.superview;
    }
    NSIndexPath * indexPath = [_LoanTableView indexPathForCell:cell];
    
    if (_nowOrderIndex == 0) {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:indexPath.row];
        LoanTopView *topView = (LoanTopView*) [cell.contentView viewWithTag:50];
        [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
        //        查询贷款详情，根据payMtd判断是否为随借随还
        if ([topView.labelState.text isEqualToString:@"待还款"] || [topView.labelState.text isEqualToString:@"还款中"])
        {
            _stateStr = @"待还款";
            //未逾期的请求tag为10
            [self creatDetailReqWithRequestTag:10];
            
        }else if ([topView.labelState.text isEqualToString:@"已逾期"]){
            _stateStr = @"已逾期";
            //逾期的请求tag为11
            [self creatDetailReqWithRequestTag:11];
            
        }
    }else{
        AllReimbursementBodyItem *rePayLoanModel = [_repaymentArray objectAtIndex:indexPath.row];
        LoanTopView *topView = (LoanTopView*) [cell.contentView viewWithTag:50];
        [AppDelegate delegate].userInfo.applSeq = rePayLoanModel.applSeq;
        //        查询贷款详情，根据payMtd判断是否为随借随还
        if ([topView.labelState.text isEqualToString:@"待还款"])
        {
            _stateStr = @"待还款";
            //未逾期的请求tag为10
            [self creatDetailReqWithRequestTag:10];
            
        }else if ([topView.labelState.text isEqualToString:@"已逾期"]){
            _stateStr = @"已逾期";
            //逾期的请求tag为11
            [self creatDetailReqWithRequestTag:11];
            
        }
    }
}

// 审批进度 跳转
- (void)clickSpeed:(UIButton *)btn
{
    UITableViewCell *  cell;
    
    if([btn.superview.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell*)btn.superview.superview.superview;
    }else
    {
        cell = (UITableViewCell*)btn.superview.superview.superview.superview;
    }
    NSIndexPath * indexPath = [_LoanTableView indexPathForCell:cell];
    
    _selectIndex = indexPath.row;

    if (_nowOrderIndex == 0)
    {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:indexPath.row];
        if ([allLoanModel.ifSettled isEqualToString:@"SE"]) {
           
            _stateStr = @"再次申请";
            
            if ([allLoanModel.formTyp isEqualToString:@"20"]) {
                _fromTyp = @"20";
                _toWare = YES;
                [self querySetAllowRequest];
            }else{
                _fromTyp = nil;
                _toWare = NO;
                if ([allLoanModel.typGrp isEqualToString:CashCode]) {
                    
//                    StageViewController *stageVc = [[StageViewController alloc]init];
//                    
//                    stageVc.noCreateMoneyCulculationReq = YES;
//                    
//                    [self.navigationController pushViewController:stageVc animated:YES];
                }else{
                
                    [self querySetAllowRequest];
                }
            }
        }else{
            
            ApprovalProgressViewController *vc = [[ApprovalProgressViewController alloc]init];
            
            
            [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
            [AppDelegate delegate].userInfo.orderNo = allLoanModel.orderNo;

            if ([allLoanModel.outSts isEqualToString:@"3"])
//            {
//                vc.stateStr = @"商户退回";
//            }else if ([allLoanModel.outSts isEqualToString:@"06"])//已放款
//            {
//                vc.stateStr = @"已放款";
//            }else if ([allLoanModel.outSts isEqualToString:@"24"])//放款审核中
//            {
//                vc.stateStr = @"放款审核中";
//            }else if ([allLoanModel.outSts isEqualToString:@"04"])//等待放款
//            {
//                vc.stateStr = @"等待放款";
//            }else if ([allLoanModel.outSts isEqualToString:@"01"] || [allLoanModel.outSts isEqualToString:@"4"])
//            {
//                vc.stateStr = @"审批中";
//            }else if ([allLoanModel.outSts isEqualToString:@"22"])
//            {
//                vc.stateStr = @"审批退回";
//            }else if ([allLoanModel.outSts isEqualToString:@"2"])
//            {
//                vc.stateStr = @"商户确认中";
//            }
//            
//            vc.flowName = AllLoan;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    }else if (_nowOrderIndex == 3)
    {
        ExaminingBody *examLoanModel = [_approvalArry objectAtIndex:indexPath.row];
        ApprovalProgressViewController *vc = [[ApprovalProgressViewController alloc]init];
//        vc.flowName = AllLoan;
        if ([examLoanModel.status isEqualToString:@"2"]) {
//            vc.stateStr = @"商户确认中";
        }else if (examLoanModel.applSeq) {
//            vc.stateStr = @"审批中";
            [AppDelegate delegate].userInfo.applSeq = examLoanModel.applSeq;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_nowOrderIndex == 4)
    {
        ExaminingBody *examLoanModel = [_deliveryArray objectAtIndex:indexPath.row];
        ApprovalProgressViewController *vc = [[ApprovalProgressViewController alloc]init];
//        vc.flowName = AllLoan;
        
        if (examLoanModel.applSeq) {
//            vc.stateStr = @"待取货";
            [AppDelegate delegate].userInfo.applSeq = examLoanModel.applSeq;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//查看物流
- (void)clickLogistics:(UIButton *)btn{

    UITableViewCell *  cell;
    
    if([btn.superview.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell*)btn.superview.superview.superview;
    }else
    {
        cell = (UITableViewCell*)btn.superview.superview.superview.superview;
    }
    NSIndexPath * indexPath = [_LoanTableView indexPathForCell:cell];
    
    LogisticsViewController *vc = [[LogisticsViewController alloc]init];

    if (_nowOrderIndex == 0) {
        
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:indexPath.row];
        
        vc.orderNo = allLoanModel.orderNo;
    
    }else{
    
        AllReimbursementBodyItem *waitRePayModel = [_repaymentArray objectAtIndex:indexPath.row];

        vc.orderNo = waitRePayModel.orderNo;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}
//被退回继续申请
- (void)clickReturnTo:(UIButton *)btn
{
    UITableViewCell *  cell;
    
    if([btn.superview.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell*)btn.superview.superview.superview;
    }else
    {
        cell = (UITableViewCell*)btn.superview.superview.superview.superview;
    }
    
    NSIndexPath * indexPath = [_LoanTableView indexPathForCell:cell];
    
    if (_nowOrderIndex == 0)
    {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:indexPath.row];

        if ([allLoanModel.formTyp isEqualToString:@"20"]) {
            _fromTyp = @"20";
        }else{
            _fromTyp = nil;
        }
        if ([allLoanModel.typGrp isEqualToString:CashCode])
        {
            _stateStr = @"被退回";
            [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
            [self queryAppLoanAndGoods];//查询贷款详情
        }else
        {
            _fromTyp = allLoanModel.formTyp;
            
            if ([allLoanModel.outSts isEqualToString:@"3"])
            {
                [AppDelegate delegate].userInfo.orderNo = allLoanModel.orderNo;
                
                _stateStr = @"商户退回商品贷";
                
                [self queryGetAppOrderAndGoods];//订单详情
                
            }else
            {
                
                [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
                
                _stateStr = @"信贷退回商品贷";
                
                [self queryChangeLoan];//修改订单
                
            }
        }
    }
}

// 确认取货 跳转
- (void)clickPick:(UIButton *)btn
{
    if (_nowOrderIndex == 0)
    {
        UITableViewCell *  cell;
        
        if([btn.superview.superview.superview isKindOfClass:[UITableViewCell class]])
        {
            cell = (UITableViewCell*)btn.superview.superview.superview;
        }else
        {
            cell = (UITableViewCell*)btn.superview.superview.superview.superview;
        }
        
        NSIndexPath * indexPath = [_LoanTableView indexPathForCell:cell];
        AllLoanOrders *allModel = [_allArray objectAtIndex:indexPath.row];
        [AppDelegate delegate].userInfo.applSeq = StringOrNull(allModel.applSeq);
        _stateStr = @"待取货";
        [self queryAppLoanAndGoods];//查询贷款详情
    }else if (_nowOrderIndex == 4)
    {
        UITableViewCell *  cell;
        
        if([btn.superview.superview.superview isKindOfClass:[UITableViewCell class]])
        {
            cell = (UITableViewCell*)btn.superview.superview.superview;
        }else
        {
            cell = (UITableViewCell*)btn.superview.superview.superview.superview;
        }
        
        NSIndexPath * indexPath = [_LoanTableView indexPathForCell:cell];
        ExaminingBody *examLoanModel = [_deliveryArray objectAtIndex:indexPath.row];
        [AppDelegate delegate].userInfo.applSeq = StringOrNull(examLoanModel.applSeq);
        _stateStr = @"待取货";
        [self queryAppLoanAndGoods];//查询贷款详情
    }
}

//等待放款
- (void)clickWaitLoan:(UIButton *)btn
{
    UITableViewCell *  cell;
    
    if([btn.superview.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell*)btn.superview.superview.superview;
    }else
    {
        cell = (UITableViewCell*)btn.superview.superview.superview.superview;
    }
    
    NSIndexPath * indexPath = [_LoanTableView indexPathForCell:cell];
    AllLoanOrders *allLoanModel = [_allArray objectAtIndex:indexPath.row];
    [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
    _stateStr = @"等待放款";
    [self queryAppLoanAndGoods];//查询贷款详情
}

//取消订单(现在除了待提交都不可能存在可取消的情况)
-(void)clickDeleLoan:(UIButton *)btn
{
    if (_nowOrderIndex == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UITableViewCell *  cell;
        
        if([btn.superview.superview.superview isKindOfClass:[UITableViewCell class]])
        {
            cell = (UITableViewCell*)btn.superview.superview.superview;
        }else
        {
            cell = (UITableViewCell*)btn.superview.superview.superview.superview;
        }
        
        NSIndexPath *indexRow = [_LoanTableView indexPathForCell:cell];
        AllLoanOrders *allModel = [_allArray objectAtIndex:indexRow.row];
        NSString * deleStr = allModel.orderNo;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:StringOrNull(deleStr) forKey:@"orderNo"];
        BSVKHttpClient *client = [BSVKHttpClient shareInstance];
        client.delegate = self;
        [client postInfo:@"app/appserver/apporder/deleteAppOrder" requestArgument:dic requestTag:deleteAppOrder requestClass:NSStringFromClass([self class])];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UITableViewCell *  cell;
        
        if([btn.superview.superview.superview isKindOfClass:[UITableViewCell class]])
        {
            cell = (UITableViewCell*)btn.superview.superview.superview;
        }else
        {
            cell = (UITableViewCell*)btn.superview.superview.superview.superview;
        }
        
        NSIndexPath *indexRow = [_LoanTableView indexPathForCell:cell];
        WaitCommitListOrders *waitModel = [_pendingArray objectAtIndex:indexRow.row];
        NSString * deleStr = waitModel.orderNo;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:StringOrNull(deleStr) forKey:@"orderNo"];
        BSVKHttpClient *client = [BSVKHttpClient shareInstance];
        client.delegate = self;
        [client postInfo:@"app/appserver/apporder/deleteAppOrder" requestArgument:dic requestTag:deleteAppOrder requestClass:NSStringFromClass([self class])];
    }
}
// 查询无额度用户审批进度
- (void)clicktoConPayfirmExamineViewController{
    
    ApprovalProgressViewController *vc = [[ApprovalProgressViewController alloc]init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}
// 点击cell中 看详情
- (void)cellBgbtnClick:(UIGestureRecognizer *)object{
    
    LoanTopView *weakLoanView = (LoanTopView *)object.view.superview;
    
    UITableViewCell *  cell;
    if([weakLoanView.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell*)weakLoanView.superview.superview;
    }else
    {
        cell = (UITableViewCell*)weakLoanView.superview.superview.superview;
    }
    NSIndexPath *index = [_LoanTableView indexPathForCell:cell];
    
    if ([weakLoanView.labelState.text isEqualToString:@"已逾期"])//只有全部中有已逾期
    {
        if (0 == _nowOrderIndex)
        {
            AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
            if (allLoanModel.applSeq)
            {
                [AppDelegate delegate].userInfo.orderNo = allLoanModel.orderNo;
                [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
                [self creatDetailReqWithRequestTag:11];//逾期的tag值为11
            }
        }
        else if (2 == _nowOrderIndex)
        {
            AllReimbursementBodyItem *rePayLoanModel = [_repaymentArray objectAtIndex:index.row];
            if (rePayLoanModel.applSeq)
            {
                [AppDelegate delegate].userInfo.applSeq = rePayLoanModel.applSeq;
                [self creatDetailReqWithRequestTag:11];//逾期的tag值为11
            }
        }
    }
    else if ([weakLoanView.labelState.text isEqualToString:@"审批中"]||[weakLoanView.labelState.text isEqualToString:@"商户确认中"])
    {
        if (0 == _nowOrderIndex)//全部贷款中的审批中
        {
            AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
            if ([allLoanModel.goodsName isEqualToString:@""])
            {
                LoanGetDetailsViewController *vc = [[LoanGetDetailsViewController alloc]init];
                [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
                vc.loanName = ExaminationCash;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else
            {
                LoanGetDetailsViewController * vc = [[LoanGetDetailsViewController alloc]init];
                [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
                [AppDelegate delegate].userInfo.orderNo = allLoanModel.orderNo;
                vc.loanName = ExaminationLoan;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if(_nowOrderIndex == 3)//审批中的审批中
        {
            ExaminingBody *examLoanModel = [_approvalArry objectAtIndex:index.row];
            if ([examLoanModel.goodsName isEqualToString:@""]) {
                LoanGetDetailsViewController *vc = [[LoanGetDetailsViewController alloc]init];
                if (examLoanModel.applSeq) {
                    [AppDelegate delegate].userInfo.applSeq = examLoanModel.applSeq;
                }
                vc.loanName = ExaminationCash;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                LoanGetDetailsViewController * vc = [[LoanGetDetailsViewController alloc]init];
                if (examLoanModel.applSeq) {
                    [AppDelegate delegate].userInfo.applSeq = examLoanModel.applSeq;
                }
                vc.loanName = ExaminationLoan;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if ([weakLoanView.labelState.text isEqualToString:@"商户退回"]||[weakLoanView.labelState.text isEqualToString:@"审批退回"])//只有全部贷款中有
    {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
        if ([allLoanModel.typGrp isEqualToString:CashCode]) {
            
            LoanGetDetailsViewController *vc = [[LoanGetDetailsViewController alloc]init];
            [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
            vc.loanName = BeReturnCash;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else
        {
            if (![allLoanModel.outSts isEqualToString:@"3"]) {//信贷退回
                LoanGetDetailsViewController *vc = [[LoanGetDetailsViewController alloc]init];
                [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
                vc.loanName = BeReturnLoan;
                vc.formTyp = allLoanModel.formTyp;
                [self.navigationController pushViewController:vc animated:YES];
            }else{//商户退回
                OrderGetDetailsViewController *vc = [[OrderGetDetailsViewController alloc]init];
                [AppDelegate delegate].userInfo.orderNo = allLoanModel.orderNo;
                vc.loanName = BeReturnLoanByMerchant;
                vc.formTyp = allLoanModel.formTyp;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    else if ([weakLoanView.labelState.text isEqualToString:@"还款完成"])//只有全部贷款中有
    {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
        BackOverrViewController *vc = [[BackOverrViewController alloc]init];
        if (allLoanModel.applSeq) {
            [AppDelegate delegate].userInfo.orderNo = allLoanModel.orderNo;
            [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([weakLoanView.labelState.text isEqualToString:@"贷款已取消"])
    {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
        if ([allLoanModel.typGrp isEqualToString:CashCode]) {
            
            LoanGetDetailsViewController *vc = [[LoanGetDetailsViewController alloc]init];
            [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
            vc.loanName = CashHaveCancel;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else
        {
            LoanGetDetailsViewController *vc = [[LoanGetDetailsViewController alloc]init];
            [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
            vc.loanName = LoanHaveCancel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    else if ([weakLoanView.labelState.text isEqualToString:@"放款审核中"])
    {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
        
        LoanGetDetailsViewController *vc = [[LoanGetDetailsViewController alloc]init];
        [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
        vc.loanName = AuditCash;
        vc.haveContract = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([weakLoanView.labelState.text isEqualToString:@"待还款"])
    {
        _stateStr = @"待还款";
        if (0 == _nowOrderIndex)//全部中的待还款
        {
            AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
            [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
            [self creatDetailReqWithRequestTag:10];//未逾期的tag为10
        }else//待还款的待还款
        {
            AllReimbursementBodyItem *rePayLoanModel = [_repaymentArray objectAtIndex:index.row];
            [AppDelegate delegate].userInfo.applSeq = rePayLoanModel.applSeq;
            
            [self creatDetailReqWithRequestTag:10];
        }
    }else if ([weakLoanView.labelState.text isEqualToString:@"待取货"])
    {
        if (0 == _nowOrderIndex)//全部中的待取货
        {
            AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
            
            LoanGetDetailsViewController *vc = [[LoanGetDetailsViewController alloc]init];
            [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
            vc.loanName = WaitPickUp;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(4 == _nowOrderIndex)
        {
            ExaminingBody *examLoanModel = [_deliveryArray objectAtIndex:index.row];
            LoanGetDetailsViewController * vc = [[LoanGetDetailsViewController alloc]init];
            if (examLoanModel.applSeq) {
                [AppDelegate delegate].userInfo.applSeq = examLoanModel.applSeq;
            }
            vc.loanName = WaitPickUp;
            vc.haveContract = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([weakLoanView.labelState.text isEqualToString:@"等待放款"])
    {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
        LoanGetDetailsViewController *vc = [[LoanGetDetailsViewController alloc]init];
        
        [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
                
        vc.loanName = waitCashDischarge;

        [self.navigationController pushViewController:vc  animated:YES];
        
    }else if ([weakLoanView.labelState.text isEqualToString:@"贷款被拒绝"])
    {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
        LoanGetDetailsViewController *vc = [[LoanGetDetailsViewController alloc]init];
        
        [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
        
        vc.loanName = LoanBeRefuse;
        
        [self.navigationController pushViewController:vc  animated:YES];
        
    }
    else if ([weakLoanView.labelState.text isEqualToString:@"审批通过，等待放款"])
    {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
        LoanGetDetailsViewController *vc = [[LoanGetDetailsViewController alloc]init];
        
        [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
        
        vc.loanName = WaitCashHaveExamination;
        vc.haveContract = @"1";
        [self.navigationController pushViewController:vc  animated:YES];
        
    }
    else if ([weakLoanView.labelState.text isEqualToString:@"待提交"])
    {
        if (_nowOrderIndex == 1) {
            
            WaitCommitListOrders *waitModel = [_pendingArray objectAtIndex:index.row];
            
            if ([waitModel.formTyp isEqualToString:@"20"]) {
                _stateStr = @"待提交";
                _fromTyp = @"20";
                _toWare = YES;
                [AppDelegate delegate].userInfo.orderNo = StringOrNull(waitModel.orderNo);
                [self queryGetAppOrderAndGoods];
            }else{
                _fromTyp = nil;
                _toWare = NO;
                OrderGetDetailsViewController *vc = [[OrderGetDetailsViewController alloc]init];
                [AppDelegate delegate].userInfo.orderNo = StringOrNull(waitModel.orderNo);
                if ([waitModel.goodsName isEqualToString:@""]) {
                    vc.loanName = waitSubmitCash;
                }else{
                    vc.loanName = waitSubmitLoan;
                }
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }else{
            
            AllLoanOrders *waitModel = [_allArray objectAtIndex:index.row];
            
            if ([waitModel.formTyp isEqualToString:@"20"]) {
                _stateStr = @"待提交";
                _fromTyp = @"20";
                _toWare = YES;
                [AppDelegate delegate].userInfo.orderNo = StringOrNull(waitModel.orderNo);
                [self queryGetAppOrderAndGoods];
            }else{
                _fromTyp = nil;
                _toWare = NO;
                OrderGetDetailsViewController *vc = [[OrderGetDetailsViewController alloc]init];
                [AppDelegate delegate].userInfo.orderNo = StringOrNull(waitModel.orderNo);
                if ([waitModel.goodsName isEqualToString:@""]) {
                    vc.loanName = waitSubmitCash;
                }else{
                    vc.loanName = waitSubmitLoan;
                }
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
        
    }else if ([weakLoanView.labelState.text isEqualToString:@"已完成"] || [weakLoanView.labelState.text isEqualToString:@"还款中"] || [weakLoanView.labelState.text isEqualToString:@"已付款待发货"] || [weakLoanView.labelState.text isEqualToString:@"已发货"] || [weakLoanView.labelState.text isEqualToString:@"退货中"])
    {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
        [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
        [AppDelegate delegate].userInfo.orderNo = allLoanModel.orderNo;
        _stateStr = weakLoanView.labelState.text;
        if ([allLoanModel.formTyp isEqualToString:@"20"]) {
            _onLine = YES;
        }else{
            _onLine = NO;
        }
        //        查询贷款详情，根据payMtd判断是否为随借随还
        if ([weakLoanView.labelState.text isEqualToString:@"已完成"]) {
            _ifSettled = @"SE";
        }else{
            _ifSettled = @"NS";
        }
        [self creatDetailReqWithRequestTag:10];
    }else if ([weakLoanView.labelState.text isEqualToString:@"取消放款"]){
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];
        LoanGetDetailsViewController *vc = [[LoanGetDetailsViewController alloc]init];
        
        [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
        
        vc.loanName = BeCancelLoan;
        vc.haveContract = @"1";
        [self.navigationController pushViewController:vc  animated:YES];
        
    }else if ([weakLoanView.labelState.text isEqualToString:@"已退货"]){
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:index.row];

        GoodsRejectedViewController *vc = [[GoodsRejectedViewController alloc]init];
        
        vc.haveContract = @"1";
        
        [AppDelegate delegate].userInfo.applSeq = allLoanModel.applSeq;
        
        [self.navigationController pushViewController:vc  animated:YES];

    }
}
#pragma mark - 网络请求

//待提交订单数量
- (void)queryLoanNumber{
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/getAppOrderCountCust" requestArgument:@{@"custNo":StringOrNull([AppDelegate delegate].userInfo.custNum)} completion:^(id results, NSError *error) {
        if (results) {
           
            WaitComNumberModel *waitComNumberModel = [WaitComNumberModel mj_objectWithKeyValues:results];
            
            if ([waitComNumberModel.head.retFlag isEqualToString:SucessCode])
            {
                if (waitComNumberModel.body.orderSize > 0)
                {
                    _pendingView.hidden = NO;
                }else
                {
                    _pendingView.hidden = YES;
                }
            }
        }
    }];
}

// 审批中订单数量
- (void)queryExamination{
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/cmis/queryApplCountPerson" requestArgument:@{@"idNo":StringOrNull([AppDelegate delegate].userInfo.realId)} completion:^(id results, NSError *error) {
        if (results) {

            ExaminationNumberModel *examinationNumberModel = [ExaminationNumberModel mj_objectWithKeyValues:results];
            
            if ([examinationNumberModel.head.retFlag isEqualToString:SucessCode])
            {
                
                if (examinationNumberModel.body.applCount > 0)
                {
                    _approvalView.hidden = NO; //审批中
                }
                
                if (examinationNumberModel.body.repayCount > 0)
                {
                    _repaymentView.hidden = NO;//待还款
                }
                
                if (examinationNumberModel.body.sendCount > 0)
                {
                    _deliveryView.hidden = NO;//待取货
                }
                
            }
        }
    }];
}



//获取全部贷款
- (void)queryAllLoan
{
    NSLog(@"点击了全部");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/getDateAppOrderPerson" requestArgument:@{@"crtUsr":StringOrNull([AppDelegate delegate].userInfo.userId),@"idNo":StringOrNull([AppDelegate delegate].userInfo.realId),@"page":@"1",@"size":@"15"} requestTag:getDateAppOrderPerson requestClass:NSStringFromClass([self class])];
}

//待提交请求
- (void)queryWaitCommit
{
    NSLog(@"点击了待提交");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"15" forKey:@"size"];
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/getWtjAppOrderCust" requestArgument:dic requestTag:getWtjAppOrderCust requestClass:NSStringFromClass([self class])];
}

//待还款
- (void)queryWaitRepayment
{
    NSLog(@"点击了待还款");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:StringOrNull([AppDelegate delegate].userInfo.realId) forKey:@"idNo"];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"15" forKey:@"size"];
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/queryApplAllByIdNo" requestArgument:dic requestTag:queryApplAllByIdNo requestClass:NSStringFromClass([self class])];
}

//审批中
- (void)queryExamining
{
    NSLog(@"点击了审批中");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:StringOrNull([AppDelegate delegate].userInfo.realId) forKey:@"idNo"];
    [dic setObject:@"01" forKey:@"outSts"];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"15" forKey:@"pageSize"];
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    [client getInfo:@"app/appserver/cmis/queryApplListPerson" requestArgument:dic requestTag:queryApplListPersonExamining requestClass:NSStringFromClass([self class])];
}

//待取货
- (void)queryWaitPick
{
    NSLog(@"点击了待取货");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:StringOrNull([AppDelegate delegate].userInfo.realId)forKey:@"idNo"];
    [dic setObject:@"30" forKey:@"outSts"];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"15" forKey:@"pageSize"];
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    [client getInfo:@"app/appserver/cmis/queryApplListPerson" requestArgument:dic requestTag:queryApplListPersonWaitPick requestClass:NSStringFromClass([self class])];
}
//
- (void)queryGetNewData{
    
    [self getLoanNumber];
    
    if (0 == _nowOrderIndex) {
        
        _pageNumber = _pageNumber + 1;
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:[AppDelegate delegate].userInfo.userId forKey:@"crtUsr"];
        
        [dic setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
        
        [dic setObject:[NSString stringWithFormat:@"%d",_pageNumber] forKey:@"page"];
        
        [dic setObject:@"15" forKey:@"size"];
        
        [BSVKHttpClient shareInstance].delegate = self;
        
        [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/getDateAppOrderPerson" requestArgument:dic requestTag:getDateAppOrderPersonNewData requestClass:NSStringFromClass([self class])];
    }
    if (1 == _nowOrderIndex) {
        
        _pageNumber = _pageNumber + 1;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [BSVKHttpClient shareInstance].delegate = self;
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:[AppDelegate delegate].userInfo.userId forKey:@"crtUsr"];
        
        [dic setObject:[NSString stringWithFormat:@"%d",_pageNumber] forKey:@"page"];
        
        [dic setObject:@"15" forKey:@"size"];
        
        [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/getWtjAppOrder" requestArgument:dic requestTag:getWtjAppOrderNewData requestClass:NSStringFromClass([self class])];
        
    }
    if (2 == _nowOrderIndex) {
        _pageNumber = _pageNumber + 1;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [BSVKHttpClient shareInstance].delegate = self;
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
        
        [dic setObject:@"370405198905174616" forKey:@"idNo"];
        
        [dic setObject:[NSString stringWithFormat:@"%d",_pageNumber] forKey:@"page"];
        
        [dic setObject:@"15" forKey:@"size"];
        
        [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/queryApplAllByIdNo" requestArgument:dic requestTag:queryApplAllByIdNoNewData requestClass:NSStringFromClass([self class])];
        
    }
    if (3 == _nowOrderIndex) {
        _pageNumber = _pageNumber + 1;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
        
        [dic setObject:@"01" forKey:@"outSts"];
        
        [dic setObject:@"15" forKey:@"pageSize"];
        
        [dic setObject:[NSString stringWithFormat:@"%d",_pageNumber] forKey:@"page"];
        
        [BSVKHttpClient shareInstance].delegate = self;
        
        [[BSVKHttpClient shareInstance] getInfo:@"app/appserver/cmis/queryApplListPerson" requestArgument:dic requestTag:queryApplListPersonExaminingNewData requestClass:NSStringFromClass([self class])];
        
    }
    if (4 == _nowOrderIndex) {
        _pageNumber = _pageNumber + 1;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
        
        [dic setObject:@"23" forKey:@"outSts"];
        
        [dic setObject:@"15" forKey:@"pageSize"];
        
        [dic setObject:[NSString stringWithFormat:@"%d",_pageNumber] forKey:@"page"];
        
        [BSVKHttpClient shareInstance].delegate = self;
        
        [[BSVKHttpClient shareInstance] getInfo:@"app/appserver/cmis/queryApplListPerson" requestArgument:dic requestTag:queryApplListPersonWaitPickNewData requestClass:NSStringFromClass([self class])];
        
    }
}

//查询订单详情
- (void)queryGetAppOrderAndGoods
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/getAppOrderAndGoods" requestArgument:@{@"orderNo":StringOrNull([AppDelegate delegate].userInfo.orderNo)} requestTag:getAppOrderAndGoods requestClass:NSStringFromClass([self class])];
}

// 查询贷款详情
- (void)queryAppLoanAndGoods
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/queryAppLoanAndGoods" requestArgument:@{@"applSeq":StringOrNull([AppDelegate delegate].userInfo.applSeq)} requestTag:queryAppLoanAndGoods requestClass:NSStringFromClass([self class])];
}

//修改订单信贷退回的订单详情
-(void)queryChangeLoan
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/customer/getReturnOrder" requestArgument:@{@"applSeq":StringOrNull([AppDelegate delegate].userInfo.applSeq),@"source":@"2",@"version":@"2"} requestTag:getReturnOrder requestClass:NSStringFromClass([self class])];
}


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

//逾期的和不逾期的分别用不同的tag值
- (void)creatDetailReqWithRequestTag:(NSInteger)tag
{
    BSVKHttpClient * detailClint = [BSVKHttpClient shareInstance];
    detailClint.delegate = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *applSeq = @"";
    if ([AppDelegate delegate].userInfo.applSeq == nil) {
        applSeq = @"";
    }else{
        applSeq = [AppDelegate delegate].userInfo.applSeq;
    }
    [dict setValue:applSeq forKey:@"applSeq"];
    [detailClint getInfo:@"app/appserver/apporder/queryAppLoanAndGoods" requestArgument:dict requestTag:tag requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//申请放款
-(void)querySubSignCont
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance] getInfo:@"app/appserver/subSignCont" requestArgument:@{@"applSeq":StringOrNull([AppDelegate delegate].userInfo.applSeq)} requestTag:subSignCont requestClass:NSStringFromClass([self class])];
}
#pragma mark - BSVKHttpClientDelegate
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
        
        if (requestTag == getDateAppOrderPerson)//全部贷款
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AllLoanModel *allLoanModel = [AllLoanModel mj_objectWithKeyValues:responseObject];

            [self analyGetDateAppOrderPerson:allLoanModel];
            
        }
        else if (requestTag == getWtjAppOrderCust)//待提交
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            WaitCommitListModel *waitModel =  [WaitCommitListModel mj_objectWithKeyValues:responseObject];
            
            [self analyGetWtjAppOrderCust:waitModel];
            
        }
        else if (requestTag == queryApplAllByIdNo)//待还款
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AllReimbursementModel *waitRepayModel = [AllReimbursementModel mj_objectWithKeyValues:responseObject];
            
            [self analySisQueryApplAllByIdNo:waitRepayModel];
            
        }
        else if (requestTag == queryApplListPersonExamining)//审批中
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ExaminingModel *examModel =  [ExaminingModel mj_objectWithKeyValues:responseObject];
            
            [self analySisQueryApplListPersonExamining:examModel];
            
        }
        else if (requestTag == queryApplListPersonWaitPick)//待取货
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ExaminingModel *examModel =  [ExaminingModel mj_objectWithKeyValues:responseObject];
            
            [self analySisQueryApplListPersonWaitPick:examModel];
        
        }
        else if (requestTag == getDateAppOrderPersonNewData)//上拉全部贷款加载回执
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AllLoanModel *allLoanModel = [AllLoanModel mj_objectWithKeyValues:responseObject];
            
            [self analySisgetDateAppOrderPersonNewData:allLoanModel];
            
        }
        else if (requestTag == getWtjAppOrderNewData)//上拉待提交加载回执
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            WaitCommitListModel *waitModel =  [WaitCommitListModel mj_objectWithKeyValues:responseObject];
            
            [self analySisGetWtjAppOrderNewData:waitModel];
            
        }
        else if (requestTag == queryApplAllByIdNoNewData)//上拉待还款回执
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            AllReimbursementModel *waitRepayModel = [AllReimbursementModel mj_objectWithKeyValues:responseObject];
            
            [self analySisQueryApplAllByIdNoNewData:waitRepayModel];
            
        }
        else if (requestTag == queryApplListPersonExaminingNewData)//上拉审批中 回执
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ExaminingModel *examModel =  [ExaminingModel mj_objectWithKeyValues:responseObject];
            
            [self analySisQueryApplListPersonExaminingNewData:examModel];
            
        }
        else if (requestTag == queryApplListPersonWaitPickNewData)
        {    // 上拉待取货 回执
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ExaminingModel *examModel =  [ExaminingModel mj_objectWithKeyValues:responseObject];
            [self analySisQueryApplListPersonWaitPickNewData:examModel];
            
        }
        else if (requestTag == getAppOrderAndGoods)//订单详情
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            OrdeDetailsModel *ordeDetailsModel = [OrdeDetailsModel mj_objectWithKeyValues:responseObject];
            
            [self analySisGetAppOrderAndGoods:ordeDetailsModel];
            
        }
        else if (requestTag == deleteAppOrder)//取消订单(待提交)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            DeleteModel *deleModel = [DeleteModel mj_objectWithKeyValues:responseObject];
            
            [self analySisDeleteAppOrder:deleModel];
            
        }
        else if (requestTag == queryAppLoanAndGoods)//贷款详情
        {  //查询贷款详情
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            LoanDetailModel *loanDetailsModel = [LoanDetailModel mj_objectWithKeyValues:responseObject];
            
            [self analySisQueryAppLoanAndGoods:loanDetailsModel];
            
        }
        else if (requestTag == getReturnOrder)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           
            OrdeDetailsModel *ordeDetailsModel = [OrdeDetailsModel mj_objectWithKeyValues:responseObject];
            
            [self analySisGetAppOrderAndGoods:ordeDetailsModel];
            
        }
        else if (requestTag == getCustIsPass)
        {
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
        else if (requestTag == 10){//待还款查询贷款详情,未逾期
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            LoanDetailModel *model = [LoanDetailModel mj_objectWithKeyValues:responseObject];
            [self analySisBeBackLoanDetailModel:model];
            
        }else if (requestTag == 11){//已逾期
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            LoanDetailModel *model = [LoanDetailModel mj_objectWithKeyValues:responseObject];
            [self analySisYuQiLoanDetailModel:model];
            
        }else if (requestTag == subSignCont){
            
            SubSignContModel * model = [SubSignContModel mj_objectWithKeyValues:responseObject];
            
            [self analySisSubSignCont:model];
            
        }
    }
}

- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [_LoanTableView.mj_header endRefreshing];
    [_LoanTableView.mj_footer endRefreshing];
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
        if (requestTag == getDateAppOrderPersonNewData || requestTag == getWtjAppOrderNewData || requestTag == queryApplAllByIdNoNewData || requestTag == queryApplListPersonExaminingNewData || requestTag == queryApplListPersonWaitPickNewData)
        {
            _pageNumber -- ;
        }
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

#pragma mark - model解析
- (void)analyGetDateAppOrderPerson:(AllLoanModel *)allLoanModel{

    if ([allLoanModel.head.retFlag isEqualToString:SucessCode])
    {
        if (allLoanModel.body.orders.count > 0)
        {
            if (!_allArray)
            {
                _allArray = [NSMutableArray array];
                
            }else{
                
                [_allArray removeAllObjects];
                
            }
            
            [_LoanTableView.mj_footer resetNoMoreData];
            
            [_allArray addObjectsFromArray:allLoanModel.body.orders];
            
            if(_allArray.count > 0)
            {
                
            }else
            {
                _allView.hidden = YES;
                _bottomOtherView.hidden = NO;
            }
            
            [_LoanTableView reloadData];
            [_LoanTableView.mj_footer resetNoMoreData];
            [_LoanTableView.mj_header endRefreshing];
            
        }else
        {
            _allView.hidden = YES;
            _bottomOtherView.hidden = NO;
        }
    }else
    {
        [self buildHeadError:allLoanModel.head.retMsg];
    }
}
- (void)analyGetWtjAppOrderCust:(WaitCommitListModel *)waitModel{

    if ([waitModel.head.retFlag isEqualToString:SucessCode])
    {
        if (waitModel.body.orders.count > 0)
        {
            if (!_pendingArray)
            {
                _pendingArray = [NSMutableArray array];
            }else {
                [_pendingArray removeAllObjects];
            }
            [_pendingArray addObjectsFromArray:waitModel.body.orders];
            
            if (_pendingArray.count == 0)
            {
                _pendingView.hidden = YES;
                _bottomOtherView.hidden = NO;
            }else
            {
                _pendingView.hidden = NO;
            }
            [_LoanTableView reloadData];
        }
        else
        {
            _pendingView.hidden = YES;
            _bottomOtherView.hidden = NO;
        }
    }else {
        [self buildHeadError:waitModel.head.retMsg];
    }
}
- (void)analySisQueryApplAllByIdNo:(AllReimbursementModel *)waitRepayModel{

    if ([waitRepayModel.head.retFlag isEqualToString:SucessCode])
    {
        if (waitRepayModel.body.orders.count > 0)
        {
            if (!_repaymentArray)
            {
                _repaymentArray = [NSMutableArray array];
            }else{
                [_repaymentArray removeAllObjects];
            }
            [_repaymentArray addObjectsFromArray:waitRepayModel.body.orders];
            
            if (_repaymentArray.count == 0)
            {
                _repaymentView.hidden = YES;
                _bottomOtherView.hidden = NO;
            }else
            {
                _repaymentView.hidden = NO;
            }
            
            [_LoanTableView reloadData];
        }
        else
        {
            _repaymentView.hidden = YES;
            _bottomOtherView.hidden = NO;
        }
    }else
    {
        [self buildHeadError:waitRepayModel.head.retMsg];
    }
}
- (void)analySisQueryApplListPersonExamining:(ExaminingModel *)examModel{

    if ([examModel.head.retFlag isEqualToString:SucessCode])
    {
        if (examModel.body.count > 0)
        {
            if (!_approvalArry) {
                _approvalArry = [NSMutableArray array];
            }else {
                [_approvalArry removeAllObjects];
            }
            [_approvalArry addObjectsFromArray:examModel.body];
            
            if (_approvalArry.count == 0)
            {
                _approvalView.hidden = YES;
                _bottomOtherView.hidden = NO;
            }else
            {
                _approvalView.hidden = NO;
            }
            
            [_LoanTableView.mj_footer resetNoMoreData];
            
            [_LoanTableView reloadData];
        }
        else
        {
            _approvalView.hidden = YES;
            _bottomOtherView.hidden = NO;
        }
    }else
    {
        [self buildHeadError:examModel.head.retMsg];
    }
}
- (void)analySisQueryApplListPersonWaitPick:(ExaminingModel *)examModel{

    if ([examModel.head.retFlag isEqualToString:@"00000"])
    {
        if (examModel.body.count > 0)
        {
            if (!_deliveryArray)
            {
                _deliveryArray = [NSMutableArray array];
            }else {
                [_deliveryArray removeAllObjects];
            }
            [_deliveryArray addObjectsFromArray:examModel.body];
            
            if (_deliveryArray.count == 0)
            {
                _deliveryView.hidden = YES;
                _bottomOtherView.hidden = NO;
            }else
            {
                _deliveryView.hidden = NO;
            }
            
            [_LoanTableView reloadData];
        }else
        {
            _deliveryView.hidden = YES;
            _bottomOtherView.hidden = NO;
        }
    }else {
        [self buildHeadError:examModel.head.retMsg];
    }
}
- (void)analySisgetDateAppOrderPersonNewData:(AllLoanModel *)allLoanModel{

    if ([allLoanModel.head.retFlag isEqualToString:SucessCode])
    {
        if (allLoanModel.body.orders.count > 0)
        {
            [_allArray addObjectsFromArray:allLoanModel.body.orders];
            
            [_LoanTableView reloadData];
            
            [_LoanTableView.mj_footer endRefreshing];
        }else
        {
            _pageNumber --;
            [_LoanTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else
    {
        _pageNumber--;
        [_LoanTableView.mj_footer endRefreshing];
        [self buildHeadError:allLoanModel.head.retMsg];
    }
}
- (void)analySisGetWtjAppOrderNewData:(WaitCommitListModel *)waitModel{

    if ([waitModel.head.retFlag isEqualToString:@"00000"])
    {
        if (waitModel.body.orders.count > 0)
        {
            [_pendingArray addObjectsFromArray:waitModel.body.orders];
            
            [_LoanTableView reloadData];
            
            [_LoanTableView.mj_footer endRefreshing];
        }else
        {
            _pageNumber --;
            
            [_LoanTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else
    {
        _pageNumber -- ;
        [_LoanTableView.mj_footer endRefreshing];
        [self buildHeadError:waitModel.head.retMsg];
    }
}
- (void)analySisQueryApplAllByIdNoNewData:(AllReimbursementModel *)waitRepayModel{

    if ([waitRepayModel.head.retFlag isEqualToString:SucessCode])
    {
        if (waitRepayModel.body.orders.count > 0)
        {
            [_repaymentArray addObjectsFromArray:waitRepayModel.body.orders];
            [_LoanTableView reloadData];
            [_LoanTableView.mj_footer endRefreshing];
        }else{
            _pageNumber -- ;
            
            [_LoanTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else
    {
        _pageNumber -- ;
        [_LoanTableView.mj_footer endRefreshing];
        [self buildHeadError:waitRepayModel.head.retMsg];
    }
}
- (void)analySisQueryApplListPersonExaminingNewData:(ExaminingModel *)examModel{

    if ([examModel.head.retFlag isEqualToString:SucessCode])
    {
        if (examModel.body.count > 0)
        {
            
            [_approvalArry addObjectsFromArray:examModel.body];
            
            [_LoanTableView reloadData];
            
            [_LoanTableView.mj_footer endRefreshing];
        }else
        {
            _pageNumber -- ;
            
            [_LoanTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
    }else
    {
        _pageNumber -- ;
        [_LoanTableView.mj_footer endRefreshing];
        [self buildHeadError:examModel.head.retMsg];
    }
}
- (void)analySisQueryApplListPersonWaitPickNewData:(ExaminingModel *)examModel{

    if ([examModel.head.retFlag isEqualToString:SucessCode])
    {
        if (examModel.body.count > 0) {
            
            [_deliveryArray addObjectsFromArray:examModel.body];
            
            [_LoanTableView reloadData];
            
            [_LoanTableView.mj_footer endRefreshing];
        }else
        {
            _pageNumber -- ;
            
            [_LoanTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        
    }else
    {
        _pageNumber -- ;
        [_LoanTableView.mj_footer endRefreshing];
        [self buildHeadError:examModel.head.retMsg];
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

//解析订单详情model
- (void)analySisGetAppOrderAndGoods:(OrdeDetailsModel *)orderDetailsModel{
    
    if ([orderDetailsModel.head.retFlag isEqualToString:SucessCode])
    {
        [AppDelegate delegate].userInfo.orderNo = orderDetailsModel.body.orderNo;
        
        if ([_stateStr isEqualToString:@"待提交"] || [_stateStr isEqualToString:@"商户退回商品贷"] || [_stateStr isEqualToString:@"信贷退回商品贷"] || [_stateStr isEqualToString:@"再次申请"])
        {
            if ([orderDetailsModel.body.typGrp isEqualToString:CashCode])
            {
                //跳转到现金贷
//                StageViewController * vc = [[StageViewController alloc]init];
//                
//                vc.orderDetailsBody = orderDetailsModel.body;
//                vc.flowName = WaitSubmitCashLoan;
//                //待提交保存流水号
//                [AppDelegate delegate].userInfo.applSeq = orderDetailsModel.body.applseq;
//                
//                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [AppDelegate delegate].userInfo.applSeq = orderDetailsModel.body.applseq;
                
                NSString * packAgeStr;//套餐名
                
                if([orderDetailsModel.body.goods[0].goodsName rangeOfString:@"goodname"].location != NSNotFound)
                {
                    NSRange range  = [orderDetailsModel.body.goods[0].goodsName rangeOfString:@"goodname"];
                    
                    packAgeStr = [orderDetailsModel.body.goods[0].goodsName substringToIndex:range.location];  //套餐
                }
                else
                {
                    packAgeStr = @"";
                }
                
//                if ([_fromTyp isEqualToString:@"20"]) {
                    //线上
//                    if (_toWare) {
//                        _toWare = NO;
//                        WareDetailViewController *vc = [[WareDetailViewController alloc]init];
//                        
//                        if ([_stateStr isEqualToString:@"再次申请"]) {
//                            vc.flowName = advertStage;
//                        }else{
//                            vc.flowName = WaitAdvertStage;
//                            vc.detailModel = orderDetailsModel;
//                        }
//                        vc.salerCode = orderDetailsModel.body.crtUsr;
//                        
//                        vc.goodsCode = orderDetailsModel.body.goods[0].goodsCode;
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }else{
//                        GoodsStageDetailViewController *goods = [[GoodsStageDetailViewController alloc]init];
//                        
//                        if([_stateStr isEqualToString:@"信贷退回商品贷"]){
//                            goods.flowName = BeReturnAdvertStage;
//                        }else if ([_stateStr isEqualToString:@"商户退回商品贷"]){
//                            
//                            goods.flowName = AdvertReturnByMerchant;
//                        }else
//                        {
//                            //商户退回和待提交是一样的
//                            goods.flowName = WaitAdvertStage;
//                        }
//                        
//                        goods.merchantCode = orderDetailsModel.body.merchNo;
//                        
//                        goods.strManagerID = orderDetailsModel.body.crtUsr;
//                        
//                        goods.ordeDetailsBody = orderDetailsModel;
//                        
//                        [self.navigationController pushViewController:goods animated:YES];
//                    }
//                }else{
//                
//                    StageApplicationViewController *goods = [[StageApplicationViewController alloc]init];
//                    
//                    if([_stateStr isEqualToString:@"信贷退回商品贷"]){
//                        goods.flowName = BeReTurnStage;
//                    }else if ([_stateStr isEqualToString:@"商户退回商品贷"]){
//                        goods.flowName = BeReturnByMerchant;
//                    }else
//                    {
//                        goods.flowName = WaitSubmitStage;
//                        if ([_stateStr isEqualToString:@"再次申请"]) {
//                            goods.noUpdateOrder = YES;
//                        }
//                    }
//                    if (packAgeStr.length > 0)
//                    {
//                        goods.scantype = goodHasMenuEnter;
//                    }else
//                    {
//                        goods.scantype = goodNoMenuEnter;
//                        
//                    }
//                    goods.merchantCode = orderDetailsModel.body.merchNo;
//                    
//                    goods.strManagerID = orderDetailsModel.body.crtUsr;
//                    
//                    goods.ordeDetailsBody = orderDetailsModel;
//                    
//                    [self.navigationController pushViewController:goods animated:YES];
//                }
            }
        }else if ([_stateStr isEqualToString:@"等待放款"])
        {
            [self toPayNoBank]; //跳转确认支付
        }
    }
    else
    {
        [self buildHeadError:orderDetailsModel.head.retMsg];
    }
    
}
- (void)analySisDeleteAppOrder:(DeleteModel *)deleModel{

    if ([deleModel.head.retFlag isEqualToString:SucessCode])
    {
        
        _LoanTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [_LoanTableView.mj_header beginRefreshing];
        
    }else
    {
        [self buildHeadError:deleModel.head.retMsg];
    }
}
- (void)analySisQueryAppLoanAndGoods:(LoanDetailModel *)loanDetailsModel{

    if ([loanDetailsModel.head.retFlag isEqualToString:SucessCode])
    {
        [AppDelegate delegate].userInfo.applSeq = StringOrNull(loanDetailsModel.body.applSeq);
//        [AppDelegate delegate].userInfo.expectCredit = loanDetailsModel.body.expectCredit;
        if ([_stateStr isEqualToString:@"被退回"])
        {
            
            if ([loanDetailsModel.body.typGrp isEqualToString:CashCode])
            {
                //跳转到现金贷
//                StageViewController * vc = [[StageViewController alloc]init];
//                
//                vc.loanDetailBody = loanDetailsModel.body;
//                
//                vc.flowName = beReturnCashLoan;
//                
//                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if ([_stateStr isEqualToString:@"等待放款"]){
            
            if ([loanDetailsModel.body.applyAmt isEqualToString:loanDetailsModel.body.apprvAmt])
            {
                [self querySubSignCont];
            }else{
                _stateStr = @"等待放款";
                
                [self queryChangeLoan];
            }
        }
        else if ([_stateStr isEqualToString:@"待取货"]){
            PickUpCodeViewController *vc = [[PickUpCodeViewController alloc]init];
            vc.codeStr = loanDetailsModel.body.applCde;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else
    {
        [self buildHeadError:loanDetailsModel.head.retMsg];
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
- (void)analySisBeBackLoanDetailModel:(LoanDetailModel *)model{

    if ([model.head.retFlag isEqualToString:@"00000"]) {
        if ([_ifSettled isEqualToString:@"SE"]) {
            
            LoanDetailsViewController *loanDetail = [[LoanDetailsViewController alloc]init];
            loanDetail.loanNo = model.body.loanNo;//借据号
            loanDetail.ifSettled = _ifSettled;
            loanDetail.haveContract = @"1";
            loanDetail.stateStr = _stateStr;
            loanDetail.onLine = _onLine;
            loanDetail.applseq = [AppDelegate delegate].userInfo.applSeq;//流水号
            [self.navigationController pushViewController:loanDetail animated:YES];
            
        }else{
            
            if ([model.body.payMtd isEqualToString:@"09"]) {//09 随借随还
                //跳转随借随还
                AnyTimeBackController *anyTime = [[AnyTimeBackController alloc]init];
                anyTime.loanNoStr = model.body.loanNo;//借据号
                anyTime.haveContract = @"1";
                anyTime.applSeq = model.body.applSeq;
                [self.navigationController pushViewController:anyTime animated:YES];
            }else if (![model.body.payMtd isEqualToString:@"09"]){//如果不是随借随借随还，就进入带账单的贷款详情
                LoanDetailsViewController *loanDetail = [[LoanDetailsViewController alloc]init];
                loanDetail.loanNo = model.body.loanNo;//借据号
                loanDetail.ifSettled = _ifSettled;
                loanDetail.haveContract = @"1";
                loanDetail.stateStr = _stateStr;
                loanDetail.onLine = _onLine;
                loanDetail.applseq = [AppDelegate delegate].userInfo.applSeq;//流水号
                [self.navigationController pushViewController:loanDetail animated:YES];
            }
        }
    }else{
        
        [self buildHeadError:model.head.retMsg];//将错误抛出
        
    }
}
- (void)analySisYuQiLoanDetailModel:(LoanDetailModel *)model{

    if ([model.head.retFlag isEqualToString:@"00000"]) {
        if ([model.body.payMtd isEqualToString:@"09"]) {//09 随借随还
            //                    跳转随借随还
            YuQiViewController *yuQi = [[YuQiViewController alloc]init];
            yuQi.haveContract = @"1";
            [self.navigationController pushViewController:yuQi animated:YES];
            
        }else if (![model.body.payMtd isEqualToString:@"09"]){//如果不是随借随还，就进入带账单的贷款详情
            LoanDetailsViewController *loanDetail = [[LoanDetailsViewController alloc]init];
//            loanDetail.haveContract = @"1";
//            loanDetail.stateStr = _stateStr;
//            loanDetail.onLine = _onLine;
//            loanDetail.applseq = [AppDelegate delegate].userInfo.applSeq;//流水号
            [self.navigationController pushViewController:loanDetail animated:YES];
        }
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
}
- (void)analySisSubSignCont:(SubSignContModel *)model{

    if ([model.head.retFlag isEqualToString:SucessCode]) {
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"申请放款成功" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                    
                }
            }
        }];
        
    }else{
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                    
                }
            }
        }];
    }
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == _nowOrderIndex)
    {
        //全部
        return _allArray.count;
    }else if (1 == _nowOrderIndex)
    {
        //待提交
        return _pendingArray.count;
    }else if (2 == _nowOrderIndex)
    {
        //待还款
        return _repaymentArray.count;
    }else if (3 == _nowOrderIndex)
    {
        //审批中
        return _approvalArry.count;
    }else if (4 == _nowOrderIndex)
    {
        //待取货
        return _deliveryArray.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iphone6 || iphone6P)
    {
        return 215;
    }else
    {
        return 175;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        LoanTopView *loanViews = [[LoanTopView alloc]init];
        loanViews.frame = CGRectMake(0, 0, DeviceWidth, 116.5);
        loanViews.tag = 50;
        [cell.contentView addSubview:loanViews];
        
        LoanBottomView *BottomView = [[LoanBottomView alloc]init];
        BottomView.tag = 51;
        BottomView.frame = CGRectMake(0,  116.5, DeviceWidth, 80);
        [cell.contentView addSubview:BottomView];
    }
    
    LoanTopView *loanView = (LoanTopView *)[cell.contentView viewWithTag:50];
    LoanBottomView *bottomView = (LoanBottomView *)[cell.contentView viewWithTag:51];
    NSString *moneyLabel = @"";
    
    bottomView.bottomLabel.hidden =NO;
    bottomView.lineView.hidden = NO;
    bottomView.bottomView.hidden = NO;
    
    loanView.labelTime.hidden = NO;
    loanView.labelState.hidden = NO;
    loanView.viewIcon.hidden = NO;
    loanView.labelTopContent.hidden = NO;
    loanView.labelBottomContent.hidden = NO;
    loanView.viewArrow.hidden = NO;
    loanView.viewArrow.image = [UIImage imageNamed:@"箭头_右_灰"];
    //    model中无图片url，
    [loanView.viewIcon yy_setImageWithURL:[NSURL URLWithString:@""] placeholder:[UIImage imageNamed:@"贷款列表默认图片"] options:YYWebImageOptionProgressiveBlur completion:nil];
    bottomView.rightBottomButton.hidden = YES;
    bottomView.leftBottomButton.hidden = YES;
    bottomView.centerBottomButton.hidden = YES;
    [bottomView.rightBottomButton setTitle:@"" forState:UIControlStateNormal];
    [bottomView.leftBottomButton setTitle:@"" forState:UIControlStateNormal];
    [bottomView.centerBottomButton setTitle:@"" forState:UIControlStateNormal];
    
    
    [self removeBtnWithBottomView:bottomView]; // 移除按钮防重合
    
    if (0 == _nowOrderIndex)
    {
        AllLoanOrders *allLoanModel = [_allArray objectAtIndex:indexPath.row];
        //给view赋值
        moneyLabel = [self setLoanView:loanView WithObject:allLoanModel withFormTyp:allLoanModel.formTyp];
        loanView.formTyp = allLoanModel.formTyp;
    }
    else if (1 == _nowOrderIndex)
    {
        WaitCommitListOrders *waitModel = [_pendingArray objectAtIndex:indexPath.row];
        //给View赋值
        moneyLabel = [self setLoanView:loanView WithObject:waitModel withFormTyp:waitModel.formTyp];
        loanView.formTyp = waitModel.formTyp;
    }else if (2 == _nowOrderIndex)
    {
        AllReimbursementBodyItem *waitRePayModel = [_repaymentArray objectAtIndex:indexPath.row];
        //给View赋值
        moneyLabel = [self setLoanView:loanView WithObject:waitRePayModel withFormTyp:waitRePayModel.formTyp];
        loanView.formTyp = waitRePayModel.formTyp;
    }else if (3 == _nowOrderIndex)
    {
        ExaminingBody *examingModel = [_approvalArry objectAtIndex:indexPath.row];
        
        //给View赋值
        moneyLabel = [self setLoanView:loanView WithObject:examingModel withFormTyp:examingModel.formTyp];
        loanView.formTyp = examingModel.formTyp;
    }else if (4 == _nowOrderIndex)
    {
        ExaminingBody *examingModel = [_deliveryArray objectAtIndex:indexPath.row];
        
        //给View赋值
        moneyLabel = [self setLoanView:loanView WithObject:examingModel withFormTyp:examingModel.formTyp];
        loanView.formTyp = examingModel.formTyp;
    }
    
    //分段改变字体颜色
    NSMutableAttributedString *moneyString = [[NSMutableAttributedString alloc]initWithString:moneyLabel];
    NSRange frontRange = [moneyLabel rangeOfString:@":"];
    NSRange backRange = [moneyLabel rangeOfString:@"元"];
    NSInteger length = backRange.location - frontRange.location;
    [moneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(frontRange.location, length)];
    [moneyString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x018de7, 1)range:NSMakeRange(frontRange.location, length)];
    bottomView.bottomLabel.attributedText = moneyString;
    
    //为BottomView上的按钮添加点击事件
    [self addTagartForLoanBottomView:bottomView WithLoanState:loanView.labelState.text WithFormTyp:loanView.formTyp];
    
    //为view添加手势,点击跳转详情
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellBgbtnClick:)];
    [[loanView returnBgView] addGestureRecognizer:tap];
    tap = nil;
    
    return cell;
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
