//
//  MenuViewController.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/14/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItemCell.h"
#import "TweetsViewController.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) NSArray *viewControllers;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuItems = @[@"Home", @"Profile"];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellReuseIdentifier:@"MenuItemCell"];

    self.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]], [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.hamburgerViewController.contentViewController = self.viewControllers[0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Table View Selector

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.hamburgerViewController.contentViewController = self.viewControllers[indexPath.row];

}


#pragma mark TableView DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuItemCell"];

    cell.textLabel.text = self.menuItems[indexPath.row];

    return cell;
}


@end
