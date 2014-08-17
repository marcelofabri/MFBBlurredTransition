//
//  MFBBlurredBackgroundCoverTransition.m
//
//  Created by Marcelo Fabri on 08/16/14.
//

#import "MFBBlurredBackgroundCoverTransition.h"
#import "UIView+UIImageEffects.h"
#import "MFBTransitionContextDecorator.h"

static NSInteger const MFBBlurredViewTag = 19;

@interface MFBBlurredBackgroundCoverTransition ()

@end

@implementation MFBBlurredBackgroundCoverTransition

- (instancetype)init {
    return [self initWithDirection:MFBTransitionDirectionForwards];
}

- (instancetype)initWithDirection:(MFBTransitionDirection)direction {
    self = [super init];
    if (self) {
        _direction = direction;
        _blurStyle = MFBTransitionBlurStyleLight;
    }
    return self;
}

+ (instancetype)transitionWithDirection:(MFBTransitionDirection)direction {
    return [[self alloc] initWithDirection:direction];
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    id<MFBViewControllerContextTransitioning> decoratedContext = [[MFBTransitionContextDecorator alloc] initWithTransitionContext:transitionContext direction:self.direction];
    [self setupAnimation:decoratedContext];
    
    if (self.animated) {
        [UIView animateWithDuration:[self transitionDuration:decoratedContext]
                              delay:0
                            options:[self animationOptions]
                         animations:^{
                             [self performAnimation:decoratedContext];
                             
                         } completion:^(BOOL finished) {
                             BOOL didComplete = ![transitionContext transitionWasCancelled];
                             if (didComplete) {
                                 [self finalizeAnimation:decoratedContext];
                             }
                             [decoratedContext completeTransition:didComplete];
                         }];
    } else {
        [self performAnimation:decoratedContext];
        [self finalizeAnimation:decoratedContext];
        [decoratedContext completeTransition:YES];
    }
}

- (void)animationEnded:(BOOL)transitionCompleted {
    
}

#pragma mark - helpers

- (void)setupAnimation:(id<MFBViewControllerContextTransitioning>)transitionContext {
    if (self.direction == MFBTransitionDirectionForwards) {
        [self setupForwardAnimation:transitionContext];
    } else {
        [self setupReverseAnimation:transitionContext];
    }
}

- (void)addMotionEffects:(UIView *)view {
    
    CGFloat value = 20;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        value *= 2;
    }
    
    NSString *keyPath = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? @"center.y" : @"center.x";
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:keyPath type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-value);
    verticalMotionEffect.maximumRelativeValue = @(value);
    
    keyPath = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? @"center.x" : @"center.y";
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:keyPath type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-value);
    horizontalMotionEffect.maximumRelativeValue = @(value);
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [view addMotionEffect:group];
}

- (void)setupForwardAnimation:(id<MFBViewControllerContextTransitioning>)transitionContext {
    UIView *container = [transitionContext containerView];
    
    UIViewController *modalController = [transitionContext presentedViewController];
    modalController.view.frame = [self initialPresentedControllerFrame:transitionContext];
    modalController.view.layer.cornerRadius = 6;
    modalController.view.layer.shadowOpacity = .4f;
    modalController.view.layer.shadowOffset = CGSizeMake(-1, -1);
    
    [self addMotionEffects:modalController.view];
    
    UIView *blurredImageView = [self createBlurredViewForContext:transitionContext];
    [container addSubview:[transitionContext originalViewController].view];
    [[transitionContext originalViewController].view addSubview:blurredImageView];
    [container addSubview:modalController.view];
    
    blurredImageView.alpha = 0;
}

- (void)setupReverseAnimation:(id<MFBViewControllerContextTransitioning>)transitionContext {
    UIViewController *sourceController = [transitionContext originalViewController];
    UIView *container = [transitionContext containerView];
    
    [container addSubview:[transitionContext presentedViewController].view];
    [container addSubview:sourceController.view];
    [container sendSubviewToBack:sourceController.view];
}

- (UIViewAnimationOptions)animationOptions {
    return (UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionCrossDissolve |
            UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState);
}

- (void)performAnimation:(id<MFBViewControllerContextTransitioning>)transitionContext {
    UIView *blurredImageView = [self blurredViewForContext:transitionContext];
    UIViewController *modalController = [transitionContext presentedViewController];
    
    blurredImageView.frame = [self finalBlurredViewFrame:transitionContext];
    modalController.view.frame = [self finalPresentedControllerFrame:transitionContext];
    
    if (self.direction == MFBTransitionDirectionForwards) {
        blurredImageView.alpha = 1;
    } else {
        blurredImageView.alpha = 0;
    }
}

