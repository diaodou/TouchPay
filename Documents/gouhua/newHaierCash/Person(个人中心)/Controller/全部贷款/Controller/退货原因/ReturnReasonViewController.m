//
//  ReturnReasonViewController.m
//  personMerchants
//
//  Created by 百思为科 on 2017/4/14.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "ReturnReasonViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "RMUniversalAlert.h"
#import "BSVKHttpClient.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "UIButton+UnifiedStyle.h"

#import "ReturnApplyModel.h"
#import "ReturnReasonModel.h"
static const CGFloat returnCargo = 1;           //退货申请
static const CGFloat selectReason = 2;          //退货原因
@interface ReturnReasonViewController ()<UITableViewDelegate,UITableViewDataSource,BSVKHttpClientDelegate>{

    NSInteger current;
}

@property(nonatomic,strong)UITableView * reasonTableView;
@property(nonatomic,strong)NSMutableArray *array;
@end

@implementation ReturnReasonViewController

#pragma mark - left cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"退货";
    self.view.backgroundColor = [UIColor whiteColor];
    current = _array.count;
    [self setNavi];
    
    [self queryReturnReason];
}

#pragma mark - private Methods
- (void)setNavi{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = ReturnRect;
    [btn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)OnBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setTopView{

    UIView *bjView = [[UIView alloc]init];
    UILabel * fixedLabel = [[UILabel alloc]init];
    if (iphone6P) {
        bjView.frame = CGRectMake(0, 0, DeviceWidth, 42);
        fixedLabel.frame = CGRectMake(25, 0, DeviceWidth, 42);
        fixedLabel.font = [UIFont appFontRegularOfSize:15];
    }else{
        bjView.frame = CGRectMake(0, 0, DeviceWidth, 37);
        fixedLabel.frame = CGRectMake(16 *scaleAdapter, 0, DeviceWidth, 37);
        fixedLabel.font = [UIFont appFontRegularOfSize:14];
    }
    fixedLabel.text = @"退货原因*";
    NSMutableAttributedString * fixedStr = [[NSMutableAttributedString alloc]initWithString:fixedLabel.text];
    NSRange range = [[fixedStr string]rangeOfString:@"*"];
    [fixedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    fixedLabel.attributedText = fixedStr;
    [bjView addSubview:fixedLabel];
    bjView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    [self.view addSubview:bjView];
}
- (void)setTableView{

    _reasonTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 37, DeviceWidth, DeviceHeight - 64 - 37) style:UITableViewStylePlain];
    _reasonTableView.delegate = self;
    _reasonTableView.dataSource = self;
    _reasonTableView.backgroundColor = [UIColor whiteColor];
    _reasonTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _reasonTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_reasonTableView];
}
- (void)setTableViewFootView{

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 100)];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (iphone6P) {
        
        btn.frame = CGRectMake(25, 55, DeviceWidth - 50, 45);
    }else{
    
        btn.frame = CGRectMake(16 *scaleAdapter, 60, DeviceWidth - 32 *scaleAdapter, 40);
    }
    
    [btn setButtonTitle:@"提交申请" titleFont:14 buttonHeight:CGRectGetHeight(btn.frame)];
    
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:btn];
    
    _reasonTableView.tableFooterView = bottomView;
}
- (void)backLastViewController{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"returnSuccess" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
// 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_reasonTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_reasonTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_reasonTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_reasonTableView setLayoutMargins:UIEdgeInsetsZero];
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
// 提交申请
- (void)submit{
    
    if (current == _array.count) {
        
        [self buildHeadError:@"请先选择退货原因"];
        
        return;
    }
    
    [self querySubmitReturn];
    
}
#pragma mark - set Request
- (void)querySubmitReturn{

    NSDate * date = [NSDate date];
    
    NSDateFormatter *fornatter = [[NSDateFormatter alloc]init];
    
    [fornatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString * currentTimeStr = [fornatter stringFromDate:date];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:StringOrNull(_applseq) forKey:@"applSeq"];
    
    [dic setObject:StringOrNull(_array[current]) forKey:@"returnReason"];
    
    [dic setObject:StringOrNull(currentTimeStr) forKey:@"applDt"];
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]postInfo:@"app/appserver/apporder/returnGoods" requestArgument:dic requestTag:returnCargo requestClass:NSStringFromClass([self class])];
}
- (void)queryReturnReason{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/appmanage/returnreason/selectReason" requestArgument:nil requestTag:selectReason requestClass:NSStringFromClass([self class])];
}
#pragma mark - UItabelView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iphone6P) {
        return 50;
    }else{
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, DeviceWidth - 50, 50)];
        label.font = [UIFont appFontRegularOfSize:15];
        label.textColor = UIColorFromRGB(0x333333, 1.0);
        if (!(iphone6P)) {
            label.frame = CGRectMake(16 *scaleAdapter, 0, DeviceWidth - 25 - 16 *scaleAdapter, 45);
            label.font = [UIFont appFontRegularOfSize:14];
        }
        label.tag = 11;
        [cell.contentView addSubview:label];
    }
    UILabel * nameLabel = [(UILabel *)cell.contentView viewWithTag:11];
    nameLabel.text = _array[indexPath.row];
    if (indexPath.row == current) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_reasonTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (current == indexPath.row) {
        
        current = _array.count;
    }else{
        current = indexPath.row;
    }
    [_reasonTableView reloadData];
}
#pragma mark - BSVK Delegate
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{

    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (requestTag == returnCargo) {
            
            ReturnApplyModel *model = [ReturnApplyModel mj_objectWithKeyValues:responseObject];
            
            [self analyReturnReasonModel:model];
        }else if (requestTag == selectReason){
        
            ReturnReasonModel *model = [ReturnReasonModel mj_objectWithKeyValues:responseObject];
            
            [self analySisReturnReasonModel:model];
        }
    }
}
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
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
#pragma mark - Model解析
- (void)analyReturnReasonModel:(ReturnApplyModel *)model{

    if ([model.head.retFlag isEqualToString:SucessCode]) {
        [AppDelegate delegate].userInfo.bReturn = NO;
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"申请成功" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex)
         {
             STRONGSELF
             if (strongSelf)
             {
                 if (buttonIndex == 0)
                 {
                     [strongSelf backLastViewController];
                 }
             }
         }];
    }else{
    
        [self buildHeadError:model.head.retMsg];
    }
}
- (void)analySisReturnReasonModel:(ReturnReasonModel *)model{

    if ([model.head.retFlag isEqualToString:SucessCode]) {
        
        _array = [[NSMutableArray alloc]initWithCapacity:0];
        
        for (int n = 0; n < model.body.count; n ++) {
            
            NSString * str = model.body[n].reason;
            
            [_array addObject:str];
            
        }
        if (_array && _array.count > 0) {
            
            [self setTopView];
            [self setTableView];
            [self setTableViewFootView];
        }else{
        
            [self buildHeadError:@"未查询到信息"];
        }
    }else{
    
        [self buildHeadError:model.head.retMsg];
    }
}
@end
