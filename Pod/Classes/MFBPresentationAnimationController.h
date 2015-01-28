//
//  MFBPresentationAnimationController.h
//
//  Created by Marcelo Fabri on 28/01/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MFBBlurredTransition/MFBTransitionEnums.h>

@interface MFBPresentationAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithDirection:(MFBTransitionDirection)direction;
+ (instancetype)animatorWithDirection:(MFBTransitionDirection)direction;

@property (nonatomic, assign, readonly) MFBTransitionDirection direction;
@property (nonatomic, assign, getter = isAnimated) BOOL animated;

@end
