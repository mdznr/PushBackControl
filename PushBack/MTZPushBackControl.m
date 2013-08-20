//
//  MTZPushBackControl.m
//
//  Created by Matt on 8/17/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZPushBackControl.h"

#define GOLDEN_RATIO 1.61803398875f
#define ANIMATION_DURATION 0.1618f
//#define ANIMATION_DURATION 1.0f

#define UIViewAutoresizingFlexibleSize (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)

@interface MTZPushBackControl ()

@property (strong, nonatomic) UIView *highlightView;

@end

@implementation MTZPushBackControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup
{
	self.layer.zPosition = 10.0f;
	
	_highlightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
	_highlightView.opaque = NO;
	_highlightView.hidden = YES;
	_highlightView.layer.opacity = 0.0f;
	[self addSubview:_highlightView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGFloat x = 0;
	CGFloat y =0;
	for ( UITouch *touch in touches ) {
		CGPoint point = [touch locationInView:self];
		x += point.x;
		y += point.y;
	}
	x /= touches.count;
	y /= touches.count;
	
	CGPoint point = (CGPoint){x,y};
	
	if ( ![self pointInside:point withEvent:event] ) {
		return;
	}
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionLayoutSubviews |
	 UIViewAnimationOptionAllowAnimatedContent |
	 UIViewAnimationOptionAllowUserInteraction |
	 UIViewAnimationOptionBeginFromCurrentState
					 animations:^(void){
						 [self pushBackWithPoint:point];
						 [self highlightAtPoint:point];
					 }
					 completion:nil];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSLog(@"Begin");
	
	CGPoint point = [touch locationInView:self];
	
	if ( ![self pointInside:point withEvent:event] ) {
		return NO;
	}
	
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionLayoutSubviews |
	                            UIViewAnimationOptionAllowAnimatedContent |
	                            UIViewAnimationOptionAllowUserInteraction |
	                            UIViewAnimationOptionBeginFromCurrentState
					 animations:^(void){
						 [self pushBackWithPoint:point];
						 [self highlightAtPoint:point];
					 }
					 completion:nil];
	
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSLog(@"Continue");
	
	CGPoint point = [touch locationInView:self];
	
#warning this should be to the original frame (not the transformed frame)
	// Give some buffer like UIButton highlighted state does.
	if ( ![self pointInside:point withEvent:event] ) {
		[self cancelTrackingWithEvent:event];
		return NO;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:1.0f/60.0f]; // set to be accurate to how often refresh of touches is.
	[self pushBackWithPoint:point];
	[self highlightAtPoint:point];
	[UIView commitAnimations];
	
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSLog(@"End");
	[self revertToNormalPerspective];
	[self stopHighlight];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
	NSLog(@"Canceled");
	[self revertToNormalPerspective];
	[self stopHighlight];
}

- (void)pushBackWithPoint:(CGPoint)point
{
	CALayer *layer = self.layer;
	CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
	rotationAndPerspectiveTransform.m34 = 1.0 / -500;
	
	// Calculate the y coordinate
	CGFloat width = self.frame.size.width;
	CGFloat y = point.x / width;
	y = (2.0f * y) - 1.0f;
	
	// Calculate the x coordinate
	CGFloat height = self.frame.size.height;
	CGFloat x = point.y / height;
	x = (2.0f * x) - 1.0f;
	x *= -1;
	
	// Calculate the partial angle (from 0 to angle)
	CGFloat angle = 10 * GOLDEN_RATIO;
	CGFloat distance = sqrt((x*x) + (y*y));
	angle *= distance;
	
	NSLog(@"x: %f y: %f a: %f", x, y, angle);
	
	CGFloat translateX = 2.0f * ((width  / 2.0f) - point.x);
	CGFloat translateY = 2.0f * ((height / 2.0f) - point.y);
	
//	rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform,  translateX,  translateY, 0.0f);
	rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, angle * M_PI / 180.0f, x, y, 0.0f);
//	rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, -translateX, -translateY, 0.0f);
	rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, 0.98f, 0.98f, 1.0f);
	
	layer.transform = rotationAndPerspectiveTransform;
//	layer.sublayerTransform = rotationAndPerspectiveTransform;
}

- (void)revertToNormalPerspective
{
	[UIView animateWithDuration:ANIMATION_DURATION
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionLayoutSubviews |
	                            UIViewAnimationOptionAllowAnimatedContent |
	                            UIViewAnimationOptionAllowUserInteraction
					 animations:^(void){self.layer.transform = CATransform3DIdentity;}
					 completion:nil];
}

#pragma mark Hightlighting

- (void)setHighlightColor:(UIColor *)highlightColor
{
	_highlightColor = highlightColor;
	_highlightView.backgroundColor = highlightColor;
}

- (void)setHighlightType:(MTZPushBackControlTouchHighlight)highlightType
{
	_highlightType = highlightType;
	switch ( highlightType ) {
		case MTZPushBackControlTouchHighlightTapArea:
			_highlightView.frame = (CGRect){0,0,40,40};
			_highlightView.autoresizingMask = UIViewAutoresizingNone;
			break;
		case MTZPushBackControlTouchHighlightWholeControl:
			_highlightView.frame = self.frame;
			_highlightView.autoresizingMask = UIViewAutoresizingFlexibleSize;
			break;
		case MTZPushBackControlTouchHighlightNone:
			_highlightView.frame = CGRectZero;
			break;
		default:
			break;
	}
}

- (void)highlightAtPoint:(CGPoint)point
{
	[_highlightView removeFromSuperview];
	[self addSubview:_highlightView];
	
	switch ( _highlightType ) {
		case MTZPushBackControlTouchHighlightTapArea:
			_highlightView.center = point;
		case MTZPushBackControlTouchHighlightWholeControl:
			_highlightView.hidden = NO;
			_highlightView.layer.opacity = 1.0f;
			break;
		case MTZPushBackControlTouchHighlightNone:
		default:
			break;
	}
}

- (void)stopHighlight
{
	_highlightView.hidden = YES;
	_highlightView.layer.opacity = 0.0f;
}

@end
