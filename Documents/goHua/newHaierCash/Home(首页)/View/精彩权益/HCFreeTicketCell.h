//
//  HCFreeTicketCell.h
//  newHaierCash
//
//  Created by Will on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HCFreeTicketCellDelegate;

@interface HCFreeTicketCell : UITableViewCell

@property (nonatomic, weak) id<HCFreeTicketCellDelegate>delegate;

-(void)generateCellWithModel:(NSDictionary *)model andAlreadyGet:(BOOL)isGet;

@end

@protocol HCFreeTicketCellDelegate <NSObject>

- (void)HCFreeTicketCellGetFreeTicket:(NSDictionary *)model;

@end
