//
//  HCCommitOffLineOrderController.m
//  newHaierCash
//
//  Created by Will on 2017/6/15.
//  Copyright © 2017年 haier. All rights reserved.
//
#import "HCCommitOffLineOrderController.h"

#import "AppDelegate.h"

#import "HCMacro.h"
#import "NSString+CheckConvert.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import "HCOrderViewModel.h"

#import "HCTextInfoCell.h"
#import "HCChangeNumCell.h"
#import "HCOrderInfoCell.h"

@interface HCCommitOffLineOrderController ()<UITableViewDataSource,UITableViewDelegate,
HCChangeNumCellDelegate,HCTextInfoCellDelegate> {
    UITableView *_orderTable;
    
    UIView *_bottomView;
    UILabel *_bTotalReplayLbl;
    UILabel *_bTotalInterestLbl;
    UIButton *_commitBtn;
    
    CGFloat _viewScale;
    NSArray *_menuDataArray;
    NSArray *_otherDataArray;
    NSArray *_dataArray;
    BOOL _isReturnedByCredit; //是否是信贷退回
    
    HCOrderViewModel *_orderModel;
    BusFlowName _flowName;
    
    
}

@end

@implementation HCCommitOffLineOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    self.view.backgroundColor = [UIColor UIColorWithHexColorString:@"#eeeeee" AndAlpha:1];
    self.title = NSLocalizedString(@"订单提交", nil);
    
    _orderModel = [HCOrderViewModel new];
    _otherDataArray = @[@[NSLocalizedString(@"名称和型号", nil),NSLocalizedString(@"商品品牌", nil),NSLocalizedString(@"商品类型", nil),NSLocalizedString(@"购买数量", nil)],@[NSLocalizedString(@"借款金额", nil),NSLocalizedString(@"分期方式", nil)],@[NSLocalizedString(@"还款计划", nil),NSLocalizedString(@"还款卡", nil)],@[NSLocalizedString(@"商家", nil)],@[NSLocalizedString(@"送货地址", nil)]];  //11
    _menuDataArray = @[@[NSLocalizedString(@"名称和型号", nil),NSLocalizedString(@"商品品牌", nil),NSLocalizedString(@"商品类型", nil),NSLocalizedString(@"购买数量", nil)],@[NSLocalizedString(@"套餐", nil),NSLocalizedString(@"分期方式", nil),NSLocalizedString(@"借款金额", nil)],@[NSLocalizedString(@"还款计划", nil),NSLocalizedString(@"默认还款卡", nil)],@[NSLocalizedString(@"商家", nil)],@[NSLocalizedString(@"送货地址", nil)]]; //10
    
    if (self.scantype == GoodsHasMenuEnter) {
        _dataArray = _menuDataArray;
    } else {
        _dataArray = _otherDataArray;
    }
    _flowName = [AppDelegate delegate].userInfo.busFlowName;
    _isReturnedByCredit = _flowName == GoodsReturnedByCredit;
    
    [self _createOrderTable];
    [self _creatBottomView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _orderTable.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64 - 50 * _viewScale);
    
    _bottomView.frame = CGRectMake(0, DeviceHeight - 64 - 50 * _viewScale, DeviceWidth, 50 * _viewScale);
    _bTotalReplayLbl.frame = CGRectMake(20 * _viewScale, 9 * _viewScale, DeviceWidth*2/3 - 30 * _viewScale, 16 * _viewScale);
    _bTotalInterestLbl.frame = CGRectMake(20 * _viewScale, 31, DeviceWidth*2/3 - 30 * _viewScale, 12 * _viewScale);
    _commitBtn.frame = CGRectMake(DeviceWidth*2/3, 0, DeviceWidth/3, 50);
    
}

