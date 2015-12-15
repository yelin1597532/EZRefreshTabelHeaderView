//
//  EZRefreshTableHeaderFooter.m
//  EZRefreshTabelHeaderView
//
//  Created by ye on 15/12/15.
//  Copyright © 2015年 4GInter. All rights reserved.
//

#import "EZRefreshTableHeaderFooter.h"
#import "EZRefreshTableHeaderDefaultContentView.h"
#import <objc/runtime.h>

@implementation EZRefreshTableHeaderFooter

- (instancetype)initWithTableView:(UITableView *)tableView direction:(EZRefreshTableHeaderPullDirection)direcion
{
    if (!tableView) {
        return nil;
    }
    self = [super init];
    if (self) {
        _tableView = tableView;
        _direction = direcion;
        
        [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial context:nil];
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial context:nil];
        [_tableView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionInitial context:nil];
        
        if (_direction & EZRefreshTableHeaderPullDirectionUp) {
            EZRefreshTableHeaderContentView *footerView = nil;
            CGFloat height = [self viewHeightForDirection:EZRefreshTableHeaderPullDirectionUp];
            if ([_dataSource respondsToSelector:@selector(refreshHeaderView:contentViewForDirection:)]) {
                footerView = [_dataSource refreshHeaderView:self contentViewForDirection:EZRefreshTableHeaderPullDirectionUp];
            } else {
                footerView = [[EZRefreshTableHeaderDefaultContentView alloc] initForDirection:EZRefreshTableHeaderPullDirectionUp];
            }
            _footerView = footerView;
            _footerView.frame = CGRectMake(0, MAX(_tableView.contentSize.height, _tableView.frame.size.height), _tableView.frame.size.width, height);
            [_tableView addSubview:_footerView];
        }
        if (_direction & EZRefreshTableHeaderPullDirectionDown) {
            EZRefreshTableHeaderContentView *headerView = nil;
            CGFloat height = [self viewHeightForDirection:EZRefreshTableHeaderPullDirectionDown];
            if ([_dataSource respondsToSelector:@selector(refreshHeaderView:contentViewForDirection:)]) {
                headerView = [_dataSource refreshHeaderView:self contentViewForDirection:EZRefreshTableHeaderPullDirectionDown];
            } else {
                headerView = [[EZRefreshTableHeaderDefaultContentView alloc] initForDirection:EZRefreshTableHeaderPullDirectionDown];
            }
            _headerView = headerView;
            _headerView.frame = CGRectMake(0, 0 - height, _tableView.frame.size.width, height);
            [_tableView addSubview:_headerView];
        }
    }
    return self;
}

- (void)dealloc
{
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
    [_tableView removeObserver:self forKeyPath:@"bounds"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"] || [keyPath isEqualToString:@"bounds"]) {
        //大小有变化时重新设置位置
        if (_direction & EZRefreshTableHeaderPullDirectionDown) {
            CGFloat headerHeight = [self viewHeightForDirection:EZRefreshTableHeaderPullDirectionDown];
            _headerView.frame = CGRectMake(0, 0 - headerHeight, _tableView.frame.size.width, headerHeight);
        }
        if (_direction & EZRefreshTableHeaderPullDirectionUp) {
            CGFloat footerHeight = [self viewHeightForDirection:EZRefreshTableHeaderPullDirectionUp];
            _footerView.frame = CGRectMake(0, MAX(_tableView.contentSize.height, _tableView.frame.size.height), _tableView.frame.size.width, footerHeight);
        }
    } else if ([keyPath isEqualToString:@"contentOffset"]) {
        if (!_refreshDirection) {
            //根据拖动进行变化
            CGPoint contentOffset = _tableView.contentOffset;
            if (_direction & EZRefreshTableHeaderPullDirectionDown) {
                CGFloat maxHeaderDistance = [self distanceForLoadingAtDirection:EZRefreshTableHeaderPullDirectionDown];
                CGFloat headerPercent = (0 - contentOffset.y) / maxHeaderDistance;
                headerPercent = headerPercent > 1 ? 1 : headerPercent;
                headerPercent = headerPercent < 0 ? 0 : headerPercent;
                [_headerView layoutSubviewsForPercent:headerPercent];
            }
            
            if (_direction & EZRefreshTableHeaderPullDirectionUp) {
                CGFloat maxFooterDistance = [self distanceForLoadingAtDirection:EZRefreshTableHeaderPullDirectionUp];
                CGFloat distance = contentOffset.y - ((_tableView.contentSize.height > _tableView.frame.size.height) ? (_tableView.contentSize.height - _tableView.frame.size.height) : 0);
                CGFloat footerPercent = distance / maxFooterDistance;
                footerPercent = footerPercent > 1 ? 1 : footerPercent;
                footerPercent = footerPercent < 0 ? 0 : footerPercent;
                [_footerView layoutSubviewsForPercent:footerPercent];
            }
        }
    }
}


