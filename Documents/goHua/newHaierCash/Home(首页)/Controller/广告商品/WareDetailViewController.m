//
//  WareDetailViewController.m
//  商品详情
//
//  Created by 史长硕 on 2017/4/21.
//  Copyright © 2017年 史长硕. All rights reserved.
//

#import "WareDetailViewController.h"
#import <MBProgressHUD.h>
#import "RMUniversalAlert.h"
#import "BSVKHttpClient.h"
#import "WareTopView.h"
#import <WebKit/WebKit.h>
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import <YYWebImage.h>
#import "NewLoanModel.h"
#import "AppDelegate.h"
#import "WareDetailModel.h"
#import "TopSelectView.h"
#import "SearchCityOrCode.h"
#import "WareNumberModel.h"
#import "UnlockAccountViewController.h"
#import "SpecialButton.h"
#import "HCCommitOnlineOrderController.h"
#import "LoanVariety.h"
#import <MJRefresh.h>
#import "QueryNumberModel.h"
#import "SaveAddreInfo.h"
#import "HCGoodsStagApplicationController.h"
#import "LoanTypeModel.h"
#import "WhiteSearchModel.h"
#import "IndetityStore.h"
#import "UILabel+SizeForStr.h"

static CGFloat const GetWareDetail = 100;//获取商品详情（主要是图片）
static CGFloat const GetWareNumber = 110;//获取商品库存
static CGFloat const GetChangeNumber = 120;//获取商品库存
static CGFloat const GetLoanDetail = 130;//获取贷款品种详情
static CGFloat const GetWareNewDetail = 140;//获取商品详情（主要是图片）
static CGFloat const queryPerCustInfo = 150;//获取实名
static CGFloat const getCustIsPass = 160;//获取用户被名单类型
static CGFloat const getInvitedCustByCustNo = 170;//获取用户邀请原因
@interface WareDetailViewController ()<BSVKHttpClientDelegate,SendTouchDelegate,UIPickerViewDelegate,UIPickerViewDataSource,SendSelectDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    float viewScaleAdept;
    
    NSInteger postNumber;
    
    NSString *strProvinceNameTemp;
    
    NSString *_newPriovinceCode;//省代码
    
    NSString *_newCityCode;//市代码
    
    NSString *_newAreaCode;//区代码
    
    UIImageView *_rightImage;
    
    NSString *_priovinceStr;//省名称
    
    NSString *_cityStr;//市名称
    
    NSString *_areaStr;//区名称
    
    UILabel *_typeLabel;//分期方式
    
    SpecialButton *_nowButton;//当前选择button
    
    BOOL _ifShowType;//是否展示分期方式
    
    LoanVariety *_nowLoanmOdel;
    
    WhiteSearchModel *_searchModel;
    
    SpecialButton *_oldButton;//记录旧的按钮
    
}

@property(nonatomic,strong)WareTopView *topView;//网页头部视图

@property(nonatomic,strong)WKWebView *webView;//网页视图

@property(nonatomic,strong)UILabel *typeLabel;//分期方式

@property(nonatomic,strong)UIButton *payButton;//立即结算按钮

@property(nonatomic,strong)MBProgressHUD *hud;//菊花

@property(nonatomic,strong)UIPickerView *addrePicker;//送货地址选择器

@property(nonatomic,strong)TopSelectView *selectView;//选择方法

@property(nonatomic,strong)UIView *baseView;//基础视图

@property(nonatomic,strong)UITableView *loanTypeTableView;

@property(nonatomic,strong)NSMutableArray *typeArray;//分期方式数组

@property(nonatomic,strong)UIView *whiteView;//商品详情加载失败后的白色遮挡

@property(nonatomic,strong)UILabel *warnLabel;//提示label

@property(nonatomic,strong)WareDetailModel *wareModel;

//省 数组
@property (strong, nonatomic) NSArray *provinceArr;
//城市 数组
@property (strong, nonatomic) NSArray *cityArr;
//区县 数组
@property (strong, nonatomic) NSArray *areaArr;

@end

@implementation WareDetailViewController

#pragma mark --> life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
   //  [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (iphone6P) {
        
        viewScaleAdept = scale6PAdapter;
        
    }else{
        viewScaleAdept = scaleAdapter;
        
    }
    
    [AppDelegate delegate].userInfo.bReturn = YES;
    
    [self creatWebView];
    
    [self creatTopView];
    
    [self creatBottomView];
    
    //[self creatIfPost];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buildRefreshLocation) name:LocationResult object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_topView.topImageScroll) {
        
        _topView.topImageScroll.infiniteLoop = YES;
        
    }
    
    self.view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    
    if (_ifShowType && [AppDelegate delegate].userInfo.bLoginOK == YES) {
        
        _ifShowType = NO;
        
        if (_baseView) {
            
            _baseView.hidden = NO;
            
        }else{
            
            _baseView = [[UIView alloc] init];
            _baseView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight-64);
            _baseView.backgroundColor = [UIColor colorWithRed:0.28 green:0.21 blue:0.20 alpha:0.50];
            [self.view addSubview:_baseView];
            
            [self creaTypeTable];
        }
        
        
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
     [[NSNotificationCenter defaultCenter]removeObserver:self name:LocationResult object:nil];

    if (_topView.topImageScroll) {
        
        _topView.topImageScroll.infiniteLoop = NO;
        
    }
}

//菊花加载视图
-(MBProgressHUD *)hud{
    
    if (!_hud) {
        
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        
        [self.view addSubview:_hud];
        
    }
    
    [self.view bringSubviewToFront:_hud];
    
    return _hud;
    
}

//创建地址选择器
-(UIPickerView *)addrePicker{
    
    if (!_addrePicker) {
        
        SearchCityOrCode *codr = [[SearchCityOrCode alloc]init];
        
        self.provinceArr = [codr provinceAll];
        
        if (self.provinceArr.count > 0) {
            
            self.cityArr = [codr cityAllFromProv:self.provinceArr[0]];
            
            if (self.cityArr.count > 0) {
                
                self.areaArr = [codr areaAllFromProv:self.provinceArr[0] andCityName:self.cityArr[0]];
                
            }
            
        }
        
        _addrePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, DeviceHeight-64-200*viewScaleAdept, DeviceWidth, 200*viewScaleAdept)];
        
        _addrePicker.backgroundColor = [UIColor colorWithRed:243 green:243 blue:243 alpha:1.0];
        
        _addrePicker.dataSource = self;
        
        _addrePicker.delegate = self;
        
        [self.view addSubview:_addrePicker];
        
    }
    
    return _addrePicker;
    
}
//确定，取消视图
-(TopSelectView *)selectView{
    
    if (!_selectView) {
        
        _selectView = [[TopSelectView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64-200*viewScaleAdept)];
        
        _selectView.delegate = self;
        
        [self.view addSubview:_selectView];
        
    }
    
    return _selectView;
    
}

