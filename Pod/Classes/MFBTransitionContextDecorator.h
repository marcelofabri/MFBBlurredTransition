//
//  MFBTransitionContextDecorator.m
//
//  Created by Marcelo Fabri on 08/16/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFBTransitionEnums.h"

@protocol MFBViewControllerContextTransitioning <UIViewControllerContextTransitioning>

@property (nonatomic, strong, readonly) UIViewController *fromViewController;
@property (nonatomic, strong, readonly) UIViewController *toViewController;
@property (nonatomic, strong, readonly) UIViewController *originalViewController;
@property (nonatomic, strong, readonly) UIViewController *presentedViewController;

@end


@interface MFBTransitionContextDecorator : NSProxy <MFBViewControllerContextTransitioning>

- (instancetype)initWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
                                direction:(MFBTransitionDirection)direction;

@end
