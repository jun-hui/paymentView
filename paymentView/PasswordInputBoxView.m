//
//  PasswordInputBoxView.m
//  paymentView
//
//  Created by 小王 on 2017/3/8.
//  Copyright © 2017年 小王. All rights reserved.
//

#import "PasswordInputBoxView.h"
#import "BaseTextField.h"

@interface PasswordInputBoxView ()<UITextFieldDelegate,TextFieldDeleteDelegate>
{
    BOOL _isDelete;
}
@property (nonatomic, strong) NSMutableArray *textFieldsArray;

@end

static CGFloat superViewLeading = 10;//上下左右边距

@implementation PasswordInputBoxView

-(void)drawRect:(CGRect)rect
{
    if (_boxType == PasswordInputBoxCellTogether) {
        [self setTogetherCellLayer];
    }
}

-(void)setBoxType:(PasswordInputBoxType)boxType
{
    _boxType = boxType;
    [self setCells];
}

-(void)setCellNum:(NSInteger)cellNum
{
    _cellNum = cellNum;
    [self setCells];
}

-(void)setSpacing:(CGFloat)Spacing
{
    _Spacing = Spacing;
    [self setCells];
}

-(void)setIsSecure:(BOOL)isSecure
{
    _isSecure = isSecure;
    for (BaseTextField *tf in _textFieldsArray) {
        
        tf.secureTextEntry = _isSecure;
    }
}

-(void)setSeparateCellLayerColor:(UIColor *)cellLayerColor
{
    _cellLayerColor = cellLayerColor;
    
    [self setSeparateCellLayer];
}

-(void)setCellBorderColor:(UIColor *)cellBorderColor
{
    _cellBorderColor = cellBorderColor;
    if (_boxType == PasswordInputBoxCellSeparate) {
        
        [self setSeparateCellLayer];
    }
}

-(void)setCellBorderWidth:(CGFloat)cellBorderWidth
{
    _cellBorderWidth = cellBorderWidth;
    if (_boxType == PasswordInputBoxCellSeparate) {
        
        [self setSeparateCellLayer];
    }
}

-(void)setCellCornerRadius:(CGFloat)cellCornerRadius
{
    _cellCornerRadius = cellCornerRadius;
    if (_boxType == PasswordInputBoxCellSeparate) {
     
        [self setSeparateCellLayer];
    }
}

-(void)awakeFromNib
{
    self.backgroundColor = whiteColor;
    self.boxType = PasswordInputBoxCellTogether;
    self.cellNum = 6;//密码位数
    self.Spacing = 0;//每个格子间距
    self.cellLayerColor = clearColor;
    self.cellBorderColor = cellSeparatorColor;
    self.cellBorderWidth = 0.5;
    self.cellCornerRadius = 3.0;
    _textFieldsArray = [NSMutableArray arrayWithCapacity:0];
    [self setCells];
    _isDelete = NO;
    
    [super awakeFromNib];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = whiteColor;
        self.boxType = PasswordInputBoxCellTogether;
        self.cellNum = 6;//密码位数
        self.Spacing = 0;//每个格子间距
        self.cellLayerColor = clearColor;
        self.cellBorderColor = cellSeparatorColor;
        self.cellBorderWidth = 0.5;
        self.cellCornerRadius = 3.0;
        _textFieldsArray = [NSMutableArray arrayWithCapacity:0];
        [self setCells];
        _isDelete = NO;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame boxType:(PasswordInputBoxType)boxType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = whiteColor;
        self.boxType = boxType;
        self.cellNum = 6;//密码位数
        self.Spacing = 0;//每个格子间距
        self.cellLayerColor = clearColor;
        self.cellBorderColor = cellSeparatorColor;
        self.cellBorderWidth = 0.5;
        self.cellCornerRadius = 3.0;
        _textFieldsArray = [NSMutableArray arrayWithCapacity:0];
        [self setCells];
        _isDelete = NO;
    }
    return self;
}

-(void)setCells
{
    if (_boxType == PasswordInputBoxCellTogether) {
        
        [self setBoxCellTogetherView];
    } else {
        [self setBoxCellSeparateView];
    }
    BaseTextField *newTF = [_textFieldsArray firstObject];
    [newTF becomeFirstResponder];
}

