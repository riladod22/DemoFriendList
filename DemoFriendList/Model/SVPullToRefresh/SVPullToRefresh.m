//
// SVPullToRefresh.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "SVPullToRefresh.h"
#import "ComFunc.h"

enum {
    SVPullToRefreshStateHidden = 1,
	SVPullToRefreshStateVisible,
    SVPullToRefreshStateTriggered,
    SVPullToRefreshStateLoading
};

typedef NSUInteger SVPullToRefreshState;


@interface SVPullToRefresh () 

- (id)initWithScrollView:(UIScrollView*)scrollView;
- (void)rotateArrow:(float)degrees hide:(BOOL)hide;
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset;
- (void)scrollViewDidScroll:(CGPoint)contentOffset;

@property (nonatomic, copy) void (^actionHandler)(void);
@property (nonatomic, readwrite) SVPullToRefreshState state;

@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong, readonly) UIImage *arrowImage;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong, readonly) UILabel *dateLabel;
@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) UIEdgeInsets originalScrollViewContentInset;

@end



@implementation SVPullToRefresh

// public properties
@synthesize actionHandler, arrowColor, textColor, activityIndicatorViewStyle, lastUpdatedDate;

@synthesize state;
@synthesize scrollView = _scrollView;
@synthesize arrow, arrowImage, activityIndicatorView, titleLabel, dateLabel, dateFormatter, originalScrollViewContentInset;

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (id)initWithScrollView:(UIScrollView *)scrollView {
    self = [super initWithFrame:CGRectZero];
    self.scrollView = scrollView;
    [_scrollView addSubview:self];
    
    // default styling values
    self.arrowColor = [UIColor grayColor];
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.textColor = [UIColor darkGrayColor];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 150, 20)];
    titleLabel.text = @"下拉刷新...";
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = textColor;
    [self addSubview:titleLabel];
        
    [self addSubview:self.arrow];
    
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    self.originalScrollViewContentInset = scrollView.contentInset;
	
    self.state = SVPullToRefreshStateHidden;    
    self.frame = CGRectMake(0, -50, scrollView.bounds.size.width, 50); //下拉區塊

    return self;
}

- (void)layoutSubviews {
    CGFloat remainingWidth = self.superview.bounds.size.width-200;
    float position = 0.50;
    
    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.x = ceil(remainingWidth*position+44);
    titleLabel.frame = titleFrame;
    
    CGRect dateFrame = dateLabel.frame;
    dateFrame.origin.x = titleFrame.origin.x;
    dateLabel.frame = dateFrame;
    
    CGRect arrowFrame = arrow.frame;
    arrowFrame.origin.x = ceil(remainingWidth*position);
    arrow.frame = arrowFrame;
    
    self.activityIndicatorView.center = self.arrow.center;
}

#pragma mark - Getters

- (UIImageView *)arrow {
    if(!arrow) {
        arrow = [[UIImageView alloc] initWithImage:self.arrowImage];
        arrow.frame = CGRectMake(0, 16, 26, 22); //arrow frame's size & position
        arrow.backgroundColor = [UIColor clearColor];
    }
    return arrow;
}

- (UIImage *)arrowImage {
    CGRect rect = CGRectMake(0, 0, 26, 22); //arrow's size
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);
    
    [self.arrowColor set];
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, [[UIImage imageNamed:@"pull_triangle"] CGImage]);
    CGContextFillRect(context, rect);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if(!activityIndicatorView) {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:activityIndicatorView];
    }
    return activityIndicatorView;
}

- (UILabel *)dateLabel {
    if(!dateLabel) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 180, 20)];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = textColor;
        [self addSubview:dateLabel];
        
        CGRect titleFrame = titleLabel.frame;
        titleFrame.origin.y = 12;
        titleLabel.frame = titleFrame;
    }
    return dateLabel;
}

- (NSDateFormatter *)dateFormatter {
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		dateFormatter.locale = [NSLocale currentLocale];
    }
    return dateFormatter;
}

#pragma mark - Setters

- (void)setArrowColor:(UIColor *)newArrowColor {
    arrowColor = newArrowColor;
    self.arrow.image = self.arrowImage;
}

- (void)setTextColor:(UIColor *)newTextColor {
    textColor = newTextColor;
    titleLabel.textColor = newTextColor;
	dateLabel.textColor = newTextColor;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        if(self.state == SVPullToRefreshStateHidden && contentInset.top == self.originalScrollViewContentInset.top)
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                self->arrow.alpha = 0;
            } completion:NULL];
    }];
}

- (void)setLastUpdatedDate:(NSDate *)newLastUpdatedDate {
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), newLastUpdatedDate?[self.dateFormatter stringFromDate:newLastUpdatedDate]:NSLocalizedString(@"Never",)];
}


#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"] && self.state != SVPullToRefreshStateLoading)
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {    
    CGFloat scrollOffsetThreshold = self.frame.origin.y-self.originalScrollViewContentInset.top;
    
    if(!self.scrollView.isDragging && self.state == SVPullToRefreshStateTriggered)
        self.state = SVPullToRefreshStateLoading;
    else if(contentOffset.y > scrollOffsetThreshold && contentOffset.y < -self.originalScrollViewContentInset.top && self.scrollView.isDragging && self.state != SVPullToRefreshStateLoading)
        self.state = SVPullToRefreshStateVisible;
    else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == SVPullToRefreshStateVisible)
        self.state = SVPullToRefreshStateTriggered;
    else if(contentOffset.y >= -self.originalScrollViewContentInset.top && self.state != SVPullToRefreshStateHidden)
        self.state = SVPullToRefreshStateHidden;
}

- (void)triggerRefresh {
    self.state = SVPullToRefreshStateLoading;
}

- (void)stopAnimating {
    self.state = SVPullToRefreshStateHidden;
}

- (void)setState:(SVPullToRefreshState)newState {
    state = newState;

    switch (newState) {
        case SVPullToRefreshStateHidden:
            titleLabel.text = @"刷新成功...";
            [self.activityIndicatorView stopAnimating];
            [self setScrollViewContentInset:self.originalScrollViewContentInset];
            [self rotateArrow:0 hide:NO];
            break;
            
        case SVPullToRefreshStateVisible:
            titleLabel.text = @"下拉刷新...";
            arrow.alpha = 1;
            [self.activityIndicatorView stopAnimating];
            [self setScrollViewContentInset:self.originalScrollViewContentInset];
            [self rotateArrow:0 hide:NO];
            break;
            
        case SVPullToRefreshStateTriggered:
            titleLabel.text = @"放開開始刷新...";
            [self rotateArrow:M_PI hide:NO];
            break;
            
        case SVPullToRefreshStateLoading:
            titleLabel.text = @"刷新中...";
            [self.activityIndicatorView startAnimating];
            [self setScrollViewContentInset:UIEdgeInsetsMake(self.frame.origin.y*-1+self.originalScrollViewContentInset.top, 0, 0, 0)];
            [self rotateArrow:0 hide:YES];
            if(actionHandler)
                actionHandler();
            break;
    }
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self.arrow.layer.opacity = !hide;
    } completion:NULL];
}

@end


#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    SVPullToRefresh *pullToRefreshView = [[SVPullToRefresh alloc] initWithScrollView:self];
    pullToRefreshView.actionHandler = actionHandler;
    self.pullToRefreshView = pullToRefreshView;
}

- (void)setPullToRefreshView:(SVPullToRefresh *)pullToRefreshView {
    [self willChangeValueForKey:@"pullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"pullToRefreshView"];
}

- (SVPullToRefresh *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

@end
