//
//  CompanyModel.h
//  personMerchants
//
//  Created by 张久健 on 16/5/7.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CompanyHead,CompanyBody;
@interface CompanyModel : NSObject

@property (nonatomic, strong) CompanyHead *head;

@property (nonatomic, strong) CompanyBody *body;

@end
@interface CompanyHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface CompanyBody : NSObject

@property (nonatomic, copy) NSString *pptyLoanYear;

@property (nonatomic, copy) NSString *liveRmk;

@property (nonatomic, copy) NSString *liveZip;

@property (nonatomic, copy) NSString *liveInfo;

@property (nonatomic, assign) NSInteger liveYear;

@property (nonatomic, copy) NSString *highestDegree;

@property (nonatomic, copy) NSString *workYrs;

@property (nonatomic, copy) NSString *positionType;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *fmlyTel;

@property (nonatomic, copy) NSString *professionalTitle;

@property (nonatomic, copy) NSString *updateDt;

@property (nonatomic, copy) NSString *maritalStatus;

@property (nonatomic, copy) NSString *pptyProvince;

@property (nonatomic, copy) NSString *regArea;

@property (nonatomic, copy) NSString *pptyLiveInd;

@property (nonatomic, copy) NSString *pptyLoanInd;

@property (nonatomic, copy) NSString *officeIndtry;

@property (nonatomic, copy) NSString *pptyRighName;

@property (nonatomic, copy) NSString *spouseOffice;

@property (nonatomic, copy) NSString *studyDegree;

@property (nonatomic, copy) NSString *updateUser;

@property (nonatomic, copy) NSString *licIdInd;

@property (nonatomic, copy) NSString *licNo;

@property (nonatomic, copy) NSString *liveProvince;

@property (nonatomic, copy) NSString *pptyLoanAmt;

@property (nonatomic, copy) NSString *regProvince;

@property (nonatomic, copy) NSString *schoolKind;

@property (nonatomic, copy) NSString *serviceYears;

@property (nonatomic, copy) NSString *yearInc;

@property (nonatomic, copy) NSString *spMthInc;

@property (nonatomic, copy) NSString *postCity;

@property (nonatomic, copy) NSString *spouseCertNo;

@property (nonatomic, copy) NSString *fmlyMthExp;

@property (nonatomic, copy) NSString *regAddr;

@property (nonatomic, copy) NSString *postArea;

@property (nonatomic, copy) NSString *liveCity;

@property (nonatomic, copy) NSString *liveArea;

@property (nonatomic, assign) NSInteger pptyAmt;

@property (nonatomic, copy) NSString *pptyCity;

@property (nonatomic, copy) NSString *officeTypRmk;

@property (nonatomic, copy) NSString *pptyArea;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *schoolGrade;

@property (nonatomic, copy) NSString *officeTel;

@property (nonatomic, copy) NSString *custNo;

@property (nonatomic, copy) NSString *officeCity;

@property (nonatomic, copy) NSString *positionRmk;

@property (nonatomic, copy) NSString *officeArea;

@property (nonatomic, copy) NSString *custIndtry;

@property (nonatomic, copy) NSString *officeName;

@property (nonatomic, copy) NSString *incSrc;

@property (nonatomic, copy) NSString *liveSize;

@property (nonatomic, copy) NSString *pptySize;

@property (nonatomic, copy) NSString *pptyLoanBank;

@property (nonatomic, copy) NSString *fmlyZone;

@property (nonatomic, copy) NSString *officeAddr;

@property (nonatomic, copy) NSString *localResid;

@property (nonatomic, copy) NSString *livePayAmt;

@property (nonatomic, copy) NSString *postProvince;

@property (nonatomic, copy) NSString * mthInc;

@property (nonatomic, copy) NSString *officeDept;

@property (nonatomic, copy) NSString *postAddr;

@property (nonatomic, copy) NSString *licInd;

@property (nonatomic, copy) NSString *studyMajor;

@property (nonatomic, copy) NSString *liveAddr;

@property (nonatomic, copy) NSString *spouseMobile;

@property (nonatomic, copy) NSString *schoolName;

@property (nonatomic, copy) NSString *studyType;

@property (nonatomic, copy) NSString *mortgagePartner;

@property (nonatomic, copy) NSString *regCity;

@property (nonatomic, copy) NSString *pptyAddr;

@property (nonatomic, copy) NSString *weixin;

@property (nonatomic, copy) NSString *spouseCertType;

@property (nonatomic, copy) NSString *mortgageRatio;

@property (nonatomic, copy) NSString *schoolLeng;

@property (nonatomic, copy) NSString *postQtInd;

@property (nonatomic, assign) NSInteger providerNum;

@property (nonatomic, copy) NSString *officeProvince;

@property (nonatomic, copy) NSString *spouseName;

@property (nonatomic, copy) NSString *regLiveInd;

@end

