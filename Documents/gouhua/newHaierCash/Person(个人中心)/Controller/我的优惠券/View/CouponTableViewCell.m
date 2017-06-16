//
//  CouponTableViewCell.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/8.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "CouponTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"

@interface CouponTableViewCell ()

{
    
    float x;
    
    UIImageView *_baseImgView;//底层照片视图
    
    UIImageView *_typeImageView;//使用券类型图片
    
    UILabel *_typeLable;//使用券类型
    
    UILabel *_conditionLable;//使用券的使用条件
    
    UILabel *_sceneLabel;//使用券的使用场景
    
    UILabel *_moneyLabel;//金额label
    
    UILabel *_timtLabel;//有效期
    
}

@end

@implementation CouponTableViewCell

#pragma mark --> life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
        
        [self creatBaseUI];
        
    }
    
    return self;
    
}

#pragma mark --> private Methods

-(void)creatBaseUI{
    
  
    
    _baseImgView = [[UIImageView alloc]init];
    
    [self.contentView addSubview:_baseImgView];
    
    _typeImageView = [[UIImageView alloc]init];
    
    [_baseImgView addSubview:_typeImageView];
    
    _typeLable = [[UILabel alloc]init];
    
    _typeLable.font = [UIFont appFontRegularOfSize:15];
    
    [_baseImgView addSubview:_typeLable];
    
    _conditionLable = [[UILabel alloc]init];
    
    _conditionLable.textColor = UIColorFromRGB(0xa3a3a3, 1.0);
    
    [_baseImgView addSubview:_conditionLable];
    
    _sceneLabel = [[UILabel alloc]init];
    
    _sceneLabel.textColor = UIColorFromRGB(0xa3a3a3, 1.0);
    
    [_baseImgView addSubview:_sceneLabel];
    
    _moneyLabel = [[UILabel alloc]init];
    
    _moneyLabel.textColor = [UIColor whiteColor];
    
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_moneyLabel];
    
    _timtLabel = [[UILabel alloc]init];
    
    _timtLabel.textColor = [UIColor whiteColor];
    
    _timtLabel.textAlignment = NSTextAlignmentCenter;
    
    _timtLabel.numberOfLines = 0;
    
    [self.contentView addSubview:_timtLabel];
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
        _baseImgView.frame = CGRectMake(15*x, 10*x, DeviceWidth-30*x, 103*x);
        
        _typeImageView.frame = CGRectMake(27*x, 25*x, 48*x, 48*x);
        
        _typeLable.frame = CGRectMake(86*x, 17*x, 120*x, 20*x);
        
        _typeLable.font = [UIFont appFontRegularOfSize:15*x];
        
        _conditionLable.frame = CGRectMake(86*x, 43*x, 180*x, 20*x);
        
        _conditionLable.font = [UIFont appFontRegularOfSize:13*x];
        
        _sceneLabel.frame = CGRectMake(86*x, 68*x, 180*x, 20*x);
        
        _sceneLabel.font = [UIFont appFontRegularOfSize:13*x];
        
        _moneyLabel.frame = CGRectMake(DeviceWidth-103*x, 18*x, 85*x, 30*x);
        
        _moneyLabel.font = [UIFont systemFontOfSize:20*x];
        
        _timtLabel.frame = CGRectMake(DeviceWidth-103*x, 50*x, 85*x, 25*x);
        
        _timtLabel.font = [UIFont appFontRegularOfSize:9*x];

        
    }else{
        
        x = scaleAdapter;
        
        _baseImgView.frame = CGRectMake(13*x, 10*x, DeviceWidth-26*x, 92*x);
        
        _typeImageView.frame = CGRectMake(25*x, 23*x, 46*x, 46*x);
        
        _typeLable.frame = CGRectMake(80*x, 17*x, 120*x, 20*x);
        
        _typeLable.font = [UIFont appFontRegularOfSize:15*x];
        
        _conditionLable.frame = CGRectMake(80*x, 40*x, 180*x, 15*x);
        
        _conditionLable.font = [UIFont appFontRegularOfSize:12*x];
        
        _sceneLabel.frame = CGRectMake(80*x, 58*x, 180*x, 15*x);
        
        _sceneLabel.font = [UIFont appFontRegularOfSize:12*x];

        _moneyLabel.frame = CGRectMake(DeviceWidth-94*x, 17*x, 80*x, 27*x);
        
        _moneyLabel.font = [UIFont systemFontOfSize:20*x];
        
        _timtLabel.frame = CGRectMake(DeviceWidth-94*x, 50*x, 80*x, 24*x);
        
        _timtLabel.font = [UIFont appFontRegularOfSize:9*x];
        
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10*x)];
    
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.contentView addSubview:lineView];
    
}

-(void)insertModelInfo:(CouponBody *)model{
    
    if ([model.type isEqualToString:@"兑换券"]) {
      
        _moneyLabel.frame = CGRectZero;
        
        if (iphone6P) {
            
            _timtLabel.frame = CGRectMake(DeviceWidth-103*x, 10*x, 80*x, 101*x);
            
        }else{
            
            _timtLabel.frame = CGRectMake(DeviceWidth-94*x, 10*x, 80*x, 92*x);
            
        }
        
    }else{
        
        _moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.money];
        
        if (iphone6P) {
            
            _moneyLabel.frame = CGRectMake(DeviceWidth-103*x, 34*x, 85*x, 30*x);
            
            _timtLabel.frame = CGRectMake(DeviceWidth-103*x, 67*x, 85*x, 25*x);
            
            
        }else{
            
            _moneyLabel.frame = CGRectMake(DeviceWidth-94*x, 25*x, 80*x, 27*x);
            
            _timtLabel.frame = CGRectMake(DeviceWidth-94*x, 57*x, 80*x, 24*x);
            
        }

    }
    
    if ([model.imgType isEqualToString:@"可使用"]) {
        
        _baseImgView.image = [UIImage imageNamed:@"优惠券_可使用"];
        
        _typeImageView.image = [UIImage imageNamed:model.type];
        
    }else{
        
        _typeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@2",model.type]];
        
        if ([model.imgType isEqualToString:@"已过期"]){
            
            _baseImgView.image = [UIImage imageNamed:@"优惠券_已过期"];
            
        }else if ([model.imgType isEqualToString:@"已使用"]){
            
            _baseImgView.image = [UIImage imageNamed:@"优惠券_已使用"];
        }
        
    }
    
    _typeLable.text = model.name;
    
    _conditionLable.text = model.condition;
    
    _sceneLabel.text = model.scene;
    
    _timtLabel.text = [NSString stringWithFormat:@"有效期至\n%@",model.time];
    
    
}

@end
