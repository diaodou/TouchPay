//
//  HCMySelfController.m
//  newHaierCash
//
//  Created by Will on 2017/5/27.
//  Copyright © 2017年 haier. All rights reserved.
//
#import "HCMySelfController.h"

#import "HCMacro.h"
#import "NSString+CheckConvert.h"
#import <MJRefresh.h>
#import "UIFont+AppFont.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import "EnterAES.h"
#import <YYWebImage.h>
#import <MBProgressHUD.h>
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import "HCMyIntegralViewController.h"
#import "HCMyCouponViewController.h"
#import "HCHeadImageTableViewCell.h"
#import "HCRepaymentTableViewCell.h"
#import "HCListTableViewCell.h"
#import "HelpViewController.h"
#import "HCMonthRepayController.h"
#import "HCWeekRepayController.h"
#import "HCAllRepayController.h"
#import "HCCashLoanViewController.h"
#import "PayHistoryViewController.h"
#import "SettingTableViewController.h"
#import "PersonalDataViewController.h"
#import "AllloanViewController.h"
#import "LoginViewController.h"
#import "OrderCodeViewController.h"
#import "AnytimePayViewController.h"
#import "QueryNumberModel.h"
static CGFloat const queryPerCustInfo = 1;
@interface HCMySelfController ()<UITableViewDelegate,UITableViewDataSource,SendRepayPlaceDelegate,BSVKHttpClientDelegate>{

    float x;
}

@property (nonatomic,strong)UITableView * mySelfTableView;    //整体tableView
@property (nonatomic,strong)NSArray *listArray;               //显示界面array
@property (nonatomic,strong)UIImageView *headerImage;
@end

