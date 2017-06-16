//
//  HCCardSideViewController.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCCardSideViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "RMUniversalAlert.h"

@interface HCCardSideViewController ()

{
    
    float x;
    
}

@property(nonatomic,strong)UIImageView *topImgView;//顶部照片视图

@end

@implementation HCCardSideViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatTopImageView];
    
    [self creatBaseUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> life Cycle

//创建顶部照片视图
-(void)creatTopImageView{
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
        
    }
    
    _topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(70*x, 127*x, DeviceWidth-140*x, 143*x)];
    
    _topImgView.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    _topImgView.userInteractionEnabled = YES;
    
    [self.view addSubview:_topImgView];
    
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buildTouchTopImage:)];
    
    [_topImgView addGestureRecognizer:gest];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 97*x, DeviceWidth, 10*x)];
    
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.view addSubview:lineView];
    
    
}

//创建基本视图
-(void)creatBaseUI{
    
    NSArray *array = @[@"发证机关",@"有效时期"];
    
    float  height = _topImgView.frame.origin.y+_topImgView.frame.size.height+25*x;
    
    for (int i =0; i<array.count; i++) {
        
        //左侧标题
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*x, (height+15*x)+50*i*x, 100*x, 20*x)];
        
        leftLabel.text = array[i];
        
        leftLabel.tag = 10+i;
        
        leftLabel.font = [UIFont appFontRegularOfSize:14*x];
        
        [self.view addSubview:leftLabel];
        
        //右侧信息
        UILabel *rightLabel = [[UILabel alloc]init];
        
        rightLabel.textColor = UIColorFromRGB(0x999999, 1.0);
        
        rightLabel.font = [UIFont appFontRegularOfSize:14*x];
        
        rightLabel.tag = 20+i;
        
        rightLabel.textAlignment = NSTextAlignmentRight;

        [self.view addSubview:rightLabel];
        
        
        rightLabel.frame = CGRectMake(125*x, (height+15*x)+50*i, DeviceWidth-158*x, 20*x);
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-30*x, (17.5*x+height)+50*i, 9*x, 15*x)];
        
        imgView.backgroundColor = [UIColor clearColor];
        
        imgView.image = [UIImage imageNamed:@"首页_箭头右"];

        [self.view addSubview:imgView];
        
        //下划线
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15*x, (49*x+height)+50*i*x, DeviceWidth-30*x, 1*x)];
        
        line.backgroundColor = UIColorFromRGB(0xdddddd, 1.0);
        
        line.tag = 30+i;
        
        [self.view addSubview:line];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15*x, height+50*i*x, DeviceWidth, 50*x)];
        
        button.backgroundColor = [UIColor clearColor];
        
        [button addTarget:self action:@selector(buildTouchTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        
    }
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(47*x, height+140*x, DeviceWidth-94*x, 50*x)];
    
    nextButton.layer.cornerRadius = 25*x;
    
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    [nextButton addTarget:self action:@selector(buildToNextView:) forControlEvents:UIControlEventTouchUpInside];
    
    nextButton.titleLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    nextButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [self.view addSubview:nextButton];
    
}

#pragma mark --> event Methods

//点击顶部照片视图
-(void)buildTouchTopImage:(UITapGestureRecognizer *)gest{
    
    
    
}

//点击姓名，性别等
-(void)buildTouchTypeAction:(UIButton *)sender{
    
    NSLog(@"点击");
    
}

//点击下一步方法
-(void)buildToNextView:(UIButton *)sender{
    
//    UILabel *labelOne = (UILabel *)[self.view viewWithTag:20];
//    
//    UILabel *labelTwo = (UILabel *)[self.view viewWithTag:21];
//    
//    if (labelOne.text.length == 0 || labelTwo.text.length == 0) {
//        
//        [self buildHeadError:@"请使用扫描功能上传身份证信息"];
//        
//    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
        
        [_delegate sendSaveInfoViewType:CardTheOtherType];
        
    }
    
}

#pragma mark --> 网络代理协议

//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                return;
            }
        }
    }];
    
    
}

@end
