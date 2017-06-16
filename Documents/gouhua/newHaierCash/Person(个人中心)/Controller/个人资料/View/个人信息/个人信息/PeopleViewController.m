//
//  PeopleViewController.m
//  personMerchants
//
//  Created by LLM on 2017/1/5.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "PeopleViewController.h"
#import "CompanyViewController.h"
#import "PersonViewController.h"
#import "HouseViewController.h"
#import "ContactsViewController.h"
#import "AddressDetailViewController.h"
#import "UIColor+DefineNew.h"
#import "PersonalMessageModel.h"
#import "CompanyModel.h"
#import "HouseModel.h"
#import "contectModel.h"
#import "HCMacro.h"
#import "BSVKHttpClient.h"
#import "AppDelegate.h"
#import "CheckPersonInfoRate.h"
#import "RMUniversalAlert.h"
#import "SearchCityOrCode.h"
#import "UIFont+AppFont.h"
#import "ShowType.h"
#import "PersonBack.h"
#import "CompanyModel.h"
#import <MBProgressHUD.h>

@interface PeopleViewController ()<BSVKHttpClientDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource>

{
    
    BOOL bCompanyOK;//单位信息是否完善
    
    BOOL bPersonOk;//个人信息是否完善
    
    BOOL bHouseOk;//房产信息是否完善
    
    BOOL bContactOk;//联系人信息是否完善
    
}

@property (nonatomic,strong) NSArray *titleArray;               //标题数组
@property (nonatomic,strong) NSMutableDictionary *imageDict;    //标题图片字典

@property (nonatomic,strong) UIButton *companyBtn;              //公司信息按钮
@property (nonatomic,strong) UIButton *personBtn;               //个人信息按钮
@property (nonatomic,strong) UIButton *houseBtn;                //房产信息按钮
@property (nonatomic,strong) UIButton *contactBtn;              //联系人信息按钮

@property (nonatomic,strong) UIView *baseView;                  //下方的容器view

@property (nonatomic,strong) CompanyViewController *companyVC;  //单位信息View
@property (nonatomic,strong) PersonViewController *personVC;    //个人信息View
@property (nonatomic,strong) HouseViewController *houseVC;      //房产信息View
@property (nonatomic,strong) ContactsViewController *contactVC; //联系人view

@property (nonatomic,strong) UIView *pickerBackView;            //选择器的蒙层
@property (nonatomic,strong) UIPickerView *pickerViw;           //选择器

@property (nonatomic,strong) UIView *tableBackView;             //tableview的蒙层
@property (nonatomic,strong) UITableView *tableView;            //tableView

@property (nonatomic,strong) NSMutableArray <NSArray *>*pickDataArr;//选择器的数据源
@property (nonatomic,strong) NSMutableArray <NSArray *>*tableDataArr; //tableView数据源
@end

@implementation PeopleViewController
{
    UIButton *_selectButton;     //当前选中的按钮
    
    NSString *_privonceName;     //选择器所选择的省份
    NSString *_cityName;         //选择器所选择的市
    NSString *_areaName;         //选择器所选择的区
    
    ShowPickViewType _type;      //当前选择器的类型
    
    NSArray *_contactParmArray;  //联系人上传的参数字典数组
    NSInteger _currentPostCount; //当前上传的是第几个联系人
    NSInteger _successCount;     //当前已经上传成功的个数
}

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationItem.title = @"个人信息";
    
    _currentPostCount = 0;
    _successCount = 0;
   
    //标题数组
    [self initTitleArray];
    //按钮图片字典
    [self initImageDict];
    //导航
    [self setNavi];
    //顶部视图
    [self createTopViewAndContentView];
    //请求个人信息
    [self personDataRequest];
    //将子Controller先添加进来
    [self addChildControls];
}


#pragma mark - 加载视图
//设置导航
- (void)setNavi
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)createTopViewAndContentView
{
    //用滚动视图作为base,方便扩展
    UIScrollView *baseSV = [[UIScrollView alloc] init];
    baseSV.frame = CGRectMake(0, 0, DeviceWidth, 80);
    baseSV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseSV];
    
    for(int i = 0; i < _titleArray.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((DeviceWidth/_titleArray.count - 41)/2 + DeviceWidth/_titleArray.count*i, 11, 41, 41);
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i == self.currentIndex)
        {
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-失败-选中",_titleArray[i]]] forState:UIControlStateNormal];
        }
        else
        {
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-失败",_titleArray[i]]] forState:UIControlStateNormal];
        }

        [baseSV addSubview:btn];
        
            if(i == 0)
            {
                _companyBtn = btn;
            }
            else if(i == 1)
            {
                _personBtn = btn;
            }
            else if (i == 2)
            {
                _houseBtn = btn;
            }
            else if (i == 3)
            {
                _contactBtn = btn;
            }
        
        if(self.currentIndex == i)
        {
            _selectButton = btn;
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake((DeviceWidth/_titleArray.count - 41)/2 + DeviceWidth/_titleArray.count*i, 55, 50, 16);
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _titleArray[i];
        [baseSV addSubview:label];
    }
    
    //下方的容器
    _baseView = [[UIView alloc] init];
    _baseView.frame = CGRectMake(0, 90, DeviceWidth, DeviceHeight-144);
    [self.view addSubview:_baseView];
}

#pragma mark - 点击事件
- (void)OnBackBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)titleClick:(UIButton *)btn
{
    if(_selectButton == btn)
    {
        return;
    }
    
    //对上一次选择的按钮做处理
    if(_selectButton == _companyBtn)
    {
        //判断单位信息是否完善
        BOOL isCompelete = [_companyVC judgeCompanyInfoCompelete];
        
        if(!isCompelete)
        {
            return;
        }
    }
    else if (_selectButton == _personBtn)
    {
        //判断单位信息是否完善
        BOOL isCompelete = [_personVC judgePersonInfoCompelete];
        
        if(!isCompelete)
        {
            return;
        }
    }
    else if (_selectButton == _houseBtn)
    {
        //判断房产信息是否完善
        BOOL isCompelete = [_houseVC judgePersonInfoCompelete];
        
        if(!isCompelete)
        {
            return;
        }
    }
    else
    {
        //判断联系人信息是否完善
        BOOL isCompelete = [_contactVC judgeContactInfoCompelete];
        
        if(!isCompelete)
        {
            return;
        }
    }
    
    _selectButton = btn;
}

