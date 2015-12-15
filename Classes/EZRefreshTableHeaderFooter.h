//
//  EZRefreshTableHeaderFooter.h
//  EZRefreshTabelHeaderView
//
//  Created by ye on 15/12/15.
//  Copyright © 2015年 4GInter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZRefreshHeaderDefs.h"
@class EZRefreshTableHeaderFooter, EZRefreshTableHeaderContentView;

@protocol EZRefreshTableHeaderViewDataSource <NSObject>
@optional
- (CGFloat)refreshHeaderView:(EZRefreshTableHeaderFooter *)headerFooter heightForViewAtDirection:(EZRefreshTableHeaderPullDirection)direction;
- (CGFloat)refreshHeaderView:(EZRefreshTableHeaderFooter *)headerFooter distanceForLoadingAtDirection:(EZRefreshTableHeaderPullDirection)direction;
- (EZRefreshTableHeaderContentView *)refreshHeaderView:(EZRefreshTableHeaderFooter *)headerFooter contentViewForDirection:(EZRefreshTableHeaderPullDirection)direction;
@end

@protocol EZRefreshTableHeaderViewDelegate <NSObject>
@required
- (BOOL)refreshHeaderSholdStartRefresh:(EZRefreshTableHeaderFooter *)headerFooter forDirection:(EZRefreshTableHeaderPullDirection)direction;
@optional
- (void)refreshHeaderDidStartRefresh:(EZRefreshTableHeaderFooter *)headerFooter forDirection:(EZRefreshTableHeaderPullDirection)direction;
- (void)refreshHeaderDidStopRefresh:(EZRefreshTableHeaderFooter *)headerFooter forDirection:(EZRefreshTableHeaderPullDirection)direction;
@end

@interface EZRefreshTableHeaderFooter : NSObject
{
    __weak UITableView *_tableView;
    __weak EZRefreshTableHeaderContentView *_headerView;
    __weak EZRefreshTableHeaderContentView *_footerView;
    EZRefreshTableHeaderPullDirection _refreshDirection;
}
@property (nonatomic, readonly) EZRefreshTableHeaderPullDirection direction;

- (id)initWithTableView:(UITableView *)tableView direction:(EZRefreshTableHeaderPullDirection)direcion;
- (void)tableViewDidEndDragging;
- (void)didFinishRefresh;


@property (nonatomic, weak) id<EZRefreshTableHeaderViewDataSource> dataSource;
@property (nonatomic, weak) id<EZRefreshTableHeaderViewDelegate> delegate;

@end
