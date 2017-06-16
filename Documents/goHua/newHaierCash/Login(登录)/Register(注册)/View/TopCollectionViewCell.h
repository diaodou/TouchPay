//
//  TopCollectionViewCell.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeosonInfoType.h"
@interface TopCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *titleImage;

@property (nonatomic,strong) UIImageView *arrowImage;

-(void)insertInfomodel:(PeosonInfoType *)model;

@end