#pragma mark - Private Method
//绘制UI
- (void)_createOrderTable {
    _orderTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _orderTable.delegate = self;
    _orderTable.dataSource = self;
    _orderTable.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self.view addSubview:_orderTable];
    _orderTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _orderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_orderTable registerClass:[HCTextInfoCell class] forCellReuseIdentifier:NSStringFromClass([HCTextInfoCell class])];
    [_orderTable registerClass:[HCChangeNumCell class] forCellReuseIdentifier:NSStringFromClass([HCChangeNumCell class])];
    
    [_orderTable registerClass:[HCOrderInfoCell class] forCellReuseIdentifier:NSStringFromClass([HCOrderInfoCell class])];
}

- (void)_creatBottomView{
    _bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.layer.borderColor = UIColorFromRGB(0xe0e0e0, 1.0).CGColor;
    _bottomView.layer.borderWidth = 1.0f;
    [self.view addSubview:_bottomView];
    //    还款总额
    _bTotalReplayLbl = [[UILabel alloc]init];
    _bTotalReplayLbl.font = [UIFont appFontRegularOfSize:15 * _viewScale];
    _bTotalReplayLbl.attributedText = [self _getAttributeTextWithMoney:@"6199.00" andContent:@"还款总额：6199.00元"];
    [_bottomView addSubview:_bTotalReplayLbl];
    //  息费
    _bTotalInterestLbl = [[UILabel alloc]init];
    _bTotalInterestLbl.font = [UIFont appFontRegularOfSize:10 * _viewScale];
    _bTotalInterestLbl.attributedText =  [self _getAttributeTextWithMoney:@"6199.00" andContent:@"还款总额：6199.00元"];
    [_bottomView addSubview:_bTotalInterestLbl];
    //   按钮
    _commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_commitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(_commitBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitBtn setBackgroundColor:[UIColor colorWithRed:0.0 green:0.5158 blue:1.0 alpha:1.0]];
    _commitBtn.titleLabel.font = [UIFont appFontRegularOfSize:16 * _viewScale];
    [_bottomView addSubview:_commitBtn];
}

- (NSMutableAttributedString *)_getAttributeTextWithMoney:(NSString *)money andContent:(NSString *)content {
    NSMutableAttributedString *moneyString = [[NSMutableAttributedString alloc]initWithString:content];
    NSRange range = [[moneyString string]rangeOfString:money];
    
    [moneyString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:range];
    
    return moneyString;
}

