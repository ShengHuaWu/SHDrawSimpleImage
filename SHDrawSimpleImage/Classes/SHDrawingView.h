//
//  SHDrawingView.h
//  SHDrawSimpleImage
//
//  Created by Shenghua on 2013/11/24.
//  Copyright (c) 2013年 Shenghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHDrawingView;

@protocol SHDrawingDelegate <NSObject>
@optional
/**
 *  @brief This method will be called after user touch ended.
 *
 *  @param drawingView The instance of this class
 */
- (void)drawingViewTouchesEnded:(SHDrawingView *)drawingView;

/**
 *  @brief This method will be called after user touch began.
 *
 *  @param drawingView The instance of this class
 */
- (void)drawingViewTouchesBegan:(SHDrawingView *)drawingView;

/**
 *  @brief This method will be called after user touch moved.
 *
 *  @param drawingView The instance of this class
 */
- (void)drawingViewTouchesMoved:(SHDrawingView *)drawingView;
@end

@interface SHDrawingView : UIView
@property (nonatomic, weak) id <SHDrawingDelegate> delegate;

/**
 *  These dual UIImageViews are used to preserve opacity.
 *  When you’re drawing on tempDrawImageView, the opacity is set to 1.0 (fully opaque).
 *  However, when you merge tempDrawImageView with mainImageView, the tempDrawImage opacity is set to the configured value, thus giving the brush stroke the opacity we want.
 *  If you were to draw directly on mainImageView, it would be incredibly difficult to draw brush strokes with different opacity values.
 */
@property (nonatomic, weak, readonly) UIImageView *tempDrawImageView;
@property (nonatomic, weak, readonly) UIImageView *mainImageView;

/**
 *  Drawing property
 */
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat strokeOpacity;
@property (nonatomic, assign) CGFloat strokeWidth;
@end
