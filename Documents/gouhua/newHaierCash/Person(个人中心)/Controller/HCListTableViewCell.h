//
//  HCListTableViewCell.h
//  newHaierCash
//
//  Created by 百思为科 on 2017/5/31.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCListTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *listImage;  //图片

@property (nonatomic, strong)UILabel *listLabel;    //文字

@property (nonatomic, strong)UIView * lineView;    //底部线

@property (nonatomic, strong)UIImageView * arrowImage;  //箭头
@end