//遮挡view
-(UIView *)whiteView{
    
    if (!_whiteView) {
        
        _whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64)];
        
        _whiteView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_whiteView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((DeviceWidth-100*viewScaleAdept)/2, (DeviceHeight-64-80*viewScaleAdept)/2, 100*viewScaleAdept, 20*viewScaleAdept)];
        
        label.text = @"网络请求失败";
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont appFontRegularOfSize:15*viewScaleAdept];
        
        [_whiteView addSubview:label];
        
        UILabel *twoLabel = [[UILabel alloc]initWithFrame:CGRectMake((DeviceWidth-100*viewScaleAdept)/2, label.frame.origin.y+label.frame.size.height, 100*viewScaleAdept, 20*viewScaleAdept)];
        
        twoLabel.text = @"请检查你的网络";
        
        twoLabel.font = [UIFont appFontRegularOfSize:13*viewScaleAdept];
        
        twoLabel.textColor = [UIColor lightGrayColor];
        
        twoLabel.textAlignment = NSTextAlignmentCenter;
        
        twoLabel.numberOfLines = 0;
        
        [_whiteView addSubview:twoLabel];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((DeviceWidth-100*viewScaleAdept)/2, twoLabel.frame.origin.y+twoLabel.frame.size.height+10*viewScaleAdept, 100*viewScaleAdept, 30*viewScaleAdept)];
    
        button.backgroundColor = [UIColor whiteColor];
        
        [button setTitle:@"重试" forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont appFontRegularOfSize:13*viewScaleAdept];
        
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        button.layer.cornerRadius = 5*viewScaleAdept;
        
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        button.layer.borderWidth = 1.0;
        
        [button addTarget:self action:@selector(buildTouchTry:) forControlEvents:UIControlEventTouchUpInside];
        
        [_whiteView addSubview:button];
        
    }
    
    return _whiteView;
    
}

#pragma mark --> private Methods(创建控件)

//创建网页视图
-(void)creatWebView{
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0,0, DeviceWidth, DeviceHeight-64-70*viewScaleAdept)];
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(510*viewScaleAdept, 0, 0, 0);
    
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    
    _webView.allowsBackForwardNavigationGestures = NO;
    
    [self.view addSubview:_webView];
    
    
}

//创建顶部视图
-(void)creatTopView{
    
    _topView = [[WareTopView alloc]initWithFrame:CGRectMake(0, -510*viewScaleAdept,DeviceWidth , 680*viewScaleAdept)];
    
    _topView.delegate = self;
    
    [_webView.scrollView addSubview:_topView];
    
}

//创建底部视图
-(void)creatBottomView{
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight-64-70*viewScaleAdept, DeviceWidth, 70*viewScaleAdept)];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bottomView];
    
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"选择分期方式";
    priceLabel.font = [UIFont appFontRegularOfSize:14];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.textColor = [UIColor colorWithRed:0.06 green:0.52 blue:0.99 alpha:1.00];
    [bottomView addSubview:priceLabel];
    _typeLabel = priceLabel;
    
    
    _rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头蓝上"]];
//    _rightImage.frame = CGRectMake((DeviceWidth-15*viewScaleAdept)/2, 30*viewScaleAdept, 15*viewScaleAdept, 10*viewScaleAdept);
    [bottomView addSubview:_rightImage];
    
    [self buildChangeFrame];
    
    //为了扩大响应区域,做个按钮盖在label和image上面
    UIButton *selectStageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectStageBtn.frame = CGRectMake(0, 0,DeviceWidth-190*viewScaleAdept, 70*viewScaleAdept);
    [selectStageBtn addTarget:self action:@selector(selectStage) forControlEvents:UIControlEventTouchUpInside];
    selectStageBtn.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:selectStageBtn];

    
    _payButton = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-190*viewScaleAdept, 10*viewScaleAdept,180*viewScaleAdept, 50*viewScaleAdept)];
    
    [_payButton setTitle:@"立即结算" forState:UIControlStateNormal];
    
    _payButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    _payButton.titleLabel.font = [UIFont appFontRegularOfSize:14];
    
    _payButton.titleLabel.textColor = [UIColor whiteColor];
    
    [_payButton addTarget:self action:@selector(buildToPush:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:_payButton];
    
}

//是否获取地理位置从而发起网络请求
-(void)creatIfPost{
    
    if ([AppDelegate delegate].mapLocation.locationStatus == LocationGeoCitySucess) {
        
        if (_detailModel && [AppDelegate delegate].userInfo.busFlowName == GoodsLoanWait && _ifOnLine) {
            
            _topView.locationLabel.text = [AppDelegate delegate].mapLocation.strAddreDetail;
            
        }else{
            
            _topView.locationLabel.text = [AppDelegate delegate].mapLocation.strAddreDetail;
            
            _topView.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",[AppDelegate delegate].mapLocation.strProvince,[AppDelegate delegate].mapLocation.strCity,[AppDelegate delegate].mapLocation.stringArea];
            
            _priovinceStr = [AppDelegate delegate].mapLocation.strProvince;
            
            _cityStr = [AppDelegate delegate].mapLocation.strCity;
            
            _areaStr = [AppDelegate delegate].mapLocation.stringArea;
            
            _newAreaCode = [AppDelegate delegate].mapLocation.strAreaCode;
            
            _newCityCode = [AppDelegate delegate].mapLocation.strCityCode;
            
            _newPriovinceCode = [AppDelegate delegate].mapLocation.strProvinceCode;
            
        }
        
        _topView.locationLabel.userInteractionEnabled = NO;
        
        if (([AppDelegate delegate].userInfo.busFlowName == GoodsLoanWait || [AppDelegate delegate].userInfo.busFlowName == GoodsLoanCreate) && _ifOnLine) {
           
            [self buildGetWareDetail];
            
        }else{
            
            [self buildGetWareDetail];
            
            _topView.stockLabel.text = @"有货";
            
        }
        
        
    }else if ([AppDelegate delegate].mapLocation.locationStatus == LocationNoAuthority){
        
        [self showNoAuthorityAlert];
        
         _topView.locationLabel.text = @"定位失败，请点击重试";
        
         _topView.locationLabel.userInteractionEnabled = YES;
        
        if (!_ifOnLine) {
            
            _topView.stockLabel.text = @"有货";
            
        }
        
         [self buildGetWareDetail];
        
    }else{
      
        _topView.locationLabel.text = @"定位失败，请点击重试";
        
        _topView.locationLabel.userInteractionEnabled = YES;
        
        if (!_ifOnLine) {
            
            _topView.stockLabel.text = @"有货";
            
        }
        
        [self buildGetWareDetail];

        
    }
    
}

