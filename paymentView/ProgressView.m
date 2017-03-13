//
//  ProgressView.m
//  ProgressView
//
//  Created by 小王 on 2017/3/10.
//  Copyright © 2017年 小王. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()
{
    int num;
}

@property (nonatomic, assign) CGFloat lineWidth; /**<边框宽度*/
@property (nonatomic, strong) NSArray *lineColor; /**<边框颜色*/
@property (nonatomic, strong) CAShapeLayer *progressLayer; /**<进度条*/
@property (nonatomic, strong) CABasicAnimation *strokeStart;
@property (nonatomic, strong) UIBezierPath *circlePath;
@property (nonatomic, strong) NSTimer *drawCircleTimer;

@end

#define FromValue           @(0.0);
#define ToValue             @(1.0);

#define superViewLeading    20

#define circleCenter        CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
#define circleRadius        circleCenter.x - superViewLeading

@implementation ProgressView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.backgroundColor = clearColor.CGColor;
    self.layer.cornerRadius = 10;
    self.lineWidth = 3.0;
    self.lineColor = @[UIColorFromRGB(0x00C8FF)];;
    
    [self addSubLayers];
}

- (instancetype)initWithFrame:(CGRect)frame andLineWidth:(CGFloat)lineWidth andLineColor:(NSArray *)lineColor {
    self = [super initWithFrame:frame];
    if(self) {
        self.layer.masksToBounds = YES;
        self.layer.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
        self.layer.cornerRadius = 10;
        self.lineWidth = lineWidth;
        self.lineColor = lineColor;
        
        [self addSubLayers];
    }
    
    return self;
}

-(CABasicAnimation *)strokeStart
{
    if (!_strokeStart) {
        
        //内层进度条动画(伸展)
        CABasicAnimation *strokeStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStart.fromValue = FromValue;
        strokeStart.toValue = ToValue;
        strokeStart.duration = 1.0;
        strokeStart.beginTime = 1.0;
        strokeStart.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _strokeStart = strokeStart;
    }
    return _strokeStart;
}

-(UIBezierPath *)circlePath
{
    if (!_circlePath) {
        _circlePath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:circleRadius startAngle:M_PI*3/2 endAngle:M_PI*7/2 clockwise:YES];
        _circlePath.lineCapStyle = kCGLineCapRound;
        _circlePath.lineJoinStyle = kCGLineCapRound;
    }
    return _circlePath;
}

-(void)createWaitingShapeLayer
{
    if (_progressLayer) {
        [_progressLayer removeFromSuperlayer];
        _progressLayer = nil;
    }
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.lineWidth = self.lineWidth;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeColor = ((UIColor *)self.lineColor[0]).CGColor;
    _progressLayer.fillColor = clearColor.CGColor;
    _progressLayer.strokeStart = 0.0;
    _progressLayer.strokeEnd = 1.0;
    [self.layer addSublayer:_progressLayer];
    
    _progressLayer.path = self.circlePath.CGPath;
}

- (void)addSubLayers {
    
    NSAssert(self.lineWidth > 0.0, @"lineWidth must great than zero");
    NSAssert(self.lineColor.count > 0, @"lineColor must set");
    
    [self createWaitingShapeLayer];
    
    [self addLoadingAnimation];
    
    [self changeColor];
    
    //延时 5 秒再返回
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [self addLoadingSuccessAnimation];
    });
}

-(void)addLoadingAnimation
{
    //内层进度条动画(收缩)
    CABasicAnimation *strokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEnd.fromValue = FromValue;
    strokeEnd.toValue = ToValue;
    strokeEnd.duration = 1.0;
    strokeEnd.beginTime = 0.0;
    strokeEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.duration = 2.0;
    animGroup.repeatCount = HUGE_VALF;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.animations = @[strokeEnd, self.strokeStart];
    [_progressLayer addAnimation:animGroup forKey:@"strokeAnim"];
    
    
    //动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.z"];
    //从12点到12点
    animation.fromValue = [NSNumber numberWithFloat:-1 * M_PI_4];
    animation.toValue = [NSNumber numberWithFloat:7 * M_PI_4];
    //间隔2秒
    animation.duration = 2.0;
    //无限循环
    animation.repeatCount = HUGE_VALF;
    //开始动画
    [self.layer addAnimation:animation forKey:@"rotation"];
}

-(void)addLoadingSuccessAnimation
{
    [self.layer removeAnimationForKey:@"rotation"];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    
    CGFloat radius = circleRadius - 10;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:pointOnCircle(circleCenter, radius, 190)];
    [linePath addLineToPoint:pointOnCircle(circleCenter, radius, 270)];
    [linePath addLineToPoint:pointOnCircle(circleCenter, radius, 35)];
    
    [self.circlePath appendPath:linePath];
    [self createWaitingShapeLayer];
    
    [self addTimer];
}

-(void)addTimer
{
    if (_progressLayer.strokeEnd == 1) {
        _progressLayer.strokeEnd = 0.01;
    }
    _drawCircleTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(drawCircleAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_drawCircleTimer forMode:NSRunLoopCommonModes];
}

-(void)drawCircleAnimation
{
    CGFloat endStroke = _progressLayer.strokeEnd;
    if (endStroke < 2) {
        endStroke += 0.02;
    } else {
        [_drawCircleTimer invalidate];
        _drawCircleTimer = nil;
        
        NSLog(@"打钩完成进度:%.2f",endStroke);
        if ([self.progressDelegate respondsToSelector:@selector(animationFinished:)]) {
            [self.progressDelegate animationFinished:self];
        }
    }
    _progressLayer.strokeEnd = endStroke;
}

-(void)changeColor
{
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(randomColor)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)randomColor {
    
    UIColor *color = (UIColor *)[self.lineColor objectAtIndex:arc4random()%self.lineColor.count];
    _progressLayer.strokeColor = color.CGColor;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    num ++;
    NSLog(@"%d,动画完成:%@",num,flag?@"YES":@"NO");
}


@end
