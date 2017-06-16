//
//  WareTopView.m
//  商品详情
//
//  Created by 史长硕 on 2017/4/21.
//  Copyright © 2017年 史长硕. All rights reserved.
//

#import "WareTopView.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "UILabel+SizeForStr.h"
@interface WareTopView ()<SDCycleScrollViewDelegate>
{
    
    float x;//屏幕适配比例
    
    UIView *_baseNameView;//商品介绍底部视图
    
    UIView *_baseWareView;//商品数量底部视图
    
    UIView *_baseWarnView;//中间介绍视图
    
}

@end


@implementation WareTopView

#pragma mark --> life Cycle

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
      
        if (iphone6P) {
            
            x = scale6PAdapter;
            
        }else{
            
            x = scaleAdapter;
            
        }
        
        [self creatWareNameView];
        
        [self creatWarnView];
        
        [self creatWareNumberDetail];
        
    }
    
    return self;
    
}

#pragma mark --> private Meyhods(创建控件)
//创建顶部图片轮播图
-(void)creatTopImageView{
    
    _topImageScroll = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 310*x)];
    
    _topImageScroll.delegate = self;
    
     _topImageScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
    _topImageScroll.backgroundColor = [UIColor whiteColor];
    
    _topImageScroll.currentPageDotColor = UIColorFromRGB(0x32beff, 1.0);
    
    _topImageScroll.pageDotColor = [UIColor whiteColor];
    
    _topImageScroll.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    
    _topImageScroll.imageURLStringsGroup = _imageArray;
    
    _topImageScroll.placeholderImage = [UIImage imageNamed:@"加载展位图"];
    
    if (_imageArray.count == 1) {
            
     _topImageScroll.infiniteLoop = NO;

    }
    if (_imageArray.count == 0) {
        _topImageScroll.infiniteLoop = NO;
        _topImageScroll.localizationImageNamesGroup = @[@"商品默认图"];
    }
    
    [self addSubview:_topImageScroll];
    
}

//创建商品介绍页面
-(void)creatWareNameView{
    
    _baseNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 310*x, DeviceWidth, 105*x)];
    
    _baseNameView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_baseNameView];
    
    _wareNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*x, 15*x, DeviceWidth-40*x, 45*x)];
    
    _wareNameLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    _wareNameLabel.numberOfLines = 0;
    
    [_baseNameView addSubview:_wareNameLabel];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*x, 60*x, DeviceWidth-20*x, 45*x)];
    
    _moneyLabel.font = [UIFont systemFontOfSize:22*x];
    
    _moneyLabel.textColor = UIColorFromRGB(0x32beff, 1.0);
    
    [_baseNameView addSubview:_moneyLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0, DeviceWidth, 1)];
    
    lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [_baseNameView addSubview:lineView];
    
}

//创建中间介绍页面
-(void)creatWarnView{
    
    _baseWarnView = [[UIView alloc]initWithFrame:CGRectMake(0, 425*x, DeviceWidth, 85*x)];
    
    _baseWarnView.backgroundColor = UIColorFromRGB(0xeaf8ff, 1.0);
    
    [self addSubview:_baseWarnView];
    
    UIView *blueView = [[UIView alloc]initWithFrame:CGRectMake(14*x, 17*x, 66*x, 20*x)];
    
    blueView.backgroundColor = UIColorFromRGB(0x2991fc, 1.0);
    
    blueView.layer.cornerRadius = 3*x;
    
    [_baseWarnView addSubview:blueView];
    
    _wareTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 66*x, 20*x)];
    
    _wareTypeLabel.textColor = [UIColor whiteColor];
    
    _wareTypeLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    _wareTypeLabel.textAlignment = NSTextAlignmentCenter;
    
    [blueView addSubview:_wareTypeLabel];
    
    _compareLabel = [[UILabel alloc]initWithFrame:CGRectMake(90*x, 17*x, DeviceWidth-90*x, 20*x)];
    
    _compareLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    _compareLabel.textColor = UIColorFromRGB(0x666666, 1.0);
    
    [_baseWarnView addSubview:_compareLabel];
    
    UIImageView *typImg = [[UIImageView alloc]initWithFrame:CGRectMake(14*x, 50*x, 16*x, 16*x)];
    
    typImg.image = [UIImage imageNamed:@"商品详情_贷款信息"];
    
    typImg.backgroundColor = [UIColor clearColor];
    
    [_baseWarnView addSubview:typImg];
    
    _typCdeLabel = [[UILabel alloc]initWithFrame:CGRectMake(36*x, 50*x, 83*x, 16*x)];
    
    _typCdeLabel.font = [UIFont appFontRegularOfSize:13*x];
    
    _typCdeLabel.textColor = UIColorFromRGB(0x666666, 1.0);
    
    [_baseWarnView addSubview:_typCdeLabel];
    
    UIImageView *goodsImg = [[UIImageView alloc]initWithFrame:CGRectMake(120*x, 50*x, 16*x, 16*x)];
    
    goodsImg.image = [UIImage imageNamed:@"商品详情_正品保证"];
    
    [_baseWarnView addSubview:goodsImg];
    
    UILabel *goodsLabel = [[UILabel alloc]initWithFrame:CGRectMake(140*x, 50*x, 83*x, 16*x)];
    
    goodsLabel.font = [UIFont appFontRegularOfSize:13*x];
    
    goodsLabel.textColor = UIColorFromRGB(0x666666, 1.0);
    
    [_baseWarnView addSubview:goodsLabel];
    
    UIImageView * backImg = [[UIImageView alloc]initWithFrame:CGRectMake(227*x, 50*x, 16*x, 16*x)];
    
    backImg.image = [UIImage imageNamed:@"商品详情_退货"];
    
    [_baseWarnView addSubview:backImg];
    
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(250*x, 50*x, DeviceWidth-250*x, 16*x)];
    
    backLabel.font = [UIFont appFontRegularOfSize:13*x];
    
    backLabel.textColor = UIColorFromRGB(0x666666, 1.0);
    
    [_baseWarnView addSubview:backLabel];
    
}