//点击确定，取消执行的方法
-(void)creatSureAction:(UIButton *)sender
{

    if(sender.tag == 76)
    {
        if(_type == WorkAddressCityPickType || _type == LiveAddressCityPickType || _type == RealEstatePlaceType)
        {
            NSInteger one = [_pickerViw selectedRowInComponent:0];
            NSInteger two = [_pickerViw selectedRowInComponent:1];
            NSInteger three = [_pickerViw selectedRowInComponent:2];
            
            if (one < self.pickDataArr[0].count)
            {
                _privonceName = self.pickDataArr[0][one];
            }
            
            if (two < self.pickDataArr[1].count)
            {
                _cityName  = self.pickDataArr[1][two];
            }
            
            if (three < self.pickDataArr[2].count)
            {
                _areaName = self.pickDataArr[2][three];
            }

            SearchCityOrCode *transform = [[SearchCityOrCode alloc]init];
            NSString *addr = [NSString stringWithFormat:@"%@%@%@",_privonceName,_cityName,_areaName];
            
            BOOL isMatch = [transform isMatchWithProvince:_privonceName andCity:_cityName andAera:_areaName];
            if(!isMatch)
            {
                if (_type == WorkAddressCityPickType)
                {
                    [self showAlertWithMessage:@"单位地址的省市区不匹配,请重新选择"];
                    return;
                }
                else if (_type == LiveAddressCityPickType)
                {
                    [self showAlertWithMessage:@"居住地址的省市区不匹配,请重新选择"];
                    return;
                }
                else
                {
                    [self showAlertWithMessage:@"房产地址的省市区不匹配,请重新选择"];
                    return;
                }
            }

            NSString *provinceCode = [transform searchCode:_privonceName provinceCode:@"" cityCode:@"" type:typeProvince];
            NSString *cityCode = [transform searchCode:_cityName provinceCode:provinceCode cityCode:@"" type:typeCity];
            NSString *areaCode = [transform searchCode:_areaName provinceCode:provinceCode cityCode:cityCode type:typeArea];
            
            
            //将选择的数据传到单位信息里去
            if (_type == WorkAddressCityPickType)
            {
                [_companyVC reloadTableViewWithDictionary:@{@"单位地址":StringOrNull(addr),@"privonceCode":StringOrNull(provinceCode),@"cityCode":StringOrNull(cityCode),@"areaCode":StringOrNull(areaCode)} andType:_type];
            }
            else if (_type == LiveAddressCityPickType)
            {
                [_personVC reloadTableViewWithDictionary:@{@"居住地址":StringOrNull(addr),@"privonceCode":StringOrNull(provinceCode),@"cityCode":StringOrNull(cityCode),@"areaCode":StringOrNull(areaCode)} andType:_type];
            }
            else
            {
                [_houseVC reloadTableViewWithDictionary:@{@"房产地址":StringOrNull(addr),@"privonceCode":StringOrNull(provinceCode),@"cityCode":StringOrNull(cityCode),@"areaCode":StringOrNull(areaCode)} andType:_type];
            }
            
        }
        else if (_type == JobType)
        {
            NSInteger count = [_pickerViw selectedRowInComponent:0];
            NSString *position = ((NSDictionary *)_pickDataArr[0][count]).allValues[0];
            
            //根据名字转换成code编码
            NSString *positionCode = ((NSDictionary *)_pickDataArr[0][count]).allKeys[0];
            
            //将选择的数据传到单位信息里去
            [_companyVC reloadTableViewWithDictionary:@{@"职务":StringOrNull(position),@"positionCode":StringOrNull(positionCode)} andType:_type];
        }
        else if (_type == IndustryType)
        {
            NSInteger count = [_pickerViw selectedRowInComponent:0];
            NSString *comKind = ((NSDictionary *)_pickDataArr[0][count]).allValues[0];
            
            //根据名字转换成code编码
            NSString *comKindCode = ((NSDictionary *)_pickDataArr[0][count]).allKeys[0];
            
            //将选择的数据传到单位信息里去
            [_companyVC reloadTableViewWithDictionary:@{@"行业性质":StringOrNull(comKind),@"comKindCode":StringOrNull(comKindCode)} andType:_type];
        }
        else if (_type == WorkType)
        {
            NSInteger count = [_pickerViw selectedRowInComponent:0];
            NSString *positionOPT = ((NSDictionary *)_pickDataArr[0][count]).allValues[0];
            
            //根据名字转换成code编码
            NSString *positionOPTCode = ((NSDictionary *)_pickDataArr[0][count]).allKeys[0];
            
            //将选择的数据传到单位信息里去
            [_companyVC reloadTableViewWithDictionary:@{@"从业性质":StringOrNull(positionOPT),@"positionOPTCode":StringOrNull(positionOPTCode)} andType:_type];
        }
        else if (_type == HighestDegreeType)
        {
            NSInteger count = [_pickerViw selectedRowInComponent:0];
            NSString *education = ((NSDictionary *)_pickDataArr[0][count]).allValues[0];
            
            //根据名字转换成code编码
            NSString *educationCode = ((NSDictionary *)_pickDataArr[0][count]).allKeys[0];
            
            //将选择的数据传到单位信息里去
            [_personVC reloadTableViewWithDictionary:@{@"最高学历":StringOrNull(education),@"educationCode":StringOrNull(educationCode)} andType:_type];
        }
        else if (_type == ResidencePickType)
        {
            NSInteger count = [_pickerViw selectedRowInComponent:0];
            NSString *localResid = ((NSDictionary *)_pickDataArr[0][count]).allValues[0];
            
            //根据名字转换成code编码
            NSString *localResidCode = ((NSDictionary *)_pickDataArr[0][count]).allKeys[0];
            
            //将选择的数据传到单位信息里去
            [_personVC reloadTableViewWithDictionary:@{@"户口性质":StringOrNull(localResid),@"localResidCode":StringOrNull(localResidCode)} andType:_type];
        }
        else if (_type == MarriedPickType)
        {
            NSInteger count = [_pickerViw selectedRowInComponent:0];
            NSString *maritalStatus = ((NSDictionary *)_pickDataArr[0][count]).allValues[0];
            
            //根据名字转换成code编码
            NSString *maritalStatusCode = ((NSDictionary *)_pickDataArr[0][count]).allKeys[0];
            
            //将选择的数据传到单位信息里去
            [_personVC reloadTableViewWithDictionary:@{@"婚姻状况":StringOrNull(maritalStatus),@"maritalStatusCode":StringOrNull(maritalStatusCode)} andType:_type];
        }
        else if (_type == SupportNumberType)
        {
            NSInteger count = [_pickerViw selectedRowInComponent:0];
            NSString *maritalStatus = _pickDataArr[0][count];
            
            //将选择的数据传到单位信息里去
            [_personVC reloadTableViewWithDictionary:@{@"供养人数":StringOrNull(maritalStatus)} andType:_type];
        }
        else if (_type == CreditCardsNumberType)
        {
            NSInteger count = [_pickerViw selectedRowInComponent:0];
            NSString *creditCount = _pickDataArr[0][count];
            
            //将选择的数据传到单位信息里去
            [_personVC reloadTableViewWithDictionary:@{@"信用卡数量":StringOrNull(creditCount)} andType:_type];
        }
        else if (_type == ContactRelationType)
        {
            NSInteger count = [_pickerViw selectedRowInComponent:0];
            NSString *contactRelationType = ((NSDictionary *)_pickDataArr[0][count]).allValues[0];
            
            //根据名字转换成code编码
            NSString *contactRelationTypeCode = ((NSDictionary *)_pickDataArr[0][count]).allKeys[0];
            
            //将选择的数据传到单位信息里去
            [_contactVC reloadTableViewWithDictionary:@{@"关系":StringOrNull(contactRelationType),@"contactRelationTypeCode":StringOrNull(contactRelationTypeCode)} andType:_type];
        }
        else if (_type == RealEstateSituationType || _type == PersonEstateSituationType)
        {
            NSInteger count = [_pickerViw selectedRowInComponent:0];
            NSString *liveInfo = ((NSDictionary *)_pickDataArr[0][count]).allValues[0];
            
            //根据名字转换成code编码
            NSString *liveInfoCode = ((NSDictionary *)_pickDataArr[0][count]).allKeys[0];
            
            //将选择的数据传到房产信息里去
            if(_type == RealEstateSituationType)
            {
                [_houseVC reloadTableViewWithDictionary:@{@"房产状况":StringOrNull(liveInfo),@"liveInfoCode":StringOrNull(liveInfoCode)} andType:_type];
            }
            //个人信息里也有
            else if (_type == PersonEstateSituationType)
            {
                [_personVC reloadTableViewWithDictionary:@{@"房产状况":StringOrNull(liveInfo),@"liveInfoCode":StringOrNull(liveInfoCode)} andType:_type];
            }
        }
        else if (_type == ResidenceTimeType)
        {
            NSInteger count = [_pickerViw selectedRowInComponent:0];
            NSString *residenceTime = _pickDataArr[0][count];
            
            //将选择的数据传到房产信息里去
            [_houseVC reloadTableViewWithDictionary:@{@"居住年限":StringOrNull(residenceTime)} andType:_type];
        }
    }
    
    _pickerBackView.hidden = YES;
}

