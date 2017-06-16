//
//  AddNewBankViewController.m
//  personMerchants
//
//  Created by 百思为科 on 16/4/13.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "AddNewBankViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "BankNumberViewController.h"
#import "NSString+CheckConvert.h"
#import "BankIardInformation.h"
#import "BankNameModel.h"
#import "SupportBankViewController.h"
#import <MJExtension.h>
@interface AddNewBankViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BSVKHttpClientDelegate>{
    
    NSArray *fixArray;
    
    NSString *nameStr;//持卡人姓名
    UITextField * numberMessage;//卡号
    NSString *userID; // 账户名
}
@property(nonatomic,strong) UITableView *bankTableView;
@end

@implementation AddNewBankViewController
#pragma mark -- lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_bankType == FromEditBank) {
        self.title = @"编辑银行卡";
    }else{
        self.title = @"添加银行卡";
    }
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    fixArray = @[@"持卡人",@"身份证",@"卡号"];
    
    [self setLabel];//上面文字
    [self setTableView];//创建表
}
#pragma mark -- setting and getting
-(void)setLabel{
    UILabel *fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, DeviceWidth, 30*DeviceWidth/375)];
    fixedLabel.text = @"请绑定本人银行卡";
    fixedLabel.font = [UIFont appFontRegularOfSize:14];
    fixedLabel.textColor = UIColorFromRGB(0xf6f6f6f, 1.0);
    [self.view addSubview:fixedLabel];
}
-(void)setTableView{
    _bankTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30*DeviceWidth/375, DeviceWidth, 150) style:UITableViewStylePlain];
    _bankTableView.delegate = self;
    _bankTableView.dataSource = self;
    _bankTableView.scrollEnabled = NO;
    [self.view addSubview:_bankTableView];
    UIButton * next = [UIButton buttonWithType:(UIButtonTypeCustom)];
    if (iphone6P) {
        
        next.frame = CGRectMake(47 , CGRectGetMaxY(_bankTableView.frame)+ 40 * scaleAdapter, DeviceWidth - 94, 50);
       
        next.layer.cornerRadius = 25;
        
    }else{
        
        next.frame = CGRectMake(42 *DeviceWidth/375 , CGRectGetMaxY(_bankTableView.frame)+ 40 * scaleAdapter, DeviceWidth - 84 *DeviceWidth/375, 45*DeviceWidth/375);
        
        next.layer.cornerRadius = 22.5*DeviceWidth/375;
        
    }
    next.layer.masksToBounds = YES;
    next.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    next.tag = 10;
    [next setTitle:@"下一步" forState:(UIControlStateNormal)];
    next.tintColor = [UIColor whiteColor];
    [next addTarget:self action:@selector(nextButton:) forControlEvents:(UIControlEventTouchUpInside)];
    next.titleLabel.font = [UIFont appFontRegularOfSize:15];
    [self.view addSubview:next];
}

#pragma mark -- tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        UILabel *fixed = [[UILabel alloc]initWithFrame:CGRectMake(15*DeviceWidth/375, 0, DeviceWidth - 15*DeviceWidth/375, 50)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        fixed.tag = 11;
        [cell.contentView addSubview:fixed];
//        持卡人
        UILabel * chiKaRen = [[UILabel alloc]initWithFrame:(CGRectMake(20, 13, 60, 21))];
        [cell.contentView addSubview:chiKaRen];
        chiKaRen.font = [UIFont appFontRegularOfSize:15];
        chiKaRen.tag = 12;
//        名字
        UILabel *name = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(chiKaRen.frame) + 10, CGRectGetMinY(chiKaRen.frame), 100, 21))];
        name.font = [UIFont appFontRegularOfSize:15];
        [cell.contentView addSubview:name];
        name.tag = 13;
//        身份证
        UILabel *idCard = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMinX(chiKaRen.frame), 13, 62, 21))];
        
        idCard.font = [UIFont appFontRegularOfSize:15];
        idCard.tag = 14;
        [cell.contentView addSubview:idCard];
//        身份证信息
        UILabel * cardDetail = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(idCard.frame) + 10, 13, DeviceWidth - 60 - CGRectGetMaxX(idCard.frame) , 21))];
        cardDetail.tag = 15;
        cardDetail.font = [UIFont appFontRegularOfSize:15];
        [cell.contentView addSubview:cardDetail];
//        卡号
        UILabel * kaHao = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMinX(chiKaRen.frame), 13, 60, 21))];
        kaHao.font = [UIFont appFontRegularOfSize:15];
        kaHao.tag = 16;
        [cell.contentView addSubview:kaHao];
//        卡号信息
        UITextField *kaHaoMessage = [[UITextField alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(kaHao.frame) + 10, 13, DeviceWidth - CGRectGetMaxX(kaHao.frame) - (60 *scaleAdapter), 21)) ];
        kaHaoMessage.hidden =YES;
        kaHaoMessage.font = [UIFont appFontRegularOfSize:15];
        kaHaoMessage.tag = 17;
        if (_bankType == FromEditBank) {
            kaHaoMessage.text = [_bankCard convertToBankNum];
            kaHaoMessage.userInteractionEnabled = NO;
        }else{
            kaHaoMessage.userInteractionEnabled = YES;
        }
        [cell.contentView addSubview:kaHaoMessage];
        if (_bankType == FromEditBank) {
            kaHaoMessage.text = [_bankCard convertToBankNum];
            kaHaoMessage.userInteractionEnabled = NO;
        }else{
            kaHaoMessage.userInteractionEnabled = YES;
        }
        numberMessage.text = kaHaoMessage.text;
        
