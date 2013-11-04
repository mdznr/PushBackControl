//
//  MTZViewController.m
//  PushBack
//
//  Created by Matt on 8/17/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZViewController.h"
#import "MTZPushBackButton.h"

#import "UIImage+Alpha.h"
#import "UIImage+Mask.h"

#define DOUBLE YES

@interface MTZViewController ()

@end

@implementation MTZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self.view setBackgroundColor:[UIColor clearColor]];
	[self.view setOpaque:NO];
	
	MTZPushBackButton *button = [[MTZPushBackButton alloc] init];
	button.opaque = NO;
//	[control setHighlightType:MTZPushBackControlTouchHighlightWholeControl];
//	[control setHighlightColor:[UIColor colorWithWhite:0.0f alpha:0.25f]];
	[self.view addSubview:button];
	
	UIImage *icon;
	if ( DOUBLE ) {
		icon = [UIImage imageNamed:@"DoublePhotos"];
	} else {
		icon = [UIImage imageNamed:@"Photos"];
	}
	CGRect iconFrame = (CGRect){0, 0, icon.size.width, icon.size.height};
	UIBezierPath *round;
	if ( DOUBLE ) {
		round = [UIBezierPath bezierPathWithRoundedRect:iconFrame
										   cornerRadius:24.0f];
	} else {
		round = [UIBezierPath bezierPathWithRoundedRect:iconFrame
										   cornerRadius:12.0f];
	}
	icon = [icon maskedImageWithBezierPath:round];
#warning move to better solution so they don't have to add transparent pixels themselves
	icon = [icon transparentBorderImage:1.0f];
	[button setBackgroundImage:icon forState:UIControlStateNormal];
	[button setFrame:iconFrame];
	[button setCenter:self.view.center];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate
{
	return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