//创建分期方式表视图
-(void)creaTypeTable{
    
    _loanTypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, DeviceHeight/10*3, DeviceWidth, DeviceHeight-64-55*viewScaleAdept-DeviceHeight/10*3) style:UITableViewStylePlain];
    _loanTypeTableView.delegate = self;
    _loanTypeTableView.dataSource = self;
    _loanTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _loanTypeTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_baseView addSubview:_loanTypeTableView];
    
    //表头
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, DeviceWidth, 108*viewScaleAdept);
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, DeviceWidth, 80*viewScaleAdept);
    topView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [headerView addSubview:topView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3*viewScaleAdept, 3*viewScaleAdept, 74*viewScaleAdept, 74*viewScaleAdept)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (_topView.imageArray.count > 0) {
        
        NSData *data = (NSData *)[[AppDelegate delegate].imagePutCache objectForKey:_topView.imageArray[0]];
        
        if (data) {
            
            imageView.image = [UIImage imageWithData:data];
            
        }else{
            
            [imageView yy_setImageWithURL:[NSURL URLWithString:_topView.imageArray[0]] placeholder:[UIImage imageNamed:@"加载展位图"] options:YYWebImageOptionIgnoreDiskCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
                if (image) {
                    
                    imageView.image = image;
                    
                    [[AppDelegate delegate].imagePutCache setObject:UIImageJPEGRepresentation(image, 0.6) forKey:_topView.imageArray[0]];
                    
                }
                
            }];
            
        }
        
    }else{
     
        imageView.image = [UIImage imageNamed:@"贷款列表默认图片"];
        
    }
    
    
    [headerView addSubview:imageView];
    
    UILabel *namelabel = [[UILabel alloc] init];
    namelabel.frame = CGRectMake(80*viewScaleAdept, 4*viewScaleAdept, DeviceWidth-125*viewScaleAdept, 74*viewScaleAdept);
    namelabel.text = _topView.wareNameLabel.text;
    namelabel.textColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.00];
    [headerView addSubview:namelabel];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(DeviceWidth-40*viewScaleAdept, 5*viewScaleAdept, 30*viewScaleAdept, 30*viewScaleAdept);
    [cancleBtn setImage:[UIImage imageNamed:@"详情页按钮"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancleBtn];
    
    _loanTypeTableView.tableHeaderView = headerView;
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, DeviceHeight-64-55*viewScaleAdept, DeviceWidth, 55*viewScaleAdept);
    submitButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    [submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitLoanTnropt) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:submitButton];

    
}

#pragma mark --> event Response(点击方法)

-(void)buildChangeFrame{
    
    CGSize size = [_typeLabel boundingRectWithSize:CGSizeMake(NSIntegerMax, 50*viewScaleAdept)];
    
    if (size.width > DeviceWidth-250*viewScaleAdept ) {
        
        size.width = DeviceWidth-250*viewScaleAdept;
        
    }
    
    float width = (DeviceWidth-190*viewScaleAdept-size.width-15*viewScaleAdept)/3.0;

    _typeLabel.frame = CGRectMake(width, 10*viewScaleAdept, size.width, 50*viewScaleAdept);
    
    _rightImage.frame = CGRectMake(width*2+size.width, 30*viewScaleAdept, 15*viewScaleAdept, 10*viewScaleAdept);
}

