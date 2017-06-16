//
//  HCUserModel.m
//  newHaierCash
//
//  Created by Will on 2017/5/31.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCUserModel.h"
#import "SignModel.h"
#import "QueryNumberModel.h"
#import "ReservedModel.h"
@implementation HCUserModel
- (void)initRealNameInfo:(id)dataModel {
    if ([dataModel isKindOfClass:[SignRealInfo class]]){
        
        SignRealInfo *model = (SignRealInfo *)dataModel;
        _myRealNameState = realNameYes;
        _custNum = model.custNo;
        _bankName = model.acctBankName;
        _realCard = model.cardNo;
        _realId = model.certNo;
        _realType = model.certType;
        _acctBankNo = model.acctBankNo;
        _realName = model.custName;
        _acctCityCode = model.acctCity;
        _acctProvinceCode = model.acctProvince;
        _realTel = model.mobile;
        
    }else if ([dataModel isKindOfClass:[QueryNumberBody class]]){
        QueryNumberBody *model = (QueryNumberBody *)dataModel;
        _myRealNameState = realNameYes;
        _custNum = model.custNo;
        _bankName = model.acctBankName;
        _realCard = model.cardNo;
        _realId = model.certNo;
        _realType = model.certType;
        _acctBankNo = model.acctBankNo;
        _realName = model.custName;
        _acctCityCode = model.acctCity;
        _acctProvinceCode = model.acctProvince;
        _realTel = model.mobile;
    }else if ([dataModel isKindOfClass:[ReservedBody class]]) {
        ReservedBody *model = (ReservedBody *)dataModel;
        _myRealNameState = realNameYes;
        _custNum = model.custNo;
        _bankName = model.acctBankName;
        _realCard = model.cardNo;
        _realId = model.certNo;
        _realType = model.certType;
        _acctBankNo = model.acctBankNo;
        _realName = model.custName;
        _acctCityCode = model.acctCity;
        _acctProvinceCode = model.acctProvince;
        _realTel = model.mobile;
    }
}
- (void)setUserTel:(NSString *)userTel {
    _userTel = userTel;
}
@end
