//
//  MerchTableViewCell.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/8.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "MerchTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "UILabel+SizeForStr.h"
@interface MerchTableViewCell ()

{
    
    float x;//屏幕适配比例
    
    UIImageView *_topImgView;//顶部照片视图
    
    UILabel *_nameLabel;//商品名称视图
    
    UILabel *_optionLabel;//商品信息说明视图
    
}

@end

@implementation MerchTableViewCell

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
        
        if (iphone6P) {
            
            x = scale6PAdapter;
            
        }else{
            
            x = scaleAdapter;
            
        }
        
        [self creatBaseUI];
        
    }
    
    return self;
    
}

#pragma mark --> private Methods
//创建基本视图
-(void)creatBaseUI{
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10*x)];
    
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.contentView addSubview:lineView];
    
    _topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10*x, DeviceWidth, 140*x)];
    
    [self.contentView addSubview:_topImgView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*x, 160*x, DeviceWidth-15*x, 20*x)];
    
    _nameLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    [self.contentView addSubview:_nameLabel];
    
    _optionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height+5*x, DeviceWidth-30*x, 15*x)];
    
    _optionLabel.textColor = UIColorFromRGB(0x999999, 1.0);
    
    _optionLabel.font = [UIFont appFontRegularOfSize:11*x];
    
    [self.contentView addSubview:_optionLabel];
    
}

-(float)insertMerchModel:(HCMerchBody *)model{
    
    _nameLabel.text = model.name;
    
    _optionLabel.text = model.option;
    
    CGSize size = [_optionLabel boundingRectWithSize:CGSizeMake(DeviceWidth-30*x, NSIntegerMax)];
    
    if (size.height > 15*x) {
        
        _optionLabel.frame = CGRectMake(15*x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height+5*x, DeviceWidth-30*x, size.height);
        
        _optionLabel.numberOfLines = 0;
        
        return 15*x+_optionLabel.frame.origin.y+_optionLabel.frame.size.height;
        
    }else{
        
        _optionLabel.frame = CGRectMake(15*x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height+5*x, DeviceWidth-30*x, 15*x);
        
        return 35*x+_nameLabel.frame.origin.y+_nameLabel.frame.size.height;
        
    }
}

@end
