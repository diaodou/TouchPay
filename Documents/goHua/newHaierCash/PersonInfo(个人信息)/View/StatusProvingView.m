//
//  StatusProvingView.m
//  personMerchants
//
//  Created by 史长硕 on 17/2/20.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "StatusProvingView.h"
#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "AppDelegate.h"
#import "UIFont+AppFont.h"
#import "GoodGestureRecognizer.h"
#import "UILabel+SizeForStr.h"
#import "DefineSystemTool.h"
#import "NSString+CheckConvert.h"
@interface StatusProvingView ()<UITextFieldDelegate,UITextViewDelegate>
{
    
    float x ;
    
    NSInteger number;
    
    float _oldHeight;

}

@property (nonatomic,strong) NSMutableArray <NSArray *>*pickDataArr;//选择器的数据源
@property (nonatomic,strong) UIView *pickerBackView;            //选择器的蒙层
@property (nonatomic,strong) UIPickerView *pickerViw;           //选择器

@end

@implementation StatusProvingView

#pragma mark --> life Cycle

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        x = DeviceWidth/414.0;
        
        self.backgroundColor = [UIColor UIColorWithHexColorString:@"0xeeeeee" AndAlpha:1.0];
        
        //[self creatHeaderView];
        
        /*
         [self creatBaseUI];
         
         [self creatNameView];
         
         [self creatBaseText];
         */
  
    }
    
    return self;
    
}

#pragma mark --> private Methods

-(void)creatHeaderView{
    
    UIView *white = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
    
    white.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:white];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, DeviceWidth-10, 20)];

    name.text = @"身份验证";
    
    [white addSubview:name];
    
    _arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-30, 21, 14, 8)];
    
    _arrowImage.image = [UIImage imageNamed:@"箭头_下"];
    
    [white addSubview:_arrowImage];
    
    _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
    
    [_button addTarget:Status action:@selector(buildOpen:) forControlEvents:UIControlEventTouchUpInside];
    
    [white addSubview:_button];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,49, DeviceWidth, 1)];
    
    view.backgroundColor = [UIColor UIColorWithHexColorString:@"0xdcdcdc" AndAlpha:1.0];
    
    [white addSubview:view];
    
}

//创建身份证视图
-(void)creatBaseUI:(CGRect)frame{
    
    _baseView = [[UIView alloc]initWithFrame:frame];
    
    _baseView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_baseView];
    
    _leftimage = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceWidth-320*x)/3, 21, 160*x, 90*x)];
    
    _leftimage.image = [UIImage imageNamed:@"默认照片"];
    
    _leftimage.backgroundColor =[UIColor UIColorWithHexColorString:@"0xf1f1f1" AndAlpha:1.0];
    
    [_baseView addSubview:_leftimage];
    
    //_cardImage = image;
    
    _leftimage.userInteractionEnabled = YES;
    
    GoodGestureRecognizer * tap = [[GoodGestureRecognizer alloc]initWithTarget:self action:@selector(buildSelectBirth:)];
    
    tap.touch = LeftImage;
    
    [_leftimage addGestureRecognizer:tap];
    
    UILabel * fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake((DeviceWidth-320*x)/3, 30+90*x, 160*x, 20)];
    
    fixedLabel.text = @"身份证正面";
    
    fixedLabel.textColor =[UIColor UIColorWithHexColorString:@"0x6e6e6e" AndAlpha:1.0];
    
    fixedLabel.font = [UIFont systemFontOfSize:12];
    
    fixedLabel.textAlignment = NSTextAlignmentCenter;
    
    [_baseView addSubview:fixedLabel];
    
    _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceWidth-160*x-(DeviceWidth-320*x)/3, 21, 160*x, 90*x)];
    
    _rightImage.image = [UIImage imageNamed:@"默认照片"];
    
    _rightImage.backgroundColor = [UIColor UIColorWithHexColorString:@"0xf1f1f1" AndAlpha:1.0];
    
    [_baseView addSubview:_rightImage];
    
    //_cardImage = image;
    
    _rightImage.userInteractionEnabled = YES;
    
    GoodGestureRecognizer * tapRih = [[GoodGestureRecognizer alloc]initWithTarget:self action:@selector(buildSelectBirth:)];
    
    tapRih.touch = RightImage;
    
    [_rightImage addGestureRecognizer:tapRih];
    
    UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth-160*x-(DeviceWidth-320*x)/3, 30+90*x, 160*x, 20)];
    
    rightLabel.text = @"身份证反面";
    
    rightLabel.textColor = [UIColor UIColorWithHexColorString:@"0x6e6e6e" AndAlpha:1.0];
    
    rightLabel.font = [UIFont systemFontOfSize:12];
    
    rightLabel.textAlignment = NSTextAlignmentCenter;
    
    [_baseView addSubview:rightLabel];
    
}

