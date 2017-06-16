//
//  PeoPleInfoTableViewCell.m
//  personMerchants
//
//  Created by LLM on 2017/1/11.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "PeoPleInfoTableViewCell.h"
#import "HCMacro.h"

@implementation PeoPleInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self initContentView];
    }
    
    return self;
}

- (void)initContentView
{
    UITextField *tf = [[UITextField alloc] init];
    tf.frame = CGRectMake(20*scaleAdapter, 0, DeviceWidth-40*scaleAdapter, 45*scaleAdapter);
    tf.font = [UIFont systemFontOfSize:13.f];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 10*scaleAdapter, 100*scaleAdapter, 25*scaleAdapter);
    label.font = [UIFont systemFontOfSize:13.0f];
    
    tf.leftView = label;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 14.5*scaleAdapter, 10*scaleAdapter, 16*scaleAdapter)];
    image.image = [UIImage imageNamed:@"箭头_右_灰"];
    
    tf.rightView = image;
    
    [self.contentView addSubview:tf];
    
    self.tf = tf;
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 44*scaleAdapter, DeviceWidth, 1.f*scaleAdapter);
    view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f];
    [self.contentView addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