//点击立即结算
-(void)buildToPush:(UIButton *)sender{
    
    if (_topView.addressLabel.text.length == 0 || !_topView.addressLabel.text) {
        
        [self buildHeadError:@"请选择送货地址"];
        
    }else if (_newPriovinceCode.length == 0 || _newCityCode.length == 0 || _newAreaCode.length == 0){
        
        [self buildHeadError:@"请选择正确的送货地址"];
        
    }else if ([_topView.stockLabel.text isEqualToString:@"刷新库存"]){
        
        [self buildHeadError:@"非常抱歉，未能查询到库存信息，请刷新重试"];
        
    }else if ([_topView.stockLabel.text isEqualToString:@"无货"]){
        
        [self buildHeadError:@"非常抱歉，您选择的地区暂时无货"];
        
    }else if (!_nowButton || _nowButton.selected == NO){
        
        [self buildHeadError:@"请先选择分期方式"];
        
    }else{
        
        if (([AppDelegate delegate].userInfo.busFlowName == GoodsLoanWait || [AppDelegate delegate].userInfo.busFlowName == GoodsLoanCreate) && _ifOnLine) {
            
          [self buildGetWareNumber];
            
        }else{
          
            [self buildGetLoanDetail];
            
        }
        
    }
    
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

//设置定位
- (void)toSetLocation{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

//点击库存
-(void)buildSelectNumber{
    
    [self buildGetWareNumber];
    
}

//选择分期方式
-(void)selectStage{
    
    if (_typeArray.count > 0) {
        
        if (_nowButton) {
            
            _oldButton = _nowButton;
            
        }
        
        if (_baseView) {
            
            _baseView.hidden = NO;
            
        }else{
            
            _baseView = [[UIView alloc] init];
            _baseView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight);
            _baseView.backgroundColor = [UIColor colorWithRed:0.28 green:0.21 blue:0.20 alpha:0.50];
            [self.view addSubview:_baseView];
            
            [self creaTypeTable];
        }
        
        
    }else{
        
        [self buildHeadError:@"非常抱歉，未能查询到贷款品种信息"];
        
    }
    
}

//点击叉号
-(void)remove{
    
    _baseView.hidden = YES;
    
    if (!_nowButton || _nowButton.selected == NO) {
        
        _typeLabel.text = @"选择分期方式";
        
        [self buildChangeFrame];
        
    }else if (!_oldButton && _nowButton){
        
        _nowButton.selected = NO;
        
        _nowButton = nil;
        
    }else if (_nowButton && _oldButton){
        
        _nowButton.selected = NO;
        
        _nowButton = nil;
        
        _nowButton = _oldButton;
        
        _nowButton.selected = YES;
        
        [_loanTypeTableView reloadData];
        
    }
    
}

//点击分期方式
-(void)typeClick:(SpecialButton *)sender{
    
    if (![_nowButton isEqual:sender] && _nowButton) {
        
        _nowButton.selected = NO;
        
    }
    
    sender.selected = !sender.selected;
    
    _nowButton = sender;
    
}

//分期方式点击确定按钮
-(void)submitLoanTnropt{
    
    if (_nowButton.selected) {
       
        _typeLabel.text = [NSString stringWithFormat:@"已选:%@",_nowButton.storeName];
        
        [self buildChangeFrame];
        
        _baseView.hidden = YES;
        
    }else{
        
        [self buildHeadError:@"请选择分期方式"];
        
    }
    
}


//点击重试按钮
-(void)buildTouchTry:(UIButton *)sender{
    
     [self buildGetWareNewDetail];
    
}

//从待提交订单解析送货地址
-(void)buildKonwAddresFronOrder{
    
    SearchCityOrCode *search = [[SearchCityOrCode alloc]init];
    
    _newPriovinceCode = _detailModel.body.deliverProvince;
    
    _newCityCode = _detailModel.body.deliverCity;
    
    _priovinceStr = [search searchName:_detailModel.body.deliverProvince provinceCode:@"" cityCode:@"" type:typeProvince];
    
    _cityStr = [search searchName:_detailModel.body.deliverCity provinceCode:StringOrNull(_newPriovinceCode) cityCode:@"" type:typeCity];
    
    _areaStr = [search searchName:_detailModel.body.deliverArea provinceCode:StringOrNull(_newPriovinceCode) cityCode:StringOrNull(_newCityCode) type:typeArea];
    
    _newAreaCode = _detailModel.body.deliverArea;
    
    _topView.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",_priovinceStr,_cityStr,_areaStr];
    ;

    
    _nowButton = [[SpecialButton alloc]init];
    
    for (NewLoanModel *model in _typeArray) {
        
        if ([model.typCde isEqualToString:_detailModel.body.typCde] && [model.time isEqualToString:_detailModel.body.applyTnr]) {
        _nowButton.days = [NSString stringWithFormat:@"%@x%@",model.money,_detailModel.body.applyTnr];
            
        _typeLabel.text = [NSString stringWithFormat:@"已选:%@x%@期",model.money,_detailModel.body.applyTnr];
            
            [self buildChangeFrame];
            
         _nowButton.storeName =  [NSString stringWithFormat:@"%@×%@期",model.money,_detailModel.body.applyTnr];
            
         break;
        }
        
    }
    
    _nowButton.typeName = _detailModel.body.typCde;
    
    _nowButton.selected = YES;
    
}

//处理地址
-(OrdeDetailsModel *)buildHandleAddress{
    
    if (![_detailModel.body.deliverProvince isEqualToString:_newPriovinceCode]||![_detailModel.body.deliverCity isEqualToString:_newCityCode]||![_detailModel.body.deliverArea isEqualToString:_newAreaCode]) {
        
        _detailModel.body.deliverProvince = _newPriovinceCode;
        
        _detailModel.body.deliverCity = _newCityCode;
        
        _detailModel.body.deliverArea = _newAreaCode;
        
        _detailModel.body.deliverAddr = @"";
        
        _detailModel.body.deliverAddrTyp = @"";
        
    }
    
    return _detailModel;
    
    
}

-(void)buildRefreshLocation{
    
    if ([AppDelegate delegate].mapLocation.strAddreDetail.length > 0 ) {
        
        _topView.locationLabel.text = [AppDelegate delegate].mapLocation.strAddreDetail;
        
        _topView.locationLabel.userInteractionEnabled = NO;
        
    }else{
        
        _topView.locationLabel.text = @"定位失败，请点击重试";
        
        _topView.locationLabel.userInteractionEnabled = YES;
    }
    
    
}

#pragma mark -->点击送货地址
-(void)sendTouchType:(TouchType)type{
    
    if (type == TouchAddre) {
      
        self.addrePicker.hidden = NO;
        
        self.selectView.hidden = NO;
        
    }else if (type == TouchLocation){
        
        if ([AppDelegate delegate].mapLocation.locationStatus == LocationNoAuthority) {
            
              [self showNoAuthorityAlert];
            
        }else{
            
            _topView.locationLabel.text = @"位置获取中..";
            
            [[AppDelegate delegate].mapLocation openLocationService];
        }
        
      
        
    }else{
        
        if (_topView.addressLabel.text.length == 0) {
            
            [self buildHeadError:@"请先选择地址，以便为您查询库存信息"];
            
        }else{
          
            [self buildGetWareNumber];
            
        }
        
    
        
    }
    
}

#pragma mark -->确定，取消的代理协议
-(void)sendSelect:(BOOL)selectResult{
    
    self.selectView.hidden = YES;
    
    self.addrePicker.hidden = YES;
    
    if (selectResult) {
        
        NSInteger one = [self.addrePicker selectedRowInComponent:0];
        
        NSInteger two = [self.addrePicker selectedRowInComponent:1];
        
        NSInteger three = [self.addrePicker selectedRowInComponent:2];
        
        NSString *cityName = @"";
        
        NSString *twoString = @"";
        
        NSString *areaName = @"";
        
        if (one < self.provinceArr.count) {
            
            cityName = self.provinceArr[one];
        }
        
        if (two < self.cityArr.count) {
            
            twoString  = self.cityArr[two];
            
        }
        
        if (three < self.areaArr.count) {
            
            areaName = self.areaArr[three];
            
        }

        SearchCityOrCode *transform =  [[SearchCityOrCode alloc]init];
        BOOL isMatch = [transform isMatchWithProvince:cityName andCity:twoString andAera:areaName];
        if (!isMatch) {
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"送货地址省市区不匹配,请重新选择" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                
            }];
        }else {
            _priovinceStr = cityName;
            
            _cityStr = twoString;
            
            _areaStr = areaName;
            
            _topView.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",_priovinceStr,_cityStr,_areaStr];
            
            SearchCityOrCode *search = [[SearchCityOrCode alloc]init];
            
            _newPriovinceCode = [search searchCode:_priovinceStr provinceCode:@"" cityCode:@"" type:typeProvince];
            
            _newCityCode = [search searchCode:_cityStr provinceCode:StringOrNull(_newPriovinceCode) cityCode:@"" type:typeCity];
            
            _newAreaCode = [search searchCode:_areaStr provinceCode:StringOrNull(_newPriovinceCode) cityCode:StringOrNull(_newCityCode) type:typeArea];
            
            if (([AppDelegate delegate].userInfo.busFlowName == GoodsLoanWait || [AppDelegate delegate].userInfo.busFlowName == GoodsLoanCreate) && _ifOnLine) {
                
                [self buildChangeAddreGetWareNumber];
                
            }   
        }
    }
    
    
}

