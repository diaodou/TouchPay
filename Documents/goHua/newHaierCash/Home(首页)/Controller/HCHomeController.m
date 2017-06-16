//
//  HCHomeController.m
//  newHaierCash
//
//  Created by Will on 2017/5/27.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "UIColor+DefineNew.h"
#import "BSVKHttpClient.h"

#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "AppDelegate.h"

#import "AdvertSelectModel.h"
#import "HCUserModel.h"
#import "HCHomeInfoModel.h"
#import "HCHomeUserModel.h"

#import "HCHomeAdvertController.h"
#import "HCHomeController.h"
#import "HCHomeHeaderView.h"
#import "HCHomeImageCell.h"
#import "HCHomeNormalCell.h"
#import "HCHomeScrollCell.h"
#import "HCFreeTicketController.h"
#import "HCRootNavController.h"
#import "HCScanController.h"
#import "LoginViewController.h"


#import "HCCommitOffLineOrderController.h"
#import "HCCommitOnlineOrderController.h"
#import "HCMessageCenterViewController.h"
#import "HCLoanIntroductoryViewController.h"

static const CGFloat GetHomeView = 1;
static const CGFloat GetHomeUserInfo = 2;



@interface HCHomeController ()<BSVKHttpClientDelegate,HCHomeHeaderViewDelegate,HCHomeImageCellDelegate,HCHomeScrollCellDelegate,UITableViewDelegate,UITableViewDataSource> {
    HCHomeHeaderView *_headerView;
    //数据信息
    CGFloat _viewScale;
    
    HCUserModel *_userModel;
    
    HCHomeInfoModel *_homeInfoModel;
    
    
    
}

@property(nonatomic,strong)UITableView *homeInfoTable;//商品轮播图

@end

