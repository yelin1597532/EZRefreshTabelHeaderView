//
//  ViewController.m
//  EZRefreshTabelHeaderView
//
//  Created by ye on 15/12/15.
//  Copyright © 2015年 4GInter. All rights reserved.
//

#import "ViewController.h"
#import "EZRefreshTableHeaderFooter.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, EZRefreshTableHeaderViewDelegate>
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [[NSMutableArray alloc] initWithCapacity:20];
    _refreshHeader = [[EZRefreshTableHeaderFooter alloc] initWithTableView:_tableView direction:EZRefreshTableHeaderPullDirectionUp|EZRefreshTableHeaderPullDirectionDown];
    _refreshHeader.delegate = self;
    [self initData];
}

- (void)initData
{
    [_array removeAllObjects];
    for (NSInteger i = 0; i < 5; i++) {
        [_array addObject:@(i)];
    }
    [_tableView reloadData];
    [_refreshHeader didFinishRefresh];
}

- (void)getMoreData
{
    NSInteger count = _array.count;
    for (NSInteger i = count; i < count + 3; i++) {
        [_array addObject:@(i)];
    }
    [_tableView reloadData];
    [_refreshHeader didFinishRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSNumber *num = _array[indexPath.row];
    cell.textLabel.text = num.stringValue;
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeader tableViewDidEndDragging];
}

- (BOOL)refreshHeaderSholdStartRefresh:(EZRefreshTableHeaderFooter *)headerFooter forDirection:(EZRefreshTableHeaderPullDirection)direction
{
    return YES;
}

- (void)refreshHeaderDidStartRefresh:(EZRefreshTableHeaderFooter *)headerFooter forDirection:(EZRefreshTableHeaderPullDirection)direction
{
    if (direction == EZRefreshTableHeaderPullDirectionUp) {
        [self performSelector:@selector(getMoreData) withObject:nil afterDelay:2];
    } else if (direction == EZRefreshTableHeaderPullDirectionDown) {
        [self performSelector:@selector(initData) withObject:nil afterDelay:2];
    }
}

@end
