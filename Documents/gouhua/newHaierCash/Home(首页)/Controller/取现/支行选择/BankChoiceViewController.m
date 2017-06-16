//
//  BankChoiceViewController.m
//  personMerchants
//
//  Created by 张久健 on 16/4/16.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "BankChoiceViewController.h"
#import "GYZCityGroupCell.h"
#import "GYZCityHeaderView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "HCMacro.h"
#import "UIFont+AppFont.h"
//#import "StageViewController.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "BankChoiceModel.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "AppDelegate.h"
#import "SearchCityOrCode.h"
static CGFloat const SearchBank = 110;
static CGFloat const GetBankInfo = 100;
static CGFloat const GetMoreBankInfo = 120;
static CGFloat const SearchMoreBankInfo = 130;
@interface BankChoiceViewController ()<GYZCityGroupCellDelegate,UISearchBarDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,BSVKHttpClientDelegate>
{
    
    NSInteger _pageNumber;//上拉
    
}


@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, assign) BOOL bLocationFail;
/**
 *  记录所有城市信息，用于搜索
 */
@property (nonatomic, strong) NSMutableArray *recordCityData;
/**
 *  定位城市
 */
@property (nonatomic, strong) NSMutableArray *localCityData;

/**
 *  最近访问城市
 */
@property (nonatomic, strong) NSMutableArray *commonCityData;

@property (nonatomic, strong) NSMutableArray *arraySection;
/**
 *  是否是search状态
 */
@property(nonatomic, assign) BOOL isSearch;
/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *searchBar;

/**
 *  搜索支行列表
 */
@property (nonatomic, strong) NSMutableArray *searchCities;

@property(nonatomic,retain)CLLocationManager *locationManager;
/**
 *  查询银行列表
 */
@property(nonatomic,strong)BSVKHttpClient *searchBankClient;
/**
 *  存放银行列表的model
 **/
@property(nonatomic,strong)BankChoiceModel *bankModel;
//数组银行
@property(nonatomic,strong)NSMutableArray *bankArr;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)NSString *currCity;//当前城市
/**
 *  搜索后的视图列表
 **/
@property(nonatomic,strong)UITableView *searchTable;

@end

NSString * bankHeaderView = @"BankHeaderView";
NSString * bankCell = @"banckCell";


@implementation BankChoiceViewController

#pragma mark --> life Cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"支行选择"];
    _pageNumber = 1;
    _page = 1;
    [self setNavi];
    [self creatSearch];
    [self creatSearchTable];
    [self creatTableView];
    [self buildGetBankInfo];
    
    _bankArr = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



#pragma mar --> private Methods

//创建表视图
-(void)creatTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, DeviceWidth, DeviceHeight - 64 - 44) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // [self.tableView setTableHeaderView:self.searchBar];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:UIColorFromRGB(0x3385ff, 1.0)];
    /*
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bankCell];
     //    [self.tableView registerClass:[GYZCityGroupCell class] forCellReuseIdentifier:bankGroupCell];
     [self.tableView registerClass:[GYZCityHeaderView class] forHeaderFooterViewReuseIdentifier:bankHeaderView];
     */

    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:(CGRectZero)];
    _page = 1;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(buildGetMoreBank)];
    
}

//创建头部搜索框
-(void)creatSearch{
    
    //    搜索框
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 44.0f)];
    [self.view addSubview:self.searchBar];
    //    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.translucent  = YES;
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"请输入支行名称";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBar.backgroundColor = [UIColor blackColor];
    [self.searchBar setBarTintColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    [self.searchBar.layer setBorderWidth:0.5f];
    [self.searchBar.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:1.0].CGColor];

    
}

//设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}


#pragma mark --> event Response

- (void)OnBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter
- (NSMutableArray *) searchCities
{
    if (_searchCities == nil) {
        _searchCities = [[NSMutableArray alloc] init];
    }
    return _searchCities;
}

-(void)creatSearchTable{
    
    _searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, DeviceWidth, DeviceHeight-64-44) style:UITableViewStylePlain];
    
    _searchTable.delegate = self;
    
    _searchTable.dataSource = self;
    
    _searchTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _searchTable.tag = 109;
    
    _searchTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(buildSearchMoreBank)];
    
    [self.view addSubview:_searchTable];
 
    
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 109) {
        return _searchCities.count;
    }
    
    return self.bankArr.count ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 109) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jack"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"jack"];
            
            cell.textLabel.font = [UIFont appFontRegularOfSize:14];
            
        }
        
        BankChoiceBody *bode = _searchCities[indexPath.row];
        
        cell.textLabel.text = bode.bchName;
        
        return cell;
        
    }else{
      
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jack"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"jack"];
            
            cell.textLabel.font = [UIFont appFontRegularOfSize:14];
            
        }
        
        BankChoiceBody *bode = _bankArr[indexPath.row];
        
        cell.textLabel.text = bode.bchName;
        
        return cell;

        
    }
    
   
}

