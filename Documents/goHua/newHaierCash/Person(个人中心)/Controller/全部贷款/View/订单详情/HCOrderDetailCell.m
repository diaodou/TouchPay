//
//  HCOrderDetailCell.m
//  newHaierCash
//
//  Created by BSVK on 2017/6/14.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCOrderDetailCell.h"
#import "HCMacro.h"
#import "UIColor+DefineNew.h"

@implementation HCOrderDetailCell
{
    UIView *_firstLine;          //三条分割线
    UIView *_secondLine;
    UIView *_thirdLine;
    UILabel *_godNameLbl;          //货物名称
    UILabel *_dateNameLbl;         //日期
    UILabel *_loanNumberLbl;      //贷款编号
    UILabel *_installmentPrincipalNameLbl;   //分期本金名称
    UILabel *_installmentPrincipalNumberLbl;  //分期本金金额
    UILabel *_interestNameLbl; //息费名称
    UILabel *_interestNumberLbl; //息费金额
    UILabel *_totalNameLbl;     //合计名称
    UILabel *_totalNumberLbl;   //合计金额
    UILabel *_installmentBillNameLbl;   //分期账单
    UILabel *_installmentBillNumberLbl; //分期账单金额
    UIButton *_applyRefundBtn;          //申请退款
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --init method

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    CGFloat x = iphone6P ? scale6PAdapter : scaleAdapter;
    if(iphone6P){
        _godNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(15,15, 200, 15)];
        _godNameLbl.font = [UIFont systemFontOfSize:15];
        _godNameLbl.textColor = [UIColor UIColorWithHexColorString:@"#fda253" AndAlpha:1];
        [self.contentView addSubview:_godNameLbl];
        
        _dateNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 44 , 200, 12)];
        _dateNameLbl.font = [UIFont systemFontOfSize:12];
        _dateNameLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        [self.contentView addSubview:_dateNameLbl];
        
        _loanNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(220, 28, DeviceWidth - 235, 13)];
        _loanNumberLbl.textAlignment  = NSTextAlignmentRight;
        _loanNumberLbl.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_loanNumberLbl];
        
        _installmentPrincipalNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 90, 50, 12)];
        _installmentPrincipalNameLbl.text = @"分期本金";
        _installmentPrincipalNameLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _installmentPrincipalNameLbl.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_installmentPrincipalNameLbl];
        
        _installmentPrincipalNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 110 , 120, 14)];
        _installmentPrincipalNumberLbl.textColor = [UIColor UIColorWithHexColorString:@"#fda253" AndAlpha:1];
        _installmentPrincipalNumberLbl.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_installmentPrincipalNumberLbl];
        
        _interestNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(170, 90, 25, 12)];
        _interestNameLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _interestNameLbl.text = @"息费";
        _interestNameLbl.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_interestNameLbl];
        
        _interestNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(170, 110, 100, 14)];
        _interestNumberLbl.textColor = [UIColor UIColorWithHexColorString:@"#fda253" AndAlpha:1];
        _interestNumberLbl.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_interestNumberLbl];
        
        _totalNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(305 , 90, 60, 12)];
        _totalNameLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _totalNameLbl.font = [UIFont systemFontOfSize:12];
        _totalNameLbl.text = @"合计金额";
        [self.contentView addSubview:_totalNameLbl];
        
        _totalNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(305, 110, 100, 14)];
        _totalNumberLbl.textColor = [UIColor UIColorWithHexColorString:@"#fda253" AndAlpha:1];
        _totalNumberLbl.font = [UIFont systemFontOfSize:13*x];
        [self.contentView addSubview:_totalNumberLbl];
        
        _installmentBillNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 160, 60, 14)];
        _installmentBillNameLbl.font = [UIFont systemFontOfSize:14];
        _installmentBillNameLbl.text = @"分期账单";
        [self.contentView addSubview:_installmentBillNameLbl];
        
        _installmentBillNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(80,160,DeviceWidth - 95 , 13)];
        _installmentBillNumberLbl.textAlignment = NSTextAlignmentRight;
        _installmentBillNumberLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _installmentBillNumberLbl.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_installmentBillNumberLbl];
        
        _applyRefundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyRefundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        _applyRefundBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _applyRefundBtn.frame = CGRectMake(309, 201, 90, 32);
        [_applyRefundBtn setTitleColor:[UIColor UIColorWithHexColorString:@"#666666" AndAlpha:1] forState:UIControlStateNormal];
        _applyRefundBtn.layer.cornerRadius = 16;
        _applyRefundBtn.layer.borderWidth = 0.5;
        _applyRefundBtn.layer.borderColor = [UIColor UIColorWithHexColorString:@"#bfbfbf" AndAlpha:1].CGColor;
        [_applyRefundBtn.layer masksToBounds];
        [_applyRefundBtn addTarget:self action:@selector(applyRefund:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_applyRefundBtn];
        
        _firstLine = [[UIView alloc]initWithFrame:CGRectMake(0, 72, DeviceWidth, 0.5)];
        _secondLine = [[UIView alloc]initWithFrame:CGRectMake(0, 144, DeviceWidth, 0.5)];
        _firstLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        _secondLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        _thirdLine = [[UIView alloc]initWithFrame:CGRectMake(0, 193, DeviceWidth, 0.5)];
        _thirdLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#dddddd" AndAlpha:1];
        [self.contentView addSubview:_firstLine];
        [self.contentView addSubview:_secondLine];
        [self.contentView addSubview:_thirdLine];
    }else{
        _godNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(13*x,15*x, 200*x, 14*x)];
        _godNameLbl.font = [UIFont systemFontOfSize:14*x];
        _godNameLbl.textColor = [UIColor UIColorWithHexColorString:@"#fda253" AndAlpha:1];
        [self.contentView addSubview:_godNameLbl];
        
        _dateNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(13*x, 38*x, 200*x, 12*x)];
        _dateNameLbl.font = [UIFont systemFontOfSize:12*x];
        _dateNameLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        [self.contentView addSubview:_dateNameLbl];
        
        _loanNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(200*x, 25*x, DeviceWidth - 213*x, 13*x)];
        _loanNumberLbl.font = [UIFont systemFontOfSize:13*x];
        _loanNumberLbl.textAlignment  = NSTextAlignmentRight;
        [self.contentView addSubview:_loanNumberLbl];
        
        _installmentPrincipalNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(13*x, 80*x, 45*x, 11*x)];
        _installmentPrincipalNameLbl.text = @"分期本金";
        _installmentPrincipalNameLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _installmentPrincipalNameLbl.font = [UIFont systemFontOfSize:11*x];
        [self.contentView addSubview:_installmentPrincipalNameLbl];
        
        _installmentPrincipalNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(13*x, 100*x, 120*x, 13*x)];
        _installmentPrincipalNumberLbl.textColor = [UIColor UIColorWithHexColorString:@"#fda253" AndAlpha:1];
        _installmentPrincipalNumberLbl.font = [UIFont systemFontOfSize:13*x];
        [self.contentView addSubview:_installmentPrincipalNumberLbl];
        
        _interestNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(155*x, 80*x, 25*x, 11*x)];
        _interestNameLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _interestNameLbl.text = @"息费";
        _interestNameLbl.font = [UIFont systemFontOfSize:11*x];
        [self.contentView addSubview:_interestNameLbl];
        
        _interestNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(155*x, 100*x, 90*x, 13*x)];
        _interestNumberLbl.textColor = [UIColor UIColorWithHexColorString:@"#fda253" AndAlpha:1];
        _interestNumberLbl.font = [UIFont systemFontOfSize:13*x];
        [self.contentView addSubview:_interestNumberLbl];
        
        _totalNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(275*x, 80*x, 55*x, 11*x)];
        _totalNameLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _totalNameLbl.font = [UIFont systemFontOfSize:11*x];
        _totalNameLbl.text = @"合计金额";
        [self.contentView addSubview:_totalNameLbl];
        
        _totalNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(275*x, 100*x, 95*x, 13*x)];
        _totalNumberLbl.textColor = [UIColor UIColorWithHexColorString:@"#fda253" AndAlpha:1];
        _totalNumberLbl.font = [UIFont systemFontOfSize:13*x];
        [self.contentView addSubview:_totalNumberLbl];
        
        _installmentBillNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(13*x, 145*x, 56*x, 13*x)];
        _installmentBillNameLbl.font = [UIFont systemFontOfSize:13*x];
        _installmentBillNameLbl.text = @"分期账单";
        [self.contentView addSubview:_installmentBillNameLbl];
        
        _installmentBillNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(80*x,145*x,DeviceWidth - 93*x , 12*x)];
        _installmentBillNumberLbl.textAlignment = NSTextAlignmentRight;
        _installmentBillNumberLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _installmentBillNumberLbl.font = [UIFont systemFontOfSize:12*x];
        [self.contentView addSubview:_installmentBillNumberLbl];
        
        _applyRefundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyRefundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        _applyRefundBtn.titleLabel.font = [UIFont systemFontOfSize:12*x];
        _applyRefundBtn.frame = CGRectMake(280*x, 181*x, 82*x, 29*x);
        [_applyRefundBtn setTitleColor:[UIColor UIColorWithHexColorString:@"#666666" AndAlpha:1] forState:UIControlStateNormal];
        _applyRefundBtn.layer.cornerRadius = 29*x/2;
        _applyRefundBtn.layer.borderWidth = 0.5;
        _applyRefundBtn.layer.borderColor = [UIColor UIColorWithHexColorString:@"#bfbfbf" AndAlpha:1].CGColor;
        [_applyRefundBtn.layer masksToBounds];
        [_applyRefundBtn addTarget:self action:@selector(applyRefund:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_applyRefundBtn];
        
        _firstLine = [[UIView alloc]initWithFrame:CGRectMake(0, 65*x, DeviceWidth, 0.5)];
        _secondLine = [[UIView alloc]initWithFrame:CGRectMake(0, 129*x, DeviceWidth, 0.5)];
        _firstLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        _secondLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        _thirdLine = [[UIView alloc]initWithFrame:CGRectMake(0, 174*x, DeviceWidth, 0.5)];
        _thirdLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#dddddd" AndAlpha:1];
        [self.contentView addSubview:_firstLine];
        [self.contentView addSubview:_secondLine];
        [self.contentView addSubview:_thirdLine];
    }
    
}

-(void)setMethod{
    _godNameLbl.text = @"欧洲七日游";
    _dateNameLbl.text = @"2015-12-30";
    _loanNumberLbl.text = @"贷款编号：1123450907";
    _installmentPrincipalNumberLbl.text = @"¥35000.00";
    _interestNumberLbl.text = @"¥350.00";
    _totalNumberLbl.text = @"35400.00";
    _installmentBillNumberLbl.text = @"已还¥890，待还¥30000";
}

-(void)applyRefund:(UIButton *)sender{
    self.applyRefundBlock(@"");
}

@end