@implementation HCHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor UIColorWithHexColorString:@"#f6f6f9" AndAlpha:1];;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    
    _headerView = [HCHomeHeaderView new];
    _headerView.delegate = self;
    [self.view addSubview:_headerView];
    
    _homeInfoModel = [HCHomeInfoModel GetHCHomeInfoModel];
    
    [self.view addSubview:self.homeInfoTable];
    self.homeInfoTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    self.homeInfoTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_getMoreData)];
    
    //[self getHomeInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self _loadHomeUserInfoView];

}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (iphone6P) {
        _headerView.frame = CGRectMake(0, 0, DeviceWidth, 350);
    } else {
        _headerView.frame = CGRectMake(0, 0, DeviceWidth, 340 * _viewScale);
    }
    
    if (_homeInfoTable) {
        _homeInfoTable.frame = self.view.bounds;
        _homeInfoTable.tableHeaderView = _headerView;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get Set
- (UITableView *)homeInfoTable {
    if (!_homeInfoTable) {
        _homeInfoTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _homeInfoTable.backgroundColor = [UIColor UIColorWithHexColorString:TableView_BackColor AndAlpha:1];
        _homeInfoTable.separatorStyle = UITableViewCellSelectionStyleNone;
        _homeInfoTable.delegate = self;
        _homeInfoTable.dataSource = self;
        [_homeInfoTable registerClass:[HCHomeNormalCell class] forCellReuseIdentifier:NSStringFromClass([HCHomeNormalCell class])];
        [_homeInfoTable registerClass:[HCHomeScrollCell class] forCellReuseIdentifier:NSStringFromClass([HCHomeScrollCell class])];
        [_homeInfoTable registerClass:[HCHomeImageCell class] forCellReuseIdentifier:NSStringFromClass([HCHomeImageCell class])];
    }
    
    return _homeInfoTable;
}

#pragma mark - Private Method
- (void)_loadHomeUserInfoView {
    _userModel = [AppDelegate delegate].userInfo;

    if (_userModel.userId.length <= 0) {
        [_headerView generateViewWithModel:nil andIsRealName:YES];
    } else if (_userModel.realId.length + _userModel.realType.length <= 0) {
       //未实名
        [_headerView generateViewWithModel:nil andIsRealName:NO];

    } else {
        [self getUserInfo];
    }
}

#pragma mark - Public Method
- (void)showKPController
{
    //数据处理
    if(_advertModel.body.kpAd.adId.length > 0)
    {
        HCHomeAdvertController *advertHome = [[HCHomeAdvertController alloc] init];
        advertHome.kpadModel = self.advertModel.body.kpAd;
        advertHome.clickReponder = ^() {
            //STRONGSELF
            /*
             AdvertisementViewController *avc = [[AdvertisementViewController alloc] init];
             avc.kpad = [AppDelegate delegate].adSelModel.body.kpAd;
             avc.pushfrom = FromKP;
             avc.hidesBottomBarWhenPushed = YES;
             [strongSelf.navigationController pushViewController:avc animated:YES];
             */
        };
        [[UIApplication sharedApplication].keyWindow addSubview:advertHome.view];
    }
}

#pragma mark - Button Event
//Section Button 待完善
- (void)_toBtnDicClick {

}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _homeInfoModel.body.info.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HomeSectionModel *sectionModel = _homeInfoModel.body.info[section];
    
    if ([sectionModel.style isEqualToString:@"slideshow"]) {
        return 1 * _viewScale;
    }
    
    if (iphone6P) {
        return 45;
    } else {
        return 40 * _viewScale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _homeInfoModel.body.info.count - 1) {
        return 1 * _viewScale;
    }
    return 10 * _viewScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HomeSectionModel *sectionModel = _homeInfoModel.body.info[section];
     
     if ([sectionModel.style isEqualToString:@"slideshow"]) {
         return nil;
     }
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont appFontRegularOfSize:15 * _viewScale];
    titleLbl.textColor = [UIColor blackColor];
    [headerView addSubview:titleLbl];
    titleLbl.text = sectionModel.title;
    
    UIButton *toBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toBtn setImage:[UIImage imageNamed:@"箭头_右_灰"] forState:UIControlStateNormal];
    [toBtn addTarget:self action:@selector(_toBtnDicClick) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:toBtn];
    if (iphone6P) {
        headerView.frame = CGRectMake(0, 0, DeviceWidth, 45);
        titleLbl.frame = CGRectMake(15, 0, DeviceWidth - 50, 45);
        toBtn.frame = CGRectMake(DeviceWidth - 24, 16, 8, 12);
        
    } else {
        headerView.frame = CGRectMake(0, 0, DeviceWidth, 40 * _viewScale);
        titleLbl.frame = CGRectMake(13 * _viewScale, 0, DeviceWidth - 50 * _viewScale, 40 * _viewScale);
        toBtn.frame = CGRectMake(DeviceWidth - 23 * _viewScale, 14 * _viewScale, 8 * _viewScale, 12 * _viewScale);
    }
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == _homeInfoModel.body.info.count - 1) {
        return nil;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 10 * _viewScale)];
    footerView.backgroundColor = [UIColor UIColorWithHexColorString:@"#f6f6f9" AndAlpha:1];
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HomeSectionModel *sectionModel = _homeInfoModel.body.info[section];
     
    if ([sectionModel.style isEqualToString:@"slideshow"] || [sectionModel.style isEqualToString:@"horizontal"]) {
         return 1;
    }
    
    NSArray *childrenModels = sectionModel.childNode;
    return childrenModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeSectionModel *sectionModel = _homeInfoModel.body.info[indexPath.section];
    
    if ([sectionModel.style isEqualToString:@"slideshow"]) {
        return 132 * _viewScale;
    } else if ([sectionModel.style isEqualToString:@"horizontal"]) {
        return 130 * _viewScale;
    }
    
    if (iphone6P) {
        return 95;
    } else {
        return 87 * _viewScale;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeSectionModel *sectionModel = _homeInfoModel.body.info[indexPath.section];
    
    if ([sectionModel.style isEqualToString:@"slideshow"]) {
        HCHomeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCHomeImageCell class]) forIndexPath:indexPath];
        cell.cellDelegate = self;
        NSArray *childrenModels = sectionModel.childNode;
        
        [cell generateCellWithModels:childrenModels];
        
        return cell;
    } else if ([sectionModel.style isEqualToString:@"horizontal"]) {
        HCHomeScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCHomeScrollCell class]) forIndexPath:indexPath];
        cell.cellDelegate = self;
        NSArray *childrenModels = sectionModel.childNode;
        
        [cell generateCellWithModels:childrenModels];
        
        return cell;
    } else {
        HCHomeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCHomeNormalCell class]) forIndexPath:indexPath];
        
        NSArray *childrenModels = sectionModel.childNode;
        
        [cell generateCellWithModel:childrenModels[indexPath.row]];
        
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_homeInfoTable deselectRowAtIndexPath:indexPath animated:YES];
    HomeSectionModel *sectionModel = _homeInfoModel.body.info[indexPath.section];
    
    //if ([sectionModel.style isEqualToString:@"slideshow"]) {
    if ([sectionModel.title isEqualToString:@"精品分期"]) {
        if (indexPath.row == 0) {
            HCCommitOnlineOrderController *commintOrderVc = [[HCCommitOnlineOrderController alloc]init];
            commintOrderVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:commintOrderVc animated:YES];
        } else {
            HCCommitOffLineOrderController *commintOrderVc = [[HCCommitOffLineOrderController alloc]init];
            commintOrderVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:commintOrderVc animated:YES];
            
        }
        
    } else if ([sectionModel.title isEqualToString:@"现金分期"]) {
        HCLoanIntroductoryViewController *loanVc = [[HCLoanIntroductoryViewController alloc]init];
        loanVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loanVc animated:YES];
    }

    
}


