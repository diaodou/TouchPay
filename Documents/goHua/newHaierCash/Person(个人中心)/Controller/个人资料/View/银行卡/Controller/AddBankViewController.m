//
//  BankViewController.m
//  Information
//
//  Created by 百思为科iOS on 16/3/31.
//  Copyright © 2016年 百思为科iOS. All rights reserved.
//

#import "AddBankViewController.h"
#import "HCMacro.h"
#import <JMRoundedCorner/UIView+RoundedCorner.h>
#import <JMRoundedCorner/UIImage+RoundedCorner.h>
#import "BindBankCardViewController.h"
#import "AddNewBankViewController.h"
//#import "InputCodeViewController.h"
#import "NSString+CheckConvert.h"
#import "AddNewBankViewController.h"
#import "BSVKHttpClient.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "AppDelegate.h"
#import "RMUniversalAlert.h"
#import "LimitationViewController.h"
#import "UIFont+AppFont.h"
#import "HCAddBankTableViewCell.h"
@interface AddBankViewController ()<UITableViewDataSource,UITableViewDelegate,SendBankNumberDelegate,SendBankDelegate,CancelBankBindingDelegate,BSVKHttpClientDelegate>
{
    BankLIstMode *_bankModel;
}
@property (nonatomic,strong) UIImageView *triangleView;// 默认还款卡
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,strong) NSMutableArray *arrList;// 绑定的银行卡
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UITableView *bankTableView;
@end

@implementation AddBankViewController
#pragma mark -- lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title  = @"选择银行卡";
    
    _arrList = [NSMutableArray array];
    
    [self setNavi];

    [self setLineView];
    
    [self creatheader];
    
    [self creatFoot];
//
    [self createBankTableView];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getBankList];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark - request
- (void)getBankList {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/crm/cust/getBankCard" requestArgument:@{@"custNo":StringOrNull([AppDelegate delegate].userInfo.custNum)} requestTag:0 requestClass:NSStringFromClass([self class])];
}
#pragma mark - BSVK Delegate
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className {
    [_bankTableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if (requestTag == 0) {
            
            BankLIstMode *model = [BankLIstMode mj_objectWithKeyValues:responseObject];
            _bankModel = model;

            [self analySisBankLIstMode:model];
        }
    }
}
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
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
#pragma mark -  解析Model
- (void)analySisBankLIstMode:(BankLIstMode *)model{
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        [_arrList removeAllObjects];
        [_arrList addObjectsFromArray:model.body.info];
        [_bankTableView reloadData];
        
    }else {
        [self buildHeadError:model.head.retMsg];
    }
}
#pragma mark -- setting and getting
//设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
//    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
//    [rightButton setTitle:@"限额查看" forState:UIControlStateNormal];
//    rightButton.backgroundColor = [UIColor clearColor];
//    rightButton.titleLabel.font = [UIFont appFontRegularOfSize:15];
//    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(toLookStopMoney:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = bar;
    
}
- (void)OnBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

