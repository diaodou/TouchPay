//
//  InputTextTableViewCell.m
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 17/1/10.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "InputTextTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "UIColor+DefineNew.h"
@interface InputTextTableViewCell ()<UITextFieldDelegate>
{
    
    float x;
    
    UIView *lineView;
    
}



@end
@implementation InputTextTableViewCell

#pragma mark --> life Cyce

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        if (iphone6P) {
            
            x = scale6PAdapter;
            
        }else{
            
            x  = DeviceWidth/375.0;
            
        }
        
        
        
        [self creatUI];
    }
    
    return self;
}

#pragma mark --> private Methods

-(void)creatUI{
    
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(28, 10, 82, 25)];
    
    _nameLab.textColor  =[UIColor UIColorWithHexColorString:@"0x232326" AndAlpha:1.0];
    
    _nameLab.font = [UIFont appFontRegularOfSize:14];
    
    [self.contentView addSubview:_nameLab];
    
    _optionText = [[GoodTextField alloc]initWithFrame:CGRectMake(125, 10, DeviceWidth-125-50*x, 25)];
    
    _optionText.textColor = [UIColor UIColorWithHexColorString:@"0x232326" AndAlpha:1.0];
    
    _optionText.textAlignment = NSTextAlignmentRight;
    
    _optionText.font = [UIFont appFontRegularOfSize:13];
    
    _optionText.returnKeyType = UIReturnKeyDone;
    
    _optionText.delegate = self;
    
    [self.contentView addSubview:_optionText];
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-50*x, 15.5, 8, 14)];
    
    _imgView.image = [UIImage imageNamed:@"箭头"];
    
    [self.contentView addSubview:_imgView];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 44, DeviceWidth-30, 0.5)];
    
    lineView.backgroundColor = [UIColor UIColorWithHexColorString:@"0xdcdcdc" AndAlpha:1.0];
    
    [self.contentView addSubview:lineView];
    
    _spaceView = [[UIView alloc]init];
    
    _spaceView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:_spaceView];
    
}

//插入单位信息数据源
-(void)inserModelCompanyModel:(TypeClass *)type view:(BOOL)Hidden{
    
    self.nameLab.text = type.title;
    
    self.optionText.keyboardType = type.boardType;
    
    self.optionText.enabled = type.isEdit;
    
    if ([type.title isEqualToString:@"紧急联系人关系"]||[type.title isEqualToString:@"亲属关系"]) {
        
        self.optionText.textAlignment = NSTextAlignmentRight;
        
    }else{
        
        self.optionText.textAlignment = NSTextAlignmentLeft;
    }
    
    if (type.isEdit) {
        
        self.imgView.hidden = YES;
        
        self.optionText.frame = CGRectMake(126, 10, DeviceWidth-126, 25);
        
    }else{
        
        self.imgView.hidden = NO;
        
        self.optionText.frame = CGRectMake(126, 10, DeviceWidth-161, 25);
    }
    
    self.optionText.placeholder = type.placeholder;
    
    if (type.result.length > 0) {
        
        self.optionText.text = type.result;
        
    }
    
    lineView.hidden = Hidden;
    
    
    
}

#pragma mark --> textField代理协议

-(void)textFieldDidEndEditing:(GoodTextField *)textField{
    
    if (textField.text.length > 0) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendText:index:)]) {
            
            UITableView *table = (UITableView *)self.superview.superview;
            
            [_delegate sendText:textField.text index:[table indexPathForCell:self]];
            
        }
        
    }else{
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendText:index:)]) {
            
            UITableView *table = (UITableView *)self.superview.superview;
            
            [_delegate sendText:@"" index:[table indexPathForCell:self]];
            
        }
    }
    
}

-(void)textFieldDidBeginEditing:(GoodTextField *)textField{
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendNowGoodText:index:)]) {
        
        UITableView *table = (UITableView *)self.superview.superview;
        
        [_delegate sendNowGoodText:textField index:[table indexPathForCell:self]];
        
    }
}

-(BOOL)textFieldShouldReturn:(GoodTextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    _nameLab.text = @"";
    
    _optionText.text = @"";
    
    _imgView.hidden = YES;
    
}

@end
