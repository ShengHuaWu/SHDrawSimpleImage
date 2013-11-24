//
//  SHDrawingView.m
//  SHDrawSimpleImage
//
//  Created by Shenghua on 2013/11/24.
//  Copyright (c) 2013年 Shenghua. All rights reserved.
//

#import "SHDrawingView.h"

@interface SHDrawingView ()
@property (nonatomic, weak, readwrite) UIImageView *tempDrawImageView;
@property (nonatomic, weak, readwrite) UIImageView *mainImageView;
@property (nonatomic, assign) CGPoint lastPoint; // Stores the last drawn point on the canvas.
@property (nonatomic, assign) CGPoint currentPoint; // Stores the current drawn point on the canvas.
@property (nonatomic, assign, getter = isTouchMoved) BOOL touchMoved;
@property (nonatomic, assign, getter = isTouchEnded) BOOL touchEnded;
@end

@implementation SHDrawingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.multipleTouchEnabled = NO;
        // Set default values
        _strokeColor = [UIColor blackColor];
        _strokeWidth = 20.0f;
        _strokeOpacity = 1.0f;
        
        UIImageView *mainImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:mainImageView];
        _mainImageView = mainImageView;
        
        UIImageView *tempDrawImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:tempDrawImageView];
        _tempDrawImageView = tempDrawImageView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tempDrawImageView.frame = self.bounds;
    self.mainImageView.frame = self.bounds;
}

- (void)drawRect:(CGRect)rect
{
    // Touch moved
    if (self.isTouchMoved && !self.isTouchEnded) {
        UIGraphicsBeginImageContext(self.tempDrawImageView.frame.size);
        [self.tempDrawImageView.image drawInRect:self.tempDrawImageView.frame];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(context, self.currentPoint.x, self.currentPoint.y);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.strokeWidth);
        CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextStrokePath(context);
        self.tempDrawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.tempDrawImageView setAlpha:self.strokeOpacity];
        UIGraphicsEndImageContext();
        
        self.lastPoint = self.currentPoint;
        
        if ([self.delegate respondsToSelector:@selector(drawingViewTouchesMoved:)]) {
            [self.delegate drawingViewTouchesMoved:self];
        }
    }
    // Touch ended
    if (self.isTouchEnded) {
        if (!self.isTouchMoved) {
            UIGraphicsBeginImageContext(self.tempDrawImageView.frame.size);
            [self.tempDrawImageView.image drawInRect:self.tempDrawImageView.frame];
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineWidth(context, self.strokeWidth);
            CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
            CGContextMoveToPoint(context, self.lastPoint.x, self.lastPoint.y);
            CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
            CGContextStrokePath(context);
            CGContextFlush(context);
            self.tempDrawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        // Merge images
        UIGraphicsBeginImageContext(self.mainImageView.frame.size);
        [self.mainImageView.image drawInRect:self.mainImageView.frame blendMode:kCGBlendModeNormal alpha:1.0f];
        [self.tempDrawImageView.image drawInRect:self.tempDrawImageView.frame blendMode:kCGBlendModeNormal alpha:self.strokeOpacity];
        self.mainImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        self.tempDrawImageView.image = nil;
        UIGraphicsEndImageContext();
        
        if ([self.delegate respondsToSelector:@selector(drawingViewTouchesEnded:)]) {
            [self.delegate drawingViewTouchesEnded:self];
        }
    }
}

#pragma mark - Touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Reset the states
    self.touchMoved = NO;
    self.touchEnded = NO;
    
    self.lastPoint = [[touches anyObject] locationInView:self];
    
    if ([self.delegate respondsToSelector:@selector(drawingViewTouchesBegan:)]) {
        [self.delegate drawingViewTouchesBegan:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchMoved = YES;
    self.currentPoint = [[touches anyObject] locationInView:self];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchEnded = YES;
    [self setNeedsDisplay];
}

@end
