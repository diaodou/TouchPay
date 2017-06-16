//
//  HCShippingAddressCell.h
//  newHaierCash
//
//  Created by BSVK on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCShippingAddressCell : UITableViewCell


@property(nonatomic , strong)UILabel *nameLbl; //收货人姓名
@property(nonatomic , strong)UILabel *phoneNumberLbl;   //收货人电话
@property(nonatomic , strong)UILabel *adressLbl;    //收货人地址
@property(nonatomic , strong)UIImageView *defaultImgV;     //右上默认标识
@property(nonatomic , strong)UIImageView *bottomImgV;       //底部默认标识

@property(nonatomic , assign)BOOL defaultAdress;

-(void)setMethod;
@end