#pragma mark --> tableView代理协议

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jack"];
    
    if (!cell) {
    
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jack"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *stageLabel = [[UILabel alloc] init];
        stageLabel.frame = CGRectMake(0, 0, 60*viewScaleAdept, 48*viewScaleAdept);
        stageLabel.tag = 99;
        stageLabel.textAlignment = NSTextAlignmentCenter;
        stageLabel.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.00];
        [cell.contentView addSubview:stageLabel];
        
        UIView *baseView = [[UIView alloc] init];
        baseView.frame = CGRectMake(60*viewScaleAdept, 0, DeviceWidth-72*viewScaleAdept, 48*viewScaleAdept);
        baseView.layer.borderWidth = 1.0f;
        baseView.layer.borderColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00].CGColor;
        baseView.layer.cornerRadius = 4*viewScaleAdept;
        baseView.layer.masksToBounds = YES;
        [cell.contentView addSubview:baseView];
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70*viewScaleAdept, 0, DeviceWidth-82*viewScaleAdept-45*viewScaleAdept, 48*viewScaleAdept)];
        typeLabel.tag = 100;
        typeLabel.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.00];
        typeLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:typeLabel];
        
        SpecialButton *btn = [SpecialButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(DeviceWidth-57*viewScaleAdept, 2*viewScaleAdept, 44*viewScaleAdept, 44*viewScaleAdept);
        [btn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"图标_选中"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 110;
        [cell.contentView addSubview:btn];

        
    }
    
    NewLoanModel *loan = _typeArray[indexPath.row];
    
    UILabel *stageLabel = [cell.contentView viewWithTag:99];
    if(indexPath.row == 0 && indexPath.section == 0)
    {
        stageLabel.text = @"分期";
    }else
    {
        stageLabel.text = @"";
    }
    
    UILabel *label = [cell.contentView viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%@期",loan.loanTime];
    
    SpecialButton *btn = [cell.contentView viewWithTag:110];
    
    btn.storeName = label.text;
    
    btn.typeName = loan.typCde;
    
    btn.days = loan.loanTime;
    
    if ([_nowButton.typeName isEqualToString:loan.typCde] && _nowButton && [_nowButton.storeName isEqualToString:label.text]) {
        
        btn.selected = YES;
        
        _nowButton = btn;
        
    }else{
        
        btn.selected = NO;
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    SpecialButton *btn = (SpecialButton *)[cell.contentView viewWithTag:110];
    if (![_nowButton isEqual:btn] && _nowButton) {
        
        _nowButton.selected = NO;
        
    }
    
    btn.selected = !btn.selected;
    
    _nowButton = btn;
    
}


#pragma mark --> pickerView代理协议

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    //component 列的编号 从0开始
    if (component == 0) {
        
        return self.provinceArr.count;
        
    }else if(component == 1){
        
        return self.cityArr.count;
        
    }else if (component == 2){
        
        
        return self.areaArr.count;
    }
    
    return 0;
    
}


//返回值为显示的文本

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLab = (UILabel *)view;
    
    if (!pickerLab) {
        
        pickerLab = [[UILabel alloc]init];
        
        pickerLab.textAlignment = NSTextAlignmentCenter;
        
        pickerLab.font = [UIFont appFontRegularOfSize:13];
        
        pickerLab.textColor = [UIColor blackColor];
        
    }
    
    //component 列的编号 从0开始
    if (component == 0) {
        
        if (row < self.provinceArr.count) {
            
            pickerLab.text = self.provinceArr[row];
            
        }
        
    }else if(component == 1){
        
        if (row < self.cityArr.count) {
            
            pickerLab.text = self.cityArr[row];
            
        }
        
    }else if (component == 2){
        
        if (row < self.areaArr.count) {
            
            pickerLab.text = self.areaArr[row];
            
        }
    }
    return pickerLab;
    
}

