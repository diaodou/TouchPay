//
//  StatusProvingView.h
//  personMerchants
//
//  Created by 史长硕 on 17/2/20.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYTextView.h>
typedef NS_ENUM(NSInteger, TouchType) {
    Status,                     //身份验证
    Gender,                     //性别
    Time,                       //出生年月
    Office,                     //签发机关
    Valid,                       //有效期
    LeftImage,                  //左侧照片
    RightImage,                   //右侧照片
    Camera,                        //拍照必传影像
    Address                        //家庭住址

};

@protocol SendStatusOpenDelegate <NSObject>

@optional

-(void)sendTouchType:(TouchType)type open:(BOOL)isOpen num:(NSInteger )number;

-(void)sendSelectType:(TouchType )type;

-(void)sendTextViewHeight:(float)height;

@end

@interface StatusProvingView : UIView

@property(nonatomic,strong)UILabel *genderLabel;//性别

@property(nonatomic,strong)UILabel *birthLabel;//出生年月

@property(nonatomic,strong)UILabel *addressText;//家庭住址

@property(nonatomic,strong)UILabel *officeText;//签证机关

@property(nonatomic,strong)UILabel *validLabel;//有效期

@property(nonatomic,strong)UIImageView *leftimage;//身份证正面

@property(nonatomic,strong)UIImageView *rightImage;//身份证反面

@property(nonatomic,strong)UIImageView *arrowImage;//箭头

@property(nonatomic,strong) UIView *baseView;

@property(nonatomic,strong) UIButton *button;

@property(nonatomic,weak)id<SendStatusOpenDelegate> delegate;

-(void)creatHeaderView;

-(void)creatBaseUI:(CGRect)frame;

-(void)creatNameView;

-(void)creatBaseText;

-(void)buildNowTimeChangeViewHeight:(NSString *)string;

@end
