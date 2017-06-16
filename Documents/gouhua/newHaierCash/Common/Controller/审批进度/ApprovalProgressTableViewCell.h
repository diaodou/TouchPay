//
//  ApprovalProgressTableViewCell.h
//  newHaierCash
//
//  Created by 张久健 on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApprovalProgressTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *wfiNodeName;
@property (strong, nonatomic) UILabel *appConclusionDesc;
@property (strong, nonatomic) UIView *roundView;
@property (strong, nonatomic) UIView *oneView;
@property (strong, nonatomic) UIView *twoView;
@end