//选中某列某行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    SearchCityOrCode *transfor =[[SearchCityOrCode alloc]init];
    
    if (component == 0) {
        
        strProvinceNameTemp = self.provinceArr[row];
        
        self.cityArr = [transfor cityAllFromProv:StringOrNull(strProvinceNameTemp)];
        
        [pickerView reloadComponent:1];
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        NSString *strCityName = self.cityArr[0];
        
        self.areaArr = [transfor areaAllFromProv:strProvinceNameTemp andCityName:strCityName];
        
        [pickerView reloadComponent:2];
        
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else if (component == 1){
        
        NSString *strCityName = self.cityArr[row];
        
        self.areaArr = [transfor areaAllFromProv:StringOrNull(strProvinceNameTemp) andCityName:strCityName];
        
        //刷新2列
        [pickerView reloadComponent:2];
        
        //滚动到0行
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else if (component == 2){
        
        //不需要更新
    }
    
}

#pragma mark --> 发起网络请求
//查询实名状态
-(void)querySetRequest{
    
    [self.hud showAnimated:YES];
    
    NSMutableDictionary * userDic = [[NSMutableDictionary alloc]init];
    
    [userDic setObject:StringOrNull([AppDelegate delegate].userInfo.userId) forKey:@"userId"];
    
    BSVKHttpClient * userClient = [BSVKHttpClient shareInstance];
    
    userClient.delegate = self;
    
    [userClient getInfo:@"app/appserver/crm/cust/queryPerCustInfo" requestArgument:userDic requestTag:queryPerCustInfo requestClass:NSStringFromClass([self class])];
    
}

//查询贷款品种详情
-(void)buildGetLoanDetail{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    if (_nowButton.typeName.length > 0) {
        
        [parm setObject:_nowButton.typeName forKey:@"typCde"];
        
    }
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    [client getInfo:@"app/appserver/cmis/pLoanTyp" requestArgument:parm requestTag:GetLoanDetail requestClass:NSStringFromClass([self class])];
    
}

//手动选择省市区获取库存
-(void)buildChangeAddreGetWareNumber{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    
    if (_wareModel.body.good.skuCode && _wareModel.body.good.skuCode.length > 0) {
        [parm setObject:_wareModel.body.good.skuCode forKey:@"skuCode"];
    }else if (_goodsCode.length > 0 && _goodsCode){
        [parm setObject:_goodsCode forKey:@"goodsCode"];
    }
    
    if (_newAreaCode.length > 0) {
        [parm setObject:_newAreaCode forKey:@"area"];
    }else if (_newCityCode.length > 0){
        [parm setObject:_newCityCode forKey:@"area"];
    }
    
    [client getInfo:@"app/appserver/pub/gm/queryInventoryBySkucode" requestArgument:parm requestTag:GetWareNumber requestClass:NSStringFromClass([self class])];
    [self.hud showAnimated:YES];
}

//获取地区库存
-(void)buildGetWareNumber{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    
    if (_wareModel.body.good.skuCode && _wareModel.body.good.skuCode.length > 0) {
        [parm setObject:_wareModel.body.good.skuCode forKey:@"skuCode"];
    }else {
        [parm setObject:_goodsCode forKey:@"goodsCode"];
    }
    
    if (_newAreaCode.length > 0) {
        [parm setObject:_newAreaCode forKey:@"area"];
    }else if (_newCityCode.length > 0){
        [parm setObject:_newCityCode forKey:@"area"];
    }
    
    [client getInfo:@"app/appserver/pub/gm/queryInventoryBySkucode" requestArgument:parm requestTag:GetChangeNumber requestClass:NSStringFromClass([self class])];
     [self.hud showAnimated:YES];
}

//获取商品详情和图片
-(void)buildGetWareDetail{
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if (_goodsCode.length > 0 && _goodsCode) {
        
        [parm setObject:_goodsCode forKey:@"goodsCode"];
        
    }
    
    [client getInfo:@"app/appserver/pub/gm/getGoodsAddImgByCode" requestArgument:parm requestTag:GetWareDetail requestClass:NSStringFromClass([self class])];
    
}

//获取商品详情和图片
-(void)buildGetWareNewDetail{
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if (_goodsCode.length > 0 && _goodsCode) {
        
        [parm setObject:_goodsCode forKey:@"goodsCode"];
        
    }
    
    [client getInfo:@"app/appserver/pub/gm/getGoodsAddImgByCode" requestArgument:parm requestTag:GetWareNewDetail requestClass:NSStringFromClass([self class])];
    
}

//查询实名认证客户的准入资格
- (void)setAllowRequest
{
    [self.hud showAnimated:YES];
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
- (void)searchInviteReason
{
    //查询邀请原因
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/crm/cust/getInvitedCustByCustNo" requestArgument:@{@"custNo":[AppDelegate delegate].userInfo.custNum} requestTag:getInvitedCustByCustNo requestClass:NSStringFromClass([self class])];
}

#pragma mark --> 网络代理协议
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (requestTag == GetWareDetail) {
            
            [self.hud hideAnimated:YES];
            
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            
            WareDetailModel *model = [WareDetailModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleGoodsDetail:model];
            
        }else if (requestTag == GetWareNumber){
            
            [self.hud hideAnimated:YES];
            
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            
            WareNumberModel *model = [WareNumberModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleGoodsNumber:model];
            
        }else if (requestTag == GetLoanDetail){
            
            [self.hud hideAnimated:YES];
            
            LoanVariety *model = [LoanVariety mj_objectWithKeyValues:responseObject];
            
            [self buildHandleLoanDetail:model];
            
        }else if (requestTag == GetWareNewDetail){
            
            [self.hud hideAnimated:YES];
            
            WareDetailModel *model = [WareDetailModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleGoodsDetail:model];
            
        }else if (requestTag == GetChangeNumber){
            
            [self.hud hideAnimated:YES];
            
            WareNumberModel *model = [WareNumberModel mj_objectWithKeyValues:responseObject];
            
            [self buildGetNewNumber:model];
            
        }else if (requestTag == queryPerCustInfo){
            
            [self.hud hideAnimated:YES];
            
            QueryNumberModel *model = [QueryNumberModel mj_objectWithKeyValues:responseObject];
            
            [self analtSisQueryNumberModel:model];
            
        }else if (requestTag == getCustIsPass){
            
            [self.hud hideAnimated:YES];
            
            WhiteSearchModel *model = [WhiteSearchModel mj_objectWithKeyValues:responseObject];
            
            [self synalizeAllowModel:model];
            
        }else if (requestTag == getInvitedCustByCustNo){
            
            [self.hud hideAnimated:YES];
            
            IndetityStore *model = [IndetityStore mj_objectWithKeyValues:responseObject];
            
            [self synalizeSocialReason:model];
        }
    
    }
    
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [self.hud hideAnimated:YES];
        
        if (requestTag == GetWareDetail) {
            
            self.whiteView.hidden = NO;
            
        }else{
            
            if (requestTag == GetWareNumber) {
                
                _topView.stockLabel.text = @"刷新库存";
                
                self.topView.stockLabel.userInteractionEnabled = YES;
                
            }
            
            if(httpCode != 0){
                
                [self buildHeadError:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode]];
                
            }else{
                
                [self buildHeadError:@"网络环境异常，请检查网络并重试"];
            }

            
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
                
            }
        }
    }];
    
    
}

