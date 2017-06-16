//
//  HCOrderInfoCell.h
//  newHaierCash
//
//  Created by Will on 2017/6/15.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCOrderInfoCell : UITableViewCell

- (void)generateCellWithTitle:(NSString *)title andType:(NSString *)type andInfo:(NSString *)info andHiddenImg:(BOOL)isHidden;

@end