#pragma mark - HCHomeHeaderViewDelegate
- (void)HCHomeHeaderViewDidClickButton:(UIButton *)button {
    switch (button.tag) {
        case buttonTypeMessage: {
            
            HCMessageCenterViewController * vc = [[HCMessageCenterViewController alloc]init];
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case buttonTypeScan: {
            //[_headerView generateViewWithModel:@{@"type":@"1"}];
            HCScanController *scanVc = [[HCScanController alloc]init];
            scanVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scanVc animated:YES];
        }
            break;
        case buttonTypeLogin:{
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            HCRootNavController *nav = [[HCRootNavController alloc]initWithRootViewController:loginVC];
            [self presentViewController:nav animated: YES completion:nil];

        }
            break;
        case buttonTypeIncreaseAmount: {

        }
            break;
        case buttonTypeActiveAmount: {

        }
            break;
        case buttonTypeAmountProgress: {

        }
            break;
        case buttonTypeCommitAmount: {

        }
            break;
        default:
            break;
    }
}

#pragma mark - HCHomeScrollCellDelegate
- (void)ProfitViewDidClcik:(HomeChildModel *)model {
    HCFreeTicketController *freeTicketVc = [[HCFreeTicketController alloc]init];
    freeTicketVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:freeTicketVc animated:YES];
}

#pragma mark - HCHomeImageCellDelegate
- (void)ADImageViewDidClcik:(HomeChildModel *)model {

}

#pragma mark - BSVKDelegate
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if(requestTag == GetHomeView) {
            _homeInfoModel = [HCHomeInfoModel mj_objectWithKeyValues:responseObject];
            [self _analysisHomeInfoModel];
            
        } else if (requestTag == GetHomeUserInfo) {
            HCHomeUserModel *userModel = [HCHomeUserModel mj_objectWithKeyValues:responseObject];
            [self _analysisHomeUserModel:userModel];

            
        }
    }
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
    }
}

#pragma mark - Get Web Data
- (void)_loadNewData {
    
    //[self getHomeInfo];
    [self _loadHomeUserInfoView];

    
    _homeInfoModel = nil;
    [self.homeInfoTable reloadData];
    
    [self.homeInfoTable.mj_header endRefreshing];
}

- (void)_getMoreData {
    
    //[self getHomeInfo];
    [self _loadHomeUserInfoView];
    
    _homeInfoModel = [HCHomeInfoModel GetHCHomeInfoModel];

    [self.homeInfoTable reloadData];
    
    [self.homeInfoTable.mj_footer resetNoMoreData];
}

- (void)getHomeInfo {
    _userModel = [AppDelegate delegate].userInfo;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc] init];
    if(iphone6P)
    {
        [parmDict setObject:@"IOS736" forKey:@"sizeType"];
    }else if (iphone6)
    {
        [parmDict setObject:@"IOS667" forKey:@"sizeType"];
    }else if ([UIScreen mainScreen].bounds.size.height == 568)
    {
        [parmDict setObject:@"IOS568" forKey:@"sizeType"];
    }else if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        [parmDict setObject:@"IOS480" forKey:@"sizeType"];
    }
    [parmDict setObject:StringOrNull(_userModel.custNum) forKey:@"custNo"];

    
    [client getInfo:@"/app/appserver/ad/getHomeView" requestArgument:parmDict requestTag:GetHomeView requestClass:NSStringFromClass([self class])];
}

- (void)getUserInfo {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc] init];
    [parmDict setObject:_userModel.realId forKey:@"idNo"];
    [parmDict setObject:_userModel.realType forKey:@"idType"];

    
    [client getInfo:@"/app/appserver/getHomeUserMsg" requestArgument:parmDict requestTag:GetHomeUserInfo requestClass:NSStringFromClass([self class])];
}

#pragma mark - 解析数据
- (void)_analysisHomeInfoModel {
    if ([_homeInfoModel.head.retMsg isEqualToString:SucessCode]) {
        [_homeInfoTable reloadData];
    } else {
    //提示
    }
}

- (void)_analysisHomeUserModel:(HCHomeUserModel *)infoModel {
    
}

@end