//银行tableview
-(void)createBankTableView{
    
    _bankTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, .5, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    
    _bankTableView.dataSource = self;
    
    _bankTableView.delegate = self;
    
    
    _bankTableView.tableHeaderView = _headerView;

    _bankTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _bankTableView.tableFooterView = _footView;

    _bankTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_bankTableView];
    
    _bankTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getBankList)];
}
- (void)setLineView{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, .5)];
    
    lineView.backgroundColor = UIColorFromRGB(0x999999, 1.0);
    
    [self.view addSubview:lineView];
}
- (void)creatheader{

    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10)];
    
    _headerView.backgroundColor = [UIColor whiteColor];
    
}
-(void)creatFoot{
    
    _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 83* DeviceWidth / 375.0)];
    
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 6 *scale6PAdapter, DeviceWidth, 42 *scale6PAdapter)];
    viewBg.backgroundColor = [UIColor whiteColor];
    
    viewBg.userInteractionEnabled = YES;
    
    [_footView addSubview:viewBg];
    
    UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(15* DeviceWidth / 375.0, 0, DeviceWidth, 42 *scale6PAdapter)];
    
    _label.text=@"＋ 添加银行卡";
    
    _label.textColor=UIColorFromRGB(0x333333, 1.0);
    
    _label.textAlignment=NSTextAlignmentLeft;
    
    _label.font=[UIFont systemFontOfSize:16];
    
    [viewBg addSubview:_label];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAction:)];
    
    [viewBg addGestureRecognizer:singleTap];
    
}
#pragma mark --> tableview的代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrList.count;
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *informationCell = @"informationcell";
    
    HCAddBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:informationCell];
    
    if (cell == nil) {
        
        cell = [[HCAddBankTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:informationCell];
        
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BankInfo *info = [_arrList objectAtIndex:indexPath.row];
    
    //得到银行图标
    UIImage *logoImage = [UIImage imageNamed:[NSString stringWithFormat:@"还款卡_%@",info.bankName]];
    
    if (logoImage) {
        
        cell.logoImage.image = logoImage;
    }else{
    
        cell.logoImage.image = [UIImage imageNamed:@""];
    }
    
    cell.leftImage.image = [UIImage imageNamed:@"还款卡_橙色"];
    
    cell.bankNameLabel.text = info.bankName;
    
    cell.bankTypeLabel.text = info.cardTypeName;
    
    NSString * message = [info.cardNo substringFromIndex:info.cardNo.length - 4];
    
    cell.bankNumberLabel.text = [NSString stringWithFormat:@"****%@",message];
    
    //第一个cell右边的图片
    if ([info.isDefaultCard isEqualToString:@"Y"]) {
        
        cell.defaultImage.hidden = NO;
    }else{
        
        cell.defaultImage.hidden = YES;
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iphone6P) {
        
        return 100;
    }else{
    
        return 91 *DeviceWidth/375;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BankInfo *bankInfo = [_arrList objectAtIndex:indexPath.row];
    
   // [_bankTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *typeStr = bankInfo.cardTypeName;
    
    NSString *numStr = bankInfo.cardNo;

    
    if ([_sumbitStr isEqualToString:@"1"]) {
        
        if (_creditBankCardDelegate && [_creditBankCardDelegate respondsToSelector:@selector(changeBank:last: bankName:)]) {
            [_creditBankCardDelegate changeBank:typeStr last:numStr bankName:bankInfo.bankName];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }else if (_choiceBank == choiceCreditCard){
        
        if (_creditBankCardDelegate && [_creditBankCardDelegate respondsToSelector:@selector(changeBank:last:bankName:)]) {
            [_creditBankCardDelegate changeBank:typeStr last:numStr bankName:bankInfo.bankName];
        }
        if (_creditBankCardDelegate && [_creditBankCardDelegate respondsToSelector:@selector(changeBank:)]) {
            [_creditBankCardDelegate changeBank:bankInfo];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (_choiceBank == choiceDefaultCard){
        
            if ([bankInfo.singleCollLimited isEqualToString:@"-1"]) {
                
                [AppDelegate delegate].recordedInfo.bankPayMaxMoney = @"20000000";
                
            }else{
                
                [AppDelegate delegate].recordedInfo.bankPayMaxMoney = bankInfo.singleCollLimited;
                
            }
            
            if (_choiceDefaultDelegate && [_choiceDefaultDelegate respondsToSelector:@selector(choiceBank:)]) {
                [_choiceDefaultDelegate choiceBank:bankInfo];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        
    }else if (_choiceBank == choicePayCard){
        
        if ([bankInfo.singleCollLimited isEqualToString:@"-1"]) {
            
            [AppDelegate delegate].recordedInfo.bankPayMaxMoney = @"20000000";
            
        }else{
            
            [AppDelegate delegate].recordedInfo.bankPayMaxMoney = bankInfo.singleCollLimited;
            
        }
        
        if ([self isJudgeOneString:_payMaxMoney twoString:[AppDelegate delegate].recordedInfo.bankPayMaxMoney]) {
            
            WEAKSELF
            
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"您的每月最高还款额已超过扣款卡的单次最大扣款限额,建议更换还款卡" cancelButtonTitle:@"查看限额" destructiveButtonTitle:@"更换" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                
                STRONGSELF
                
                if (strongSelf) {
                    
                    if (buttonIndex == 0) {
                        
                        [strongSelf toLookStopMoney:nil];
                        
                    }
                    
                }
                
            }];

        }else{
            
            if (_choiceDefaultDelegate && [_choiceDefaultDelegate respondsToSelector:@selector(choiceBank:)]) {
                [_choiceDefaultDelegate choiceBank:bankInfo];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
 
            
        }
        
    }else{
        
        [self toBindBankCardViewController:bankInfo];
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

#pragma mark - 跳转
//跳往限额查看页面
-(void)toLookStopMoney:(UIButton *)sender{
    
    LimitationViewController *limitVc = [[LimitationViewController alloc]init];
    
    limitVc.model = _bankModel;
    
    [self.navigationController pushViewController:limitVc animated:YES];
    
}

- (void)toBindBankCardViewController:(BankInfo *)bankInfo{
    
    BindBankCardViewController *vc = [[BindBankCardViewController alloc]init];
    
    vc.cardType = [NSString stringWithFormat:@"%@  %@",bankInfo.bankName,bankInfo.cardTypeName];
    vc.provinceCode = bankInfo.acctProvince;
    vc.cityCode = bankInfo.acctCity;
    vc.areaCode = bankInfo.acctArea;//可能
    vc.delegate = self;
    vc.mobie = bankInfo.mobile;
    vc.cardNumber = bankInfo.cardNo;
    vc.cancelDelegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}
// 下一步
-(void)addAction:(UIButton *)sender{
    
    AddNewBankViewController *vc = [[AddNewBankViewController alloc]init];
    
    vc.bankDelegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 自定义代理

-(void)sendBankNumber:(BOOL)number{
    
    [_bankTableView reloadData];
}
-(void)sendBank:(NSString *)number{
    
    number = [number convertToTelNum];
    
    [_bankTableView reloadData];
}
-(void)cancelBankBinding:(BOOL)number{
    
    [_bankTableView reloadData];
    
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
@end
