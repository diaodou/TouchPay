//
//  HCChangeNumCell.h
//  newHaierCash
//
//  Created by Will on 2017/6/3.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HCChangeNumCellDelegate;

@interface HCChangeNumCell : UITableViewCell

@property (nonatomic, weak) id<HCChangeNumCellDelegate> delegate;

- (void)generateCellWithModel:(NSDictionary *)model;

- (void)generateCellWithTitle:(NSString *)title andGoodsNum:(NSString *)num;

- (void)resetNumLbl:(NSInteger)num;

@end

@protocol HCChangeNumCellDelegate <NSObject>

@optional
- (void)HCChangeNumCellChangeNum:(NSInteger)num withTitle:(NSString *)title;

- (void)HCChangeNumCellGetModel:(NSDictionary *)model;



@end
