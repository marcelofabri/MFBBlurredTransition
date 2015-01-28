//
//  MFBMotionEffectsHelper.m
//  Pods
//
//  Created by Marcelo Fabri on 28/01/15.
//
//

#import "MFBMotionEffectsHelper.h"

@implementation MFBMotionEffectsHelper

+ (void)addMotionEffectsToView:(UIView *)view {
    
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

@end
