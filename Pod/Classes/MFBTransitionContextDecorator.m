//
//  MFBTransitionContextDecorator.m
//
//  Created by Marcelo Fabri on 08/16/14.
//

#import "MFBTransitionContextDecorator.h"
#import <CGFloatType/CGFloatType.h>

@interface MFBTransitionContextDecorator ()

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) MFBTransitionDirection direction;

@end

@implementation MFBTransitionContextDecorator

@dynamic fromViewController;
@dynamic toViewController;
@dynamic originalViewController;
@dynamic presentedViewController;

- (instancetype)initWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
                                direction:(MFBTransitionDirection)direction {
    if (! transitionContext) {
        return nil;
    }
    _transitionContext = transitionContext;
    _direction = direction;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.transitionContext];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [(id)self.transitionContext methodSignatureForSelector:sel];
}

- (UIViewController *)fromViewController {
    return [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
}

- (UIViewController *)toViewController {
    return [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
}

- (UIViewController *)originalViewController {
    if (self.direction == MFBTransitionDirectionForwards) {
        return self.fromViewController;
    }
    
    return self.toViewController;
}

- (UIViewController *)presentedViewController {
    if (self.direction == MFBTransitionDirectionForwards) {
        return self.toViewController;
    }
    
    return self.fromViewController;
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    CGSize size = vc.preferredContentSize;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        screenSize = CGSizeMake(screenSize.height, screenSize.width);
        
        
        CGRect result = CGRectMake(ceilCGFloat((screenSize.height - size.height) / 2.0f),
                          ceilCGFloat((screenSize.width - size.width) / 2.0f),
                          size.width, size.height);
        size = CGSizeMake(size.height, size.width);
        result.size = size;
        return result;
    }
    return CGRectMake(ceilCGFloat((screenSize.width - size.width) / 2.0f),
                      ceilCGFloat((screenSize.height - size.height) / 2.0f), size.width, size.height);
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    CGRect rect = [self finalFrameForViewController:vc];
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        rect.origin.x = -rect.size.width * 1.5f;
    } else {
        rect.origin.y = -rect.size.height * 1.5f;
    }
    
    return rect;
}

@end