#pragma mark --> 网络请求成功后的处理逻辑

//数据模型转换
-(LoanTypeInfo *)buildHandleFromLoan:(LoanVerietyBody *)body{
    
    LoanTypeInfo *info = [[LoanTypeInfo alloc]init];
    
    info.typCde = body.typCde;
    
    info.mtdCde = body.payMtd;
    
    info.maxAmt = [NSString stringWithFormat:@"%ld",(long)body.maxAmt];
    
    info.typSeq = [NSString stringWithFormat:@"%ld",(long)body.typSeq];
    
    info.minAmt = [NSString stringWithFormat:@"%@",body.minAmt];
    
    info.tnrOpt = body.tnrOpt;
    
    info.tnrMaxDays = body.tnrMaxDays; //最大天数
    
    info.mtdDesc = body.typDesc;
    
    info.typLvlCde = body.levelTwo;//小类代码
    
    return info;
    
}

//处理实名认证请求
- (void)analtSisQueryNumberModel:(QueryNumberModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]){
        
        [[AppDelegate delegate].userInfo initRealNameInfo:model.body];
        
        [AppDelegate delegate].userInfo.myRealNameState = realNameYes;
        
        [self setAllowRequest];
        
    }else if ([model.head.retFlag isEqualToString:@"C1220"]){
        
        [AppDelegate delegate].userInfo.myRealNameState = realNameNo;
        
        [self buildToNextController:_nowLoanmOdel];
        
    }else {
        
        [self buildHeadError:model.head.retMsg];
    }
}

//处理贷款品种详情
-(void)buildHandleLoanDetail:(LoanVariety *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        if ([AppDelegate delegate].userInfo.myRealNameState == realNameYes) {
            
            if ([AppDelegate delegate].userInfo.whiteType == WhiteNoCheck || ![AppDelegate delegate].userInfo.whiteType) {
                
                _nowLoanmOdel = model;
                
                [self setAllowRequest];
                
            }else{
                
                [self buildToNextController:model];
                
            }
            
            
        }else if ([AppDelegate delegate].userInfo.myRealNameState == realNameNo)  {
            
           [self buildToNextController:model];
            
        }else{
            
            _nowLoanmOdel = model;
            
            [self querySetRequest];
            
        }

        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

-(void)buildToNextController:(LoanVariety *)model{
    
    NSString *psLoanTypeStr = _nowButton.days;
    psLoanTypeStr = [psLoanTypeStr stringByReplacingOccurrencesOfString:@"x" withString:@"×"];
    psLoanTypeStr = [psLoanTypeStr stringByReplacingOccurrencesOfString:@"X" withString:@"×"];


    NSMutableString *string = [NSMutableString stringWithString:psLoanTypeStr];
    
    NSRange range = [string rangeOfString:@"×"];
#warning mark -->暂时注释
   // [AppDelegate delegate].userInfo.typCde = model.body.typCde;
    
//    if ([_wareModel.body.good.goodsLine isEqualToString:@"ON"]) {
    
        //            HCCommitOnlineOrderController *goods = [[HCCommitOnlineOrderController alloc]init];
        //
        //            goods.inQuiryModel = _wareModel;
        //
        //            goods.merchantCode = _wareModel.body.good.merchantCode;
        //
        //            goods.selectLoan = model.body;
        //
        //            goods.flowName = _flowName;
        //
        //            goods.selectTime = [string substringFromIndex:range.location+1];
        //
        //            if (_detailModel && _flowName == WaitAdvertStage) {
        //
        //                goods.ordeDetailsBody = [self buildHandleAddress];
        //
        //            }else{
        //
        //                SaveAddreInfo *info = [[SaveAddreInfo alloc]init];
        //
        //                info.province = _priovinceStr;
        //
        //                info.city = _cityStr;
        //
        //                info.area = _areaStr;
        //
        //                info.provinceCode = _newPriovinceCode;
        //
        //                info.cityCode = _newCityCode;
        //
        //                info.areaCode = _newAreaCode;
        //
        //                goods.addressInfo = info;
        //
        //            }
        //
        //            goods.strManagerID = _salerCode;
        //
        //            [self.navigationController pushViewController:goods animated:YES];
        //
        //
        //        }else{
        //
        //            InquiryModel *inQuiryModel = [[InquiryModel alloc] initWithAdvertGoodsBody:_wareModel.body];
        //
        //            StageApplicationViewController *stage = [[StageApplicationViewController alloc]init];
        //
        //            stage.inQuiryModel = inQuiryModel;
        //
        //            stage.flowName = _flowName;
        //
        //            stage.merchantCode = _wareModel.body.good.merchantCode;
        //
        //            stage.strManagerID = _salerCode;
        //
        //            stage.selectLoan = [self buildHandleFromLoan:model.body];
        //
        //            stage.selectTime = [string substringFromIndex:range.location+1];
        //
        //            if([_wareModel.body.good.haveMenu isEqualToString:@"Y"])
        //            {
        //                //有套餐
        //                if(_wareModel.body.menus.count > 0)
        //                {
        //                    stage.scantype = goodHasMenuEnter;
        //                }
        //            }else
        //            {
        //                //无套餐
        //                stage.scantype = goodNoMenuEnter;
        //            }
        //
        //            
        //            [self.navigationController pushViewController:stage animated:YES];
        //            
        //        }
    
}

//处理商品详情
-(void)buildHandleGoodsDetail:(WareDetailModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        self.whiteView.hidden = YES;
        
        _topView.wareNameLabel.text = model.body.good.goodsName;
        
        float height = [_topView buildChangeUiframe];
        
        _topView.frame = CGRectMake(0, -height, DeviceWidth, height);
        
        _webView.scrollView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
        
        _wareModel = model;

        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        for (NSString *rose in model.body.pics.pics) {
            
            NSString *string = [NSString stringWithFormat:@"%@pub/gm/getImgByFilepath?filePath=%@",baseUrl,rose];
            
            [array addObject:string];
            
        }
        
        NSURL *url = [NSURL URLWithString:StringOrNull(model.body.goodsHtmlUrl)];
        
         [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        
        _typeArray = [[NSMutableArray alloc]init];
        
        for (WareDetailLoan *loan in model.body.loans) {
            
            for (WareDetailPerNo *perNo in loan.psPerdNo) {
                
                NewLoanModel *newLoan = [[NewLoanModel alloc]init];
                
                newLoan.typCde = loan.loanCode;
                
                newLoan.loanTime = [NSString stringWithFormat:@"%@×%@",perNo.money,perNo.nper];
                
                newLoan.time = perNo.nper;
                
                newLoan.money = perNo.money;
                
                [_typeArray addObject:newLoan];
                
            }
            
        }
        
        if (_detailModel && [AppDelegate delegate].userInfo.busFlowName == GoodsLoanWait && _ifOnLine) {
            
            [self buildKonwAddresFronOrder];
            
        }
        
        if (!_ifOnLine) {
            
            _topView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.body.good.goodsPrice floatValue]];
            
        }else{
            
            if (([AppDelegate delegate].mapLocation.locationStatus == LocationGeoCitySucess)) {
                
                [self buildChangeAddreGetWareNumber];
                
            }
            
        }
        
        _topView.imageArray = [NSArray arrayWithArray:array];
        
        [_topView creatTopImageView];
        
    }else{
    
        self.whiteView.hidden = NO;
        
    }
    
}

