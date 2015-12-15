//
//  EZRefreshTableHeaderContentView.h
//  EZRefreshTabelHeaderView
//
//  Created by ye on 15/12/15.
//  Copyright © 2015年 4GInter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZRefreshHeaderDefs.h"
@interface EZRefreshTableHeaderContentView : UIView

- (instancetype)initForDirection:(EZRefreshTableHeaderPullDirection)direction;

//invoked when pulling, used for adjusting subviews by percentage of changing
//percent: percentage of changing，between 0 to 1
- (void)layoutSubviewsForPercent:(CGFloat)percent;

//invoked when pull distance is enough and start loading animation. used for adjusting subviews
- (void)startRefreshAnimation;

//invoked when loading animation is complete. used for adjusting subviews
- (void)endRefreshAnimation;
@end
