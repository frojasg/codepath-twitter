//
//  TweetsViewController.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/6/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "TweetsViewController.h"
#import "ComposerController.h"
#import "TweetDetailsViewController.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, TweetDelegate, TweetCellDelegate>

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
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents: UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    UIImageView *twitter =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    twitter.image=[UIImage imageNamed:@"twitter"];
    self.navigationItem.titleView = twitter;

    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(showComposer)];
    self.navigationItem.rightBarButtonItem = tweetButton;

    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout:)];
    self.navigationItem.leftBarButtonItem = logoutButton;

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

#pragma mark Tweet Delegator
- (void) reply: (TweetCell *) cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    ComposerController *vc = [[ComposerController alloc] initWithTweet:tweet];
//    [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];

    [self presentViewController:vc animated:YES completion:nil];

}
- (void) retweet: (TweetCell *) cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    [self retweetTweet:tweet];
}
- (void) like: (TweetCell *) cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    [self likeTweet:tweet];
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

#pragma mark TweetDelegate
- (void) retweetTweet:(Tweet *)tweet {
    [[TwitterClient sharedInstance] retweetWithId:tweet.tweetId completion:^(Tweet *tweet, NSError *error) {
    }];
}
- (void) likeTweet: (Tweet *) tweet {
    [[TwitterClient sharedInstance] likeWithId:tweet.tweetId completion:^(Tweet *tweet, NSError *error) {
    }];
}
- (void) replyTweet: (Tweet *) tweet {
    NSLog(@"status: %@, replyTo: %@", tweet.text, tweet.responseTo.tweetId);
    [[TwitterClient sharedInstance] tweetWithParams:@{@"status": tweet.text, @"in_reply_to_status_id": tweet.responseTo.tweetId} completion:^(Tweet *tweet, NSError *error) {
    }];
}


#pragma mark TableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    Tweet *tweet = self.tweets[indexPath.row];

    TweetDetailsViewController *vc = [[TweetDetailsViewController alloc] initWithTweet:tweet];
    vc.delegator = self;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark TableView DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    [cell setTweet: self.tweets[indexPath.row]];
    cell.delegator = self;

    return cell;
}

@end