#pragma mark - 做网络请求的方法
//个人信息查询
- (void)personDataRequest
{
    NSString *custNum = [AppDelegate delegate].userInfo.custNum;
    
    //个人全部接口
    BSVKHttpClient *peopleClient = [BSVKHttpClient shareInstance];
    peopleClient.delegate = self;
    NSMutableDictionary *peopleDict = [NSMutableDictionary dictionary];
    if (custNum)
    {
        [peopleDict setObject:custNum forKey:@"custNo"];
        [peopleDict setObject:@"Y" forKey:@"flag"];
    }
    [peopleClient getInfo:@"app/appserver/getAllCustExtInfo" requestArgument:peopleDict requestTag:1 requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//上传单位信息
- (void)upLoadCompanyInfoWithParmDict:(NSDictionary *)parmDict
{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
//    [parmDict setObject:@"app_person" forKey:@"dataFrom"];
    [client postInfo:@"app/appserver/crm/cust/saveAllCustExtInfo" requestArgument:parmDict requestTag:2 requestClass:NSStringFromClass([self class])];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//上传个人信息
- (void)upLoadPersonInfoWithParmDict:(NSDictionary *)parmDict
{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    
    [client postInfo:@"app/appserver/crm/cust/saveAllCustExtInfo" requestArgument:parmDict requestTag:3 requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
//上传房产信息
- (void)upLoadHouseInfoWithParmDict:(NSDictionary *)parmDict
{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    
    [client postInfo:@"app/appserver/crm/cust/saveAllCustExtInfo" requestArgument:parmDict requestTag:4 requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
//上传联系人信息
- (void)upLoadContactInfoWithParmArray:(NSArray *)parmArray
{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    
    _contactParmArray = parmArray;
    
    NSMutableDictionary *parm = parmArray[_currentPostCount];
    
    [client postInfo:@"app/appserver/crm/saveCustFCiCustContact" requestArgument:parm requestTag:5 requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - BSVKDelegate
//请求成功
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className
{
    if([className isEqualToString:NSStringFromClass([self class])])
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(requestTag == 1)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            //解析个人信息
            [self analysisPerseonData:responseObject];
        }
        else if (requestTag == 2)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            PersonBack *model = [PersonBack mj_objectWithKeyValues:responseObject];
            
            //解析单位信息上传返回的model
            [self analysisCompanyInfoModel:model];
        }
        else if (requestTag == 3)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            PersonalMessageModel *model = [PersonalMessageModel mj_objectWithKeyValues:responseObject];
            
            //解析个人信息上传返回的model
            [self analysisPersonInfoModel:model];
        }
        else if (requestTag == 4)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            HouseModel *model = [HouseModel mj_objectWithKeyValues:responseObject];
            
            //解析房产信息上传返回的model
            [self analysisHouseModelInfoModel:model];
        }
        else if (requestTag == 5)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            CompanyModel *model = [CompanyModel mj_objectWithKeyValues:responseObject];
            
            //解析联系人信息上传返回的model
            [self analysisContactInfoModel:model];
        }
    }
}

- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
        //如果请求个人信息失败,要将所有信息清空
        if(requestTag == 1)
        {
            if(_selectButton == _companyBtn)
            {
                _companyVC.companyBody = nil;
                [_companyVC reloadCompanyInfo];
            }
            else if (_selectButton == _personBtn)
            {
                _personVC.personBody = nil;
                [_personVC reloadPersonInfo];
            }
            else if (_selectButton == _houseBtn)
            {
                _houseVC.houseBody = nil;
                [_houseVC reloadHouseInfo];
            }
            else
            {
                _contactVC.contectBody = nil;
                [_contactVC reloadContactInfo];
            }
        }
        else if(requestTag == 2)
        {
            _selectButton = _companyBtn;
            self.currentIndex = 0;
        }
        else if(requestTag == 3)
        {
            _selectButton = _personBtn;
            self.currentIndex = 1;
        }
        else if (requestTag == 4)
        {
            _selectButton = _contactBtn;
            self.currentIndex = 3;
        }
        
        if(httpCode != 0)
        {
            [self showAlertWithMessage:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode]];
        }
        else
        {
            [self showAlertWithMessage:@"网络环境异常，请检查网络并重试"];
        }
    }
}

