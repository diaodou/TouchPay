//
//  HCMessageCenterViewController.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMessageCenterViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import <MBProgressHUD.h>
#import "BSVKHttpClient.h"
#import "AppDelegate.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "RMUniversalAlert.h"
#import "HCMessageCenterTableViewCell.h"

#import "HCMessageCenterModel.h"

#import "LoanGetDetailsViewController.h"
#import "QuoteStateViewController.h"
#import "ApprovalProgressViewController.h"
#import "PayHistoryViewController.h"
#import "YuQiViewController.h"
#import "HCWeekRepayController.h"
#import "HCAllRepayController.h"
static CGFloat const getMessageList = 1;
static CGFloat const getMoreMessageList = 2;
@interface HCMessageCenterViewController ()<BSVKHttpClientDelegate,UITableViewDelegate,UITableViewDataSource>{

    NSInteger _nowPage;

}
@property (nonatomic, strong)UITableView *messageTableView;
@property (nonatomic, strong)HCMessageCenterModel *messageCenterModel;
@property(nonatomic, strong) NSMutableArray *messageArray;  //数据数组

@end

@implementation HCMessageCenterViewController
#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.view.backgroundColor = [UIColor whiteColor];
    _messageArray = [NSMutableArray array];
    [self setTableView];
    [self setNavi];
    
    self.messageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(queryMsgList)];
    self.messageTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self queryMsgList];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark - private Methods

- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.backBarButtonItem.enabled = NO;
    [self.navigationItem setHidesBackButton:YES];
}

