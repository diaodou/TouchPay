//
//  AddressDetailViewController.m
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/4/19.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "SearchCityOrCode.h"
#import "RMUniversalAlert.h"
@interface AddressDetailViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

{
    
    UILabel *_cityLab;//城市lab
    
    UITextField *_addressText;//街道地址
    
    float x;//适应屏幕比例
    
    UIPickerView *_cityPickerViw;//城市地址选择器
    
    NSArray *_dataList;//盛放城市名称的数组
    
    UIView *_groundView;
    NSString * area ;//地区
    NSString *city;//城市
    NSString * province;//省份
    NSString *provinceCode ;//省code
    NSString *cityCode ;//市code
    NSString *areaCode ;//区code
    
    NSString *strProvinceNameTemp;
}
//省 数组
@property (strong, nonatomic) NSArray *provinceArr;
//城市 数组
@property (strong, nonatomic) NSArray *cityArr;
//区县 数组
@property (strong, nonatomic) NSArray *areaArr;

@end

@implementation AddressDetailViewController


#pragma mark --> life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"地址";
    
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    x = DeviceWidth/375.0;
    
    [self creatAddressView];
    
    [self creatLeftBtn];
    
    [self creatCityPickerView];
    
    [self creatGroundView];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


#pragma mark --> private Cycle


//创建导航栏右侧按钮

-(void)creatLeftBtn{
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(buildSuccessAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = bar;
    
    
}


//创建地址视图
-(void)creatAddressView{
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 10*x, DeviceWidth, 90)];
    
    whiteView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:whiteView];
    
    
    //创建灰色横线
    UIView *light = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 1)];
    
    light.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [whiteView addSubview:light];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 45, DeviceWidth, 1)];
    
    line.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [whiteView addSubview:line];
    
    UIView *last = [[UIView alloc]initWithFrame:CGRectMake(0, 89, DeviceWidth, 1)];
    
    last.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [whiteView addSubview:last];
    
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(25*x, 0, 100*x, 45)];
    
    if(self.addressType == RegAddressType)
    {
        nameLab.text = @"户籍地址";
    }else if (self.addressType == PostAddressType)
    {
        nameLab.text = @"通讯地址";
    }else if (self.addressType == HouseAddressType)
    {
        nameLab.text = @"房产地址";
    }
    
    nameLab.font = [UIFont appFontRegularOfSize:15];
    
    nameLab.userInteractionEnabled = YES;
    
    [whiteView addSubview:nameLab];
    
    UILabel *addressLab = [[UILabel alloc]initWithFrame:CGRectMake(25*x, 57.5, 100*x, 20)];
    
    addressLab.text  =@"详细地址";
    
    addressLab.font = [UIFont appFontRegularOfSize:15];
    
    [whiteView addSubview:addressLab];
    
    
    _cityLab = [[UILabel alloc]initWithFrame:CGRectMake(115*x, 0, DeviceWidth-135*x, 45)];
    
    _cityLab.font = [UIFont appFontRegularOfSize:15];
    
    _cityLab.text = @"省市区";
    
    _cityLab.userInteractionEnabled = YES;
    
    [whiteView addSubview:_cityLab];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-20, 14, 10, 15)];
    
    imgView.image = [UIImage imageNamed:@"灰色箭头"];
    
    imgView.userInteractionEnabled = YES;
    
    [whiteView addSubview:imgView];
    
    _addressText = [[UITextField alloc]initWithFrame:CGRectMake(115*x, 57.5, DeviceWidth-115*x, 20)];
    
    _addressText.font = [UIFont appFontRegularOfSize:15];
    
    _addressText.placeholder = @"街道门牌号";
    
    [whiteView addSubview:_addressText];
    
    UITapGestureRecognizer *gest1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buildPickerHidden)];
    
    [nameLab addGestureRecognizer:gest1];
    
    UITapGestureRecognizer *gest2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buildPickerHidden)];
    
    [_cityLab addGestureRecognizer:gest2];
    
    UITapGestureRecognizer *gest3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buildPickerHidden)];
    
    [imgView addGestureRecognizer:gest3];
    
}

//创建城市地址选择器
-(void)creatCityPickerView{

    SearchCityOrCode *transfor =[[SearchCityOrCode alloc]init];
    
    self.provinceArr = [transfor provinceAll];
    
    if (self.provinceArr.count > 0) {
        NSString *strProvinceName = self.provinceArr[0];
        
        self.cityArr = [transfor cityAllFromProv:strProvinceName];
        
        if (self.cityArr.count > 0) {
            NSString *strCityName = self.cityArr[0];
            self.areaArr = [transfor areaAllFromProv:strProvinceName andCityName:strCityName];
            
            _cityPickerViw = [[UIPickerView alloc]initWithFrame:CGRectMake(0, DeviceHeight-64-200*x, DeviceWidth, 200*x)];
            
            _cityPickerViw.dataSource =self;
            
            _cityPickerViw.delegate = self;
            
            _cityPickerViw.hidden = YES;
            
            _cityPickerViw.backgroundColor = [UIColor colorWithRed:243 green:243 blue:243 alpha:1.0];
            
            [self.view addSubview:_cityPickerViw];
        }
        
    }
    
    
    
}

