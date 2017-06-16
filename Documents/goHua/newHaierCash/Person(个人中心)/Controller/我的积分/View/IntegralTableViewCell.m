//
//  IntegralTableViewCell.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "IntegralTableViewCell.h"
#import "UIFont+AppFont.h"
#import "HCMacro.h"
#import <YYWebImage.h>
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
@interface IntegralTableViewCell ()

{
    
    UIImageView *_leftImage;//左侧积分视图
    
    UILabel *_nameLabel;    //积分视图名称
    
    UILabel *_sceneLabel;   //积分使用条件
    
    UILabel *_moneyLabel;   //兑换积分
    
    float x;                //适配比例
    
}


@end

@implementation IntegralTableViewCell

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
     
        [self creatBaseUI];
        
    }
    
    return self;
    
}

#pragma mark --> private Methods

-(void)creatBaseUI{
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
        
    }
    
    _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(14*x, 12*x, 100*x, 76*x)];
    
    [self.contentView addSubview:_leftImage];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(130*x, 14*x, DeviceWidth-130*x, 20*x)];
    
    _nameLabel.font = [UIFont appFontRegularOfSize:15*x];
    
    _nameLabel.textColor = [UIColor blackColor];
    
    [self.contentView addSubview:_nameLabel];
    
    _sceneLabel = [[UILabel alloc]initWithFrame:CGRectMake(130*x, 34*x, DeviceWidth-130*x, 20*x)];
    
    _sceneLabel.font = [UIFont appFontRegularOfSize:12*x];
    
    _sceneLabel.textColor = UIColorFromRGB(0xc2c2c2, 1.0);
    
    [self.contentView addSubview:_sceneLabel];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(130*x, 62*x, DeviceWidth-130*x, 28*x)];
    
    _moneyLabel.font = [UIFont appFontRegularOfSize:20*x];
    
    _moneyLabel.textColor = UIColorFromRGB(0xf15a4a, 1.0);
    
    [self.contentView addSubview:_moneyLabel];
    
}

-(void)insertModelInfo:(IntegralBody *)model{
    
    if (model.imgUrl.length > 0) {
        
        NSData *data = (NSData *)[[AppDelegate delegate].imagePutCache objectForKey:model.imgUrl];
        
        if (data) {
          
            _leftImage.image = [UIImage imageWithData:data];
            
        }else{
           
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,model.imgUrl]];
            
            [_leftImage yy_setImageWithURL:url placeholder:nil options:YYWebImageOptionIgnoreDiskCache | YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
                
                if (image) {
                    
                    _leftImage.image = image;
                    
                    [[AppDelegate delegate].imagePutCache setObject:image forKey:model.imgUrl];
                    
                }
                
            }];

            
        }
        
        
    }
    
    _nameLabel.text = model.name;
    
    _sceneLabel.text = model.secne;
    
    _moneyLabel.text = model.money;
    
}

@end