//创建姓名
-(void)creatNameView{
    
    NSArray *nameArray = [NSArray arrayWithObjects:@"姓名",@"身份证",@"性别",@"出生年月",@"家庭住址",@"签发机关",@"有效期", nil];
    
    for (int i =0; i<nameArray.count; i++) {
        
        UILabel *nameLab = [self creatNameLableFrame:CGRectMake(24*x, 70+90*x+i*42, 92*x, 42) labName:nameArray[i]];
        
        nameLab.tag = 10+i;
        
        [_baseView addSubview:nameLab];
        
         UIView *view = [[UIView alloc]initWithFrame:CGRectMake(14*x, 70+90*x+i*42, DeviceWidth-28*x, 1)];
        
        view.backgroundColor = [UIColor UIColorWithHexColorString:@"0xdcdcdc" AndAlpha:1.0];
        
        view.tag = 20+i;
        
        [_baseView addSubview:view];
        
    }
    
}

//创建右侧一栏的视图
-(void)creatBaseText{
    
    //姓名
    UILabel *nameLab = [self creatNameLableFrame:CGRectMake(115*x, 70+90*x, DeviceWidth-115*x, 42) labName:[AppDelegate delegate].userInfo.realName];
    
    [_baseView addSubview:nameLab];
    
    //身份证
    UILabel *certLab = [self creatNameLableFrame:CGRectMake(115*x, 112+90*x, DeviceWidth-115*x, 42) labName:[AppDelegate delegate].userInfo.realId];
    
    [_baseView addSubview:certLab];
    
    //性别
    _genderLabel = [self creatNameLableFrame:CGRectMake(115*x, 154+90*x, DeviceWidth-155*x, 42) labName:@""];
    
    _genderLabel.userInteractionEnabled = YES;
    
    [_baseView addSubview:_genderLabel];
    
    GoodGestureRecognizer *genTap = [[GoodGestureRecognizer alloc]initWithTarget:self action:@selector(buildSelectBirth:)];
    
    genTap.touch = Gender;
    
    [_genderLabel addGestureRecognizer:genTap];
    
    UIImageView *imageOne = [self creatImageFrame:CGRectMake(DeviceWidth-35, 168+90*x, 8, 14)];
    
    [_baseView addSubview:imageOne];
    
    //出生年月
    _birthLabel = [self creatNameLableFrame:CGRectMake(115*x, 196+90*x, DeviceWidth-155*x, 42) labName:@""];
    
    _birthLabel.userInteractionEnabled = YES;
    
    [_baseView addSubview:_birthLabel];
    
    GoodGestureRecognizer *birTap = [[GoodGestureRecognizer alloc]initWithTarget:self action:@selector(buildSelectBirth:)];
    
    birTap.touch = Time;
    
    [_birthLabel addGestureRecognizer:birTap];
    
    UIImageView *imageTwo = [self creatImageFrame:CGRectMake(DeviceWidth-35, 210+90*x, 8, 14)];
    
    [_baseView addSubview:imageTwo];
    
    //家庭住址
    _addressText = [[UILabel alloc]initWithFrame:CGRectMake(115*x, 238+90*x, DeviceWidth-115*x, 42)];
    
    _addressText.userInteractionEnabled = YES;
    
    _addressText.numberOfLines = 0;
    
    _addressText.font = [UIFont appFontRegularOfSize:14];
    
    _addressText.backgroundColor = [UIColor clearColor];
    
    [_baseView addSubview:_addressText];
    
    //签发机关
    _officeText = [self creatNameLableFrame:CGRectMake(115*x, 280+90*x, DeviceWidth-115*x, 42) labName:@""];
    
    _officeText.userInteractionEnabled = YES;
    
    GoodGestureRecognizer *officeTap = [[GoodGestureRecognizer alloc]initWithTarget:self action:@selector(buildSelectBirth:)];
    
    officeTap.touch = Office;
    
    [_officeText addGestureRecognizer:officeTap];
    
    [_baseView addSubview:_officeText];
    
    //有效期
    _validLabel = [self creatNameLableFrame:CGRectMake(115*x, 322+90*x, DeviceWidth-155*x, 42) labName:@""];
    
    _validLabel.userInteractionEnabled = YES;
    
    [_baseView addSubview:_validLabel];
    
    UIImageView *imageThree = [self creatImageFrame:CGRectMake(DeviceWidth-35, 336+90*x, 8, 14)];
    
    imageThree.tag = 45;
    
    [_baseView addSubview:imageThree];
    
    GoodGestureRecognizer *valTap = [[GoodGestureRecognizer alloc]initWithTarget:self action:@selector(buildSelectBirth:)];
    
    valTap.touch = Valid;
    
    [_validLabel addGestureRecognizer:valTap];
    
}

