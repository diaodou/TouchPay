//
//  HCHeadImageTableViewCell.h
//  newHaierCash
//
//  Created by 百思为科 on 2017/5/27.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCHeadImageTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView * headImageView;  //头像

@property (nonatomic, strong)UILabel * nameLabel;          //姓名

@property (nonatomic, strong)UILabel * numberLabel;        //手机号

@property (nonatomic, strong)UILabel * loginLabel;          //登录按钮
@end