- (void)OnBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTableView{

    self.messageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.showsVerticalScrollIndicator = NO;
    self.messageTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.messageTableView];
}
- (void)toAuditController:(MessageCenterBody *)info{
    
    [AppDelegate delegate].userInfo.applSeq =StringOrNull(info.applSeq);
    
    if ([info.msgTyp isEqualToString:@"39"]) {
        
        if ([info.typGrp isEqualToString:CashCode]) {
            
            LoanGetDetailsViewController * vc = [[LoanGetDetailsViewController alloc]init];
            
            vc.msgId = info.ID;
            
            vc.loanName = MsgExaminationCash;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            LoanGetDetailsViewController * vc = [[LoanGetDetailsViewController alloc]init];
            
            vc.loanName = MsgExaminationLoan;
            
            vc.msgId = info.ID;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }else if ([info.msgTyp isEqualToString:@"40"]){
        //被退回
        if ([info.typGrp isEqualToString:CashCode]) {//现金贷
            LoanGetDetailsViewController * vc = [[LoanGetDetailsViewController alloc]init];
            vc.loanName = BeReturnCash;
            vc.msgId = info.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            LoanGetDetailsViewController * vc = [[LoanGetDetailsViewController alloc]init];
            vc.loanName = BeReturnLoan;
            vc.msgId = info.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([info.msgTyp isEqualToString:@"41"] || [info.msgTyp isEqualToString:@"42"] || [info.msgTyp isEqualToString:@"43"]){
        
        QuoteStateViewController *vc = [[QuoteStateViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([info.msgTyp isEqualToString:@"44"]){
        
    }else if ([info.msgTyp isEqualToString:@"45"] || [info.msgTyp isEqualToString:@"54"]){
        
        ApprovalProgressViewController * vc = [[ApprovalProgressViewController alloc]init];
        
//        vc.msgId = info.ID;
//        
//        vc.flowName = fromMsg;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([info.msgTyp isEqualToString:@"46"]){
        
    }else if ([info.msgTyp isEqualToString:@"47"]){
        
        if ([info.typGrp isEqualToString:CashCode]) {
            
            LoanGetDetailsViewController * vc = [[LoanGetDetailsViewController alloc]init];
            
            vc.msgId = info.ID;
            
            vc.loanName = waitCashDischarge;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            LoanGetDetailsViewController * vc = [[LoanGetDetailsViewController alloc]init];
            
            vc.loanName = waitCashDischarge;
            
            vc.msgId = info.ID;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }else if ([info.msgTyp isEqualToString:@"48"]){
        
        if ([info.typGrp isEqualToString:CashCode]) {
            
            LoanGetDetailsViewController * vc = [[LoanGetDetailsViewController alloc]init];
            
            vc.msgId = info.ID;
            
            vc.loanName = MsgExaminationCash;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            LoanGetDetailsViewController * vc = [[LoanGetDetailsViewController alloc]init];
            
            vc.loanName = MsgExaminationLoan;
            
            vc.msgId = info.ID;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }else if ([info.msgTyp isEqualToString:@"49"]){
        
        PayHistoryViewController *vc = [[PayHistoryViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([info.msgTyp isEqualToString:@"50"]){
        
        [AppDelegate delegate].userInfo.applSeq = info.applSeq;
        
        YuQiViewController * vc = [[YuQiViewController alloc]init];
        
        vc.msgId = info.ID;
        
//        vc.flowName = fromMsg;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([info.msgTyp isEqualToString:@"51"]){
        
    }else if ([info.msgTyp isEqualToString:@"52"]){
        
        ApprovalProgressViewController * vc = [[ApprovalProgressViewController alloc]init];
        
//        vc.msgId = info.ID;
//        
//        vc.stateStr = @"审批中";
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([info.msgTyp isEqualToString:@"53"]){
        
        HCWeekRepayController *vc = [[HCWeekRepayController alloc]init];
        
//        vc.msgId = info.ID;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([info.msgTyp isEqualToString:@"55"]){
        
        HCAllRepayController *vc = [[HCAllRepayController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
#pragma mark - query Methods
- (void)queryMsgList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _nowPage = 1;
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/customer/getMessageList" requestArgument:@{@"userId":StringOrNull([AppDelegate delegate].userInfo.userId),@"page":@"1",@"pageNum":@"10",@"source":@"2"} requestTag:getMessageList requestClass:NSStringFromClass([self class])];
}
- (void)loadMoreData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _nowPage += 1;
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/customer/getMessageList" requestArgument:@{@"userId":StringOrNull([AppDelegate delegate].userInfo.userId),@"page":[NSString stringWithFormat:@"%d",(int)_nowPage],@"pageNum":@"10",@"source":@"2"} requestTag:getMoreMessageList requestClass:NSStringFromClass([self class])];
}
#pragma maek - request Delegate
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className {
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (requestTag == getMessageList) {
            [self.messageTableView.mj_header endRefreshing];
            _messageCenterModel = [HCMessageCenterModel mj_objectWithKeyValues:responseObject];
            [self analySisMessageCenterModel];
        }else if (requestTag == getMoreMessageList){
            [self.messageTableView.mj_footer endRefreshing];
            HCMessageCenterModel *model = [HCMessageCenterModel mj_objectWithKeyValues:responseObject];
            [self analySisgetMoreMessageList:model];
        }
    }
}
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className {
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.messageTableView.mj_header endRefreshing];
        [self.messageTableView.mj_footer endRefreshing];
        NSString *errorStr;
        if(httpCode != 0)
        {
            errorStr = [NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode];
        }
        else
        {
            errorStr = @"网络环境异常，请检查网络并重试";
        }
        [self buildHeadError:errorStr];
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
#pragma mark - Model 解析
- (void)analySisMessageCenterModel{
    if ([_messageCenterModel.head.retFlag isEqualToString:SucessCode]) {
        if (_messageCenterModel.body.count != 0) {
            [_messageArray removeAllObjects];
            [_messageArray addObjectsFromArray:_messageCenterModel.body];
            [self.messageTableView reloadData];
            [self.messageTableView.mj_footer resetNoMoreData];
        }else {
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"没有查询到数据" cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }else {
        [self buildHeadError:_messageCenterModel.head.retMsg];
    }
}
- (void)analySisgetMoreMessageList:(HCMessageCenterModel *)model{
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        if (model.body.count != 0) {
            [_messageArray addObjectsFromArray:model.body];
            
            [self.messageTableView reloadData];
        }else {
            [self.messageTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else {
        [self buildHeadError:model.head.retMsg];
    }
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messageArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iphone6P) {
        return 64;
    }else{
        return 58;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCMessageCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[HCMessageCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    MessageCenterBody *info = _messageArray[indexPath.row];
    cell.titleLabel.text = info.pullDate;
    cell.timeLabel.text = @"";
    cell.contentLabel.text = info.message;
    MessageCenterBody * body = _messageArray[indexPath.row];
    
    if ([body.flag isEqualToString:@"N"]) {
        
        cell.circularView.hidden = NO;
        
    }else{
        
        cell.circularView.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCenterBody *info = [_messageArray objectAtIndex:indexPath.row];
    [self toAuditController:info];
    
}
@end
