//
//  MTZViewController.m
//  PushBack
//
//  Created by Matt on 8/17/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZViewController.h"
#import "MTZPushBackControl.h"

#import "UIImage+Alpha.h"
#import "UIImage+Mask.h"

@interface MTZViewController ()

@end

@implementation MTZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self.view setBackgroundColor:[UIColor clearColor]];
	[self.view setOpaque:NO];
	
	MTZPushBackControl *control = [[MTZPushBackControl alloc] init];
	control.opaque = NO;
//	[control setHighlightType:MTZPushBackControlTouchHighlightWholeControl];
//	[control setHighlightColor:[UIColor colorWithWhite:0.0f alpha:0.25f]];
	[self.view addSubview:control];
	
#warning move to better solution so they don't have to add transparent pixels themselves
	UIImage *icon = [UIImage imageNamed:@"Photos"];
	CGRect iconFrame = (CGRect){0,0,icon.size.width,icon.size.height};
	UIBezierPath *round = [UIBezierPath bezierPathWithRoundedRect:iconFrame
													 cornerRadius:12.0f];
	icon = [icon maskedImageWithBezierPath:round];
	icon = [icon transparentBorderImage:1.0f];
	UIImageView *iv = [[UIImageView alloc] initWithImage:icon];
	[control addSubview:iv];
	[control setFrame:iv.frame];
	[control setCenter:self.view.center];
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