//创建确定和取消按钮

-(void)creatGroundView{
    
    _groundView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight-200*x-64, DeviceWidth, 50*x)];
    
    _groundView.backgroundColor = [UIColor colorWithRed:248 green:248 blue:248 alpha:1.0];
    
    _groundView.hidden = YES;
    
    [self.view addSubview:_groundView];
    
    UIButton *sureBtn  = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-65, 0, 35, 35)];
    
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];

    [sureBtn setTitleColor:[UIColor colorWithRed:27 green:156 blue:253 alpha:1.0] forState:UIControlStateNormal];
    
    sureBtn.tag = 76;
    
    sureBtn.titleLabel.font = [UIFont appFontRegularOfSize:14];
    
    [sureBtn addTarget:self action:@selector(creatSureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_groundView addSubview:sureBtn];
    
    UIButton *releaseBtn  = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 35, 35)];
    
    releaseBtn.tag = 77;
    
    releaseBtn.titleLabel.font = [UIFont appFontRegularOfSize:14];
    
    [releaseBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [releaseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [releaseBtn addTarget:self action:@selector(creatSureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_groundView addSubview:releaseBtn];
    
}




#pragma mark --> event Methods

//点击完成方法

-(void)buildSuccessAction:(UIButton *)sender{
    
    
    NSString *kiss = _cityLab.text;
    
    if ([_cityLab.text isEqualToString:@"省市区"]) {
        
        kiss = @"";
        
    }
    
    NSString *kill = _addressText.text;
    
    if (kill.length > 0 && kiss.length > 0)
    {
        SearchCityOrCode *search =[[SearchCityOrCode alloc]init];
        BOOL isMatch = [search isMatchWithProvince:province andCity:city andAera:area];
        
        if(!isMatch)
        {
            NSString *alert;
            if(self.addressType == RegAddressType)
            {
                alert = @"户籍地址省市区不匹配,请重新选择";
            }else if (self.addressType == PostAddressType)
            {
                alert = @"通讯地址省市区不匹配,请重新选择";
            }else if (self.addressType == HouseAddressType)
            {
                alert = @"房产地址省市区不匹配,请重新选择";
            }
            
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:alert cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                
            }];
            return;
        }

        
    
        //将选择的地址传回去
    
        NSString *address = [NSString stringWithFormat:@"%@%@",kiss,_addressText.text];
        
        self.sendAddress(@{@"address":StringOrNull(address),@"addressPrivonce":StringOrNull(provinceCode),@"addressCity":StringOrNull(cityCode),@"addressArea":StringOrNull(areaCode),@"addressDetail":StringOrNull(_addressText.text)});
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
      WEAKSELF
        
      [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请完善所有信息" cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
          
        STRONGSELF
          
          if (strongSelf ) {
              
              return ;
              
          }
          
      }];
        
    }
    
    
    
   
    
}

//显示城市选择视图
-(void)buildPickerHidden{
    
    _cityPickerViw.hidden = NO;
    
    _groundView.hidden = NO;
    
    [_addressText resignFirstResponder];
    
}

//点击确定，取消执行的方法
-(void)creatSureAction:(UIButton *)sender{
    
    if (sender.tag == 76) {
        
        NSInteger one = [_cityPickerViw selectedRowInComponent:0];
        
        NSInteger two = [_cityPickerViw selectedRowInComponent:1];
        
        NSInteger three = [_cityPickerViw selectedRowInComponent:2];
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
        NSString *text = [NSString stringWithFormat:@"%@%@%@",cityName,twoString,areaName];
        province = cityName;
        city = twoString;
        area = areaName;
        _cityLab.text = text;
        SearchCityOrCode *transfor =[[SearchCityOrCode alloc]init];
        provinceCode = [transfor searchCode:cityName provinceCode:@"" cityCode:@"" type:typeProvince];
        cityCode = [transfor searchCode:twoString provinceCode:provinceCode cityCode:@"" type:typeCity];
        areaCode = [transfor searchCode:areaName provinceCode:provinceCode cityCode:cityCode type:typeArea];
    }
    
    
    
    
    
    
    
    
    _cityPickerViw.hidden = YES;
    
    _groundView.hidden = YES;
    
    
    
}


#pragma mark --> pickerView的代理方法

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


@end