- (void)finalizeAnimation:(id<MFBViewControllerContextTransitioning>)transitionContext {
    if (self.direction == MFBTransitionDirectionForwards) {
        [self finalizeForwardTransition:transitionContext];
    } else {
        [self finalizeReverseTransition:transitionContext];
    }
}

- (void)finalizeForwardTransition:(id<MFBViewControllerContextTransitioning>)transitionContext {
    //    UIViewController *sourceController = [transitionContext originalViewController];
    //    [sourceController.view removeFromSuperview];
}

- (void)finalizeReverseTransition:(id<MFBViewControllerContextTransitioning>)transitionContext {
    UIView *blurredImageView = [self blurredViewForContext:transitionContext];
    UIViewController *modalController = [transitionContext presentedViewController];
    
    [blurredImageView removeFromSuperview];
    [modalController.view removeFromSuperview];
}

#pragma mark - blurred view states
- (UIView *)createBlurredViewForContext:(id<MFBViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromController = [transitionContext fromViewController];
    UIViewController *toController = [transitionContext toViewController];
    
    UIImageView *blurredImageView = [self blurredView:fromController.view forStyle:self.blurStyle];
    blurredImageView.tag = MFBBlurredViewTag;
    blurredImageView.contentMode = UIViewContentModeBottom;
    blurredImageView.clipsToBounds = YES;
    blurredImageView.frame = [self initialBlurredViewFrame:transitionContext];
    blurredImageView.userInteractionEnabled = YES;
	
    SEL selector = sel_registerName("blurTapped:");
    
    if ([toController respondsToSelector:selector]) {
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:toController
                                                                             action:selector];
        [blurredImageView addGestureRecognizer:gr];
    }
    
    return blurredImageView;
}

- (UIView *)blurredViewForContext:(id<MFBViewControllerContextTransitioning>)transitionContext {
    return [[transitionContext originalViewController].view viewWithTag:MFBBlurredViewTag];
}

- (UIImageView *)blurredView:(UIView *)view forStyle:(MFBTransitionBlurStyle)style {
    switch (style) {
        case MFBTransitionBlurStyleExtraLight:
            return [view extraLightBlurredView];
        case MFBTransitionBlurStyleDark:
            return [view darkBlurredView];
        case MFBTransitionBlurStyleCustomTint:
            return [view blurredViewWithTintColor:self.tintColor];
        case MFBTransitionBlurStyleLight:
        default:
            return [view lightBlurredView];
    }
}

- (CGRect)initialBlurredViewFrame:(id<MFBViewControllerContextTransitioning>)transitionContext {
    if (self.direction == MFBTransitionDirectionForwards) {
        return [self uncoveredBlurredViewFrame:transitionContext];
    }
    return [self coveredBlurredViewFrame:transitionContext];
}

- (CGRect)finalBlurredViewFrame:(id<MFBViewControllerContextTransitioning>)transitionContext {
    if (self.direction == MFBTransitionDirectionForwards) {
        return [self coveredBlurredViewFrame:transitionContext];
    }
    return [self uncoveredBlurredViewFrame:transitionContext];
}

- (CGRect)coveredBlurredViewFrame:(id<MFBViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromController = [transitionContext originalViewController];
    return fromController.view.bounds;
}

- (CGRect)uncoveredBlurredViewFrame:(id<MFBViewControllerContextTransitioning>)transitionContext {
    return [self coveredBlurredViewFrame:transitionContext];
}

#pragma mark - modal view states

- (CGRect)initialPresentedControllerFrame:(id<MFBViewControllerContextTransitioning>)transitionContext {
    if (self.direction == MFBTransitionDirectionForwards) {
        return [self uncoveredPresentedControllerFrame:transitionContext];
    }
    
    return [self coveredPresentedControllerFrame:transitionContext];
}

- (CGRect)finalPresentedControllerFrame:(id<MFBViewControllerContextTransitioning>)transitionContext {
    if (self.direction == MFBTransitionDirectionForwards) {
        return [self coveredPresentedControllerFrame:transitionContext];
    }
    
    return [self uncoveredPresentedControllerFrame:transitionContext];
}

- (CGRect)coveredPresentedControllerFrame:(id<MFBViewControllerContextTransitioning>)transitionContext {
    UIViewController *toController = [transitionContext presentedViewController];
    return [transitionContext finalFrameForViewController:toController];
}

- (CGRect)uncoveredPresentedControllerFrame:(id<MFBViewControllerContextTransitioning>)transitionContext {
    UIViewController *toController = [transitionContext presentedViewController];
    return [transitionContext initialFrameForViewController:toController];
}


@end
