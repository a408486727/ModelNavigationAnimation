//
//  NavigationAnimation.m
//  ModelNavigationAnimation
//
//  Created by xuchuanqi on 16/1/11.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "NavigationAnimation.h"

typedef NS_ENUM(NSUInteger ,AnimationType)
{
    AnimationTypePresent,
    AnimationTypeDismiss
};

@interface NavigationAnimation()
{
    UIPercentDrivenInteractiveTransition *percentDriven;
    AnimationType type;
    BOOL interactionInProgress;
}

@property(nonatomic,weak)UIViewController *currentVC;

@end

@implementation NavigationAnimation

- (instancetype)init
{
    self = [super init];
    if (self) {
        percentDriven = [[UIPercentDrivenInteractiveTransition alloc] init];
        interactionInProgress = NO;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    type = AnimationTypePresent;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    type = AnimationTypeDismiss;
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return interactionInProgress ? percentDriven : nil;
}

#pragma mark - GestureRecognizer
- (void)setCurrentVC:(UIViewController *)currentVC
{
    _currentVC = currentVC;
    UIScreenEdgePanGestureRecognizer *screenPan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(ScreenEdgePanSwipe:)];
    screenPan.edges = UIRectEdgeLeft;
    [_currentVC.view addGestureRecognizer:screenPan];
}

- (void)ScreenEdgePanSwipe:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    CGFloat moveX = [recognizer translationInView:self.currentVC.view].x;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            interactionInProgress = YES;
            [self.currentVC dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
            [percentDriven updateInteractiveTransition:moveX/self.currentVC.view.frame.size.width];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            interactionInProgress = NO;
            if (moveX/self.currentVC.view.frame.size.width< 0.5) {
                [percentDriven cancelInteractiveTransition];
            }else
            {
                [percentDriven finishInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return AnimationDuration;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (AnimationTypePresent == type) {
        [containerView addSubview:toViewController.view];
        self.currentVC = toViewController;

        toViewController.view.transform = CGAffineTransformMakeTranslation(containerView.frame.size.width, 0);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromViewController.view.transform = CGAffineTransformMakeTranslation(- containerView.frame.size.width/5, 0);
            toViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];

    }else
    {
        [containerView addSubview:toViewController.view];
        [containerView sendSubviewToBack:toViewController.view];
        
        fromViewController.view.layer.shadowOffset = CGSizeMake(-4, 0);
        fromViewController.view.layer.shadowColor = [[UIColor blackColor] CGColor];
        fromViewController.view.layer.shadowOpacity = 0.2;
        toViewController.view.transform = CGAffineTransformMakeTranslation(- containerView.frame.size.width/5, 0);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromViewController.view.transform = CGAffineTransformMakeTranslation(containerView.frame.size.width, 0);
            toViewController.view.transform = CGAffineTransformIdentity;

        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