#pragma mark UITableViewDelegate
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < 2 || self.isSearch) {
        return nil;
    }
    GYZCityHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:bankHeaderView];
      return headerView;
}
//cell高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearch) {
        return 44.0f;
    }
    if (indexPath.section == 0) {
        return 37.0f;
    }
    else if (indexPath.section == 1) {
        return 41.0f;
    }
    return 45.0f;
}
//区头高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section < 2 || self.isSearch) {
//        return 0.0f;
//    }
    return 0.0f;
}
//点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == 109) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendBankInfo:)]) {
            
            [_delegate sendBankInfo:_searchCities[indexPath.row]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }else{
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendBankInfo:)]) {
            
            [_delegate sendBankInfo:_bankArr[indexPath.row]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
 }

//- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if (self.isSearch) {
//        return nil;
//    }
//    return self.arraySection;
//}
////点击右侧字母
//- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    //    if (index == 0) {
//    //        return -1;
//    //    }
//    return index + 2;
//}

#pragma mark searchBarDelegete
//开始编辑
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont appFontRegularOfSize:16.0f]];
}
//编辑结束
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{   [searchBar setShowsCancelButton:YES animated:YES];

    if (searchText.length == 0) {
        
        if (_searchCities) {
            
            [_searchCities removeAllObjects];
            
            _pageNumber = 1;
            
            [_searchTable.mj_footer resetNoMoreData];
            
            [_searchTable reloadData];
            
        }
        
        [self.view bringSubviewToFront:_tableView];
        
    }

}
//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    [searchBar resignFirstResponder];
    _page = 1;
   // [self searchBankListWithMj:@"begain" andSearchText:searchBar.text];
    [self searchBarResignAndChangeUI];
    [self buildSearchBank];
}
//点击取消
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    
    if (_searchCities.count > 0) {
        
        [_searchCities removeAllObjects];
        
        [_searchTable reloadData];
        
    }
    
    [self.view bringSubviewToFront:_tableView];
    
}


#pragma mark - Event Response

#pragma mark - Private Methods


- (void)reflashSectionOne {
    [self.tableView beginUpdates];
    NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:0];//刷新第二个section
    [self.tableView reloadSections:nd withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

//分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
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

#pragma mark ----BSVKHttpDelegate---------
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
  
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == GetBankInfo) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            BankChoiceModel *model = [BankChoiceModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleGetBankInfo:model];
            
        }else if (requestTag == GetMoreBankInfo){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            BankChoiceModel *model = [BankChoiceModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleMoreBank:model];
    
            
        }else if (requestTag == SearchBank){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            BankChoiceModel *model = [BankChoiceModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSearchInfo:model];
            
        }else if (requestTag == SearchMoreBankInfo){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            BankChoiceModel *model = [BankChoiceModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSearchMoreBank:model];
            
        }
   
    }
}
//请求失败
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (requestTag == GetMoreBankInfo) {
            
              [self.tableView.mj_footer endRefreshing];
        }else if (requestTag == SearchMoreBankInfo){
            
            [_searchTable.mj_footer endRefreshing];
        }
        
     
        
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
//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                
                return ;
                
            }
        }
    }];
}


#pragma mark --> 发起网络请求

