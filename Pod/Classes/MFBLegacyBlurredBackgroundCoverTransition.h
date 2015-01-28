//
//  MFBBlurredBackgroundCoverTransition.h
//
//  Created by Marcelo Fabri on 08/16/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFBTransitionEnums.h"

@interface MFBLegacyBlurredBackgroundCoverTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithDirection:(MFBTransitionDirection)direction;
+ (instancetype)transitionWithDirection:(MFBTransitionDirection)direction;

@property (nonatomic, assign, readonly) MFBTransitionDirection direction;
@property (nonatomic, assign) MFBTransitionBlurStyle blurStyle;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign, getter = isAnimated) BOOL animated;

@end
