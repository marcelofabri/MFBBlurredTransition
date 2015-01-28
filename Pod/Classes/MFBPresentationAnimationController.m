//
//  MFBPresentationAnimationController.m
//  Pods
//
//  Created by Marcelo Fabri on 28/01/15.
//
//

#import "MFBPresentationAnimationController.h"

@implementation MFBPresentationAnimationController

- (instancetype)initWithDirection:(MFBTransitionDirection)direction {
    self = [super init];
    
    if (self) {
        _direction = direction;
        _animated = YES;
    }
    
    return self;
}

+ (instancetype)animatorWithDirection:(MFBTransitionDirection)direction {
    return [[self alloc] initWithDirection:direction];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (UIViewAnimationOptions)animationOptions {
    return (UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionCrossDissolve |
            UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState);
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.direction == MFBTransitionDirectionForwards) {
        [self animatePresentationWithTransitionContext:transitionContext];
    } else {
        [self animateDismissalWithTransitionContext:transitionContext];
    }
}

- (void)animatePresentationWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *presentedController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *presentedControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // Position the presented view off the top of the container view
    presentedControllerView.frame = [transitionContext finalFrameForViewController:presentedController];
    CGPoint center = presentedControllerView.center;
    center.y += containerView.bounds.size.height;
    presentedControllerView.center = center;
    
    [containerView addSubview:presentedControllerView];
    
    // Animate the presented view to it's final position
    void(^animations)() = ^{
        CGPoint center = presentedControllerView.center;
        center.y -= containerView.bounds.size.height;
        presentedControllerView.center = center;
    };
    
    void(^completion)(BOOL) = ^(BOOL completed){
        [transitionContext completeTransition:completed];
    };
    
    if (self.animated) {
        [UIView animateWithDuration:duration delay:0 options:[self animationOptions]
                         animations:animations completion:completion];
    } else {
        animations();
        completion(YES);
    }
}

- (void)animateDismissalWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *presentedControllerView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    void(^animations)() = ^{
        CGPoint center = presentedControllerView.center;
        center.y += containerView.bounds.size.height;
        presentedControllerView.center = center;
    };
    
    void(^completion)(BOOL) = ^(BOOL completed){
        [transitionContext completeTransition:completed];
    };
    
    if (self.animated) {
        [UIView animateWithDuration:duration delay:0 options:[self animationOptions]
                         animations:animations completion:completion];
    } else {
        animations();
        completion(YES);
    }
}

@end
