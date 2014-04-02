//
//  MTZPushBackButton.h
//
//  Created by Matt on 8/17/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

///	Different types of highlighting.
typedef NS_ENUM(NSUInteger, MTZPushBackButtonTouchHighlight) {
	///	No highlight is shown.
	MTZPushBackButtonTouchHighlightNone = 0,
	///	Just the area of the tap is highlighted.
	MTZPushBackButtonTouchHighlightTapArea,
	///	The entire control is highlighted.
	MTZPushBackButtonTouchHighlightWholeControl
};

@interface MTZPushBackButton : UIButton

#warning TODO: Highlighting isn't perfect
// The edges aren't crisp with perspective
// The hightlight whole control doesn't fit to icon
// Take into consideration performance when removed and adding subview each move

///	The type of highlighting to display when the button is tapped.
@property (nonatomic) MTZPushBackButtonTouchHighlight highlightType;

///	The shape of the control.
@property (nonatomic) UIBezierPath *controlShape;

///	The color of the highlight.
@property (nonatomic) UIColor *highlightColor;

@end
