//
//  EZRefreshTableHeaderDefaultContentView.h
//  EZRefreshTabelHeaderView
//
//  Created by ye on 15/12/15.
//  Copyright © 2015年 4GInter. All rights reserved.
//

#import "EZRefreshTableHeaderContentView.h"
#import "EZRefreshHeaderDefs.h"

@interface EZRefreshTableHeaderDefaultContentView : EZRefreshTableHeaderContentView
{
    BOOL _distanceEnough;
}
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIImageView *arrow;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;
@property (nonatomic, readonly) EZRefreshTableHeaderPullDirection direction;

@end
