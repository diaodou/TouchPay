//
//  LoanDetailCommonView.m
//  贷款详情
//
//  Created by 百思为科 on 16/4/3.
//  Copyright © 2016年 百思为科iOS. All rights reserved.
//

#import "LoanDetailCommonView.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"

//59

static const CGFloat btnCellHeight = 26.0;

@implementation LoanDetailCommonView
{
    UIView *_viewSep;
}
#pragma mark - lift Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

#pragma mark - private Methods 
- (void)setUI {
    self.backgroundColor = [UIColor whiteColor];
    self.loanTopView = [[LoanTopView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, [LoanTopView heightTopView])];
    self.loanTopView.labelRight.hidden = NO;
    
    self.loanTopView.labelMidContent.hidden = NO;
    
    
    UILabel *_pricipalLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.loanTopView.frame) + 15 , DeviceWidth/3, 14)];
    
    _pricipalLabel.textAlignment=NSTextAlignmentCenter;
    
    _pricipalLabel.text=@"分期本金（元）";
    
    _pricipalLabel.font=[UIFont appFontRegularOfSize:12];
    
    _pricipalLabel.textColor=UIColorFromRGB(0x343434, 1.0);
    
    
    _priManey=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_pricipalLabel.frame) + 8, DeviceWidth/3, CGRectGetHeight(_pricipalLabel.frame))];
    
    _priManey.textAlignment=NSTextAlignmentCenter;
    
    _priManey.textColor = UIColorFromRGB(0xff5500, 1.0);
    
    _priManey.font = [UIFont appFontRegularOfSize:12];
    
    UILabel *_dividendLabel=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/3, CGRectGetMinY(_pricipalLabel.frame), DeviceWidth/3, CGRectGetHeight(_pricipalLabel.frame))];
    
    _dividendLabel.textAlignment=NSTextAlignmentCenter;
    
    _dividendLabel.text=@"息费（元）";
    
    _dividendLabel.font=[UIFont appFontRegularOfSize:12];
    
    _dividendLabel.textColor=UIColorFromRGB(0x343434, 1.0);

    _divManey=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/3, CGRectGetMaxY(_pricipalLabel.frame) + 8, DeviceWidth/3, CGRectGetHeight(_pricipalLabel.frame))];
    
    _divManey.textAlignment=NSTextAlignmentCenter;
    
    _divManey.textColor = UIColorFromRGB(0xff5500, 1.0);
    
    _divManey.font=[UIFont appFontRegularOfSize:12];
    
    _interestDays = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_divManey.frame), CGRectGetMaxY(_divManey.frame), CGRectGetWidth(_divManey.frame), 12)];
    _interestDays.textAlignment=NSTextAlignmentCenter;
    
//    _interestDays.text=@"(10天)";
    
    _interestDays.font=[UIFont appFontRegularOfSize:12];
    
    _interestDays.textColor=UIColorFromRGB(0x333333, 1.0);
    
    
    UILabel *_totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth*2/3, CGRectGetMinY(_pricipalLabel.frame), DeviceWidth/3, CGRectGetHeight(_pricipalLabel.frame))];
    
    _totalLabel.textAlignment=NSTextAlignmentCenter;
    
    _totalLabel.text=@"合计金额（元）";
    
    _totalLabel.font=[UIFont appFontRegularOfSize:12];
    
    _totalLabel.textColor=UIColorFromRGB(0x343434, 1.0);
    
    _totalManey=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth*2/3, CGRectGetMaxY(_pricipalLabel.frame) + 8, DeviceWidth/3, CGRectGetHeight(_pricipalLabel.frame))];
    
    _totalManey.textAlignment=NSTextAlignmentCenter;
    
    _totalManey.textColor = UIColorFromRGB(0xff5500, 1.0);
    
    _totalManey.font=[UIFont appFontRegularOfSize:12];
    
    _viewSep=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_totalManey.frame) + 21, DeviceWidth, 1)];
    
    _viewSep.backgroundColor=UIColorFromRGB(0xececec, 1.0);
    

    
    [self addSubview:_viewSep];
    
    [self addSubview:_totalLabel];
    
    [self addSubview:_totalManey];
    
    [self addSubview:_dividendLabel];
    
    [self addSubview:_divManey];
    
    [self addSubview:_priManey];
    
    [self addSubview:_pricipalLabel];
    
    [self addSubview:self.loanTopView];
    
    [self addSubview:_interestDays];
}
- (void)setLoanHandlingType:(LoanHandlingTypes)loanHandlingType {
    _loanHandlingType = loanHandlingType;
    if (loanFallback == _loanHandlingType) {
        //底部35
        //被退回
        self.loanTopView.labelState.textColor = UIColorFromRGB(0x676767, 1.0);
        self.loanTopView.labelState.text = @"被退回";
        self.loanTopView.labelTopContent.hidden = YES;
        self.loanTopView.labelBottomContent.hidden = YES;
        self.loanTopView.labelMidContent.hidden = NO;
        self.loanTopView.labelRight.hidden = NO;
        self.loanTopView.viewArrow.hidden = YES;
        
        self.btnCommit = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth - 80, CGRectGetMaxY(_viewSep.frame) + 5, 68, btnCellHeight)];
        _btnCommit.titleLabel.font = [UIFont appFontRegularOfSize:12];
        [_btnCommit setTitle:@"修改提交" forState:UIControlStateNormal];
        _btnCommit.tag = 11;
        _btnCommit.backgroundColor = UIColorFromRGB(0x028de5, 1.0);
        [_btnCommit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_btnCommit];
        
    }else if (loanProductDetailCommit == _loanHandlingType) {
        //待提交  40
        self.loanTopView.labelState.textColor = UIColorFromRGB(0x676767, 1.0);
//        self.loanTopView.labelState.text = @"2015-11-15";
        self.loanTopView.labelTopContent.hidden = YES;
        self.loanTopView.labelBottomContent.hidden = YES;
        self.loanTopView.labelMidContent.hidden = NO;
        self.loanTopView.labelRight.hidden = NO;
        self.loanTopView.viewArrow.hidden = YES;
        
        _summary = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewSep.frame), DeviceWidth - 10, 40)];
        if (iphone6P) {
            
            _summary.frame = CGRectMake(0, CGRectGetMaxY(_viewSep.frame), DeviceWidth - 20, 40);
        }
        _summary.font = [UIFont appFontRegularOfSize:12];
        _summary.textColor = UIColorFromRGB(0x333333, 1.0);
        _summary.textAlignment = NSTextAlignmentRight;