#pragma mark - model解析
- (void)analysisPerseonData:(id)responseObject
{
    CompanyModel *company = [CompanyModel mj_objectWithKeyValues:responseObject];
    if ([company.head.retFlag isEqualToString:@"00000"])
    {
        CheckPersonInfoRate *checkRate = [[CheckPersonInfoRate alloc]init];
        if (_ifFromTe) {
            checkRate.ifFromTE = YES;
        }
        
        bCompanyOK = [checkRate isCompanyCompeleteWithModel:company];
        
        //给单位信息View的model赋值
        _companyVC.companyBody = company.body;
        [_companyVC reloadCompanyInfo];
        
        //刷新按钮显示的图片
        if([_titleArray[_currentIndex] isEqualToString:@"单位信息"])
        {
            if(bCompanyOK)
            {
                [_imageDict setObject:@"单位信息-成功-选中" forKey:@"单位信息"];
            }
            else
            {
                [_imageDict setObject:@"单位信息-失败-选中" forKey:@"单位信息"];
            }
        }
        else
        {
            if(bCompanyOK)
            {
                [_imageDict setObject:@"单位信息-成功" forKey:@"单位信息"];
            }
            else
            {
                [_imageDict setObject:@"单位信息-失败" forKey:@"单位信息"];
            }
        }
        
        [self reloadButtonImageWithButton:_companyBtn andTypeString:@"单位信息"];
        
    }
    else if ([company.head.retFlag isEqualToString:NoFindCustExtInfo])
    {
    }
    else
    {
        _companyVC.companyBody = nil;
        [_companyVC reloadCompanyInfo];
        [self showAlertWithMessage:company.head.retMsg];
    }
    
    PersonalMessageModel *person = [PersonalMessageModel mj_objectWithKeyValues:responseObject];
    if ([person.head.retFlag isEqualToString:@"00000"])
    {
        CheckPersonInfoRate *checkRate = [[CheckPersonInfoRate alloc]init];
        
        bPersonOk = [checkRate isPersonCopeleteWithModel:person];
        if (_ifFromTe) {
            checkRate.ifFromTE = YES;
        }
        //个人信息view的Model赋值
        _personVC.personBody = person.body;
        [_personVC reloadPersonInfo];
        
        if([_titleArray[_currentIndex] isEqualToString:@"个人信息"])
        {
            if(bPersonOk)
            {
                [_imageDict setObject:@"个人信息-成功-选中" forKey:@"个人信息"];
            }
            else
            {
                [_imageDict setObject:@"个人信息-失败-选中" forKey:@"个人信息"];
            }
        }
        else
        {
            if(bPersonOk)
            {
                [_imageDict setObject:@"个人信息-成功" forKey:@"个人信息"];
            }
            else
            {
                [_imageDict setObject:@"个人信息-失败" forKey:@"个人信息"];
            }
        }
        
        [self reloadButtonImageWithButton:_personBtn andTypeString:@"个人信息"];
        
    }
    else if ([person.head.retFlag isEqualToString:NoFindCustExtInfo])
    {
    }
    else
    {
        _personVC.personBody = nil;
        [_personVC reloadPersonInfo];
        [self showAlertWithMessage:person.head.retMsg];
    }
    
    HouseModel *house = [HouseModel mj_objectWithKeyValues:responseObject];
    if ([house.head.retFlag isEqualToString:@"00000"])
    {
        CheckPersonInfoRate *checkRate = [[CheckPersonInfoRate alloc]init];
        
        bHouseOk = [checkRate isHouseCompeleteWithModel:house];
        if (_ifFromTe) {
            checkRate.ifFromTE = YES;
        }
        //房产信息view的Model赋值
        _houseVC.houseBody = house.body;
        [_houseVC reloadHouseInfo];
        
        if([_titleArray[_currentIndex] isEqualToString:@"房产信息"])
        {
            if(bHouseOk)
            {
                [_imageDict setObject:@"房产信息-成功-选中" forKey:@"房产信息"];
            }
            else
            {
                [_imageDict setObject:@"房产信息-失败-选中" forKey:@"房产信息"];
            }
        }
        else
        {
            if(bHouseOk)
            {
                [_imageDict setObject:@"房产信息-成功" forKey:@"房产信息"];
            }
            else
            {
                [_imageDict setObject:@"房产信息-失败" forKey:@"房产信息"];
            }
        }
        
        
        [self reloadButtonImageWithButton:_houseBtn andTypeString:@"房产信息"];
        
    }
    else if ([house.head.retFlag isEqualToString:NoFindCustExtInfo])
    {
    }
    else
    {
        _houseVC.houseBody = nil;
        [_houseVC reloadHouseInfo];
        [self showAlertWithMessage:house.head.retMsg];
    }
    
    contectModel *contact = [contectModel mj_objectWithKeyValues:responseObject];
    if ([contact.head.retFlag isEqualToString:@"00000"])
    {
        CheckPersonInfoRate *checkRate = [[CheckPersonInfoRate alloc]init];
        
        bContactOk = [checkRate isContactCompeleteWithModel:contact];
        if (_ifFromTe) {
            checkRate.ifFromTE = YES;
        }
        //赋值并刷新数据源
        _contactVC.contectBody = contact.body;
        [_contactVC reloadContactInfo];
        
        if([_titleArray[_currentIndex] isEqualToString:@"联系人"])
        {
            if(bContactOk)
            {
                [_imageDict setObject:@"联系人-成功-选中" forKey:@"联系人"];
            }
            else
            {
                [_imageDict setObject:@"联系人-失败-选中" forKey:@"联系人"];
            }
        }
        else
        {
            if(bContactOk)
            {
                [_imageDict setObject:@"联系人-成功" forKey:@"联系人"];
            }
            else
            {
                [_imageDict setObject:@"联系人-失败" forKey:@"联系人"];
            }
        }
        
        [self reloadButtonImageWithButton:_contactBtn andTypeString:@"联系人"];
        
    }
    else if ([contact.head.retFlag isEqualToString:NoFindCustExtInfo])
    {
    }
    else
    {
        _contactVC.contectBody = nil;
        [_contactVC reloadContactInfo];
        [self showAlertWithMessage:contact.head.retMsg];
    }
}

//解析单位信息上传的model
- (void)analysisCompanyInfoModel:(PersonBack *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"])
    {
        [_imageDict setObject:@"单位信息-成功" forKey:@"单位信息"];
       bCompanyOK = YES;
        [self reloadButtonImageWithButton:_companyBtn andTypeString:@"单位信息"];
        
        //如果当前选中的按钮是单位信息按钮,代表是点击下一步
        if(_selectButton == _companyBtn)
        {

                if(bPersonOk == NO)
                {
                    //刷新顶部按钮的图片
                    [_imageDict setObject:@"个人信息-失败-选中" forKey:@"个人信息"];
                    [self reloadButtonImageWithButton:_personBtn andTypeString:@"个人信息"];
                    
                    //将子视图控制器的View加载进来
                    if([_baseView.subviews containsObject:_personVC.view])
                    {
                        [_baseView bringSubviewToFront:_personVC.view];
                    }
                    else
                    {
                        [_baseView addSubview:_personVC.view];
                    }
                    
                    _selectButton = _personBtn;
                    self.currentIndex = 1;
                }
                else if (bHouseOk == NO)
                {
                    //刷新顶部按钮的图片
                    [_imageDict setObject:@"房产信息-失败-选中" forKey:@"房产信息"];
                    [self reloadButtonImageWithButton:_houseBtn andTypeString:@"房产信息"];
                    
                    //将子视图控制器的View加载进来
                    if([_baseView.subviews containsObject:_houseVC.view])
                    {
                        [_baseView bringSubviewToFront:_houseVC.view];
                    }
                    else
                    {
                        [_baseView addSubview:_houseVC.view];
                    }
                    
                    _selectButton = _houseBtn;
                    self.currentIndex = 2;
                }
                else
                {
                    
                    //将子视图控制器的View加载进来
                    if([_baseView.subviews containsObject:_contactVC.view])
                    {
                        [_baseView bringSubviewToFront:_contactVC.view];
                    }
                    else
                    {
                        [_baseView addSubview:_contactVC.view];
                    }
                    if(bContactOk)
                    {
                        [_imageDict setObject:@"联系人-成功-选中" forKey:@"联系人"];
                    }
                    else
                    {
                        [_imageDict setObject:@"联系人-失败-选中" forKey:@"联系人"];
                    }
                    _selectButton = _contactBtn;
                    self.currentIndex = 3;
                    [self reloadButtonImageWithButton:_contactBtn andTypeString:@"联系人"];
                    [self personDataRequest];
                    
                }
        }
        else
        {
            NSString *str = [_imageDict objectForKey:@"单位信息"];
            [_imageDict setObject:[str stringByReplacingOccurrencesOfString:@"-选中" withString:@""] forKey:@"单位信息"];
            [self reloadButtonImageWithButton:_companyBtn andTypeString:@"单位信息"];

            
            [self refreshButtonState];
        }
    }
    else
    {
        [_imageDict setObject:@"单位信息-失败-选中" forKey:@"单位信息"];
        bCompanyOK = NO;
        _selectButton = _companyBtn;
        self.currentIndex = 0;
        
        [self showAlertWithMessage:model.head.retMsg];
    }
}