//处理库存
-(void)buildHandleGoodsNumber:(WareNumberModel *)model{

    if ([model.head.retFlag isEqualToString:@"00000"]) {
        WareNumberBody *body = model.body;
        
         self.topView.stockLabel.userInteractionEnabled = NO;
        
        if ([body.inventory integerValue] > 0) {
            
            _topView.stockLabel.text = @"有货";
            
        }else{
            
            _topView.stockLabel.text = @"无货";
            
        }

        _topView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[body.price floatValue]];
        
    }else{
        
        self.topView.stockLabel.text = @"刷新库存";
        self.topView.stockLabel.userInteractionEnabled = YES;
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"取消" destructiveButtonTitle:@"刷新库存" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                
                if (buttonIndex == 1) {
                    
                    [strongSelf buildChangeAddreGetWareNumber];
                    
                }else{
                    
                    strongSelf.topView.stockLabel.text = @"刷新库存";
                    
                    strongSelf.topView.stockLabel.userInteractionEnabled = YES;
                    
                    return ;
                    
                }
                
            }
        }];
        
    }
}

//白名单解析
- (void)synalizeAllowModel:(WhiteSearchModel *)_allowModel
{
    //白名单
    
    if ([_allowModel.head.retFlag isEqualToString:@"00000"])
    {
        _searchModel = _allowModel;
        // 社会化顾客
        if ([_allowModel.body.isPass isEqualToString:SocietyUser])
        {
            [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
            
            [self searchInviteReason];
        }
        else if ([_allowModel.body.isPass isEqualToString:@"1"])
        {
            //优质白名单  海尔、电信员工
            if ([_allowModel.body.level isEqualToString:Auser])
            {
                [AppDelegate delegate].userInfo.whiteType = WhiteA;
                
                [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;

                [self buildToNextController:_nowLoanmOdel];
            }
            //其他白名单
            else if ([_allowModel.body.level isEqualToString:Buser])
            {
                [AppDelegate delegate].userInfo.whiteType = WhiteB;
                
                [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
                
                [self buildToNextController:_nowLoanmOdel];
                
            }else if ([_allowModel.body.level isEqualToString:Cuser]){
                
                //[AppDelegate delegate].userInfo.whiteType = WhiteC;
                [AppDelegate delegate].userInfo.haierVipState = IsHaierVip;
                
                [self searchInviteReason];
                
            }
        }
        else if ([_allowModel.body.isPass isEqualToString:@"-1"]){
            
            [AppDelegate delegate].userInfo.whiteType = BlackMan;
            
            [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
            
            [self buildHeadError:@"此账号无贷款权限，详情请拨打4000187777"];
            
        }
    }else{
        
        [self buildHeadError:_allowModel.head.retMsg];
        
    }
}

//查询用户邀请原因
- (void)synalizeSocialReason:(IndetityStore *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        if (model.body.count > 0) {
            //                 有邀请原因 继续走
            if ([_searchModel.body.isPass isEqualToString:@"1"]) {
                [AppDelegate delegate].userInfo.whiteType = WhiteCReason;
            }else{
                [AppDelegate delegate].userInfo.whiteType = WhiteSocityReason;
            }
            // 只可能是BeReTurnStage类型，才会走准入资格查询
            
            [self buildToNextController:_nowLoanmOdel];
            
        }
        //                没有邀请原因  获取贷款品种 用来判断每日额度
        else{
            //                    判断10w
            if ([_searchModel.body.isPass isEqualToString:@"1"]) {
                [AppDelegate delegate].userInfo.whiteType = WhiteCNoReason;
            }else{
                [AppDelegate delegate].userInfo.whiteType = WhiteSocityNoReason;
            }
            
            [self buildToNextController:_nowLoanmOdel];
            
        }
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}


//点击立即结算时查询是否有库存
-(void)buildGetNewNumber:(WareNumberModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        self.topView.stockLabel.userInteractionEnabled = NO;
        
        WareNumberBody *body = model.body;
        
        if ([body.inventory integerValue] > 0 && _nowButton.typeName.length > 0) {
            
               [self buildGetLoanDetail];
            
        }else if([body.inventory integerValue] <= 0){
            
            _topView.stockLabel.text = @"无货";
            
            [self buildHeadError:@"非常抱歉，您选择的地区暂时无货"];
            
        } else {
            _topView.stockLabel.text = @"有货";
            _topView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[body.price floatValue]];
        }
        
    }else{
        
        self.topView.stockLabel.text = @"刷新库存";
        
        self.topView.stockLabel.userInteractionEnabled = YES;
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg  cancelButtonTitle:@"取消" destructiveButtonTitle:@"刷新库存" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            
            STRONGSELF
            
            if (strongSelf) {
                
                if (buttonIndex == 1) {
                    
                    [strongSelf buildChangeAddreGetWareNumber];
                    
                }else{
                    
                    strongSelf.topView.stockLabel.text = @"刷新库存";
                    
                    strongSelf.topView.stockLabel.userInteractionEnabled = YES;
                    
                    return ;
                    
                }
                
            }
            
        }];
        
    }
    
}

@end