- (void)tableViewDidEndDragging
{
    if (_refreshDirection) {
        return;
    }
    CGFloat maxFooterDistance = [self distanceForLoadingAtDirection:EZRefreshTableHeaderPullDirectionUp];
    CGFloat footerDistance = _tableView.contentOffset.y - ((_tableView.contentSize.height > _tableView.frame.size.height) ? (_tableView.contentSize.height - _tableView.frame.size.height) : 0);
    CGFloat maxHeaderDistance = [self distanceForLoadingAtDirection:EZRefreshTableHeaderPullDirectionDown];
    if (_direction & EZRefreshTableHeaderPullDirectionUp && footerDistance > maxHeaderDistance && [self shouldStartRefreshForDistance:EZRefreshTableHeaderPullDirectionUp]) {
        _refreshDirection = EZRefreshTableHeaderPullDirectionUp;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, (_tableView.contentSize.height > _tableView.frame.size.height) ? maxFooterDistance : _tableView.frame.size.height - _tableView.contentSize.height + maxFooterDistance, 0);
        [_footerView startRefreshAnimation];
        _headerView.hidden = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(refreshHeaderDidStartRefresh:forDirection:)]) {
            [_delegate refreshHeaderDidStartRefresh:self forDirection:EZRefreshTableHeaderPullDirectionUp];
        }
    } else if (_direction & EZRefreshTableHeaderPullDirectionDown && _tableView.contentOffset.y < 0 - maxHeaderDistance && [self shouldStartRefreshForDistance:EZRefreshTableHeaderPullDirectionDown]) {
        _refreshDirection = EZRefreshTableHeaderPullDirectionDown;
        _tableView.contentInset = UIEdgeInsetsMake(maxHeaderDistance, 0, 0, 0);
        [_headerView startRefreshAnimation];
        _footerView.hidden = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(refreshHeaderDidStartRefresh:forDirection:)]) {
            [_delegate refreshHeaderDidStartRefresh:self forDirection:EZRefreshTableHeaderPullDirectionDown];
        }
    }
}

- (void)didFinishRefresh
{
    if (!_refreshDirection) {
        return;
    }
    if (_refreshDirection == EZRefreshTableHeaderPullDirectionDown) {
        _refreshDirection = 0;
        [_headerView endRefreshAnimation];
        [UIView animateWithDuration:0.25 animations:^{
            _tableView.contentInset = UIEdgeInsetsZero;
        }];
        _footerView.hidden = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(refreshHeaderDidStopRefresh:forDirection:)]) {
            [_delegate refreshHeaderDidStopRefresh:self forDirection:EZRefreshTableHeaderPullDirectionDown];
        }
    } else if (_refreshDirection == EZRefreshTableHeaderPullDirectionUp) {
        _refreshDirection = 0;
        [_footerView endRefreshAnimation];
        [UIView animateWithDuration:0.25 animations:^{
            _tableView.contentInset = UIEdgeInsetsZero;
        }];
        _headerView.hidden = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(refreshHeaderDidStopRefresh:forDirection:)]) {
            [_delegate refreshHeaderDidStopRefresh:self forDirection:EZRefreshTableHeaderPullDirectionUp];
        }
    }
}

#pragma mark Helper

- (CGFloat)viewHeightForDirection:(EZRefreshTableHeaderPullDirection)direction
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(refreshHeaderView:heightForViewAtDirection:)]) {
        return [_dataSource refreshHeaderView:self heightForViewAtDirection:_direction];
    } else {
        return 44;
    }
}

- (CGFloat)distanceForLoadingAtDirection:(EZRefreshTableHeaderPullDirection)direction
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(refreshHeaderView:distanceForLoadingAtDirection:)]) {
        return [_dataSource refreshHeaderView:self distanceForLoadingAtDirection:_direction];
    } else {
        return 60;
    }
}

- (BOOL)shouldStartRefreshForDistance:(EZRefreshTableHeaderPullDirection)direction
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshHeaderSholdStartRefresh:forDirection:)]) {
        return [_delegate refreshHeaderSholdStartRefresh:self forDirection:direction];
    } else {
        return NO;
    }
    
}
@end