//解析个人信息上传的model
- (void)analysisPersonInfoModel:(PersonalMessageModel *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"])
    {
        [_imageDict setObject:@"个人信息-成功" forKey:@"个人信息"];
      bPersonOk = YES;
        [self reloadButtonImageWithButton:_personBtn andTypeString:@"个人信息"];
        
        //当前按钮是个人信息,代表点击的下一步走到这里
        if(_selectButton == _personBtn)
        {
            if(bCompanyOK == NO)
                {
                    //刷新顶部按钮的图片
                    [_imageDict setObject:@"单位信息-失败-选中" forKey:@"单位信息"];
                    [self reloadButtonImageWithButton:_companyBtn andTypeString:@"单位信息"];
                    
                    //将子视图控制器的View加载进来
                    if([_baseView.subviews containsObject:_companyVC.view])
                    {
                        [_baseView bringSubviewToFront:_companyVC.view];
                    }
                    else
                    {
                        [_baseView addSubview:_companyVC.view];
                    }
                    
                    _selectButton = _companyBtn;
                    self.currentIndex = 0;
                }
                else if (bHouseOk == NO)
                {
                    //刷新顶部按钮的图片
                    [_imageDict setObject:@"房产信息-失败-选中" forKey:@"房产信息"];
                    [self reloadButtonImageWithButton:_houseBtn andTypeString:@"房产信息"];
                    
                    //将子视图控制器的View加载进来
                    if([_baseView.subviews containsObject:_houseVC.view])
                    {
                        [_baseView bringSubviewToFront:_houseVC.view];
                    }
                    else
                    {
                        [_baseView addSubview:_houseVC.view];
                    }
                    
                    _selectButton = _houseBtn;
                    self.currentIndex = 2;
                }
                else
                {
                    
                    //将子视图控制器的View加载进来
                    if([_baseView.subviews containsObject:_contactVC.view])
                    {
                        [_baseView bringSubviewToFront:_contactVC.view];
                    }
                    else
                    {
                        [_baseView addSubview:_contactVC.view];
                    }
                    
                    
                    if(bContactOk)
                    {
                        [_imageDict setObject:@"联系人-成功-选中" forKey:@"联系人"];
                    }
                    else
                    {
                        [_imageDict setObject:@"联系人-失败-选中" forKey:@"联系人"];
                    }
                    [self reloadButtonImageWithButton:_contactBtn andTypeString:@"联系人"];
                    _selectButton = _contactBtn;
                    self.currentIndex = 3;
                    [self personDataRequest];
                }
            
   
        }
        else
        {
            NSString *str = [_imageDict objectForKey:@"个人信息"];
            [_imageDict setObject:[str stringByReplacingOccurrencesOfString:@"-选中" withString:@""] forKey:@"个人信息"];
            [self reloadButtonImageWithButton:_personBtn andTypeString:@"个人信息"];
            
            [self refreshButtonState];
        }
    }
    else
    {
        [_imageDict setObject:@"个人信息-失败-选中" forKey:@"个人信息"];
        bPersonOk = NO;
        _selectButton = _personBtn;
        self.currentIndex = 1;
        
        [self showAlertWithMessage:model.head.retMsg];
    }
}
//解析房产信息上传返回的model
- (void)analysisHouseModelInfoModel:(HouseModel *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"])
    {
        [_imageDict setObject:@"房产信息-成功" forKey:@"房产信息"];
        bHouseOk = YES;
        [self reloadButtonImageWithButton:_houseBtn andTypeString:@"房产信息"];
        //当前按钮是房产信息,代表点击的下一步走到这里
        if(_selectButton == _houseBtn)
        {
            
            //将子视图控制器的View加载进来
            if([_baseView.subviews containsObject:_contactVC.view])
            {
                [_baseView bringSubviewToFront:_contactVC.view];
            }
            else
            {
                [_baseView addSubview:_contactVC.view];
            }
            
            _selectButton = _contactBtn;
            self.currentIndex = 3;
            if(bContactOk)
            {
                [_imageDict setObject:@"联系人-成功-选中" forKey:@"联系人"];
            }
            else
            {
                [_imageDict setObject:@"联系人-失败-选中" forKey:@"联系人"];
            }
            [self reloadButtonImageWithButton:_contactBtn andTypeString:@"联系人"];
            
            [self personDataRequest];
        }
        else
        {
            NSString *str = [_imageDict objectForKey:@"房产信息"];
            [_imageDict setObject:[str stringByReplacingOccurrencesOfString:@"-选中" withString:@""] forKey:@"房产信息"];
            [self reloadButtonImageWithButton:_houseBtn andTypeString:@"房产信息"];
            
            [self refreshButtonState];
        }
    }
    else
    {
        [_imageDict setObject:@"房产信息-失败-选中" forKey:@"房产信息"];
        bHouseOk = NO;
        _selectButton = _houseBtn;
        self.currentIndex = 2;
    }
}
//解析联系人上传返回的model
- (void)analysisContactInfoModel:(CompanyModel *)model
{
    _currentPostCount ++;
    
    if ([model.head.retFlag isEqualToString:@"00000"])
    {
        _successCount ++;
    }
    else
    {
        [self showAlertWithMessage:[NSString stringWithFormat:@"第%ld位联系人上传失败 原因:%@",(long)_currentPostCount,model.head.retMsg]];
    }
    
    if(_currentPostCount >= _contactParmArray.count)
    {
        _currentPostCount = 0;
        if(_successCount >= _contactParmArray.count)
        {
            if(_selectButton == _contactBtn)
            {
                //所有的信息都上传成功
                [_imageDict setObject:@"联系人-成功" forKey:@"联系人"];
                bContactOk = YES;
                [self reloadButtonImageWithButton:_contactBtn andTypeString:@"联系人"];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSString *str = [_imageDict objectForKey:@"联系人"];
                [_imageDict setObject:[str stringByReplacingOccurrencesOfString:@"-选中" withString:@""] forKey:@"联系人"];
                [self reloadButtonImageWithButton:_contactBtn andTypeString:@"联系人"];
                
                [self refreshButtonState];
            }
        }
    }
    else
    {
        [self upLoadContactInfoWithParmArray:_contactParmArray];
    }
}

#pragma mark - pickerView的代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _pickDataArr.count;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(_type == WorkAddressCityPickType || _type == LiveAddressCityPickType)
    {
        if (component == 0)
        {
            return _pickDataArr[0].count;
        }
        else if(component == 1)
        {
            return _pickDataArr[1].count;
        }
        else if (component == 2)
        {
            return _pickDataArr[2].count;
        }
    }
    else
    {
        return _pickDataArr[0].count;
    }
    return 0;
}

//返回值为显示的文本
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLab = (UILabel *)view;
    
    if (!pickerLab)
    {
        pickerLab = [[UILabel alloc]init];
        pickerLab.textAlignment = NSTextAlignmentCenter;
        pickerLab.font = [UIFont appFontRegularOfSize:13];
        pickerLab.textColor = [UIColor blackColor];
    }
    
    if(_type == WorkAddressCityPickType || _type == LiveAddressCityPickType)
    {
        if (component == 0)
        {
            if (row < _pickDataArr[0].count)
            {
                pickerLab.text = _pickDataArr[0][row];
            }
        }
        else if(component == 1)
        {
            if (row < _pickDataArr[1].count)
            {
                pickerLab.text = _pickDataArr[1][row];
            }
        }
        else if (component == 2)
        {
            if (row < _pickDataArr[2].count)
            {
                pickerLab.text = _pickDataArr[2][row];
            }
        }
    }
    else if (_type == SupportNumberType || _type == CreditCardsNumberType || _type == ResidenceTimeType)
    {
        pickerLab.text = _pickDataArr[0][row];
    }
    else
    {
        pickerLab.text = ((NSDictionary *)_pickDataArr[0][row]).allValues[0];
    }
    
    return pickerLab;
}

