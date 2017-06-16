//
//  LimitInfoTableViewCell.h
//  HaiFu
//
//  Created by 史长硕 on 17/2/14.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@protocol SendCellNameDelegate <NSObject>

-(void)sendCellName:(NSString *)name;

@end

@interface LimitInfoTableViewCell : UITableViewCell

@property(nonatomic,strong)CustomButton *cutNutton;//按钮


@property(nonatomic,weak)id<SendCellNameDelegate> delegate;

-(void)insertTitleArray:(NSArray *)titArray success:(NSMutableDictionary *)dic;

@end