-(UILabel *)creatNameLableFrame:(CGRect)frame labName:(NSString *)name{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    label.text = name;
    
    label.font = [UIFont appFontRegularOfSize:14];
    
    return label;
    
}

-(UIImageView *)creatImageFrame:(CGRect)frame{
    
    UIImageView *textField = [[UIImageView alloc]initWithFrame:frame];
    
    textField.image = [UIImage imageNamed:@"箭头_右_灰"];
    
    return textField;
    
}


#pragma mark --> event Response
//点击身份验证按钮
-(void)buildOpen:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
       
        _arrowImage.image = [UIImage imageNamed:@"箭头_上"];
        
    }else{
        
        _arrowImage.image = [UIImage imageNamed:@"箭头_下"];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendTouchType:open:num:)]) {
        
        [_delegate sendTouchType:Status open:sender.selected num:number];
        
    }
    
    number++;
    
}

//选择方法
-(void)buildSelectBirth:(GoodGestureRecognizer *)gest{
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendSelectType:)]) {
        
        [_delegate sendSelectType:gest.touch];
        
    }
    
}

//实时调整视图高度
-(void)buildNowTimeChangeViewHeight:(NSString *)string{
    
    _addressText.text = [string deleteSpeaceString];
    
    CGSize rect = [_addressText boundingRectWithSize:CGSizeMake(_addressText.frame.size.width, NSIntegerMax)];
    
    float height = rect.height;
    
    if (height < 42) {
        
        
        height = 42;
    }
    
        for (int i = 4; i<7; i++) {
            
            if (i == 4) {
                
                UILabel *nameLab = (UILabel *)[_baseView viewWithTag:10+i];
                
                nameLab.frame = CGRectMake(24*x, 239+90*x, 92*x, height);
               
                
            }else if (i == 5){
                
                UILabel *nameLab = (UILabel *)[_baseView viewWithTag:10+i];
                
                nameLab.frame = CGRectMake(24*x, 42*(i-1)+70+90*x+height+1, 92*x, 42);
                
                UIView *view = [_baseView viewWithTag:20+i];
                
                view.frame =CGRectMake(14*x, 238+height+90*x, DeviceWidth-28*x, 1);
                
            }else{
                
                UILabel *nameLab = (UILabel *)[_baseView viewWithTag:10+i];
                
                nameLab.frame = CGRectMake(24*x, 42*(i-1)+70+90*x+height+1, 92*x, 42);
                
                UIView *view = [_baseView viewWithTag:20+i];
                
                view.frame =CGRectMake(14*x, 42*(i-1)+70+90*x+height, DeviceWidth-28*x, 1);
                
            }
            
        }
    
        _addressText.frame = CGRectMake(115*x, 239+90*x,DeviceWidth- 115*x, height);
        
        _officeText.frame =   CGRectMake(115*x, _addressText.frame.origin.y+_addressText.frame.size.height, DeviceWidth-115*x, 42);
        
        _validLabel.frame = CGRectMake(115*x, _officeText.frame.origin.y+_officeText.frame.size.height, DeviceWidth-155*x, 42);
    
       UIImageView *imgView = (UIImageView *)[_baseView viewWithTag:45];
    
       imgView.frame = CGRectMake(DeviceWidth-35, _officeText.frame.origin.y+_officeText.frame.size.height+14, 8, 14);
    
      _baseView.frame = CGRectMake(0, 50, DeviceWidth, _validLabel.frame.origin.y+_validLabel.frame.size.height);
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendTextViewHeight:)]) {
        
        [_delegate sendTextViewHeight:_baseView.frame.origin.y+_baseView.frame.size.height];
    }

    
}

@end