//选中某列某行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_type == WorkAddressCityPickType || _type == LiveAddressCityPickType)
    {
        SearchCityOrCode *transfor =[[SearchCityOrCode alloc]init];
        if (component == 0)
        {
            _privonceName = _pickDataArr[0][row];
            
            _pickDataArr[1] = [transfor cityAllFromProv:StringOrNull(_privonceName)];
            
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            NSString *strCityName = _pickDataArr[1][0];
            _pickDataArr[2] = [transfor areaAllFromProv:_privonceName andCityName:strCityName];
            
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        else if (component == 1)
        {
            NSString *strCityName = _pickDataArr[1][row];
            _pickDataArr[2] = [transfor areaAllFromProv:StringOrNull(_privonceName) andCityName:strCityName];
            
            //刷新2列
            [pickerView reloadComponent:2];
            //滚动到0行
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDataArr[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*scaleAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section != 0)
    {
        return 10*scaleAdapter;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, DeviceWidth, 50*scaleAdapter);
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 100;
        label.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:label];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.frame = CGRectMake(0, 49.5*scaleAdapter, DeviceWidth, 0.5*scaleAdapter);
        [cell.contentView addSubview:lineView];
    }
    
    UILabel *label = [cell.contentView viewWithTag:100];
    label.text = ((NSDictionary *)_tableDataArr[indexPath.section][indexPath.row]).allValues[0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type == PermanentAddressType)//户籍地址
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                NSString *permanentAddr = ((NSDictionary *)_tableDataArr[indexPath.section][indexPath.row]).allValues[0];
                
                NSString *permanentAddrInt = ((NSDictionary *)_tableDataArr[indexPath.section][indexPath.row]).allKeys[0];
                
                [_personVC reloadTableViewWithDictionary:@{@"permanentAddr":permanentAddr,@"permanentAddrInt":permanentAddrInt} andType:_type];
            }
            else if (indexPath.row == 1)
            {
                AddressDetailViewController *addressVc =[[AddressDetailViewController alloc]init];
                addressVc.addressType = RegAddressType;
                
                WEAKSELF
                addressVc.sendAddress = ^(NSDictionary *dict)
                {
                    STRONGSELF
                    [strongSelf.personVC reloadTableViewWithDictionary:dict andType:_type];
                };
                
                [self.navigationController pushViewController:addressVc animated:YES];
            }
        }
    }
    else if (_type == PostalAddressType)//通讯地址
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0 || indexPath.row == 1)
            {
                NSString *postAddr = ((NSDictionary *)_tableDataArr[indexPath.section][indexPath.row]).allValues[0];
                
                NSString *postAddrInt = ((NSDictionary *)_tableDataArr[indexPath.section][indexPath.row]).allKeys[0];
                
                [_personVC reloadTableViewWithDictionary:@{@"postAddr":postAddr,@"postAddrInt":postAddrInt} andType:_type];
            }
            else if(indexPath.row == 2)
            {
                AddressDetailViewController *addressVc =[[AddressDetailViewController alloc]init];
                addressVc.addressType = PostAddressType;
                
                WEAKSELF
                addressVc.sendAddress = ^(NSDictionary *dict)
                {
                    STRONGSELF
                    [strongSelf.personVC reloadTableViewWithDictionary:dict andType:_type];
                };
                
                [self.navigationController pushViewController:addressVc animated:YES];
            }
        }
    }
    else if(_type == RealEstatePlaceType)//房产地址
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                NSString *addressAddr = ((NSDictionary *)_tableDataArr[indexPath.section][indexPath.row]).allValues[0];
                
                NSString *addressAddrInt = ((NSDictionary *)_tableDataArr[indexPath.section][indexPath.row]).allKeys[0];
                
                [_houseVC reloadTableViewWithDictionary:@{@"addressAddr":addressAddr,@"addressAddrInt":addressAddrInt} andType:_type];
            }
            else if (indexPath.row == 1)
            {
                AddressDetailViewController *addressVc =[[AddressDetailViewController alloc]init];
                addressVc.addressType = HouseAddressType;
                
                WEAKSELF
                addressVc.sendAddress = ^(NSDictionary *dict)
                {
                    STRONGSELF
                    [strongSelf.houseVC reloadTableViewWithDictionary:dict andType:_type];
                };
                
                [self.navigationController pushViewController:addressVc animated:YES];
            }
        }
    }
    _tableBackView.hidden = YES;
}

#pragma mark - private methods
- (void)initTitleArray
{

    _titleArray = @[@"单位信息",@"个人信息",@"房产信息",@"联系人"];
   
}

- (void)initImageDict
{
    _imageDict = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < _titleArray.count; i++)
    {
        if(i == self.currentIndex)
        {
            [_imageDict setObject:[NSString stringWithFormat:@"%@-失败-选中",_titleArray[i]] forKey:_titleArray[i]];
        }
        else
        {
            [_imageDict setObject:[NSString stringWithFormat:@"%@-失败",_titleArray[i]] forKey:_titleArray[i]];
        }
    }
}

/**
 *  刷新按钮的背景图
 *  @param button 需要刷新的按钮 typeStr 用来取图片的key值
 */
- (void)reloadButtonImageWithButton:(UIButton *)button andTypeString:(NSString *)typeStr
{
    [button setImage:[UIImage imageNamed:[_imageDict objectForKey:typeStr]] forState:UIControlStateNormal];
}

- (void)refreshButtonState
{
    //对当前选择的按钮做处理
    if(_selectButton == _companyBtn)
    {
        self.currentIndex = 0;
        
        //将子视图控制器的View加载进来
        if([_baseView.subviews containsObject:_companyVC.view])
        {
            [_baseView bringSubviewToFront:_companyVC.view];
        }
        else
        {
            [_baseView addSubview:_companyVC.view];
        }
        
        NSString *str = [_imageDict objectForKey:@"单位信息"];
        [_imageDict setObject:[str stringByAppendingString:@"-选中"] forKey:@"单位信息"];
        [self reloadButtonImageWithButton:_companyBtn andTypeString:@"单位信息"];
    }
    else if (_selectButton == _personBtn)
    {
        self.currentIndex = 1;
        
        //将子视图控制器的View加载进来
        if([_baseView.subviews containsObject:_personVC.view])
        {
            [_baseView bringSubviewToFront:_personVC.view];
        }
        else
        {
            [_baseView addSubview:_personVC.view];
        }
        
        NSString *str = [_imageDict objectForKey:@"个人信息"];
        [_imageDict setObject:[str stringByAppendingString:@"-选中"] forKey:@"个人信息"];
        [self reloadButtonImageWithButton:_personBtn andTypeString:@"个人信息"];
    }
    else if (_selectButton == _houseBtn)
    {
        self.currentIndex = 2;
        
        //将子视图控制器的View加载进来
        if([_baseView.subviews containsObject:_houseVC.view])
        {
            [_baseView bringSubviewToFront:_houseVC.view];
        }
        else
        {
            [_baseView addSubview:_houseVC.view];
        }
        
        NSString *str = [_imageDict objectForKey:@"房产信息"];
        [_imageDict setObject:[str stringByAppendingString:@"-选中"] forKey:@"房产信息"];
        [self reloadButtonImageWithButton:_houseBtn andTypeString:@"房产信息"];
    }
    else
    {
        

        self.currentIndex = 3;
            
        //将子视图控制器的View加载进来
        if([_baseView.subviews containsObject:_contactVC.view])
        {
            [_baseView bringSubviewToFront:_contactVC.view];
        }
        else
        {
            [_baseView addSubview:_contactVC.view];
        }
        
        NSString *str = [_imageDict objectForKey:@"联系人"];
        [_imageDict setObject:[str stringByAppendingString:@"-选中"] forKey:@"联系人"];
        [self reloadButtonImageWithButton:_contactBtn andTypeString:@"联系人"];
        
        [self personDataRequest];
    }
}

