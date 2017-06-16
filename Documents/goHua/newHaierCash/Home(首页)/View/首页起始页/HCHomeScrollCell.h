//
//  HCHomeScrollCell.h
//  newHaierCash
//
//  Created by Will on 2017/6/3.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeChildModel;

@protocol HCHomeScrollCellDelegate;

@interface HCHomeScrollCell : UITableViewCell

@property(nonatomic,weak)id<HCHomeScrollCellDelegate> cellDelegate;

- (void)generateCellWithModels:(NSArray *)models;

@end

@protocol HCHomeScrollCellDelegate <NSObject>

- (void)ProfitViewDidClcik:(HomeChildModel *)model;

@end
