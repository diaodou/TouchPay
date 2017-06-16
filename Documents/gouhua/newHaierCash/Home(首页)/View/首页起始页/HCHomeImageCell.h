//
//  HCHomeImageCell.h
//  newHaierCash
//
//  Created by Will on 2017/6/3.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeChildModel;
@protocol HCHomeImageCellDelegate;

@interface HCHomeImageCell : UITableViewCell

@property(nonatomic,weak)id<HCHomeImageCellDelegate> cellDelegate;


- (void)generateCellWithModels:(NSArray *)models;


@end

@protocol HCHomeImageCellDelegate <NSObject>

- (void)ADImageViewDidClcik:(HomeChildModel *)model;

@end