- (void)showAlertWithMessage:(NSString *)message
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:message cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex)
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

- (void)addChildControls
{
    WEAKSELF
    //单位信息
    self.companyVC.showPikerViewShow = ^(ShowPickViewType type)
    {
        STRONGSELF
        [strongSelf createPikeViewWithType:type];
    };
    _companyVC.sendParmDict = ^(NSDictionary *parmDict)
    {
        STRONGSELF
        [strongSelf upLoadCompanyInfoWithParmDict:parmDict];
    };
    [self addChildViewController:_companyVC];
    
    //个人信息
    self.personVC.showPikerViewShow = ^(ShowPickViewType type)
    {
        STRONGSELF
        if(type != PermanentAddressType && type != PostalAddressType)
        {
            [strongSelf createPikeViewWithType:type];
        }
        else
        {
            [strongSelf createTableViewWithType:type];
        }
    };
    _personVC.sendParmDict = ^(NSDictionary *parmDict)
    {
        STRONGSELF
        [strongSelf upLoadPersonInfoWithParmDict:parmDict];
    };
    [self addChildViewController:_personVC];
    
    //房产信息

        _houseVC = [[HouseViewController alloc]init];
        _houseVC.showPikerViewShow = ^(ShowPickViewType type)
        {
            STRONGSELF
            if(type != RealEstatePlaceType)
            {
                [strongSelf createPikeViewWithType:type];
            }
            else
            {
                [strongSelf createTableViewWithType:type];
            }
        };
        _houseVC.sendParmDict = ^(NSDictionary *parmDict)
        {
            STRONGSELF
            [strongSelf upLoadHouseInfoWithParmDict:parmDict];
        };
        [self addChildViewController:_houseVC];
 
    
    //联系人信息
    self.contactVC.showPikerViewShow = ^(ShowPickViewType type)
    {
        STRONGSELF
        [strongSelf createPikeViewWithType:type];
    };
    _contactVC.sendParmDict = ^(NSArray *parmArray)
    {
        STRONGSELF
        [strongSelf upLoadContactInfoWithParmArray:parmArray];
    };
    
    [self addChildViewController:_contactVC];
    
    //先将当前选择的那一栏的view加载进来
    if([_titleArray[_currentIndex] isEqualToString:@"单位信息"])
    {
        [_baseView addSubview:_companyVC.view];
    }
    else if ([_titleArray[_currentIndex] isEqualToString:@"个人信息"])
    {
        [_baseView addSubview:_personVC.view];
    }
    else if ([_titleArray[_currentIndex] isEqualToString:@"房产信息"])
    {
        [_baseView addSubview:_houseVC.view];
    }
    else
    {
        [_baseView addSubview:_contactVC.view];
    }
}

//创建pikerView,并初始化数据源
- (void)createPikeViewWithType:(ShowPickViewType)type
{
    //创建数据源
    if(_pickDataArr)
    {
        [_pickDataArr removeAllObjects];
    }
    else
    {
        _pickDataArr = [[NSMutableArray alloc] init];
    }

    //记录当前选择器的类型
    _type = type;
    
    if(_type == WorkAddressCityPickType || _type == LiveAddressCityPickType || _type == RealEstatePlaceType)
    {
        SearchCityOrCode *transfor =[[SearchCityOrCode alloc]init];
        NSArray *provinceArr = [transfor provinceAll];
        
        [_pickDataArr addObject:provinceArr];
        
        if (_pickDataArr[0].count > 0)
        {
            NSString *strProvinceName = _pickDataArr[0][0];
            NSArray *cityArr = [transfor cityAllFromProv:strProvinceName];
            
            [_pickDataArr addObject:cityArr];
            
            if (_pickDataArr[1].count > 0)
            {
                NSString *strCityName = _pickDataArr[1][0];
                NSArray *areaArr = [transfor areaAllFromProv:strProvinceName andCityName:strCityName];
                
                [_pickDataArr addObject:areaArr];
            }
        }
        else
        {
            [self showAlertWithMessage:@"可选地址为空"];
        }
    }
    else if(type == JobType)
    {
        NSArray *positionArr = [self plistValuesWithType:@"POSITION"];
        
        if(positionArr.count > 0)
        {
            [_pickDataArr addObject:positionArr];
        }
        else
        {
            [self showAlertWithMessage:@"可选职务为空"];
        }
    }
    else if (type == IndustryType)
    {
        NSArray *comKindArr = [self plistValuesWithType:@"COM_KIND"];
        
        if(comKindArr.count > 0)
        {
            [_pickDataArr addObject:comKindArr];
        }
        else
        {
            [self showAlertWithMessage:@"可选行业性质为空"];
        }
    }
    else if (type == WorkType)
    {
        NSArray *positionOPTArr = [self plistValuesWithType:@"POSITION_OPT"];
        
        if(positionOPTArr.count > 0)
        {
            //要将字典项中的学生去掉
            NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:positionOPTArr];
            
            for(int i = 0; i < positionOPTArr.count; i++)
            {
                if([((NSDictionary *)positionOPTArr[i]).allValues[0] isEqualToString:@"学生"])
                {
                    [mArr removeObjectAtIndex:i];
                }
            }
            
            [_pickDataArr addObject:mArr];
        }
        else
        {
            [self showAlertWithMessage:@"可选从业性质为空"];
        }
    }
    else if (type == HighestDegreeType)
    {
        NSArray *educationArr = [self plistValuesWithType:@"EDU_TYP"];
        
        if(educationArr.count > 0)
        {
            [_pickDataArr addObject:educationArr];
        }
        else
        {
            [self showAlertWithMessage:@"可选最高学历为空"];
        }
    }
    else if (type == ResidencePickType)
    {
        NSArray *localResidArr = [self plistValuesWithType:@"LOCAL_RESID"];
        
        if(localResidArr.count > 0)
        {
            [_pickDataArr addObject:localResidArr];
        }
        else
        {
            [self showAlertWithMessage:@"可选户口性质为空"];
        }
    }
    else if (type == MarriedPickType)
    {
        NSArray *maritalStatusArr = [self plistValuesWithType:@"MARR_STS"];
        
        if(maritalStatusArr.count > 0)
        {
            [_pickDataArr addObject:maritalStatusArr];
        }
        else
        {
            [self showAlertWithMessage:@"可选婚姻性质为空"];
        }
    }
    else if (type == SupportNumberType)
    {
        NSMutableArray *providerNumArr = [[NSMutableArray alloc]init];
        
        for (int i=0; i<21; i++) {
            
            [providerNumArr addObject:[NSString stringWithFormat:@"%d",i]];
            
        }
        
        if(providerNumArr.count > 0)
        {
            [_pickDataArr addObject:providerNumArr];
        }
        else
        {
            [self showAlertWithMessage:@"可选供养人数为空"];
        }
    }
    else if (type == CreditCardsNumberType)
    {
        NSMutableArray *creditCountArr = [[NSMutableArray alloc]init];
        
        for (int i=0; i<21; i++) {
            
            [creditCountArr addObject:[NSString stringWithFormat:@"%d",i]];
            
        }
        
        if(creditCountArr.count > 0)
        {
            [_pickDataArr addObject:creditCountArr];
        }
        else
        {
            [self showAlertWithMessage:@"可选信用卡数量为空"];
        }
    }
    else if (type == ContactRelationType)
    {
        NSArray *relationTypeArray = [self plistValuesWithType:@"RELATION"];
        
        if(relationTypeArray.count > 0)
        {
            [_pickDataArr addObject:relationTypeArray];
        }
        else
        {
            [self showAlertWithMessage:@"可选的联系人关系为空"];
        }
    }
    else if (type == RealEstateSituationType || type == PersonEstateSituationType)
    {
        NSArray *liveInfoArr = [self plistValuesWithType:@"CURR_SITUATION"];
        
        if(liveInfoArr.count > 0)
        {
            [_pickDataArr addObject:liveInfoArr];
        }
        else
        {
            [self showAlertWithMessage:@"可选房产状况为空"];
        }
    }
    else if (type == ResidenceTimeType)
    {
        NSMutableArray *residenceTimeArr = [[NSMutableArray alloc]init];
        
        for (int i=0; i<51; i++) {
            
            [residenceTimeArr addObject:[NSString stringWithFormat:@"%d",i]];
            
        }
        
        if(residenceTimeArr.count > 0)
        {
            [_pickDataArr addObject:residenceTimeArr];
        }
        else
        {
            [self showAlertWithMessage:@"可选居住年限为空"];
        }
    }
    if (_pickerBackView && _pickerBackView.hidden == YES)
    {
        //根据数据源刷新
        _pickerBackView.hidden = NO;
        [_pickerViw reloadAllComponents];
        NSLog(@"%@",_pickDataArr);
        if (_pickDataArr.count == 3) {
             [_pickerViw selectRow:0 inComponent:0 animated:YES];
             [_pickerViw selectRow:0 inComponent:1 animated:YES];
             [_pickerViw selectRow:0 inComponent:2 animated:YES];
            
        }else{
            [_pickerViw selectRow:0 inComponent:0 animated:YES];
            
        }
        
    }
    else
    {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64)];
        backView.backgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5f];
        [self.view addSubview:backView];
        
        _pickerBackView = backView;
        
        _pickerViw = [[UIPickerView alloc]initWithFrame:CGRectMake(0, DeviceHeight-150*scaleAdapter-64, DeviceWidth, 150*scaleAdapter)];
        _pickerViw.dataSource = self;
        _pickerViw.delegate = self;
        _pickerViw.backgroundColor = [UIColor UIColorWithRed:243 green:243 blue:243 alpha:1.0];
        [backView addSubview:_pickerViw];
        
        //选择器上方的确定取消按钮
        UIView *groundView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight-200*scaleAdapter-64, DeviceWidth, 50*scaleAdapter)];
        groundView.backgroundColor = [UIColor colorWithRed:248 green:248 blue:248 alpha:1.0];

        [backView addSubview:groundView];
        
        UIButton *sureBtn  = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-65, 0, 35, 35)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:UIColorFromRGB(0x028ce5, 1.0) forState:UIControlStateNormal];
        sureBtn.tag = 76;
        sureBtn.titleLabel.font = [UIFont appFontRegularOfSize:14];
        [sureBtn addTarget:self action:@selector(creatSureAction:) forControlEvents:UIControlEventTouchUpInside];
        [groundView addSubview:sureBtn];
        
        UIButton *releaseBtn  = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 35, 35)];
        releaseBtn.tag = 77;
        releaseBtn.titleLabel.font = [UIFont appFontRegularOfSize:14];
        [releaseBtn setTitle:@"取消" forState:UIControlStateNormal];
        [releaseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [releaseBtn addTarget:self action:@selector(creatSureAction:) forControlEvents:UIControlEventTouchUpInside];
        [groundView addSubview:releaseBtn];
    }
}

