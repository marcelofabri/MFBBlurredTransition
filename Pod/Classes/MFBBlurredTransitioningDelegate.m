//
//  MFBBlurredTransitioningDelegate.m
//
//  Created by Marcelo Fabri on 28/01/15.
//

#import "MFBBlurredTransitioningDelegate.h"
#import <MFBBlurredTransition/MFBLegacyBlurredBackgroundCoverTransition.h>
#import <MFBBlurredTransition/MFBBlurPresentationController.h>
#import <MFBBlurredTransition/MFBPresentationAnimationController.h>

@implementation MFBBlurredTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    
    return [[MFBBlurPresentationController alloc] initWithPresentedViewController:presented
                                                         presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([UIPresentationController class]) {
        return [MFBPresentationAnimationController animatorWithDirection:MFBTransitionDirectionForwards];
    }
    
    MFBLegacyBlurredBackgroundCoverTransition *animator = [[MFBLegacyBlurredBackgroundCoverTransition alloc] init];
    animator.blurStyle = MFBTransitionBlurStyleDark;
    animator.animated = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([UIPresentationController class]) {
        return [MFBPresentationAnimationController animatorWithDirection:MFBTransitionDirectionReverse];
    }
    
    MFBLegacyBlurredBackgroundCoverTransition *reverseAnimator = [[MFBLegacyBlurredBackgroundCoverTransition alloc] initWithDirection:MFBTransitionDirectionReverse];
    reverseAnimator.blurStyle = MFBTransitionBlurStyleDark;
    reverseAnimator.animated = YES;
    return reverseAnimator;
}

@end