//创建商品数量详情页面
-(void)creatWareNumberDetail{
    
    _baseWareView = [[UIView alloc]initWithFrame:CGRectMake(0, 520*x, DeviceWidth, 160*x)];
    
    _baseWareView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_baseWareView];
    
    /*----------------------------定位----------------------------------*/
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49*x, DeviceWidth, 1)];
    
    lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [_baseWareView addSubview:lineView];
    
    /*----------------------------送货地址----------------------------------*/
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*x, 15*x, 35*x, 20*x)];
    
    leftLabel.font = [UIFont appFontRegularOfSize:15*x];
    
    leftLabel.text = @"送至";
    
    [_baseWareView addSubview:leftLabel];
    
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(60*x, 50, DeviceWidth-110*x, 50*x)];
    
    _addressLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    _addressLabel.numberOfLines = 0;
    
   // _addressLabel.userInteractionEnabled = YES;
    
    _addressLabel.textAlignment = NSTextAlignmentRight;
    
    [_baseWareView addSubview:_addressLabel];
    
    UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-35*x, 17.5*x, 8*x, 15*x)];
    
    rightImg.image = [UIImage imageNamed:@"首页_箭头右"];
    
    [_baseWareView addSubview:rightImg];
    
    UIButton *addreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50*x)];
    
    addreBtn.backgroundColor = [UIColor clearColor];
    
    [addreBtn addTarget:self action:@selector(buildToAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    [_baseWareView addSubview:addreBtn];
    
    UIView *lineViewTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 49*x, DeviceWidth, 1)];
    
    lineViewTwo.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [_baseWareView addSubview:lineViewTwo];
    
    /*----------------------------库存----------------------------------*/
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*x, 65*x, 60*x, 20*x)];
    
    numLabel.font = [UIFont appFontRegularOfSize:15*x];
    
    numLabel.text = @"库存";
    
    [_baseWareView addSubview:numLabel];
    
    _stockLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*x, 50*x, DeviceWidth-130*x, 50*x)];
    
    _stockLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    _stockLabel.textColor = UIColorFromRGB(0x65d8b2, 1.0);
    
    _stockLabel.textAlignment = NSTextAlignmentRight;
    
    [_baseWareView addSubview:_stockLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buildToStoke)];
    
    [_stockLabel addGestureRecognizer:tap];
    
    UIView *lineBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 100*x, DeviceWidth, 10*x)];
    
    lineBottomView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [_baseWareView addSubview:lineBottomView];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*x, 125*x, 80*x, 20*x)];
    
    detailLabel.font = [UIFont appFontRegularOfSize:15*x];
    
    detailLabel.text = @"商品详情";
    
    [_baseWareView addSubview:detailLabel];
    
    UIView *endView = [[UIView alloc]initWithFrame:CGRectMake(0, 159*x, DeviceWidth, 1*x)];
    
    endView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [_baseWareView addSubview:endView];
    
}

#pragma mark --> event Response(点击方法)

//点击定位
-(void)buildToLocation{
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendTouchType:)]) {
        
        [_delegate sendTouchType:TouchLocation];
        
    }
    
}

//点击送货地址
-(void)buildToAddress:(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendTouchType:)]) {
        
        [_delegate sendTouchType:TouchAddre];
        
    }
    
}
//点击刷新库存
-(void)buildToStoke{
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendTouchType:)]) {
        
        [_delegate sendTouchType:TouchStoke];
        
    }
}

//修改frame
-(float)buildChangeUiframe{
    
    CGSize size = [_wareNameLabel boundingRectWithSize:CGSizeMake(DeviceWidth-40*x, NSIntegerMax)];
    
    if (size.height > 45*x) {
        
        _wareNameLabel.frame = CGRectMake(20*x, 15*x, DeviceWidth-40*x, size.height);
        
        _moneyLabel.frame = CGRectMake(20*x, 15*x+size.height, DeviceWidth-20*x, 45*x);
        
        _baseNameView.frame = CGRectMake(0, 310*x, DeviceWidth, 60*x+size.height);
        
        _baseWarnView.frame = CGRectMake(0, 380*x+size.height, DeviceWidth, 85*x);
        
        _baseWareView.frame = CGRectMake(0, 465*x+size.height, DeviceWidth, 150*x);
        
    }else{
        
        size.height = 45*x;
        
        _wareNameLabel.frame = CGRectMake(20*x, 15*x, DeviceWidth-40*x, size.height);
        
        _moneyLabel.frame = CGRectMake(20*x, 15*x+size.height, DeviceWidth-20*x, 45*x);
        
        _baseNameView.frame = CGRectMake(0, 310*x, DeviceWidth, 60*x+size.height);
        
        _baseWarnView.frame = CGRectMake(0, 380*x+size.height, DeviceWidth, 85*x);
        
        _baseWareView.frame = CGRectMake(0, 465*x+size.height, DeviceWidth, 150*x);
   
        
    }
    
    float height = 465*x+size.height;
    
    return height;
    
}

@end
