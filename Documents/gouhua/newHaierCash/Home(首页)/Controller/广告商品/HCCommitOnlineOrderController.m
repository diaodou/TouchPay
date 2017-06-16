//
//  HCCommitOnlineOrderController.m
//  newHaierCash
//
//  Created by Will on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"
#import "HCShippingAddressViewController.h"

#import "HCCommitOnlineOrderController.h"
#import "HCChangeNumCell.h"

@interface HCCommitOnlineOrderController ()<HCChangeNumCellDelegate>{
    UIView *_topView;
    UIView *_ttLineView;
    UIView *_taddAddressView;
    UIButton *_tAddAddressBtn;
    UILabel *_tAddAddressLbl;
    UIView *_tshowAddressView;
    UILabel *_tBuyerLbl;
    UILabel *_tPhoneNumLbl;
    UILabel *_tAddressLbl;
    UIImageView *_tMoreAddressImg;
    UIView *_tLineView;
    UIImageView *_tLineImgView;
    
    UIView *_middleView;
    UIImageView *_mGoodsImgView;
    UILabel *_mGoodsTitleLbl;
    UILabel *_mGoodsMoneyLbl;
    HCChangeNumCell *_mChangeNumCell;
    UILabel *_mMerchantLbl;
    UILabel *_mMerchantNameLbl;
    UILabel *_mGoodsNumLbl;
    UILabel *_mMoneyInfoLbl;
    UILabel *_mAllMoneyLbl;
    UIView *_mLine1View;
    UIView *_mLine2View;
    UIView *_mLine3View;
    UIView *_mLine4View;

    UIView *_bottomView;
    UIView *_bLineView;
    UILabel *_bStyleLbl;
    UILabel *_bLoanInfoLbl;
    UIButton *_bPayBtn;
    
    CGFloat _viewScale;
    
    //测试
    BOOL haveAddress;
    
}

@end

