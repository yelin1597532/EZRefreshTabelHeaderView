//
//  EZRefreshTableHeaderDefaultContentView.m
//  EZRefreshTabelHeaderView
//
//  Created by ye on 15/12/15.
//  Copyright © 2015年 4GInter. All rights reserved.
//

#import "EZRefreshTableHeaderDefaultContentView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EZRefreshTableHeaderDefaultContentView

- (instancetype)initForDirection:(EZRefreshTableHeaderPullDirection)direction
{
    self = [super initForDirection:direction];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        _arrow = imageView;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:indicator];
        indicator.hidden = YES;
        _activityView = indicator;
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _label = label;
        
        _direction = direction;
        if (direction == EZRefreshTableHeaderPullDirectionUp) {
            _arrow.image = [UIImage imageNamed:@"upArrow"];
            _label.text = @"上拉即可加载更多";
        } else {
            _arrow.image = [UIImage imageNamed:@"downArrow"];
            _label.text = @"下拉即可刷新";
        }
    }
    return self;
}

- (void)dealloc
{
    [self endRefreshAnimation];
}

- (void)layoutSubviews
{
    _arrow.frame = CGRectMake(30, self.frame.size.height / 2 - 15, 30, 30);
    _activityView.frame = CGRectMake(30, self.frame.size.height / 2 - 15, 30, 30);
    _label.frame = CGRectMake(90, self.frame.size.height / 2 - 8, self.frame.size.width - 90 - 90, 16);
}

- (void)layoutSubviewsForPercent:(CGFloat)percent
{
    if (_direction == EZRefreshTableHeaderPullDirectionUp) {
        if (percent == 1) {
            if (!_distanceEnough) {
                _distanceEnough = YES;
                _label.text = @"松开即可刷新";
                [_arrow.layer addAnimation:[self rotationAnimationFromAngle:0 toAngle:180] forKey:@"right"];
                [CATransaction setDisableActions:YES];
                _arrow.layer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
                [CATransaction setDisableActions:NO];
            }
        } else {
            if (_distanceEnough) {
                _distanceEnough = NO;
                _label.text = @"上拉即可加载更多";
                [_arrow.layer addAnimation:[self rotationAnimationFromAngle:180 toAngle:0] forKey:@"left"];
                [CATransaction setDisableActions:YES];
                _arrow.layer.transform = CATransform3DMakeRotation(0, 0.0f, 0.0f, 1.0f);
                [CATransaction setDisableActions:NO];
            }
        }
    } else {
        if (percent == 1) {
            if (!_distanceEnough) {
                _distanceEnough = YES;
                _label.text = @"松开即可加载更多";
                [_arrow.layer addAnimation:[self rotationAnimationFromAngle:0 toAngle:-180] forKey:@"right"];
                [CATransaction setDisableActions:YES];
                _arrow.layer.transform = CATransform3DMakeRotation(0 - M_PI, 0.0f, 0.0f, 1.0f);
                [CATransaction setDisableActions:NO];
            }
        } else {
            if (_distanceEnough) {
                _distanceEnough = NO;
                _label.text = @"下拉即可更新";
                [_arrow.layer addAnimation:[self rotationAnimationFromAngle:-180 toAngle:0] forKey:@"right"];
                [CATransaction setDisableActions:YES];
                _arrow.layer.transform = CATransform3DMakeRotation(0, 0.0f, 0.0f, 1.0f);
                [CATransaction setDisableActions:NO];
            }
        }
    }
}

- (void)startRefreshAnimation
{
    _arrow.hidden = YES;
    _activityView.hidden = NO;
    _label.text = @"加载中...";
    [_activityView startAnimating];
}

- (void)endRefreshAnimation
{
    if (_direction == EZRefreshTableHeaderPullDirectionUp) {
        _label.text = @"上拉即可加载更多";
    } else {
        _label.text = @"下拉即可刷新";
    }
    _arrow.hidden = NO;
    _activityView.hidden = YES;
    [_activityView stopAnimating];
    [CATransaction setDisableActions:YES];
    _arrow.layer.transform = CATransform3DIdentity;
    [CATransaction setDisableActions:NO];
}

- (CAAnimation *)rotationAnimationFromAngle:(CGFloat)fromAngle toAngle:(CGFloat)toAngle
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = @(fromAngle / 180 * M_PI);
    animation.toValue = @(toAngle / 180 * M_PI);
    animation.duration = 0.2f;
    animation.removedOnCompletion = YES;
    return animation;
}

@end
