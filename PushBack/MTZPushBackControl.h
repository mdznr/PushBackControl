//
//  MTZPushBackControl.h
//
//  Created by Matt on 8/17/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	MTZPushBackControlTouchHighlightNone,
	MTZPushBackControlTouchHighlightTapArea,
	MTZPushBackControlTouchHighlightWholeControl
} MTZPushBackControlTouchHighlight;

@interface MTZPushBackControl : UIControl

#warning TODO: Highlighting isn't perfect
// The edges aren't crisp with perspective
// The hightlight whole control doesn't fit to icon
// Take into consideration performance when removed and adding subview each move
@property (nonatomic) MTZPushBackControlTouchHighlight highlightType;
@property (nonatomic) UIColor *highlightColor;

@end
