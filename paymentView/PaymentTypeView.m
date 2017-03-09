//
//  PaymentTypeView.m
//  paymentView
//
//  Created by 小王 on 2017/3/8.
//  Copyright © 2017年 小王. All rights reserved.
//

#import "PaymentTypeView.h"

@interface PaymentTypeView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *payTypeArray;

@end

static PaymentType _payType = 0;

@implementation PaymentTypeView

-(void)setPaymentTypes
{
    self.goInputButton.layer.masksToBounds = YES;
    [self.goInputButton.layer setBackgroundColor:UIColorFromRGB(0x20AAEE).CGColor];
    [self.goInputButton.layer setCornerRadius:5.0];
    
    self.payTypeArray = @[@(PaymentTypeAlipay),@(PaymentTypeWeChat),@(PaymentTypeUnionPay),@(PaymentTypeApplePay)];
    
    self.payTypeTable.delegate = self;
    self.payTypeTable.dataSource = self;
    self.payTypeTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"TableCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    
    if (indexPath.row == _payType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = globalFont;
    cell.imageView.image = [UIImage imageNamed:payTypeNameArray[indexPath.row]];
    cell.textLabel.text = payTypeNameArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    _payType = (PaymentType)indexPath.row;
    
    if ([self.paymentTypeDelegate respondsToSelector:@selector(finishChoosePayType:)]) {
        [self.paymentTypeDelegate finishChoosePayType:_payType];
    }
}



- (IBAction)cancelPay:(UIButton *)sender
{
    if ([self.paymentTypeDelegate respondsToSelector:@selector(cancelPay)]) {
        [self.paymentTypeDelegate cancelPay];
    }
}

- (IBAction)goChoosePayType:(UIButton *)sender
{
    if ([self.paymentTypeDelegate respondsToSelector:@selector(goPayTypeViewWithPayType:)]) {
        [self.paymentTypeDelegate goPayTypeViewWithPayType:_payType];
    }
}

- (IBAction)goInputPassword:(UIButton *)sender
{
    if ([self.paymentTypeDelegate respondsToSelector:@selector(goInputPasswordViewWithPayType:)]) {
        [self.paymentTypeDelegate goInputPasswordViewWithPayType:_payType];
    }
}

- (IBAction)goBackPayDetailView:(UIButton *)sender
{
    if ([self.paymentTypeDelegate respondsToSelector:@selector(finishChoosePayType:)]) {
        [self.paymentTypeDelegate finishChoosePayType:_payType];
    }
}

@end