//创建tableView,并初始化数据源
- (void)createTableViewWithType:(ShowPickViewType)type
{
    if(_tableDataArr)
    {
        [_tableDataArr removeAllObjects];
    }
    else
    {
        _tableDataArr = [[NSMutableArray alloc] init];
    }
    
    //记录当前选择器的类型
    _type = type;
    
    if(type == PermanentAddressType)//户籍地址
    {
        NSArray *array1 = @[@{@"Y":@"同住宅地址"},@{@"N":@"其他"}];
        NSArray *array2 = @[@{@"cancle":@"取消"}];
        
        [_tableDataArr addObject:array1];
        [_tableDataArr addObject:array2];
    }
    else if (type == PostalAddressType)
    {
        //通讯地址数组
        NSArray *array = [self plistValuesWithType:@"MAIL_ADDR"];
        NSMutableArray *Marray = [[NSMutableArray alloc] initWithArray:array];
        if([Marray containsObject:@{@"S":@"自提"}])
        {
            [Marray removeObject:@{@"S":@"自提"}];
        }
        
        NSArray *array1 = @[@{@"cancle":@"取消"}];
        
        [_tableDataArr addObject:Marray];
        [_tableDataArr addObject:array1];
    }
    else if (type == RealEstatePlaceType)
    {
        NSArray *array1 = @[@{@"10":@"同现住房地址"},@{@"30":@"其他"}];
        NSArray *array2 = @[@{@"cancle":@"取消"}];
        
        [_tableDataArr addObject:array1];
        [_tableDataArr addObject:array2];
    }
    if (_tableBackView && _tableBackView.hidden == YES)
    {
        _tableView.frame = CGRectMake(0, DeviceHeight-64-(_tableDataArr[0].count + _tableDataArr[1].count)*50*scaleAdapter - 10*scaleAdapter, DeviceWidth, (_tableDataArr[0].count + _tableDataArr[1].count) * 50 * scaleAdapter + 10*scaleAdapter);
        //根据数据源刷新
        _tableBackView.hidden = NO;
        [_tableView reloadData];
    }
    else
    {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64)];
        backView.backgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5f];
        [self.view addSubview:backView];
        
        _tableBackView = backView;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, DeviceHeight-64-(_tableDataArr[0].count + _tableDataArr[1].count)*50*scaleAdapter - 10*scaleAdapter, DeviceWidth, (_tableDataArr[0].count + _tableDataArr[1].count) * 50 * scaleAdapter + 10*scaleAdapter) style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableBackView addSubview:_tableView];
    }

}

//从沙盒中得到字典项
- (NSMutableArray *)plistValuesWithType:(NSString *)type
{
    // 在这里做判断，看看plist中有没有东西
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@person.plist",type]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if ([dict  valueForKey:type]) {
        return [dict  valueForKey:type];
    }else{
        return nil;
    }
}

#pragma mark -- setting and getting 
//单位信息
- (CompanyViewController *)companyVC {
    if (_companyVC == nil) {
        _companyVC = [[CompanyViewController alloc]init];
        
    }
    return _companyVC;
}
//个人信息
- (PersonViewController *)personVC {
    if (_personVC == nil) {
        _personVC = [[PersonViewController alloc]init];
        
    }
    return _personVC;
}

//房产信息
- (HouseViewController *)houseVC {
    if (_houseVC == nil) {
        _houseVC = [[HouseViewController alloc]init];
       
    }
    return _houseVC;
}

//联系人
- (ContactsViewController *)contactVC {
    if (_contactVC == nil) {
        _contactVC = [[ContactsViewController alloc]init];
        if (_ifFromTe) {
            _contactVC.ifFromTE = YES;
        }
        
    }
    return _contactVC;
}

@end
