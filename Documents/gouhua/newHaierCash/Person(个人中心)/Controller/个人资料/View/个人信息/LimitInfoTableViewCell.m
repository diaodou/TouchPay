//
//  LimitInfoTableViewCell.m
//  HaiFu
//
//  Created by 史长硕 on 17/2/14.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import "LimitInfoTableViewCell.h"
#import "UIFont+AppFont.h"
#import "HCMacro.h"
#import "CheckMsgModel.h"
@implementation LimitInfoTableViewCell

#pragma mark --> life Cycle

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        [self creatUI];
        
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --> previte Methods

-(void)creatUI{
    
    for (int i = 0; i<4; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth/16+DeviceWidth/4*i, DeviceWidth/40, DeviceWidth/8, DeviceWidth/8)];
        
        imageView.layer.cornerRadius = DeviceWidth/16;
        
        imageView.tag = 10+i;
        
        imageView.hidden = YES;
        
        [self.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/4*i, DeviceWidth*3/20, DeviceWidth/4, DeviceWidth/10)];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.tag = 20+i;
        
        label.hidden = YES;
        
        label.font = [UIFont appFontRegularOfSize:12];
        
        [self.contentView addSubview:label];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(DeviceWidth/4*(i+1), 0, 1, DeviceWidth/4)];
        
        lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
        
        lineView.hidden = YES;
        
        lineView.tag = 30+i;
        
        [self.contentView addSubview:lineView];
        
        UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth/5+DeviceWidth/4*i, DeviceWidth/80, DeviceWidth/25, DeviceWidth/25)];
        
        rightImg.tag = 40+i;
        
        rightImg.hidden = YES;
        
        [self.contentView addSubview:rightImg];
        
        CustomButton *button = [[CustomButton alloc]initWithFrame:CGRectMake(DeviceWidth/4*i, 0, DeviceWidth/4, DeviceWidth/4)];
        
        button.tag = 60+i;
        
        [button addTarget:self action:@selector(buildTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:button];
        
    }
    
}



-(void)insertTitleArray:(NSArray *)titArray success:(NSMutableDictionary *)dic{
    
    for (UIView *view in self.contentView.subviews) {
        
        view.hidden = YES;
        
    }
    
    for (int i = 0; i<titArray.count; i++) {
        
        NSString *string = titArray[i];
        
        UIImageView *imgView = (UIImageView *)[self.contentView viewWithTag:i+10];
        
        imgView.hidden = NO;
        
        
        
        if ([string isEqualToString:@"必传影像"]) {
            
             imgView.image = [UIImage imageNamed:@"影像信息"];
            
        }else if ([string isEqualToString:@"选传影像"]){
            
            imgView.image = [UIImage imageNamed:@"选传影像"];
        }else{
            
           imgView.image = [UIImage imageNamed:string];
            
        }
        
        UILabel *lab = (UILabel *)[self.contentView viewWithTag:20+i];
        
        lab.text = string;
        
        lab.hidden = NO;
        
         UIImageView *sucImg = (UIImageView *)[self.contentView viewWithTag:40+i];
        
        sucImg.hidden = NO;
        
        if (![string isEqualToString:@"选传影像"]) {
            
            if ([string isEqualToString:@"人脸识别"]) {
                
                CheckMsgRlsb *rlsb = [dic objectForKey:string];
                
                if ([rlsb.code isEqualToString:@"00"]) {
                  
                     sucImg.image = [UIImage imageNamed:@"成功"];
                    
                }else{
                    
                  sucImg.image = [UIImage imageNamed:@"失败"];
                    
                }
                
            }else if ([string isEqualToString:@"必传影像"]){
               
                CheckMsgBcyx *bcyx = [dic objectForKey:string];
                
                if ([bcyx.BCYX isEqualToString:@"Y"]) {
                 
                    sucImg.image = [UIImage imageNamed:@"成功"];
                    
                }else{
                 
                     sucImg.image = [UIImage imageNamed:@"失败"];
                    
                }
                
            }else if ([string isEqualToString:@"公积金"]||[string isEqualToString:@"银联"]){
                    
                    if ([[dic objectForKey:string]isEqualToString:@"Y"]) {
                        
                        sucImg.image = [UIImage imageNamed:@"成功"];
                        
                        
                    }else{
                        
                        sucImg.image = [UIImage imageNamed:@"失败"];
                        
                    }
               
                
            }else{
               
                if ([[dic objectForKey:string]isEqualToString:@"Y"]) {
                    
                    sucImg.image = [UIImage imageNamed:@"成功"];
                    
                }else{
                    
                    sucImg.image = [UIImage imageNamed:@"失败"];
                    
                }
                
            }

            
            
        }else{
            
            sucImg.hidden = YES;
        }
        
        if (i<3) {
            
          UIView *lineView = (UIView *)[self.contentView viewWithTag:30+i];
            
          lineView.hidden = NO;
            
        }
        
        CustomButton *button = (CustomButton *)[self.contentView viewWithTag:60+i];
        
        button.hidden = NO;
        
        button.storeName = string;
        
    }
    
}

#pragma mark --> response Methods

-(void)buildTouchAction:(CustomButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendCellName:)]) {
        
        [_delegate sendCellName:sender.storeName];
        
    }
    
}

@end
