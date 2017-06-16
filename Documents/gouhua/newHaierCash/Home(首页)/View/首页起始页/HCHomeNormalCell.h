//
//  HCHomeInfoCell.h
//  newHaierCash
//
//  Created by Will on 2017/5/31.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeChildModel;

@interface HCHomeNormalCell : UITableViewCell

- (void)generateCellWithModel:(HomeChildModel *)model;

@end
