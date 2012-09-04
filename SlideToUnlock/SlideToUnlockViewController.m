//
//  SlideToUnlockViewController.m
//  SlideToUnlock
//
//  Created by Rounak Jain on 03/09/12.
//  Copyright (c) 2012 Rounak Jain. All rights reserved.
//

#import "SlideToUnlockViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <GLKit/GLKit.h>
@interface SlideToUnlockViewController ()
{
    CALayer *slidingArea;
    CALayer *slider;
    CGRect viewFrame;
    CGFloat offset;
    CGFloat initialX;
    UILabel *slidingLabel;
}
@end

@implementation SlideToUnlockViewController

- (id)initWithFrame:(CGRect)passedFrame {
    if (self = [super init]) {
        viewFrame = passedFrame;
    }
    return self;
}


- (void)slide:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        if (slider.frame.origin.x >= (slidingArea.frame.size.width - slider.frame.size.width))
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unlocked" message:@"Unlock Completed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        [UIView animateWithDuration:0.2 animations:^{
            slidingLabel.alpha = 1.0;
        }];
        CABasicAnimation *slideBackAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        slideBackAnimation.duration = 0.2;
        slideBackAnimation.fromValue = [NSNumber numberWithFloat:slider.position.x];
        slideBackAnimation.toValue = [NSNumber numberWithFloat:slider.frame.size.width/2];
        [slider addAnimation:slideBackAnimation forKey:@"slidebackanimation"];
        [CATransaction setDisableActions:YES];
        slider.position = CGPointMake(slider.frame.size.width/2, slider.position.y);
    }
    else
    {
        if (recognizer.state == UIGestureRecognizerStateBegan)
        {
            offset = [recognizer locationInView:slidingLabel].x - slider.position.x;
        }
        [CATransaction  setDisableActions:YES];
        slider.position = CGPointMake([recognizer locationInView:slidingLabel].x - offset, slider.position.y);
        slidingLabel.alpha = 1.0 - (slider.frame.origin.x/(slidingArea.frame.size.width/3));
    }
}
    
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);
    slidingLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 0, self.view.frame.size.width - 90.0, 60.0)];
    slidingLabel.textAlignment = UITextAlignmentCenter;
    slidingLabel.font = [UIFont systemFontOfSize:30.0];
    slidingLabel.numberOfLines = 1;
    slidingLabel.adjustsFontSizeToFitWidth = YES;
    slidingLabel.backgroundColor = [UIColor clearColor];
    slidingLabel.text = @"slide to unlock";
    slidingLabel.textColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor clearColor];
   
    [self.view addSubview:slidingLabel];
    
    slidingArea = [CALayer layer];
    slidingArea.frame = self.view.bounds;
    slidingArea.cornerRadius = 10.0;
    slidingArea.backgroundColor = [UIColor blackColor].CGColor;
    slidingArea.opacity = 0.5;
    [self.view.layer addSublayer:slidingArea];
    slider = [CALayer layer];
    slider.frame = CGRectMake(0, 0, 80.0 , slidingArea.frame.size.height);
    initialX = slider.position.x;
    slider.cornerRadius = 10.0;
    slider.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:slider];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slide:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

-(void)loadView
{
    UIView *tempView = [[UIView alloc] initWithFrame:viewFrame];
    self.view = tempView;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
