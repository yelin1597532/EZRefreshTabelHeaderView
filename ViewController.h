//
//  ViewController.h
//  EZRefreshTabelHeaderView
//
//  Created by ye on 15/12/15.
//  Copyright © 2015年 4GInter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZRefreshTableHeaderFooter;
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) EZRefreshTableHeaderFooter *refreshHeader;


@end