#pragma mark - Button Event
- (void) _commitBtnDidClick {
    if(self.scantype == MerchantEnter && _orderModel.storeName.length <= 0)
    {
        //[self buildHeadError:@"请先选择商家"];
        return;
    }
    
    if (isEmptyString(_orderModel.goodsName))
    {
        if (self.scantype == MerchantEnter)
        {
            //美凯龙
            //[self buildHeadError:@"请输入商品名称与型号"];
            return;
        }else{
            //[self buildHeadError:@"请先选择商品名称与型号"];
            return;
        }
    }
    
    if (isEmptyString(_orderModel.goodsKind))
    {
        //[self buildHeadError:@"请先选择商品品牌"];
        return;
    }
    
    if (isEmptyString(_orderModel.goodsBrand))
    {
        //[self buildHeadError:@"请先选择商品类型"];
        return;
    }
    if (isEmptyString(_orderModel.strLoanStyle))
    {
        //[self buildHeadError:@"请先选择分期方式"];
        return;
        
    }
    if(self.scantype == GoodsNoMenuEnter)
    {
        
    }else if(self.scantype == GoodsHasMenuEnter)
    {
        if(isEmptyString(_orderModel.goodsMenu))
        {
            //[self buildHeadError:@"请选择套餐"];
            return;
        }else //if(!self.selectTime || self.selectTime.length == 0)
        {
            //[self buildHeadError:@"请先选择分期方式"];
            return;
        }
    }
    
    if (isEmptyString(_orderModel.loanMoney))
    {
        //[self buildHeadError:@"请先输入借款金额"];;
        return;
    }
    
    if(self.scantype == MerchantEnter)
    {
        /*if(![self floatNumGreaterThanTwo:scanInfoModel.goodPrice])
        {
            scanInfoModel.loanMoney = @"";
            [_stageApplicationTableView reloadData];
            [self buildHeadError:@"商品单价不是整数,请重新输入借款金额"];
            return;
        }*/
    }
    
    if(isEmptyString(_orderModel.repayCardNum))
    {
        //[self buildHeadError:@"请选择默认还款卡"];
        return;
    }
    
    if (!_orderModel.goodsAddressTyp || _orderModel.goodsAddressTyp.length == 0){
        //[self buildHeadError:@"请先选择送货地址"];
        return;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5; //分为5个
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = _dataArray[section];
    
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  1 * _viewScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return  1 * _viewScale;
    }
    return 10 * _viewScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = iphone6P ? 50 : 45 * _viewScale;
    if (indexPath.section == 4) {
        //根据字符串长度来决定高度
        return 60 * _viewScale;//默认
    } else if (indexPath.section == 3) {
        return 60 * _viewScale;
    }
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return nil;
    }
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 10 * _viewScale)];
    footView.backgroundColor = [UIColor UIColorWithHexColorString:@"0xeeeeee" AndAlpha:1];
    return footView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArray = _dataArray[indexPath.section];
    NSString *titleStr = sectionArray[indexPath.row];
    if ([titleStr isEqualToString:NSLocalizedString(@"购买数量", nil)]) {
        HCChangeNumCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCChangeNumCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        [cell generateCellWithTitle:titleStr andGoodsNum:@"0"]; //传入获取的数值
        return cell;
    } else if ([titleStr isEqualToString:NSLocalizedString(@"送货地址", nil)]) {
        HCOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCOrderInfoCell class]) forIndexPath:indexPath];
        [cell generateCellWithTitle:titleStr andType:@"现住房地址" andInfo:@"山东省青岛市崂山区中韩街道柳絮飘雪小区120号楼1单元1209" andHiddenImg:_isReturnedByCredit];
        cell.userInteractionEnabled = !_isReturnedByCredit;
        return cell;
        
    } else if ([titleStr isEqualToString:NSLocalizedString(@"商家", nil)]) {
        HCOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCOrderInfoCell class]) forIndexPath:indexPath];
        [cell generateCellWithTitle:titleStr andType:@"" andInfo:@"山东省青岛市李沧区海尔专卖店" andHiddenImg:YES];
        return cell;
        
    } else {
        HCTextInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCTextInfoCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        if ([titleStr isEqualToString:NSLocalizedString(@"名称和型号", nil)]) {
            [cell generateCellWithTitle:titleStr andPlaceStr:@"" orContent:@"goodName"];
            [cell.contentTxt setEnabled:(self.scantype == MerchantEnter)];
            cell.userInteractionEnabled = _flowName == GoodsLoanCreate;
        } else if ([titleStr isEqualToString:NSLocalizedString(@"商品品牌", nil)]) {
            [cell generateCellWithTitle:titleStr andPlaceStr:@"" orContent:@"goodBrand"];
        } else if ([titleStr isEqualToString:NSLocalizedString(@"商品类型", nil)]) {
            [cell generateCellWithTitle:titleStr andPlaceStr:@"" orContent:@"goodKind"];
        } else if ([titleStr isEqualToString:NSLocalizedString(@"借款金额", nil)]) {
            [cell generateCellWithTitle:titleStr andPlaceStr:@"" orContent:@"loanMoney"];
            cell.contentTxt.keyboardType = UIKeyboardTypeNumberPad;
            if (_flowName == GoodsReturnedByCredit) { //  || 非自定义产品goods.length > 0
                cell.contentTxt.enabled = NO;
            }
        } else if ([titleStr isEqualToString:NSLocalizedString(@"分期方式", nil)]) {
            [cell generateCellWithTitle:titleStr andInfo:@"strLoanStyle"];
            cell.userInteractionEnabled = !_isReturnedByCredit;
            [cell setImgHidden:_isReturnedByCredit];
        } else if ([titleStr isEqualToString:NSLocalizedString(@"还款计划", nil)]) {
            [cell generateCellWithTitle:titleStr andInfo:@""];
        } else if ([titleStr isEqualToString:NSLocalizedString(@"还款卡", nil)] || [titleStr isEqualToString:NSLocalizedString(@"默认还款卡", nil)]) {
            NSString *str = @"";
            str = @"1234***1234";
            [cell generateCellWithTitle:titleStr andInfo:str];
        } else if ([titleStr isEqualToString:NSLocalizedString(@"套餐", nil)]) {
            [cell generateCellWithTitle:titleStr andInfo:@"goodsMenu"];
        }
        return cell;
        
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *sectionArray = _dataArray[indexPath.section];
    NSString *titleStr = sectionArray[indexPath.row];
    
    if (!_isReturnedByCredit) {
        if (self.scantype == StoreEnter) {
            if ([titleStr isEqualToString:NSLocalizedString(@"名称和型号", nil)]) {
                //获取商品
                //跳转商品选择页面
                self.scantype = GoodsUnKnowMenu;
            }else {
            //提示先选名称型号
                return;
            }
        }

        
        if (self.scantype == MerchantEnter) {
            if ([titleStr isEqualToString:NSLocalizedString(@"商家", nil)]) {
                //判断商家信息有无，根据数量进行处理 1请求数据。2为空。3加载
            } else {
                //其他选项先判断商家有无
                //if(商家无) {
                //@"请先选择商家"
                //return;
                //}
            }
        }
        
        
        if ([titleStr isEqualToString:NSLocalizedString(@"商品品牌", nil)]) {
            //判断名称和型号 1
            //需商家
        } else if ([titleStr isEqualToString:NSLocalizedString(@"商品类型", nil)]) {
            //判断品牌有无 2
            //需商家和品牌
        } else if ([titleStr isEqualToString:NSLocalizedString(@"分期方式", nil)]) {
            //有套餐(判断名称和型号)  其他(判断类型和借款的有无) 6
            //需商家  ->获取分期方式Model保存到本地
            // ->根据选择的套餐和分期方式跳转
        } else if ([titleStr isEqualToString:NSLocalizedString(@"套餐", nil)]) {
            //判断名称和型号  5
            //需商家
            //->先获取分期方式Model保存到本地
            //跳转到套餐页面
        }else if ([titleStr isEqualToString:NSLocalizedString(@"商家", nil)]) {
            //加载已有的商家信息 进行跳转
            
        }
        
    }
    
    if ([titleStr isEqualToString:NSLocalizedString(@"还款计划", nil)]) {
        if (isEmptyString(_orderModel.strLoanStyle))
        {
            //[self buildHeadError:@"请先选择分期方式"];
        }else if (isEmptyString(_orderModel.loanMoney))
        {
            //[self buildHeadError:@"请先输入借款金额"];
        }else
        {
            //[self toReturnPlanViewController];
        }
        //判断分期方式的有无  8、9
        //需进行还款试算
    } else if ([titleStr isEqualToString:NSLocalizedString(@"还款卡", nil)]) {
        
        //跳转选择卡页面  9、10
    } else if ([titleStr isEqualToString:NSLocalizedString(@"送货地址", nil)]) {
        //跳转选择地址页面 13、14
    }
    
}

#pragma mark - HCChangeNumCellDelegate
- (void)HCChangeNumCellChangeNum:(NSInteger)num withTitle:(NSString *)title {
    
}

#pragma mark - HCTextInfoCellDelegate
- (void)HCTextInfoInput:(NSString *)content withTitle:(NSString *)title {
    
}
@end

