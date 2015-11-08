//
//  TweetsViewController.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/6/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "TweetsViewController.h"
#import "ComposerController.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents: UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    UIImageView *twitter =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    twitter.image=[UIImage imageNamed:@"twitter"];
    self.navigationItem.titleView = twitter;

    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(showComposer)];

    self.navigationItem.rightBarButtonItem = tweetButton;


    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];

    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^
     (NSArray *tweets, NSError *error) {
         self.tweets = tweets;
         for (Tweet *tweet in tweets) {
             NSLog(@"image: %@ text: %@ ", [tweet.user.profileImageUrl absoluteString], tweet.text);

         }
         [self.tableView reloadData];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)onLogout:(id)sender {
    [User logout];
}
#pragma mark Actions

- (void) showComposer {
    NSLog(@"Tweet");
    [self presentViewController:[[ComposerController alloc] init] animated:YES completion:nil];
}

#pragma mark Refresh Controller
- (void) onRefresh:(UIRefreshControl *)refresh {
    if (self.tweets.count > 0) {
        Tweet *lasTweet = self.tweets[0];
    [[TwitterClient sharedInstance] homeTimelineWithParams:@{@"since_id": lasTweet.tweetId } completion:^
     (NSArray *tweets, NSError *error) {
         self.tweets = [tweets arrayByAddingObjectsFromArray:self.tweets];

         for (Tweet *tweet in tweets) {
             NSLog(@"image: %@ text: %@ ", [tweet.user.profileImageUrl absoluteString], tweet.text);

         }
         [self.tableView reloadData];
         [self.refreshControl endRefreshing];
     }];
    }
}


#pragma mark TableView DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    [cell setTweet: self.tweets[indexPath.row]];

    return cell;
}



@end