@implementation HCCommitOnlineOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    self.view.backgroundColor = [UIColor UIColorWithHexColorString:@"#eeeeee" AndAlpha:1];
    self.title = NSLocalizedString(@"订单提交", nil);
    haveAddress = NO;

    [self _createTopView];
    [self _createMiddleView];
    [self _createBottomView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    //根据地址信息给TopView赋值
    if (!(_taddAddressView.superview && !haveAddress) && !(_tshowAddressView.superview && haveAddress)) {
        if(haveAddress) {
            [_topView addSubview:_tshowAddressView];
            _tBuyerLbl.text = @"收货人：徐凯丽";
            _tPhoneNumLbl.text = @"13567890987";
            _tAddressLbl.text = @"收货地址：山东省青岛市崂山区海尔路178号";
        } else {
            [_topView addSubview:_taddAddressView];
        }
        [self.view layoutIfNeeded];
    }
    
    //数据赋值
    [_mGoodsImgView setImage:[UIImage imageNamed:@"a1.jpg"]];
    [_mGoodsTitleLbl setText:@"【卡萨帝】 成就品质生活，双11特惠，9期免费，抢抢"];
    [_mGoodsMoneyLbl setText:@"￥9999.00"];
    [_mChangeNumCell generateCellWithTitle:@"购买数量" andGoodsNum:@"1"];
    _mMerchantLbl.text = @"商家：";
    _mMerchantNameLbl.text = @"海尔消费金融自营";
    _mGoodsNumLbl.text = @"共1件商品";
    _mMoneyInfoLbl.text = @"小计：";
    _mAllMoneyLbl.text = @"￥9999.00";
    
    _bLoanInfoLbl.text = @"￥3333.00 * 3期";
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (iphone6P) {
        //顶部视图
        _topView.frame = CGRectMake(0, 0, DeviceWidth, 80);
        _ttLineView.frame = CGRectMake(0, 0, DeviceWidth, 1);
        //添加地址
        _taddAddressView.frame = _tshowAddressView.frame = CGRectMake(0, 1, DeviceWidth - 27, 74 - thinLineHeight);
        _tAddAddressBtn.frame = CGRectMake(20, 22, 30, 30);
        _tAddAddressLbl.frame = CGRectMake(60, 22, DeviceWidth - 92, 30);
        
        _tBuyerLbl.frame = CGRectMake(15, 15, DeviceWidth - 173, 16);
        _tPhoneNumLbl.frame = CGRectMake(DeviceWidth - 143, 15, 106, 16);
        _tAddressLbl.frame = CGRectMake(15, 46, DeviceWidth - 47, 18);
        
        _tMoreAddressImg.frame = CGRectMake(DeviceWidth - 27, 27, 12, 15);
        _tLineView.frame = CGRectMake(0, 75 - thinLineHeight, DeviceWidth, thinLineHeight);
        _tLineImgView.frame =  CGRectMake(0, 75, DeviceWidth, 5);
        
        
        //中间视图
        _middleView.frame = CGRectMake(0, 90, DeviceWidth, 275);
        _mLine1View.frame = CGRectMake(0, 0, DeviceWidth, thinLineHeight);
        
        _mGoodsImgView.frame = CGRectMake(15, 17, 130, 90);
        _mGoodsTitleLbl.frame = CGRectMake(155, 29, DeviceWidth - 170, 38);
        _mGoodsMoneyLbl.frame = CGRectMake(155, 78, DeviceWidth - 170, 14);
        _mLine2View.frame = CGRectMake(0, 125 - thinLineHeight, DeviceWidth, thinLineHeight);
        
        
        _mChangeNumCell.frame = CGRectMake(0, 125, DeviceWidth, 50);
        
        _mMerchantLbl.frame = CGRectMake(15, 175, 50, 50);
        _mMerchantNameLbl.frame = CGRectMake(80, 175, DeviceWidth - 95, 50);
        
        _mLine3View.frame = CGRectMake(0, 225 - thinLineHeight, DeviceWidth, thinLineHeight);
        
        _mAllMoneyLbl.frame = CGRectMake(DeviceWidth - 95, 225, 80, 50);
        _mMoneyInfoLbl.frame = CGRectMake(DeviceWidth - 145, 225, 50, 50);
        _mGoodsNumLbl.frame = CGRectMake(0 , 225, DeviceWidth - 160, 50);
        _mLine4View.frame = CGRectMake(0, 275 - thinLineHeight, DeviceWidth, thinLineHeight);
        
        //底部视图
        _bottomView.frame = CGRectMake(0, DeviceHeight - 118, DeviceWidth, 54);
        _bLineView.frame = CGRectMake(0, 0, DeviceWidth, thinLineHeight);
        _bStyleLbl.frame = CGRectMake(15, 0, 80, 54);
        _bLoanInfoLbl.frame = CGRectMake(90, 0, DeviceWidth - 237, 54);
        _bPayBtn.frame = CGRectMake(DeviceWidth - 137, 0, 137, 54);
    } else {
        _topView.frame = CGRectMake(0, 0, DeviceWidth, 75 * _viewScale);
        _ttLineView.frame = CGRectMake(0, 0, DeviceWidth, 1 * _viewScale);
        //添加地址
        _taddAddressView.frame = _tshowAddressView.frame = CGRectMake(0, 1 * _viewScale, DeviceWidth - 23 * _viewScale, 69 * _viewScale - thinLineHeight);
        _tAddAddressBtn.frame = CGRectMake(20 * _viewScale, 20 * _viewScale, 30 * _viewScale, 30 * _viewScale);
        _tAddAddressLbl.frame = CGRectMake(60 * _viewScale, 20 * _viewScale, DeviceWidth - 100 * _viewScale, 30 * _viewScale);
        
        _tBuyerLbl.frame = CGRectMake(15 * _viewScale, 14 * _viewScale, DeviceWidth - 169 * _viewScale, 16 * _viewScale);
        _tPhoneNumLbl.frame = CGRectMake(DeviceWidth - 139 * _viewScale, 14 * _viewScale, 106 * _viewScale, 16 * _viewScale);
        _tAddressLbl.frame = CGRectMake(15 * _viewScale, 41 * _viewScale, DeviceWidth - 53 * _viewScale, 14 * _viewScale);
        
        _tMoreAddressImg.frame = CGRectMake(DeviceWidth - 23 * _viewScale, 27 * _viewScale, 8 * _viewScale, 14 * _viewScale);
        _tLineView.frame = CGRectMake(0, 70 * _viewScale - thinLineHeight, DeviceWidth, thinLineHeight);
        _tLineImgView.frame =  CGRectMake(0, 70 * _viewScale, DeviceWidth, 5 * _viewScale);
        
        
        
        //中间视图
        _middleView.frame = CGRectMake(0, 90 * _viewScale, DeviceWidth, 249 * _viewScale);
        _mLine1View.frame = CGRectMake(0, 0, DeviceWidth, thinLineHeight);
        
        _mGoodsImgView.frame = CGRectMake(15 * _viewScale, 17 * _viewScale, 109 * _viewScale, 82 * _viewScale);
        _mGoodsTitleLbl.frame = CGRectMake(134 * _viewScale, 27 * _viewScale, DeviceWidth - 159 * _viewScale, 38 * _viewScale);
        _mGoodsMoneyLbl.frame = CGRectMake(134 * _viewScale, 75 * _viewScale, DeviceWidth - 159 * _viewScale, 14 * _viewScale);
        _mLine2View.frame = CGRectMake(0, 114 * _viewScale - thinLineHeight, DeviceWidth, thinLineHeight);
        
        _mChangeNumCell.frame = CGRectMake(0, 114 * _viewScale, DeviceWidth, 45 * _viewScale);
        
        _mMerchantLbl.frame = CGRectMake(15 * _viewScale, 159 * _viewScale, 50 * _viewScale, 45 * _viewScale);
        _mMerchantNameLbl.frame = CGRectMake(80 * _viewScale, 159 * _viewScale, DeviceWidth - 95 * _viewScale, 45 * _viewScale);
        
        _mLine3View.frame = CGRectMake(0, 204 * _viewScale - thinLineHeight, DeviceWidth, thinLineHeight);
        
        _mAllMoneyLbl.frame = CGRectMake(DeviceWidth - 95 * _viewScale, 204 * _viewScale, 80 * _viewScale, 45 * _viewScale);
        _mMoneyInfoLbl.frame = CGRectMake(DeviceWidth - 145 * _viewScale, 204 * _viewScale, 50 * _viewScale, 45 * _viewScale);
        _mGoodsNumLbl.frame = CGRectMake(0 , 204 * _viewScale, DeviceWidth - 160 * _viewScale, 45 * _viewScale);
        _mLine4View.frame = CGRectMake(0, 249 * _viewScale - thinLineHeight, DeviceWidth, thinLineHeight);
        
        
        
        //底部视图
        _bottomView.frame = CGRectMake(0, DeviceHeight - 64 - 50 * _viewScale, DeviceWidth, 50 * _viewScale);
        _bLineView.frame = CGRectMake(0, 0, DeviceWidth, thinLineHeight);
        _bStyleLbl.frame = CGRectMake(15 * _viewScale, 0, 75 * _viewScale, 50 * _viewScale);
        _bLoanInfoLbl.frame = CGRectMake(91 * _viewScale, 0, DeviceWidth - 224 * _viewScale, 50 *_viewScale);
        _bPayBtn.frame = CGRectMake(DeviceWidth - 124 * _viewScale, 0, 124 * _viewScale, 50 *_viewScale);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
#pragma mark --UI绘制--
- (void)_createTopView {
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    
    _ttLineView = [self _generateLineView];
    _ttLineView.backgroundColor = [UIColor UIColorWithHexColorString:@"#e5e5e5" AndAlpha:1];
    [_topView addSubview:_ttLineView];
    
    _taddAddressView = [UIView new];
    _taddAddressView.backgroundColor = [UIColor whiteColor];
    
    _tAddAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tAddAddressBtn setTitle:@"+" forState:UIControlStateNormal];
    [_tAddAddressBtn.titleLabel setFont:[UIFont systemFontOfSize:16 * _viewScale]];
    _tAddAddressBtn.layer.borderWidth = thinLineHeight;
    _tAddAddressBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [_tAddAddressBtn addTarget:self action:@selector(_tAddAddressBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [_taddAddressView addSubview:_tAddAddressBtn];
    
    _tAddAddressLbl = [self _generateLabelWithFont:[UIFont systemFontOfSize:17 * _viewScale]];
    _tAddAddressLbl.text = NSLocalizedString(@"点击新增地址", nil);
    [_taddAddressView addSubview:_tAddAddressLbl];
    
    _tMoreAddressImg = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceWidth - 27 * _viewScale, 31 * _viewScale, 12 * _viewScale, 20 * _viewScale)];
    [_tMoreAddressImg setImage:[UIImage imageNamed:@"箭头_右_灰"]];
    _tMoreAddressImg.contentMode = UIViewContentModeScaleAspectFit;
    [_topView addSubview:_tMoreAddressImg];
    
    _tshowAddressView = [UIView new];
    _tshowAddressView.backgroundColor = [UIColor whiteColor];
    
    _tBuyerLbl = [self _generateLabelWithFont:[UIFont appFontRegularOfSize:14 * _viewScale]];
    _tBuyerLbl.numberOfLines = 1;
    [_tshowAddressView addSubview:_tBuyerLbl];
    
    _tPhoneNumLbl = [self _generateLabelWithFont:[UIFont appFontRegularOfSize:14 * _viewScale]];
    _tPhoneNumLbl.numberOfLines = 1;
    _tPhoneNumLbl.textAlignment = NSTextAlignmentRight;
    [_tshowAddressView addSubview:_tPhoneNumLbl];

    
    _tAddressLbl = [self _generateLabelWithFont:[UIFont appFontRegularOfSize:13 * _viewScale]];
    _tAddressLbl.numberOfLines = 1;
    [_tshowAddressView addSubview:_tAddressLbl];


    _tLineView = [self _generateLineView];
    _tLineView.backgroundColor = [UIColor UIColorWithHexColorString:@"#e5e5e5" AndAlpha:1];
    [_topView addSubview:_tLineView];
    
    _tLineImgView = [[UIImageView alloc] init];
    [_tLineImgView setImage:[UIImage imageNamed:@"地址花边"]];
    _tLineImgView.contentMode = UIViewContentModeScaleToFill;
    [_topView addSubview:_tLineImgView];
    
    if(haveAddress) {
        [_topView addSubview:_tshowAddressView];
    } else {
        [_topView addSubview:_taddAddressView];
    }
}

- (void)_createMiddleView {
    _middleView = [UIView new];
    _middleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_middleView];
    
    _mGoodsImgView = [UIImageView new];
    _mGoodsImgView.contentMode = UIViewContentModeScaleAspectFit;
    [_middleView addSubview:_mGoodsImgView];
    
    _mGoodsTitleLbl = [self _generateLabelWithFont:[UIFont appFontRegularOfSize:15 * _viewScale]];
    _mGoodsTitleLbl.numberOfLines = 2;
    [_middleView addSubview:_mGoodsTitleLbl];
    
    _mGoodsMoneyLbl = [self _generateLabelWithFont:[UIFont appFontRegularOfSize:13 * _viewScale]];
    _mGoodsMoneyLbl.textColor = [UIColor redColor];
    [_middleView addSubview:_mGoodsMoneyLbl];

    _mChangeNumCell = [[HCChangeNumCell alloc] init];
    _mChangeNumCell.delegate = self;
    [_middleView addSubview:_mChangeNumCell];
    
    _mMerchantLbl = [self _generateLabelWithFont:[UIFont appFontRegularOfSize:15 * _viewScale]];
    [_middleView addSubview:_mMerchantLbl];
    
    _mMerchantNameLbl = [self _generateLabelWithFont:[UIFont appFontRegularOfSize:13 * _viewScale]];
    _mMerchantNameLbl.textColor = [UIColor grayColor];
    _mMerchantNameLbl.textAlignment = NSTextAlignmentRight;
    [_middleView addSubview:_mMerchantNameLbl];
    
    _mGoodsNumLbl = [self _generateLabelWithFont:[UIFont appFontRegularOfSize:15 * _viewScale]];
    _mGoodsNumLbl.textAlignment = NSTextAlignmentRight;
    [_middleView addSubview:_mGoodsNumLbl];
    
    _mMoneyInfoLbl = [self _generateLabelWithFont:[UIFont appFontRegularOfSize:15 * _viewScale]];
    _mMoneyInfoLbl.textAlignment = NSTextAlignmentRight;
    [_middleView addSubview:_mMoneyInfoLbl];
    
    _mAllMoneyLbl = [self _generateLabelWithFont:[UIFont appFontRegularOfSize:13 * _viewScale]];
    _mAllMoneyLbl.textColor = [UIColor redColor];
    _mAllMoneyLbl.textAlignment = NSTextAlignmentRight;
    [_middleView addSubview:_mAllMoneyLbl];
    
    _mLine1View = [self _generateLineView];
    [_middleView addSubview:_mLine1View];
    _mLine2View = [self _generateLineView];
    [_middleView addSubview:_mLine2View];
    _mLine3View = [self _generateLineView];
    [_middleView addSubview:_mLine3View];
    _mLine4View = [self _generateLineView];
    [_middleView addSubview:_mLine4View];

}

