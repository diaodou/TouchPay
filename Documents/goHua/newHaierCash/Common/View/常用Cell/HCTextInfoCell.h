//
//  HCTextInfoCell.h
//  newHaierCash
//
//  Created by Will on 2017/6/15.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HCTextInfoCellDelegate;

@interface HCTextInfoCell : UITableViewCell

@property (nonatomic, strong) UITextField *contentTxt;

@property (nonatomic,weak)id<HCTextInfoCellDelegate> delegate;

- (NSString *)cellTitle;

- (void)generateCellWithModel:(NSDictionary *)model;

- (void)generateCellWithTitle:(NSString *)title andPlaceStr:(NSString *)placeStr orContent:(NSString *)content;

- (void)generateCellWithTitle:(NSString *)title andInfo:(NSString *)info;

- (void)setImgHidden:(BOOL)hidden;
@end

@protocol HCTextInfoCellDelegate <NSObject>

@optional
- (void)HCTextInfoCellGetModel:(NSDictionary *)model;

- (void)HCTextInfoInput:(NSString *)content withTitle:(NSString *)title;
@end
