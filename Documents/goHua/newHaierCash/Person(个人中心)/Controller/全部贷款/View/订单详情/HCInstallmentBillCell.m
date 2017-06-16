//
//  HCInstallmentBillCell.m
//  newHaierCash
//
//  Created by BSVK on 2017/6/14.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCInstallmentBillCell.h"
#import "UIColor+DefineNew.h"
#import "HCMacro.h"

@implementation HCInstallmentBillCell
{
    UIButton *_choiceBtn;        //选择btn
    UILabel *_moneyLbl;         //金额
    UILabel *_nameLbl;          //名称
    UILabel *_waitRepayLbl;        //等待还款
}
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
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    CGFloat x = iphone6P ? scale6PAdapter : scaleAdapter;
    if (iphone6P) {
        _choiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 24, 24, 24)];
        [_choiceBtn setBackgroundImage:[UIImage imageNamed:@"图标_未选中"] forState:UIControlStateNormal];
        [self.contentView addSubview:_choiceBtn];
        
        _moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(48, 17, 200, 13)];
        _moneyLbl.textColor = [UIColor UIColorWithHexColorString:@"#fda253" AndAlpha:1];
        _moneyLbl.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_moneyLbl];
        
        _nameLbl  = [[UILabel alloc]initWithFrame:CGRectMake(48, 42, 200, 13)];
        _nameLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _nameLbl.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_nameLbl];
        
        _waitRepayLbl = [[UILabel alloc]initWithFrame:CGRectMake(309, 29, 90, 13)];
        _waitRepayLbl.textAlignment = NSTextAlignmentRight;
        _waitRepayLbl.font = [UIFont systemFontOfSize:13];
        _waitRepayLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        [self.contentView addSubview:_waitRepayLbl];
    }else{
        _choiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(13*x, 22*x, 21*x, 21*x)];
        [_choiceBtn setBackgroundImage:[UIImage imageNamed:@"图标_未选中"] forState:UIControlStateNormal];
        [self.contentView addSubview:_choiceBtn];
        
        _moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(42*x, 15*x, 200*x, 12*x)];
        _moneyLbl.textColor = [UIColor UIColorWithHexColorString:@"#fda253" AndAlpha:1];
        _moneyLbl.font = [UIFont systemFontOfSize:12*x];
        [self.contentView addSubview:_moneyLbl];
        
        _nameLbl  = [[UILabel alloc]initWithFrame:CGRectMake(42*x, 38*x, 200*x, 12*x)];
        _nameLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _nameLbl.font = [UIFont systemFontOfSize:12*x];
        [self.contentView addSubview:_nameLbl];
        
        _waitRepayLbl = [[UILabel alloc]initWithFrame:CGRectMake(272*x, 25*x, 90*x, 12*x)];
        _waitRepayLbl.textAlignment = NSTextAlignmentRight;
        _waitRepayLbl.font = [UIFont systemFontOfSize:12*x];
        _waitRepayLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        [self.contentView addSubview:_waitRepayLbl];
    }
    
}

-(void)setMethod{
    _moneyLbl.text = @"¥78.90";
    _nameLbl.text = @"【1/12期】日韩五日游";
    _waitRepayLbl.text = @"03-12待还";
}

@end
