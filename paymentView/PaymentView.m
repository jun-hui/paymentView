//
//  PaymentView.m
//  paymentView
//
//  Created by 小王 on 2017/3/8.
//  Copyright © 2017年 小王. All rights reserved.
//

#import "PaymentView.h"

@interface PaymentView()<PaymentTypeViewDelegate>

@property (nonatomic, strong) PaymentTypeView *payDetailView;
@property (nonatomic, strong) PaymentTypeView *typeView;
@property (nonatomic, strong) PaymentTypeView *inputPasswView;
@property (nonatomic, assign) PaymentType paymentType;
@property (nonatomic, copy) NSString *orderInfo;
@property (nonatomic, copy) NSString *money;

@end

@implementation PaymentView

- (instancetype)initWithOrderInfo:(NSString *)orderInfo money:(NSString *)money paymentType:(PaymentType)paymentType
{
    if (self = [super init]) {
        self.paymentType = paymentType;
        self.orderInfo = orderInfo;
        self.money = money;
        
    }
    return self;
}

//支付页面
-(PaymentTypeView *)payDetailView
{
    if (!_payDetailView) {
        _payDetailView = [[[NSBundle mainBundle] loadNibNamed:paymentTypeViewID owner:nil options:nil] objectAtIndex:0];
        _payDetailView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, _payDetailView.height);
        _payDetailView.paymentTypeDelegate = self;
    }
    return _payDetailView;
}

//付款方式页面
-(PaymentTypeView *)typeView
{
    if (!_typeView) {
        _typeView = [[[NSBundle mainBundle] loadNibNamed:paymentTypeViewID owner:nil options:nil] objectAtIndex:1];
        _typeView.frame = CGRectMake(ScreenWidth, ScreenHeight - _typeView.height, ScreenWidth, _typeView.height);
        _typeView.paymentTypeDelegate = self;
    }
    return _typeView;
}

//密码输入页面
-(PaymentTypeView *)inputPasswView
{
    if (!_inputPasswView) {
        _inputPasswView = [[[NSBundle mainBundle] loadNibNamed:paymentTypeViewID owner:nil options:nil] objectAtIndex:2];
        _inputPasswView.frame = CGRectMake(ScreenWidth, ScreenHeight - _inputPasswView.height, ScreenWidth, _inputPasswView.height);
        _inputPasswView.paymentTypeDelegate = self;
        _inputPasswView.passwordBoxView.isSecure = YES;
    }
    return _inputPasswView;
}
/**
 *  显示付款视图
 */
- (void)showPayment
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [ScreenWindow addSubview:self];
    
    [ScreenWindow addSubview:self.payDetailView];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        _payDetailView.transform = CGAffineTransformTranslate(_payDetailView.transform, 0, -_payDetailView.height);
    }];
}

-(void)goPayTypeViewWithPayType:(PaymentType)payType
{
    [ScreenWindow addSubview:self.typeView];
    [_typeView setPaymentTypes];
    [UIView animateWithDuration:0.3 animations:^{

        _payDetailView.transform = CGAffineTransformTranslate(_payDetailView.transform, -ScreenWidth, 0);
        _typeView.transform = CGAffineTransformTranslate(_typeView.transform, -ScreenWidth, 0);
    }];
}

-(void)finishChoosePayType:(PaymentType)payType
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _payDetailView.transform = CGAffineTransformTranslate(_payDetailView.transform, ScreenWidth, 0);
        if (_typeView.x == 0) {
            _typeView.transform = CGAffineTransformTranslate(_typeView.transform, ScreenWidth, 0);
        }
        if (_inputPasswView.x == 0) {
            _inputPasswView.transform = CGAffineTransformTranslate(_inputPasswView.transform, ScreenWidth, 0);
        }
    } completion:^(BOOL finished) {
        NSInteger index = (PaymentType)payType;
        [_payDetailView.payTypeButton setTitle:payTypeNameArray[index] forState:UIControlStateNormal];
        [_typeView removeFromSuperview];
        [_inputPasswView removeFromSuperview];
        _typeView = nil;
        _inputPasswView = nil;
    }];
}

-(void)goInputPasswordViewWithPayType:(PaymentType)payType
{
    [ScreenWindow addSubview:self.inputPasswView];
    [UIView animateWithDuration:0.3 animations:^{
        
        _payDetailView.transform = CGAffineTransformTranslate(_payDetailView.transform, -ScreenWidth, 0);
        _inputPasswView.transform = CGAffineTransformTranslate(_inputPasswView.transform, -ScreenWidth, 0);
    }];
}

-(void)cancelPay
{
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        _payDetailView.transform = CGAffineTransformTranslate(_payDetailView.transform, 0, _payDetailView.height);
        _typeView.transform = CGAffineTransformTranslate(_typeView.transform, 0, _typeView.height);
        _inputPasswView.transform = CGAffineTransformTranslate(_inputPasswView.transform, 0, _inputPasswView.height);
    } completion:^(BOOL finished) {
        
        [self removeSubViews];
    }];
}

-(void)removeSubViews
{
    [_payDetailView removeFromSuperview];
    [_typeView removeFromSuperview];
    [_inputPasswView removeFromSuperview];
    [self removeFromSuperview];
}



@end