//        提示button
        UIButton * first = [UIButton buttonWithType:(UIButtonTypeCustom)];
        first.frame = CGRectMake(DeviceWidth - 35, 13, 22, 21);
        first.tag = 18;
        [first addTarget:self action:@selector(firstAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.contentView addSubview:first];
    }
    if (indexPath.row == 0) {
        UILabel * chiKaRen = [cell.contentView viewWithTag:12];
        chiKaRen.text = @"持卡人";
        UITextField * name = [cell.contentView viewWithTag:13];
        name.text = [AppDelegate delegate].userInfo.realName;
        UIButton *first = [cell.contentView viewWithTag:18];
        nameStr = name.text;
        [first setImage:[UIImage imageNamed:@"提示"] forState:(UIControlStateNormal)];
    }else if (indexPath.row == 1){
        UILabel *idCard = [cell.contentView viewWithTag:14];
        idCard.text = @"身份证";
        UILabel *cardDetail = [cell.contentView viewWithTag:15];
        cardDetail.text =  [[AppDelegate delegate].userInfo.realId convertToIdCardNum];
    }else if (indexPath.row == 2){
        UILabel * kaHao = [cell.contentView viewWithTag:16];
        kaHao.text = @"卡号";
        numberMessage = [cell.contentView viewWithTag:17];
        numberMessage.hidden = NO;
        numberMessage.placeholder = @"银行卡号";
        numberMessage.keyboardType = UIKeyboardTypeNumberPad;
        UIButton * second = [cell.contentView viewWithTag:18];
        [second setImage:[UIImage imageNamed:@"提示"] forState:(UIControlStateNormal)];
    }
    return cell;
}
#pragma mark - private Methods
- (void)firstAction:(UIButton*)sender{
    UITableViewCell *cell =(UITableViewCell *)[sender superview ].superview;
    NSIndexPath * indexpath = [_bankTableView indexPathForCell:cell];
    if (indexpath.row == 0) {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"持卡人说明" message:@"为了保证您的账户资金安全，只能帮您认证用户本人的银行卡" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
        
    }else if (indexpath.row == 2)
    {
        SupportBankViewController *supportVC = [[SupportBankViewController alloc] init];
        
        HCRootNavController *nav = [[HCRootNavController alloc] initWithRootViewController:supportVC];
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}
// 点击下一步
- (void)nextButton:(UIButton *)button{
    
    if (numberMessage.text.length == 0) {
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请输入银行卡号" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
        return;
        
    }else{
        
        NSMutableDictionary *bankDict = [[NSMutableDictionary alloc]init];
        if (numberMessage.text.length != 0) {
            
            BSVKHttpClient *client = [BSVKHttpClient shareInstance];
            
            if (_bankType == FromEditBank) {
                [bankDict setObject:_bankCard forKey:@"cardNo"];
            }else{
                [bankDict setObject:numberMessage.text forKey:@"cardNo"];
            }
            
            client.delegate = self;
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [client getInfo:@"app/appserver/crm/cust/getBankInfo" requestArgument:bankDict requestTag:250 requestClass:NSStringFromClass([self class])];
        }
    }
}
#pragma mark - Model解析
- (void)analySisBankNameModel:(BankNameModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        NSUInteger a = model.body.count;
        
        NSMutableString * newString = [NSMutableString string];
        
        for (int n = 0; n < a; n ++) {
            
            NSString * nameStrs = [NSString stringWithFormat:@"%@,",model.body[n].bankName];
            
            [newString appendString:nameStrs];
            
        }
        NSString * nameStrs = [NSString stringWithFormat:@"由于银行扣款需要，现仅支持%@，",newString];
        
        NSString * str = [nameStrs substringToIndex:nameStrs.length - 2];
        
        [self buildHeadError:str];
    }else{
        [self buildHeadError:model.head.retMsg];
    }
}
- (void)analySisBankIardInformation:(BankIardInformation *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        BankNumberViewController *real = [[BankNumberViewController alloc]init];
        
        real.mobile = _mobile;
        
        real.nameText = nameStr;
        
        real.idText = [AppDelegate delegate].userInfo.realId;
        
//        real.flowName = _flowName;
        
        if (_bankType == FromEditBank) {
            real.cardText = _bankCard;
        }else{
            real.cardText = numberMessage.text;
        }
        
        real.bankName = model.body.bankName;
        
        real.bankType = model.body.cardType;
        real.bankNo = model.body.bankNo;
        
        real.provinceCode = _provinceCode;
        real.cityCode = _cityCode;
        real.areaCode = _areaCode;//可能为空
        [self.navigationController pushViewController:real animated:YES];
        
    }else{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"系统暂不支持您认证的银行卡" cancelButtonTitle:@"查看支持银行" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0)
                {
                    SupportBankViewController *supportVC = [[SupportBankViewController alloc] init];
                    
                    HCRootNavController *nav = [[HCRootNavController alloc] initWithRootViewController:supportVC];
                    
                    [strongSelf.navigationController presentViewController:nav animated:YES completion:nil];
                }
            }
        }];

    }
}
#pragma mark - BSVK delegate
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {

    if (requestTag == 250){
        
           BankIardInformation *model =  [BankIardInformation mj_objectWithKeyValues:responseObject];
        
           [self analySisBankIardInformation:model];
        }
    }
}
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
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