-(void)setBoxCellSeparateView
{
    NSArray *views = [self subviews];
    
    for (BaseTextField *tf in views) {
        
        [tf removeFromSuperview];
    }
    [_textFieldsArray removeAllObjects];
    for (int i = 0; i < self.cellNum; i ++) {
        
        CGSize cellSize = CGSizeMake((self.width - superViewLeading*2 - _Spacing*(_cellNum-1))/_cellNum, self.height - superViewLeading*2);
        CGRect cellFrame = CGRectMake(i*(cellSize.width+_Spacing)+superViewLeading, superViewLeading, cellSize.width, cellSize.height);
        
        BaseTextField *tf = [[BaseTextField alloc]init];
        tf.frame = cellFrame;
        tf.delegate = self;
        tf.deleteDelegate = self;
        tf.tag = 100+i;
        tf.textAlignment = NSTextAlignmentCenter;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.backgroundColor = self.cellLayerColor;
        tf.layer.borderColor = self.cellBorderColor.CGColor;
        tf.layer.borderWidth = self.cellBorderWidth;
        tf.layer.cornerRadius = self.cellCornerRadius;
        tf.secureTextEntry = self.isSecure;
        
        [self addSubview:tf];
        [_textFieldsArray addObject:tf];
    }
}
-(void)setBoxCellTogetherView
{
    NSArray *views = [self subviews];
    
    for (BaseTextField *tf in views) {
        
        [tf removeFromSuperview];
    }
    [_textFieldsArray removeAllObjects];
    for (int i = 0; i < self.cellNum; i ++) {
        
        CGSize cellSize = CGSizeMake((self.width - superViewLeading*2)/_cellNum, self.height - superViewLeading*2);
        CGRect cellFrame = CGRectMake(i*cellSize.width + superViewLeading, superViewLeading, cellSize.width, cellSize.height);
        
        BaseTextField *tf = [[BaseTextField alloc]init];
        tf.frame = cellFrame;
        tf.delegate = self;
        tf.deleteDelegate = self;
        tf.tag = 100+i;
        tf.textAlignment = NSTextAlignmentCenter;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.secureTextEntry = self.isSecure;
        
        [self addSubview:tf];
        [_textFieldsArray addObject:tf];
    }
}

-(void)setTogetherCellLayer
{
    CGRect drawRect = {superViewLeading,superViewLeading,self.width - 2*superViewLeading,self.height - 2*superViewLeading};
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, _cellBorderWidth);
    
    CGContextSetStrokeColorWithColor(context, _cellBorderColor.CGColor);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:_cellCornerRadius];
    
    CGContextAddPath(context, bezierPath.CGPath);
    
    for (int i = 0; i < self.cellNum - 1; i ++) {
        
        CGFloat OrginX = (self.width - superViewLeading*2)/_cellNum;
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(OrginX*(i + 1) + superViewLeading, superViewLeading)];
        [linePath addLineToPoint:CGPointMake(OrginX*(i + 1) + superViewLeading, self.height - superViewLeading)];
        // 将path绘制出来
        [linePath stroke];
    }
    
    CGContextStrokePath(context);
}

-(void)setSeparateCellLayer
{
    NSArray *views = [self subviews];
    
    for (BaseTextField *tf in views) {
        
        tf.backgroundColor = self.cellLayerColor;
        tf.layer.borderColor = self.cellBorderColor.CGColor;
        tf.layer.borderWidth = self.cellBorderWidth;
        tf.layer.cornerRadius = self.cellCornerRadius;
        tf.secureTextEntry = self.isSecure;
    }
}

#pragma mark - BaseTextFieldDelegate

-(void)textFieldDeleteBackward:(BaseTextField *)textField
{
    if (textField.tag > [[_textFieldsArray firstObject] tag]) {
        
        UITextField *newTF = (UITextField *)[self viewWithTag:textField.tag-1];
        newTF.text = @"";
        [newTF becomeFirstResponder];
    }
    _isDelete = YES;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(BaseTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    textField.text = string;
    
    if (textField == [_textFieldsArray lastObject] && string.length > 0) {
        
        [self endEditing:YES];
        if ([self.passwordInputDelegate respondsToSelector:@selector(passwordInputFinished:)]) {
            
            NSString *paswString = [NSString string];
            
            for (int i = 0; i<_textFieldsArray.count; i++) {
                paswString = [paswString stringByAppendingString:[NSString stringWithFormat:@"%@",(BaseTextField *)[_textFieldsArray[i] text]]];
            }
            [self.passwordInputDelegate passwordInputFinished:paswString];
        }
    }
    if (textField.text.length > 0) {
        
        if (textField.tag<  [[_textFieldsArray lastObject] tag]) {
            
            UITextField *newTF =  (UITextField *)[self viewWithTag:textField.tag+1];
            
            [newTF becomeFirstResponder];
        }
        
    } else {
        
    }
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _isDelete = NO;//解决删除一格后再点击那一格还会响应的问题
    return YES;
}

//靠前的未输入框才能响应点击
-(void)textFieldDidBeginEditing:(BaseTextField *)textField{
    
    if (!_isDelete) {
        if (textField.text.length == 0) {
            if (textField != [_textFieldsArray firstObject]) {
                
                BaseTextField *newTF = (BaseTextField *)[self viewWithTag:textField.tag-1];
                if (newTF.text.length == 0) {
                    [newTF becomeFirstResponder];
                    return;
                }
            }
        } else {
            if (textField == [_textFieldsArray lastObject]) {
                [self endEditing:YES];
            } else {
                BaseTextField *newTF = (BaseTextField *)[self viewWithTag:textField.tag+1];
                [newTF becomeFirstResponder];
                return;
            }
        }
    }
    _isDelete = NO;
}

-(void)textFieldDidEndEditing:(BaseTextField *)textField{
    
    [self getVertificationCode];
}

-(void)getVertificationCode{ //获取验证码方法
    
    NSString *str = [NSString string];
    
    for (int i = 0; i<_textFieldsArray.count; i++) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@",(BaseTextField *)[_textFieldsArray[i] text]]];
    }
    _vertificationCode = str;
    
    if (self.passwordBlock) {
        self.passwordBlock(_vertificationCode);
    }
}


@end
