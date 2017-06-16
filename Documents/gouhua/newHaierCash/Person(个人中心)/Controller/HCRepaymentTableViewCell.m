//
//  HCRepaymentTableViewCell.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/5/27.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import "HCRepaymentTableViewCell.h"
#import "UIColor+DefineNew.h"
#import "HCRepayButton.h"
@implementation HCRepaymentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma Mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUI];
    }
    return self;
}
#pragma mark - private Methods
- (void)setUI{
    
    NSArray * typeArray = [NSArray arrayWithObjects:@"近7日待还",@"本月待还",@"全部待还",nil];
    if (iphone6P) {
     
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 110)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        for (int n = 0 ; n < 3; n ++) {
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth/6 - 12 + n * DeviceWidth/3, 22, 24, 24)];
            
            imageView.image = [UIImage imageNamed:typeArray[n]];
                        
            [bottomView addSubview:imageView];
            
            UILabel * typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/3 * n, CGRectGetMaxY(imageView.frame) + 9, DeviceWidth/3, 12)];
            
            typeLabel.textAlignment = NSTextAlignmentCenter;
            
            typeLabel.text = typeArray[n];
            
            typeLabel.font = [UIFont appFontRegularOfSize:11];
            
            typeLabel.textColor = [UIColor UIColorWithHexColorString:@"0x999999" AndAlpha:1.0];
            
            [bottomView addSubview:typeLabel];
            
            UILabel * moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/3 * n, CGRectGetMaxY(typeLabel.frame) + 4, DeviceWidth/3, 17)];
            
            moneyLabel.textAlignment = NSTextAlignmentCenter;
            
            moneyLabel.font = [UIFont systemFontOfSize:16];
            
            moneyLabel.textColor = UIColorFromRGB(0x333333, 1.0);
            
            if (n == 0) {
                
                _nearlySevenDay = moneyLabel;
                
                _nearlySevenDay.textColor =  [UIColor UIColorWithHexColorString:@"0xfda252" AndAlpha:1.0];
            }else if (n == 1){
                
                _thisMonth = moneyLabel;
            }else{
                
                _fullLoan = moneyLabel;
            }
            [bottomView addSubview:moneyLabel];
            
            if (n == 1 || n == 2) {
                
                UIView * verticalView = [[UIView alloc]initWithFrame:CGRectMake(DeviceWidth/3 * n, 23, 1, 64)];
                
                verticalView.backgroundColor = [UIColor UIColorWithHexColorString:@"0xebebeb" AndAlpha:1.0];
                
                [bottomView addSubview:verticalView];
            }
            HCRepayButton *button = [[HCRepayButton alloc]initWithFrame:CGRectMake(DeviceWidth/3 * n, 0, DeviceWidth/3, 110)];
            
            button.tag = 10+n;
            
            button.place = typeArray[n];
            
            [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            
            button.backgroundColor = [UIColor clearColor];
            
            [bottomView addSubview:button];
        }
    }else{
        
        float x = DeviceWidth/375;
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 90 *x)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        for (int n = 0 ; n < 3; n ++) {
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth/6 - 8 *x + n * DeviceWidth/3, 15 *x, 16 *x, 16 *x)];
            
            imageView.image = [UIImage imageNamed:typeArray[n]];
            
            [bottomView addSubview:imageView];
            
            UILabel * typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/3 * n, CGRectGetMaxY(imageView.frame) + 8 *x, DeviceWidth/3, 13 *x)];
            
            typeLabel.textAlignment = NSTextAlignmentCenter;
            
            typeLabel.text = typeArray[n];
            
            typeLabel.font = [UIFont appFontRegularOfSize:12 *x];
            
            typeLabel.textColor = [UIColor UIColorWithHexColorString:@"0x999999" AndAlpha:1.0];
            
            [bottomView addSubview:typeLabel];
            
            UILabel * moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/3 * n, CGRectGetMaxY(typeLabel.frame) + 5 *x, DeviceWidth/3, 15 *x)];
            
            moneyLabel.textAlignment = NSTextAlignmentCenter;
            
            moneyLabel.font = [UIFont systemFontOfSize:17];
            
            moneyLabel.textColor = [UIColor UIColorWithHexColorString:@"0x666666" AndAlpha:1.0];
            
            if (n == 0) {
                
                _nearlySevenDay = moneyLabel;
                
                _nearlySevenDay.textColor =  [UIColor UIColorWithHexColorString:@"0xfda252" AndAlpha:1.0];
            }else if (n == 1){
                
                _thisMonth = moneyLabel;
            }else{
                
                _fullLoan = moneyLabel;
            }
            [bottomView addSubview:moneyLabel];
            
            if (n == 1 || n == 2) {
                
                UIView * verticalView = [[UIView alloc]initWithFrame:CGRectMake(DeviceWidth/3 * n, 15 *x, 1 *x, 60 *x)];
                
                verticalView.backgroundColor = [UIColor UIColorWithHexColorString:@"0xebebeb" AndAlpha:1.0];
                
                [bottomView addSubview:verticalView];
            }
            
            HCRepayButton *button = [[HCRepayButton alloc]initWithFrame:CGRectMake(DeviceWidth/3 * n, 0, DeviceWidth/3, 90 *x)];
            
            button.tag = 10+n;
            
            button.place = typeArray[n];
            
            [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            
            button.backgroundColor = [UIColor clearColor];
            
            [bottomView addSubview:button];
        }
    }
}
- (void)clickAction:(HCRepayButton *)btn{

    if (_delegate && [_delegate respondsToSelector:@selector(sendRepayPlace:)]) {
        [_delegate sendRepayPlace:btn.place];
    }
}
@end
