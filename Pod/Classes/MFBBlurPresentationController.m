//
//  MFBBlurPresentationController.m
//  Pods
//
//  Created by Marcelo Fabri on 28/01/15.
//
//

#import "MFBBlurPresentationController.h"
#import "MFBMotionEffectsHelper.h"
#import <sys/sysctl.h>
#import "UIView+UIImageEffects.h"

NSString * mfb_devicePlatform() {
    int mib[] = { CTL_HW, HW_MACHINE };
    size_t len = 0;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    char *machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    NSString *platform = @(machine);
    free(machine);
    
    return platform;
}

BOOL mfb_deviceSupportsBlur() {
    NSArray *crappyDevices = @[@"iPhone3,1", @"iPhone3,2", @"iPhone3,3",
                               @"iPad2,1", @"iPad2,2", @"iPad2,3", @"iPad3,1", @"iPad3,2", @"iPad3,3"];
    
    return ![crappyDevices containsObject:mfb_devicePlatform()];
}

@interface MFBBlurPresentationController ()

@property (nonatomic, strong) UIView *dimmingView;

@end

@implementation MFBBlurPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController
                         presentingViewController:presentingViewController];
    if (self) {
        _blurStyle = UIBlurEffectStyleDark;
    }
    
    return self;
}

- (UIView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.blurStyle];

        UIView *blurView = nil;
        if (mfb_deviceSupportsBlur()) {
            blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        } else {
            switch (self.blurStyle) {
                case UIBlurEffectStyleExtraLight:
                    blurView = [self.containerView extraLightBlurredView];
                    break;
                case UIBlurEffectStyleLight:
                    blurView = [self.containerView lightBlurredView];
                    break;
                case UIBlurEffectStyleDark:
                default:
                    blurView = [self.containerView darkBlurredView];
                    break;
            }
        }

        blurView.frame = _dimmingView.bounds;
        
        [_dimmingView addSubview:blurView];
        _dimmingView.alpha = 0;
        
        SEL selector = sel_registerName("blurTapped:");
        
        if ([self.presentedViewController respondsToSelector:selector]) {
            UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self.presentedViewController
                                                                                 action:selector];
            [_dimmingView addGestureRecognizer:gr];
        }
    }
    
    return _dimmingView;
}
- (void)presentationTransitionWillBegin {
    self.dimmingView.frame = self.containerView.bounds;
    [self.containerView addSubview:self.dimmingView];
    [self.containerView addSubview:self.presentedView];
    
    [MFBMotionEffectsHelper addMotionEffectsToView:self.presentedView];
    
    self.presentedView.layer.cornerRadius = 6;
    self.presentedView.layer.shadowOpacity = 0.4;
    self.presentedView.layer.shadowOffset = CGSizeMake(-1, -1);
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 1;
    } completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        [self.dimmingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.dimmingView removeFromSuperview];
    }
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGSize size = self.presentedViewController.preferredContentSize;
    CGRect containerFrame = self.containerView.frame;
    
    CGRect frame = CGRectMake(ceil((containerFrame.size.width - size.width) / 2.0),
                              ceil((containerFrame.size.height - size.height) / 2.0), size.width, size.height);
    return frame;
}

- (BOOL)shouldRemovePresentersView {
    return NO;
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.frame = self.containerView.bounds;
    } completion:nil];
}

@end