//获取全部支行
-(void)buildGetBankInfo{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    [parm setObject:StringOrNull(self.strBackNo) forKey:@"bank"];
    
    [parm setObject:@"" forKey:@"key"];
    
    [parm setObject:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    
    [parm setObject:@"20" forKey:@"size"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/cmis/bankList" requestArgument:parm requestTag:GetBankInfo requestClass:NSStringFromClass([self class])];

    
}

//获取全部支行上拉
-(void)buildGetMoreBank{
    
    _page++;
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    [parm setObject:StringOrNull(self.strBackNo) forKey:@"bank"];
    
    [parm setObject:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    
    [parm setObject:@"" forKey:@"key"];
    
    [parm setObject:@"20" forKey:@"size"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/cmis/bankList" requestArgument:parm requestTag:GetMoreBankInfo requestClass:NSStringFromClass([self class])];

    
}

//查询银行支行
-(void)buildSearchBank{

    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
     [parm setObject:StringOrNull(self.strBackNo) forKey:@"bank"];
    
    if (_searchBar.text !=nil &&(![_searchBar.text isEqualToString:@""])) {
        [parm setObject:_searchBar.text forKey:@"key"];
        
    }else{
        
        [parm setObject:@"" forKey:@"key"];
        
    }
    
    [parm setObject:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    
    [parm setObject:@"20" forKey:@"size"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/cmis/bankList" requestArgument:parm requestTag:SearchBank requestClass:NSStringFromClass([self class])];
    
}

-(void)buildSearchMoreBank{
    
    _pageNumber++;
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    [parm setObject:StringOrNull(self.strBackNo) forKey:@"bank"];
    
    if (_searchBar.text !=nil &&(![_searchBar.text isEqualToString:@""])) {
        [parm setObject:_searchBar.text forKey:@"key"];
        
    }else{
        
        [parm setObject:@"" forKey:@"key"];
        
    }
    
    [parm setObject:[NSString stringWithFormat:@"%ld",(long)_pageNumber] forKey:@"page"];
    
    [parm setObject:@"20" forKey:@"size"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/cmis/bankList" requestArgument:parm requestTag:SearchMoreBankInfo requestClass:NSStringFromClass([self class])];

    
}

#pragma mark --> 网络请求成功后的处理

//处理获得更多搜索后的支行信息
-(void)buildHandleSearchMoreBank:(BankChoiceModel *)model{
    
    [_searchTable.mj_footer endRefreshing];
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        if (model.body.count > 0) {
            
            [_searchCities addObjectsFromArray:model.body];
            
        }else{
            
            _pageNumber--;
            
            [_searchTable.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.searchTable reloadData];
        
        [self.view bringSubviewToFront:self.searchTable];
        
    }else{
        
        _pageNumber--;
        
        [self buildHeadError:model.head.retMsg];
        
    }

    
}

//处理搜索后的支行信息
-(void)buildHandleSearchInfo:(BankChoiceModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        if (!_searchCities) {
            
            _searchCities = [[NSMutableArray alloc]init];
            
        }else{
            
            [_searchCities removeAllObjects];
            
        }
        
        if (model.body.count > 0) {
            
            [_searchCities addObjectsFromArray:model.body];
            
        }
        
        [self.searchTable reloadData];
        
        [self.view bringSubviewToFront:self.searchTable];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//请求全部上拉支行
-(void)buildHandleMoreBank:(BankChoiceModel*)model{
    
    [self.tableView.mj_footer endRefreshing];
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        if (model.body.count > 0) {
            
            [_bankArr addObjectsFromArray:model.body];
            
            [_tableView reloadData];
            
        }else{
          
            _page--;
            
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        
        
        
    }else{
        
        _page--;
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//请求全部支行
-(void)buildHandleGetBankInfo:(BankChoiceModel*)model{
    
    if ([[model.head valueForKey:@"retFlag"] isEqualToString:@"00000"]) {
        
        if (!_bankArr) {
            
            _bankArr = [[NSMutableArray alloc]init];
            
        }else{
            
            [_bankArr removeAllObjects];
            
        }
        
        
        if (model.body.count > 0) {
            
            [_bankArr addObjectsFromArray:model.body];
            
        }
        
        [_tableView reloadData];
        
        [_tableView.mj_footer resetNoMoreData];
        
    }else if([[_bankModel.head valueForKey:@"retFlag"] isEqualToString:@"A1205"]){
        
        [self buildHeadError:@"查询失败"];
        
    }else{
        
        [self buildHeadError:[_bankModel.head valueForKey:@"retMsg"]];
        
    }

    
}


// searchBarResignAndChangeUI方法的实现如下：

 - (void)searchBarResignAndChangeUI{
 
 [_searchBar resignFirstResponder];//失去第一响应
 
 [self changeSearchBarCancelBtnTitleColor:_searchBar];//改变布局
 
 }
 
 #pragma mark - 遍历改变搜索框 取消按钮的文字颜色
 
 - (void)changeSearchBarCancelBtnTitleColor:(UIView *)view{
 
 if (view) {
 
 if ([view isKindOfClass:[UIButton class]]) {
 
 UIButton *getBtn = (UIButton *)view;
 
 [getBtn setEnabled:YES];//设置可用
 
 [getBtn setUserInteractionEnabled:YES];
 
 //设置取消按钮字体的颜色“#0374f2”
     ;
 [getBtn setTitleColor: UIColorFromRGB(0x0374f2, 1.0) forState:UIControlStateReserved];
 
 [getBtn setTitleColor:UIColorFromRGB(0x0374f2, 1.0) forState:UIControlStateDisabled];
 
 return;
 
 }else{
 
 for (UIView *subView in view.subviews) {
 
 [self changeSearchBarCancelBtnTitleColor:subView];
 
 }
 
 }
 
 }else{
 
 return;
 
 }
 
 }

 
 
@end