//        _summary.text = @"分期账单，已还800，待还3000";
       [self addSubview:_summary];
        
    }else if (loanApprovaling == _loanHandlingType) {
        //正在审批
        self.loanTopView.labelState.textColor = UIColorFromRGB(0x676767, 1.0);
        self.loanTopView.labelState.text = @"审批中";
        self.loanTopView.labelTopContent.hidden = YES;
        self.loanTopView.labelBottomContent.hidden = YES;
        self.loanTopView.labelMidContent.hidden = NO;
        self.loanTopView.labelRight.hidden = NO;
        self.loanTopView.viewArrow.hidden = YES;
        
        self.btnCommit = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth - 80, CGRectGetMaxY(_viewSep.frame) + 5,68, btnCellHeight)];
        _btnCommit.titleLabel.font = [UIFont appFontRegularOfSize:12];
        [_btnCommit setTitle:@"审批进度" forState:UIControlStateNormal];
        _btnCommit.backgroundColor = UIColorFromRGB(0x028de5, 1.0);
        [_btnCommit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnCommit.tag = 10;
        [self addSubview:_btnCommit];
        
        
    }else if (loanOutDate == _loanHandlingType) {
        //逾期
        self.loanTopView.labelState.textColor = UIColorFromRGB(0xe90505, 1.0);
        self.loanTopView.labelState.text = @"已逾期";
        self.loanTopView.labelTopContent.hidden = YES;
        self.loanTopView.labelBottomContent.hidden = YES;
        self.loanTopView.labelMidContent.hidden = NO;
        self.loanTopView.labelRight.hidden = NO;
        self.loanTopView.viewArrow.hidden = YES;
        
        _summary = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewSep.frame), DeviceWidth - 10, 40)];
        if (iphone6P) {
            
            _summary.frame = CGRectMake(0, CGRectGetMaxY(_viewSep.frame), DeviceWidth - 20, 40);
        }
        _summary.font = [UIFont appFontRegularOfSize:12];
        _summary.textColor = UIColorFromRGB(0x333333, 1.0);
        _summary.textAlignment = NSTextAlignmentRight;
//        _summary.text = @"分期账单，已还800，待还3000";
        [self addSubview:_summary];
        
        
    }else if(loanMakeAppoint == _loanHandlingType) {
        //合同签订
        self.loanTopView.labelState.textColor = UIColorFromRGB(0x676767, 1.0);
//        self.loanTopView.labelState.text = @"贷款编号12322222222";
        self.loanTopView.labelTopContent.hidden = YES;
        self.loanTopView.labelBottomContent.hidden = YES;
        self.loanTopView.labelMidContent.hidden = NO;
        self.loanTopView.labelRight.hidden = NO;
        self.loanTopView.viewArrow.hidden = YES;
        
        self.btnCommit = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth - 80, CGRectGetMaxY(_viewSep.frame) + 5,68, btnCellHeight)];
        _btnCommit.titleLabel.font = [UIFont appFontRegularOfSize:12];
        [_btnCommit setTitle:@"合同签订" forState:UIControlStateNormal];
        _btnCommit.backgroundColor = UIColorFromRGB(0x028de5, 1.0);
        [_btnCommit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnCommit.tag = 10;
        UILabel * signLab = [[UILabel alloc]initWithFrame:(CGRectMake(20, CGRectGetMinY(_btnCommit.frame), 80, 24))];
            signLab.font = [UIFont appFontRegularOfSize:12];
            signLab.text = @"合同签订中";
        [self addSubview:_btnCommit];
        signLab.hidden = YES;
        signLab.tag = 100;
        [self addSubview:signLab];
    }else {
        
    }
}

+ (CGFloat)heightView:(LoanHandlingTypes)loanHandlingType {
    if (loanFallback == loanHandlingType) {
        //底部35
        return [LoanTopView heightTopView] + 67.0 + 35.0;
    }else if (loanProductDetailCommit == loanHandlingType) {
        //待提交  40
        return [LoanTopView heightTopView] + 67.0 + 40.0;
        
    }else if (loanApprovaling == loanHandlingType) {
        //正在审批
        return [LoanTopView heightTopView] + 67.0 + 40.0;
        
        
    }else if (loanOutDate == loanHandlingType) {
        //逾期
        return [LoanTopView heightTopView] + 67.0 + 40.0;
    }else if (loanMakeAppoint == loanHandlingType){
        //合同签订
        return [LoanTopView heightTopView] + 67.0 + 40.0;
    }else {
        return 0;
    }

}

@end
