//
//  RootViewController.m
//  读取通讯录
//
//  Created by mac on 15/4/16.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import "ContactRootViewController.h"
#import "ReadManager.h"
#import "AddressBook.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "BSVKHttpClient.h"
#import "DetailsViewController.h"
#import "AppDelegate.h"
#import "PhoneModel.h"
#import "EnterAES.h"
#import "NSString+CheckConvert.h"
@interface ContactRootViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SendPhoneDelegate,BSVKHttpClientDelegate>
{
    NSMutableArray* _dataSource;
    
    UITableView* _tableView;
    
    AddressBook * addressBook;
    
    UITextField *_serchTextField;
    
    UIImageView *imageView1;
    
    NSInteger kill;
    
    NSInteger tom;
    
    //
    
    NSArray *_oldArray;
    
    NSArray *tempArr;
    
}

@end

@implementation ContactRootViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"联系人";
    
    [self setNavi];
    
    kill = 0;
    
    tom = 0;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    self.view.backgroundColor = [UIColor UIColorWithHexColorString:@"0xf6f6f6" AndAlpha:1.0];
    
    _newaArray = [[NSMutableArray alloc]init];
    
 }


#pragma mark --> setting and getting

-(void)setNewaArray:(NSMutableArray *)newaArray{
    
    _newaArray = newaArray;
    
    tempArr = [[NSArray alloc]initWithArray:newaArray];
    
    _dataSource  =[NSMutableArray arrayWithArray:_newaArray];
    //B类  和 社会化 才采集影像
    if ([AppDelegate delegate].userInfo.whiteType == WhiteB || [AppDelegate delegate].userInfo.whiteType == WhiteSocityReason || [AppDelegate delegate].userInfo.whiteType == WhiteSocityNoReason || [AppDelegate delegate].userInfo.whiteType == WhiteCReason || [AppDelegate delegate].userInfo.whiteType == WhiteCNoReason) {
         [self buildPostInfo];
    }
    
    _oldArray = [NSArray arrayWithArray:_newaArray];
    
    [self createTable];
    
    [self createSearchView];
}

//外部风险信息采集联系人采集
-(void)buildPostInfo{
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (dele.userInfo.realId  && dele.userInfo.realId.length > 0) {
        
        [parm setObject:[EnterAES simpleEncrypt:dele.userInfo.realId] forKey:@"idNo"];
        
    }
    
    [parm setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realTel] forKey:@"mobile"];
    
    [parm setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realName] forKey:@"name"];
    
    [parm setObject:@"02" forKey:@"dataTyp"];
    
    [parm setObject:@"2" forKey:@"source"];
    
    NSMutableArray *jackArray = [[NSMutableArray alloc]init];
    
    for (AddressBook *address in _dataSource) {
        
        NSString *phoneString;
        
        NSMutableString *string = [NSMutableString stringWithFormat:@"%@",address.fullName];
        
        if (address.phone.count > 0) {
            
            for (PhoneModel *model in address.phone) {
                
                NSString * nameStr = model.telName;
                
                NSString * telStr = model.telNo;
                
                phoneString = [NSString stringWithFormat:@"%@%@",nameStr,telStr];
                
                [string appendFormat:@",%@",[self SeparatedByString:[NSMutableString stringWithString:StringOrNull(phoneString)]]];
                
            }
            
        }
        
        [jackArray addObject:string];
        
    }
    
    if (jackArray && jackArray.count > 0) {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (int i=1; i<jackArray.count; i++) {
            NSString *jack=[EnterAES simpleEncrypt:jackArray[i]];
            [array addObject:jack];
        }
        
        
        
       [parm setObject:array forKey:@"content"];
        
    }
    [[BSVKHttpClient shareInstance]postInfo:@"app/appserver/updateRiskInfo" requestArgument:parm completion:^(id results, NSError *error) {
        
        NSDictionary *dic = (NSDictionary *)results;
        
        NSLog(@"head = %@",[[[dic objectForKey:@"response"]objectForKey:@"head"]objectForKey:@"retFlag"]);
        
    }];
    
    
    
}

#pragma mark --> 网络请求代理方法
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        NSLog(@"%@",responseObject);
        
    }
    
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        
        
    }
    
}

#pragma mark --> private Methods

//当搜索框里的内容发生变化时调用此方法
-(void)textValueChange{
    
    [self creatSerchView:_serchTextField.text];
    
}

#pragma private Methods

//电话格式
-(NSString *)SeparatedByString:(NSMutableString*)string{
    
    for (int i = 0; i < string.length; i ++) {
        
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        if ([s isEqualToString:@"-"]) {
            
            [string deleteCharactersInRange:NSMakeRange(i, 1)];
            
        }
        
    }
    
    NSString *killJack = [NSString stringWithString:string];
    
    return killJack;
}


