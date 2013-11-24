//
//  MainViewController.m
//  SHDrawSimpleImage
//
//  Created by Shenghua on 2013/11/24.
//  Copyright (c) 2013年 Shenghua. All rights reserved.
//

#import "MainViewController.h"
#import "SHDrawingView.h"

@interface MainViewController () <SHDrawingDelegate>
@property (nonatomic, weak) SHDrawingView *drawingView;
@property (nonatomic, strong) NSMutableArray *drawingStack; // Store drawing images
@property (nonatomic, assign) NSInteger drawingStackLocation; // Current location of the stack. This will change with undo or redo action.
@end

@implementation MainViewController

- (NSMutableArray *)drawingStack
{
    if (!_drawingStack) {
        _drawingStack = [NSMutableArray array];
    }
    return _drawingStack;
}

#pragma mark - View life cycle
- (void)loadView
{
    SHDrawingView *drawingView = [[SHDrawingView alloc] initWithFrame:CGRectZero];
    self.view = drawingView;
    self.drawingView = drawingView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.drawingView.delegate = self;
    self.drawingView.strokeColor = [UIColor greenColor];
    self.drawingView.strokeWidth = 10.0f;
}

#pragma mark - SH Drawing Delegate
- (void)drawingViewTouchesEnded:(SHDrawingView *)drawingView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
