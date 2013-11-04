//
//  MTZPushBackButton.h
//
//  Created by Matt on 8/17/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	MTZPushBackButtonTouchHighlightNone,
	MTZPushBackButtonTouchHighlightTapArea,
	MTZPushBackButtonTouchHighlightWholeControl
} MTZPushBackButtonTouchHighlight;

@interface MTZPushBackButton : UIButton

#warning TODO: Highlighting isn't perfect
// The edges aren't crisp with perspective
// The hightlight whole control doesn't fit to icon
// Take into consideration performance when removed and adding subview each move
@property (nonatomic) MTZPushBackButtonTouchHighlight highlightType;
@property (nonatomic) UIColor *highlightColor;

@end
