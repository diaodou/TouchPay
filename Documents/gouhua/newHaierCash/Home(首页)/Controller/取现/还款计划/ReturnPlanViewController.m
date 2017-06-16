//
//  ReturnPlanViewController.m
//  personMerchants
//
//  Created by 百思为科 on 16/4/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "ReturnPlanViewController.h"
#import "UIFont+AppFont.h"
#import "HCMacro.h"
#import "ConfirmPayNoBankViewController.h"
//#import "PeopleViewController.h"
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
//#import "RealNameJudgeModel.h"
#import "StageApplicationModel.h"
#import <YYLabel.h>
#import <YYTextLayout.h>
#import <NSAttributedString+YYText.h>

@interface ReturnPlanViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation ReturnPlanViewController
{
    UITableView *_planTableView;
    
    UIView *_headerView;//tableView表头
    
    NSArray *_planArray;//数据源数组
    float x ;
    UIView *_footView;
    //提示语
    UILabel *footerLabel;
    NSMutableAttributedString *textTwo;
    YYLabel *labelTwo;
    UILabel *footerLabelOne;
    NSMutableAttributedString *textOne;
    YYLabel *labelOne;
    
    YYTextLayout *layout;
    YYTextLayout *layoutOne;
}

#pragma mark -- lift cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"还款计划";
    x = DeviceWidth/414.0;
    [self setTableView];
    [self setTableViewHeader];
    [self setTableViewFoot];
    _nameOne = @"随借随还";
    _nameTwo = @"123";
    _showOne = @"1234567654321sgfdvfderwdacvzbdhetrwdsfgd";
    _showTwo = @"发给和特务v";
    //区分现金贷商品贷
    if (self.pushType == fromGoodsByStages)
    {
       [self creatBackMoneyPlanRequest];
    }
    else if (self.pushType == fromMoneyStage)
    {
        [self creatMoneyStageSearchRequest];
    }
    
    if (_planModel.body == nil)
    {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"数据刷新失败\n请重新刷新" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
    }
}

#pragma Mark -- set tableView
- (void)setTableView
{
    _planTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64) style:UITableViewStylePlain];
    _planTableView.tableFooterView = [[UIView alloc]initWithFrame:(CGRectZero)];
    _planTableView.delegate = self;
    _planTableView.dataSource = self;
    _planTableView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self.view addSubview:_planTableView];
}

