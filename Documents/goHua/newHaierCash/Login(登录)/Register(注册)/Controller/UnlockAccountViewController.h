//
//  UnlockAccountViewController.h
//  newHaierCash
//
//  Created by 张久健 on 2017/6/1.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
typedef NS_ENUM(NSInteger,FromStartView){
    
    FromRegister,   //从注册页面开始
    
    FromRealName,   //从实名认证开始
    
    FromPersonInfo, //从个人资料开始
    
    FromFace,       //从人脸识别开始
    
    FromSetPayNum,  //从设置支付密码开始
    
};

typedef NS_ENUM(NSInteger,ShowInfoType){
    
    ShowRegAndRealInfo,    //仅展示注册，实名
    
    ShowPerAndFaceInfo,    //仅展示个人资料，人脸，设置密码
    
    ShowAllInfo,           //展示全部信息
    
};

typedef NS_ENUM(NSInteger ,NowWhere)
{
    NowRegister,        //注册
    NowVerification,    //验证码
    NowSetPass,         //设置登录密码
    NowCardFront,       //身份证正面
    NowSide,            //身份证反面
    NowCheckBank,       //校验银行卡
    NowPersonInfo,      //完善信息
    NowFace,            //人脸
    NowSetPayNum,       //支付密码设置
    NowCommit,          //支付密码验证码
};

typedef NS_ENUM(NSInteger,FaceStatus){
    
    FaceNoCheck,   //未定义
    
    FaceNotPass,   //人脸识别未通过
    
    FaceNotDo,     //人脸识别未做
    
    FaceReplaceImage, //人脸卫国但是有替代影像
    
    FacePassed      //人脸识别成功
    
};

@interface UnlockAccountViewController : HCBaseViewController

@property (nonatomic,assign) NSInteger currentIndex;  //判断当前的是哪栏
/**
 判断从哪一个页面开始
 */
@property (nonatomic,assign) FromStartView startType;
/**
 判断需要展示那些内容
 */
@property (nonatomic,assign) ShowInfoType  showType;
/*
 若是从现金贷，商品贷流程进入，贷款品种代码必传
 */
@property (nonatomic,copy) NSString *typeCde;//贷款品种代码
/**
 若显示三个圈(展示个人资料，人脸，设置密码),个人信息是否完善必定赋值
 */
@property (nonatomic,assign) BOOL personInfoSuccess;//个人信息是否完善
/**
 若显示三个圈(展示个人资料，人脸，设置密码),人脸识别是否完善必定赋值
 */
@property (nonatomic,assign) FaceStatus faceInfoSuccess;//人脸识别是否完善

@property (nonatomic,copy) NSArray *faceImgArray;//人脸替代影像

/**
 仅限手势解锁页面进入登录页面，点击注册进入此页面才可给此值赋为YES
 */
@property (nonatomic,assign) BOOL ifFromGesture;

@end