-(void)creatSerchView:(NSString *)much{
    
    NSString *string = much;
    
    if (_dataSource) {
        
        [_dataSource removeAllObjects];
        
        [_dataSource addObjectsFromArray:_oldArray];
        
    }else{
        _dataSource = [NSMutableArray arrayWithArray:_oldArray];
    }
    
    if (string.length>0) {
        
        //创建谓词条件
       
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",string];
        
        NSArray *array = [NSArray arrayWithArray:_dataSource];
        
        NSMutableArray *stringArray = [[NSMutableArray alloc]init];
        
        for (AddressBook *book in array) {
            
            [stringArray addObject:StringOrNull(book.fullName)];
        }
        
        //筛选出来的数据创建新的数组
        NSArray *kills = [stringArray filteredArrayUsingPredicate:predicate];
        
        NSMutableArray *jay = [[NSMutableArray alloc]init];
        
        for (int i=0; i<array.count; i++) {
            
            [jay addObject:@"NO"];
            
        }
        
        for (int i=0; i<array.count; i++) {
            
            AddressBook *book = _dataSource[i];
            
            NSString *lucy = book.fullName;
            
            NSInteger num = 0;
            
            for (int j=0; j< kills.count; j++) {
                
                NSString *moun = kills[j];
                
                if ([moun isEqualToString:lucy]) {
                    
                    num++;
                    
                }
                
            }
            
            if (num!=1) {
                
                [jay replaceObjectAtIndex:i withObject:@"YES"];
                
            }
            
        }
        NSInteger laker = _dataSource.count;
        
        NSInteger like = 0;
        
        for (int i=0; i<laker; i++) {
            
            NSString *mom = jay[like];
            
            if ([mom isEqualToString:@"YES"]) {
                
                [_dataSource removeObjectAtIndex:like];
                
                [jay removeObjectAtIndex:like];
                
            }else{
                
                like++;
            }
            
            
        }
        
        
    }
    
    
    //刷新表示图
    
    [_tableView reloadData];
    
    
}


#pragma mark -->搜索框方法
//搜索框方法
-(void)createSearchView{
    
    //搜索框
    _serchTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth-69, 28)];
    
    _serchTextField.backgroundColor = [UIColor whiteColor];
    
    _serchTextField.placeholder = @"搜索联系人";
    
    _serchTextField.textAlignment=NSTextAlignmentCenter;
    
    _serchTextField.returnKeyType = UIReturnKeySearch;
    
    _serchTextField.backgroundColor=[UIColor UIColorWithHexColorString:@"0xffffff" AndAlpha:1.0];
    
    _serchTextField.delegate = self;
    
    _serchTextField.font = [UIFont systemFontOfSize:12];
    
    //    _serchTextField.layer.cornerRadius=14;
    
    UIView *_view1=[[UIView alloc]initWithFrame:CGRectMake(8, 6.5, DeviceWidth-16, 28)];
    
    _view1.backgroundColor=[UIColor UIColorWithHexColorString:@"0x32beff" AndAlpha:1.0];
    
    _view1.layer.masksToBounds = YES;
    
    _view1.layer.cornerRadius=14;
    
    imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-50, 6, 14, 14)];
    
    //自适应图片宽高比例
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView1.image=[UIImage imageNamed:@"搜索"];
    
    imageView1.backgroundColor=[UIColor UIColorWithHexColorString:@"0x32beff" AndAlpha:1.0];
    
    [imageView1 setUserInteractionEnabled:YES];
    // 贾文磊 17.5.15修改  解决搜索按钮不灵敏问题
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(DeviceWidth-70, 0, 55, 28);
        
    [btn addTarget:self action:@selector(textValueChange) forControlEvents:UIControlEventTouchUpInside];

    [_view1 addSubview:_serchTextField];
    
    [_view1 addSubview:imageView1];
    
    [_view1 addSubview:btn];
    [self.view addSubview:_view1];
}


-(void)createTable{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, DeviceWidth, DeviceHeight-64-40) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.tag = 20;
    
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}
#pragma mark -- UITableViewDelegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identify = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        
        UIView *light = [[UIView alloc]initWithFrame:CGRectMake(0, 44, DeviceWidth, 1)];
        
        light.backgroundColor = [UIColor UIColorWithHexColorString:@"0xf6f6f6" AndAlpha:1.0];
        
        [cell.contentView addSubview:light];
    }
    
    addressBook = _dataSource[indexPath.row];
    
    cell.textLabel.text = addressBook.fullName;
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressBook  *book = _dataSource[indexPath.row];
    
    kill = 1;
    
    
    if (_kiss == 1) {
        
        [_delegate sendName:book.fullName];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }else if (_kiss ==2){
        
        DetailsViewController *control = [[DetailsViewController alloc]init];
        
        control.address = book;
        
        control.delegate = self;
        
        [self.navigationController pushViewController:control animated:YES];
        
    }
    
   
    
}

-(void)sendPhone:(NSString *)number{
    
    tom = 1;
    
    number = [number buildPrefixString];
        
    [self dismissViewControllerAnimated:YES completion:^{
            [_delegate sendPhone:number];
    }];
    
}

#pragma mark --> textField的代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self creatSerchView:textField.text];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        _dataSource  =[NSMutableArray arrayWithArray:tempArr];
        [_tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置导航
- (void)setNavi {
//    UIButton * _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _backBtn.frame = ReturnRect;
//    [_backBtn setImage:[UIImage imageNamed:@@"返回_黑"] forState:UIControlStateNormal];
//    [_backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -3 , 0, 0);
    backBtn.imageView.image = [UIImage imageNamed:@"返回_黑"];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
}

- (void)OnBackBtn:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendPhoneNumBack)]) {
        [self.delegate sendPhoneNumBack];
    }
}


@end
























































