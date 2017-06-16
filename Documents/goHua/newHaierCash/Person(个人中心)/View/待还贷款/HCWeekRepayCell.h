//
//  HCWeekRepayCell.h
//  newHaierCash
//
//  Created by Will on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HCWeekRepayCellDelegate;

@interface HCWeekRepayCell : UITableViewCell
@property (nonatomic, weak) id<HCWeekRepayCellDelegate> delegate;

- (void)generateCellWithModel:(NSDictionary *)model;

- (void)changeSelectBtnState:(BOOL)isSelect;

@end

@protocol HCWeekRepayCellDelegate <NSObject>

- (void)HCWeekReplayCellGetModel:(NSDictionary *)model withIsSelect:(BOOL)isSelect;


@end
