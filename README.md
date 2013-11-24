This project contains a simple drawing view. It is enable to change the stroke color and stroke width. However, it supports only single touch.

## Classes

### SHDrawingView
These dual UIImageViews are used to preserve opacity. When you’re drawing on tempDrawImageView, the opacity is set to 1.0 (fully opaque). However, when you merge tempDrawImageView with mainImageView, the tempDrawImage opacity is set to the configured value, thus giving the brush stroke the opacity we want. If you were to draw directly on mainImageView, it would be incredibly difficult to draw brush strokes with different opacity values.

		@property (nonatomic, weak, readonly) UIImageView *tempDrawImageView;
		@property (nonatomic, weak, readonly) UIImageView *mainImageView;

Drawing properties

		@property (nonatomic, strong) UIColor *strokeColor;
		@property (nonatomic, assign) CGFloat strokeOpacity;
		@property (nonatomic, assign) CGFloat strokeWidth;

Delegate methods

		- (void)drawingViewTouchesEnded:(SHDrawingView *)drawingView;
		- (void)drawingViewTouchesBegan:(SHDrawingView *)drawingView;
		- (void)drawingViewTouchesMoved:(SHDrawingView *)drawingView;