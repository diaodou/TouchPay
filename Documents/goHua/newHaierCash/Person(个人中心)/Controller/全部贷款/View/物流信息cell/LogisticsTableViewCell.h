//
//  LogisticsTableViewCell.h
//  物流信息
//
//  Created by 史长硕 on 2017/4/15.
//  Copyright © 2017年 史长硕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeActonModel.h"
@interface LogisticsTableViewCell : UITableViewCell

-(float)insertLogisticsModel:(TimeActionDetail *)model number:(NSInteger)num;

@end
