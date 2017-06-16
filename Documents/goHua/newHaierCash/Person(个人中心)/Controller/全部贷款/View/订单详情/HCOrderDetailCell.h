//
//  HCOrderDetailCell.h
//  newHaierCash
//
//  Created by BSVK on 2017/6/14.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCOrderDetailCell : UITableViewCell
@property(nonatomic , copy)void (^applyRefundBlock)(NSString *orderNumber);

-(void)setMethod;

@end
