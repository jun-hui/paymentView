//
//  ViewController.m
//  paymentView
//
//  Created by 小王 on 2017/3/9.
//  Copyright © 2017年 小王. All rights reserved.
//

#import "ViewController.h"
#import "PaymentView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = whiteColor;
    
    [self addButton];
}

-(void)addButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 100, 40);
    [button.layer setMasksToBounds:YES];
    [button.layer setBackgroundColor:barColor.CGColor];
    [button.layer setCornerRadius:5.0];
    [button setTitle:@"去结算" forState:UIControlStateNormal];
    [button setTitleColor:whiteColor forState:UIControlStateNormal];
    [button.titleLabel setFont:globalFont];
    [button addTarget:self action:@selector(showPaymentView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button.center = ScreenCenter;
}

-(void)showPaymentView
{
    // 创建支付视图
    PaymentView *paymentView = [[PaymentView alloc] initWithOrderInfo:@"商品名称" money:@"¥ 99.00" paymentType:PaymentTypeAlipay];
    [paymentView showPayment];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
