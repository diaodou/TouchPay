//
//  HCRepaymentTableViewCell.h
//  newHaierCash
//
//  Created by 百思为科 on 2017/5/27.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendRepayPlaceDelegate <NSObject>

- (void)sendRepayPlace:(NSString *)label;

@end

@interface HCRepaymentTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel * nearlySevenDay;     //近七日待还

@property (nonatomic, strong)UILabel * thisMonth;          //本月待还

@property (nonatomic, strong)UILabel * fullLoan;           //全部待还

@property (nonatomic, weak)id<SendRepayPlaceDelegate>delegate; //点击回调
@end