#pragma makr -- set tableViewHeader
- (void)setTableViewHeader
{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
    _headerView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    UILabel *fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*DeviceWidth/375, 0, DeviceWidth - 20 * DeviceWidth/375, 50)];
    fixedLabel.numberOfLines = 0;
    fixedLabel.font = [UIFont appFontRegularOfSize:12];
    fixedLabel.text = @"此还款计划为还款试算，实际还款计划以实际放款后的还款计划为准";
    [_headerView addSubview:fixedLabel];
    
    _planTableView.tableHeaderView = _headerView;
}
- (void)setTableViewFoot{
    footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(16*x, 15*x, DeviceWidth-50*x, 20*x)];
    footerLabel.textColor = UIColorFromRGB(0x999999, 1);
    footerLabel.text = _nameOne;
    footerLabel.font =[UIFont appFontRegularOfSize:13];
    footerLabel.textAlignment = NSTextAlignmentLeft;
    
    textTwo = [[NSMutableAttributedString alloc] initWithString:_showOne];
    textTwo.yy_font = [UIFont appFontRegularOfSize:12];
    textTwo.yy_lineSpacing = 4;
    textTwo.yy_color = UIColorFromRGB(0x999999, 1.0);
    CGSize size = CGSizeMake(DeviceWidth - 36, CGFLOAT_MAX);
    layout = [YYTextLayout layoutWithContainerSize:size text:textTwo];
    
    labelTwo = [YYLabel new];
    labelTwo.frame = CGRectMake(16*x, 35*x, DeviceWidth - 36*x, layout.textBoundingSize.height);
    labelTwo.tag = 10;
    labelTwo.numberOfLines = 0;
    labelTwo.attributedText = textTwo;
    
    footerLabelOne = [[UILabel alloc]initWithFrame:CGRectMake(16*x, layout.textBoundingSize.height + 40*x, DeviceWidth-50*x, 20*x)];
    footerLabelOne.textColor = UIColorFromRGB(0x999999, 1);
    footerLabelOne.text = _nameTwo;
    footerLabelOne.font =[UIFont appFontRegularOfSize:13];
    footerLabelOne.textAlignment = NSTextAlignmentLeft;
    
    textOne = [[NSMutableAttributedString alloc] initWithString:_showTwo];
    textOne.yy_font = [UIFont appFontRegularOfSize:12];
    textOne.yy_lineSpacing = 4;
    textOne.yy_color = UIColorFromRGB(0x999999, 1.0);
    layoutOne = [YYTextLayout layoutWithContainerSize:size text:textOne];
    
    labelOne = [YYLabel new];
    labelOne.frame = CGRectMake(16*x, layout.textBoundingSize.height + 60*x, DeviceWidth - 36*x, layoutOne.textBoundingSize.height);
    labelOne.tag = 10;
    labelOne.numberOfLines = 0;
    labelOne.attributedText = textOne;
    
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, layout.textBoundingSize.height+layoutOne.textBoundingSize.height + 80*x)];
    _footView.backgroundColor = UIColorFromRGB(0xeeeeee, 1);
    [_footView addSubview:footerLabel];
    [_footView addSubview:labelTwo];
    [_footView addSubview:footerLabelOne];
    [_footView addSubview:labelOne];
    
    
}
#pragma mark --  tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.pushType == fromMoneyStage)
    {
        return 2;
    }else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.pushType == fromMoneyStage)
    {
        if(section == 0)
        {
            return 1;
        }else
        {
            return _planArray.count;
        }
    }else
    {
        return _planArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*DeviceWidth/375, 0, 100, cell.contentView.frame.size.height)];
        leftLabel.tag = 1;
        [cell.contentView addSubview:leftLabel];
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth - 120*DeviceWidth/375, 0, 100*DeviceWidth/375, cell.contentView.frame.size.height)];
        rightLabel.tag = 2;
        rightLabel.textAlignment = NSTextAlignmentRight;
        
        [cell.contentView addSubview:rightLabel];
    }
    
    UILabel *leftLabel = [(UILabel *)cell.contentView viewWithTag:1];
    leftLabel.font = [UIFont appFontRegularOfSize:14];
    leftLabel.textColor = UIColorFromRGB(0x333333, 1.0);
    
    UILabel *rightLabel = [(UILabel *)cell.contentView viewWithTag:2];
    rightLabel.font = [UIFont appFontRegularOfSize:14];
    rightLabel.textColor = [UIColor colorWithRed:0.23 green:0.54 blue:0.89 alpha:1.00];
    
    if(self.pushType == fromMoneyStage)
    {
        if(indexPath.section == 0)
        {
            leftLabel.text = @"实际到账金额";
            if(!_planModel.body.actualArriveAmt || _planModel.body.actualArriveAmt.length == 0)
            {
                rightLabel.text = @"";
            }else
            {
                rightLabel.text = [self formatNumByRoundingWithStr:_planModel.body.actualArriveAmt];
            }
        }else if(indexPath.section == 1)
        {
            StageApplicationModelMx *mxModel = _planArray[indexPath.row];
            
            leftLabel.text = [NSString stringWithFormat:@"【%ld/%lu期】",(long)mxModel.psPerdNo,(unsigned long)_planArray.count ];
            
            rightLabel.text = [NSString stringWithFormat:@"%@元",mxModel.instmAmt];
        }
    }else
    {
        StageApplicationModelMx *mxModel = _planArray[indexPath.row];
        
        leftLabel.text = [NSString stringWithFormat:@"【%ld/%lu期】",(long)mxModel.psPerdNo,(unsigned long)_planArray.count ];
        
        rightLabel.text = [NSString stringWithFormat:@"%@元",mxModel.instmAmt];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_planTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, DeviceWidth, 35);
        view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(15*DeviceWidth/375, 0, 100*DeviceWidth/375, 35);
        label.text = @"还款计划";
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont appFontRegularOfSize:14];
        [view addSubview:label];
        
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 35;
    }
    
    return 0;
}
#pragma mark -----通过现金贷界面查询还款计划---------
- (void)creatMoneyStageSearchRequest
{
    _planArray = _planModel.body.mx;
    [_planTableView reloadData];
    
}
#pragma mark ------通过商品分期贷查询还款计划-----------
-(void)creatBackMoneyPlanRequest
{
    _planArray = _planModel.body.mx;
    [_planTableView reloadData];
}

#pragma mark -- private methods
- (void)pushAction{

}

#pragma mark -- 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_planTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_planTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_planTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_planTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - private methods
- (NSString *)formatNumByRoundingWithStr:(NSString *)str
{
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *dec = [NSDecimalNumber decimalNumberWithString:str];
    
    NSDecimalNumber *result = [dec decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"0.00"] withBehavior:roundUp];
    NSString *strResult = [NSString stringWithFormat:@"%.2f",result.floatValue];
    
    return  strResult;
}
@end