@implementation HCMySelfController
#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    self.navigationItem.title = @"个人中心";
    x = DeviceWidth/375;
    [self buildArray];
    [self buildTableView];
    [self setSettingBtn];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x333333, 1.0),NSFontAttributeName:[UIFont appFontRegularOfSize:19]}];
    [self queryHeadImage];
    if ([AppDelegate delegate].userInfo.bLoginOK && [AppDelegate delegate].userInfo.myRealNameState != realNameYes) {
        [self queryMyRealName];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
#pragma mark - private Methods
- (void)buildArray{

    _listArray = [[NSArray alloc]initWithObjects:@"我的账单",@"",@"增信提额",@"还款记录",@"",@"我的积分",@"我的优惠券",@"",@"帮助中心",nil];
    
}
- (void)buildTableView{

    self.mySelfTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, .5, DeviceWidth, DeviceHeight - 50 - 64) style:UITableViewStylePlain];
    self.mySelfTableView.delegate = self;
    self.mySelfTableView.dataSource = self;
    self.mySelfTableView.showsVerticalScrollIndicator = NO;
    //设置分割线样式
    self.mySelfTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mySelfTableView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    self.mySelfTableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    [self.view addSubview:self.mySelfTableView];
}
- (void)setSettingBtn{

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, 21, 21);
    
    [rightBtn setImage:[UIImage imageNamed:@"右上角设置"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(toSettingViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
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
#pragma mark - custom Methods
- (void)toSevenDayRepayment{
    NSLog(@"近七日待还");
    HCWeekRepayController *weekCon = [HCWeekRepayController new];
    weekCon.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:weekCon animated:YES];
}
- (void)toMonthRepayment{
    NSLog(@"本月待还");
    HCMonthRepayController *monthCon = [HCMonthRepayController new];
    monthCon.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:monthCon animated:YES];
}
- (void)toAllRepayment{
    NSLog(@"全部待还");
    HCAllRepayController *allRepayCon = [HCAllRepayController new];
    allRepayCon.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allRepayCon animated:YES];
}
- (void)loadNewData{
    [self.mySelfTableView reloadData];
    [self.mySelfTableView.mj_header endRefreshing];
}
- (void)toSettingViewController{

    SettingTableViewController *setVC = [[SettingTableViewController alloc]init];
    
    setVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:setVC animated:YES];
}
- (void)toLogin{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    HCRootNavController *nav = [[HCRootNavController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated: YES completion:nil];
}
#pragma mark - network Request
- (void)queryHeadImage{
    //       通过URL给头像赋值
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc]init];
    }
    NSString *imageBaseUrl =[NSString stringWithFormat:@"%@app/uauth/getUserPic",baseUrl];
    NSURL *strUrl =  [NSURL URLWithString:[NSString stringWithFormat:@"%@?userId=%@",imageBaseUrl,[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId]]];
    if ([AppDelegate delegate].userInfo.userHeader && [AppDelegate delegate].userInfo.bLoginOK) {
        UIImage *imageHead = (UIImage *)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@app/uauth/getUserPic?userId=%@",baseUrl,[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId]]];
        if (imageHead) {
            _headerImage.image = imageHead;
            [self.mySelfTableView reloadData];
        }else {
            WEAKSELF
            [_headerImage yy_setImageWithURL:strUrl placeholder:[UIImage imageNamed:@"默认个人头像"] options:YYWebImageOptionRefreshImageCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                STRONGSELF
                [[AppDelegate delegate].imagePutCache setObject:image forKey:url.absoluteString];
                
                NSLog(@"aaa ==%@",[[AppDelegate delegate].imagePutCache objectForKey:url.absoluteString]);
                if (image) {
                    strongSelf.headerImage.image = image;
                    [strongSelf.mySelfTableView reloadData];
                }else{
                    strongSelf.headerImage.image = [UIImage imageNamed:@"默认个人头像"];
                    [strongSelf.mySelfTableView reloadData];
                }
            }];
        }
        
    }else{
        _headerImage.image = [UIImage imageNamed:@"默认个人头像"];
    }
}
- (void)queryMyRealName{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary * userDic = [[NSMutableDictionary alloc]init];
    
    [userDic setObject:StringOrNull([AppDelegate delegate].userInfo.userId) forKey:@"userId"];
    
    BSVKHttpClient * userClient = [BSVKHttpClient shareInstance];
    
    userClient.delegate = self;
    
    [userClient getInfo:@"app/appserver/crm/cust/queryPerCustInfo" requestArgument:userDic requestTag:queryPerCustInfo requestClass:NSStringFromClass([self class])];
    
}
#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 13;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        if (iphone6P) {
            
            return 97;
        }else{
        
            return 65 *x;
        }
    }else if (indexPath.row == 2){
        
        if (iphone6P) {
            
            return 110;
        }else{
            
            return 90 *x;
        }
    }else if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 11){
        
        if (iphone6P) {
            
            return 10;
        }else{
            
            return 8 *x;
        }
    }else{
        
        if (iphone6P) {
            
            return 50;
        }else{
            
            return 44 *x;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        HCHeadImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"headImage"];
        if (cell == nil) {
            cell = [[HCHeadImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headImage"];
        }
        if ([AppDelegate delegate].userInfo.bLoginOK) {
            
            cell.headImageView.image = _headerImage.image;
            
            cell.nameLabel.text = [AppDelegate delegate].userInfo.realName;
            
            cell.numberLabel.text = [[AppDelegate delegate].userInfo.userTel convertToTelNum];

            cell.nameLabel.hidden = NO;
            
            cell.numberLabel.hidden = NO;
            
            cell.loginLabel.hidden = YES;
        }else{
        
            cell.headImageView.image = [UIImage imageNamed:@"默认个人头像"];
            
            cell.nameLabel.hidden = YES;
            
            cell.numberLabel.hidden = YES;
            
            cell.loginLabel.hidden = NO;
            
        }
        
        
        return cell;
    }else if (indexPath.row == 2){
    
        HCRepaymentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"repayMoney"];
        if (cell == nil) {
            cell = [[HCRepaymentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"repayMoney"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nearlySevenDay.text = [NSString stringWithFormat:@"¥1000.00"];
        cell.thisMonth.text = [NSString stringWithFormat:@"¥1000.00"];
        cell.fullLoan.text = [NSString stringWithFormat:@"¥1000.00"];
        return cell;
    }else if (indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 12){
        HCListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
        if (cell == nil) {
            cell = [[HCListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"list"];
        }
        
        if (indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 9) {
            cell.lineView.hidden = NO;
        }else{
            cell.lineView.hidden = YES;
        }
        if (indexPath.row == 6) {
            
            if (/* DISABLES CODE */ (1) == 1) {
               
                cell.arrowImage.hidden = NO;
            }else{
                
                cell.arrowImage.hidden = YES;
            }
        }else{
            
            cell.arrowImage.hidden = NO;
        }
        cell.listImage.image = [UIImage imageNamed:_listArray[indexPath.row - 4]];
        cell.listLabel.text = _listArray[indexPath.row - 4];
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

   // [AppDelegate delegate].userInfo.bLoginOK = YES;
    [_mySelfTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 12){
        //帮助中心
        HelpViewController *helpVC = [[HelpViewController alloc]init];
        helpVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:helpVC animated:YES];
    }else{
        if ([AppDelegate delegate].userInfo.bLoginOK) {
            if (indexPath.row == 0) {
#warning mark - 临时跳转
//                HCCashLoanViewController * vc = [[HCCashLoanViewController alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
                
//                个人资料
                PersonalDataViewController * vc = [[PersonalDataViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 4){
                // 我的账单
                AllloanViewController * vc = [[AllloanViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 6){
                //增值提额
            }else if (indexPath.row == 7){
                //还款记录
                PayHistoryViewController * vc = [[PayHistoryViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if (indexPath.row == 9){
                //我的积分

                HCMyIntegralViewController *myVc = [[HCMyIntegralViewController alloc]init];
                
                myVc.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:myVc animated:YES];
                
            }else if (indexPath.row == 10){
                //我的优惠券
                HCMyCouponViewController * vc = [[HCMyCouponViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [self toLogin];
        }
    }
}

#pragma mark - BSVK Delegate
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if (requestTag == queryPerCustInfo) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            QueryNumberModel * model = [QueryNumberModel mj_objectWithKeyValues:responseObject];
            
            [self analtSisQueryNumberModel:model];
            
        }
    }
}
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
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
#pragma mark - Model 解析
- (void)analtSisQueryNumberModel:(QueryNumberModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]){
        
        [[AppDelegate delegate].userInfo initRealNameInfo:model.body];
        
        [AppDelegate delegate].userInfo.myRealNameState = realNameYes;
        
        [self.mySelfTableView reloadData];
        
    }else if ([model.head.retFlag isEqualToString:@"C1220"]){
        
        [AppDelegate delegate].userInfo.myRealNameState = realNameNo;
        
    }else {
        
        [self buildHeadError:model.head.retMsg];
    }
}
#pragma mark - custom Delegate
- (void)sendRepayPlace:(NSString *)place{

    if ([place isEqualToString:@"近7日待还"]) {
        
        [self toSevenDayRepayment];
    }else if ([place isEqualToString:@"本月待还"]){
    
        [self toMonthRepayment];
    }else{
    
        [self toAllRepayment];
    }
}
@end