-(void)_createBottomView {
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _bLineView = [self _generateLineView];
    [_bottomView addSubview:_bLineView];
    
    _bStyleLbl = [self _generateLabelWithFont:[UIFont systemFontOfSize:15 * _viewScale]];
    _bStyleLbl.text = NSLocalizedString(@"分期方式：", nil);
    [_bottomView addSubview:_bStyleLbl];
    
    _bLoanInfoLbl = [self _generateLabelWithFont:[UIFont systemFontOfSize:13 * _viewScale]];
    _bLoanInfoLbl.textColor = [UIColor redColor];
    [_bottomView addSubview:_bLoanInfoLbl];
    
    _bPayBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bPayBtn setTitle:NSLocalizedString(@"确认支付", nil) forState:UIControlStateNormal];
    _bPayBtn.titleLabel.font = [UIFont appFontRegularOfSize:15 * _viewScale];
    [_bPayBtn setBackgroundColor:[UIColor UIColorWithHexColorString:App_MainColor AndAlpha:1]];
    [_bPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bPayBtn addTarget:self action:@selector(_bPayBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_bPayBtn];
}

- (UIView *)_generateLineView {
    UIView *lineView = [UIView new];
    lineView.backgroundColor  =[UIColor grayColor];
    
    return lineView;
}

- (UILabel *)_generateLabelWithFont:(UIFont *)font {
    UILabel *label = [UILabel new];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

#pragma mark - Button Event
- (void)_tAddAddressBtnDidClick {
    /*
    haveAddress = YES;
    if (_taddAddressView.superview) {
        [_taddAddressView removeFromSuperview];
    }
    if(haveAddress) {
        [_topView addSubview:_tshowAddressView];
        _tBuyerLbl.text = @"收货人：徐凯丽";
        _tPhoneNumLbl.text = @"13567890987";
        _tAddressLbl.text = @"收货地址：山东省青岛市崂山区海尔路178号";
    } else {
        [_topView addSubview:_taddAddressView];
    }
    [self.view layoutIfNeeded];
     */
    HCShippingAddressViewController *viewController = [[HCShippingAddressViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)_bPayBtnDidClick {
    
}

#pragma mark - HCChangeNumCellDelegate
- (void)HCChangeNumCellGetModel:(NSDictionary *)model {

}
@end
