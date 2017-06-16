//
//  ShowType.h
//  TestC
//
//  Created by xuxie on 17/1/3.
//  Copyright © 2017年 chinaredstar. All rights reserved.
//

#ifndef ShowType_h
#define ShowType_h

typedef NS_ENUM(NSInteger, ShowPickViewType)
{
    WorkAddressCityPickType = 1, //单位地址省市选择
    LiveAddressCityPickType,     //居住地址省市选择
    EduPickType,                 //学历
    ResidencePickType,           //户口性质
    
    MarriedPickType,             //婚姻状况
    JobType,                     //职务类型
    IndustryType,                //行业性质
    WorkType,                    //从业性质
    HighestDegreeType,           //最高学历
    SupportNumberType,           //供养人数
    CreditCardsNumberType,       //信用卡数量
    PermanentAddressType,        //户籍地址
    PostalAddressType,           //通讯地址
    PersonEstateSituationType,   //个人信息栏的房产状况
    
    RealEstateSituationType,     //房产状况
    RealEstatePlaceType,         //房产地址
    ResidenceTimeType,           //居住年限
    
    ContactRelationType,         //联系人关系
    PermanentAddress,            //户籍地址
    PostalAddress,               //通讯地址
    
    ChooseGender,                //性别
    ChooseDateOfBirth,           //出生年月
    ValidityPeriod               //有效期限
};

typedef NS_ENUM(NSInteger, KeyBoardType)
{
    KeyBoardTypeDefault,        //默认键盘
    KeyBoardTypeNum             //数字键盘
};

//解锁账户中注册账号
typedef NS_ENUM(NSInteger,ShowUnlockType)
{
    MobileType,            //输入手机视图
    VerificationType,      //验证码视图
    PassWordType,          //密码设置视图
    
    CardPositiveType,      //身份证正面
    CardTheOtherType,      //身份证反面
    CheckBankType,         //校验银行卡
    
    ShowPersonType,        //完善信息
    
    ToFaceVerification,    //去人脸识别
    
    SetPayPassword,        //设置支付密码
    PasswordVericationType //支付密码验证
};
#endif /* ShowType_h */
