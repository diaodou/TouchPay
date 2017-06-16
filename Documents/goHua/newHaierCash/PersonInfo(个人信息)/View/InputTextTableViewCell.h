//
//  InputTextTableViewCell.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 17/1/10.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeClass.h"
#import "GoodTextField.h"

@protocol SendTextDelegate <NSObject>

-(void)sendText:(NSString *)string index:(NSIndexPath *)path;

-(void)sendNowGoodText:(GoodTextField *)field index:(NSIndexPath *)indexPath;

@end

@interface InputTextTableViewCell : UITableViewCell

@property(nonatomic,weak)id<SendTextDelegate> delegate;

@property(nonatomic,strong)UILabel *nameLab;//左侧标题

@property(nonatomic,strong)GoodTextField *optionText;//中间文字说明

@property(nonatomic,strong)UIImageView *imgView;//右侧箭头

@property(nonatomic,strong)UIView *spaceView;//间隔view

-(void)inserModelCompanyModel:(TypeClass *)type view:(BOOL)Hidden;



@end
