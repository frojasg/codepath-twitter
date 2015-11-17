//
//  ProfileViewController.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/14/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ProfileViewController.h"
#import "ComposerController.h"
#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "TweetDelegate.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate,  TweetCellDelegate, TweetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.coverImageView setImageWithURL:self.user.coverImageUrl];
    [self.profileImageView setImageWithURL:self.user.profileImageUrl];
    self.nameLabel.text = self.user.name;
    self.screennameLabel.text = self.user.screenname;
    self.tweetsCountLabel.text = [NSString stringWithFormat:@"%@", self.user.tweetCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%@", self.user.followersCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%@", self.user.followingCount];

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
    self.title = self.user.screenname;

    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(showComposer)];
    self.navigationItem.rightBarButtonItem = tweetButton;

    if (self.showMenuItem) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu:)];

        self.navigationItem.leftBarButtonItem = menuButton;

    }

    [self fetchUserTimeLine];

    [self.profileImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.profileImageView.layer setBorderWidth: 3.0];
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void) fetchUserTimeLine {

    [[TwitterClient sharedInstance] userTimelineWithParams:@{@"screen_name": self.user.screenname} completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
    }];
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

#pragma mark Tweet Delegator
- (void) reply: (TweetCell *) cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    ComposerController *vc = [[ComposerController alloc] initWithTweet:tweet];
    [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];

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
- (void) unretweet: (TweetCell *) cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    [self unretweetTweet:tweet];
}
- (void) unlike: (TweetCell *) cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    [self unlikeTweet:tweet];
}
- (void) profileSelection:(TweetCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    if (![tweet.user.screenname isEqualToString:self.user.screenname]) {
        [self viewProfile:tweet.user];
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
- (void) unretweetTweet:(Tweet *)tweet {
    [[TwitterClient sharedInstance] unretweetWithId:tweet.tweetId completion:^(Tweet *tweet, NSError *error) {
    }];

}
- (void) unlikeTweet: (Tweet *) tweet {
    [[TwitterClient sharedInstance] unlikeWithId:tweet.tweetId completion:^(Tweet *tweet, NSError *error) {
    }];
}
- (void) replyTweet: (Tweet *) tweet {
    NSLog(@"status: %@, replyTo: %@", tweet.text, tweet.responseTo.tweetId);
    [[TwitterClient sharedInstance] tweetWithParams:@{@"status": tweet.text, @"in_reply_to_status_id": tweet.responseTo.tweetId} completion:^(Tweet *tweet, NSError *error) {
    }];
}

- (void) viewProfile: (User *) user {
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [profile setUser:user];
    [self.navigationController pushViewController:profile  animated:YES];
}

#pragma mark TableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    Tweet *tweet = self.tweets[indexPath.row];

    TweetDetailsViewController *vc = [[TweetDetailsViewController alloc] initWithTweet:tweet];
    vc.delegator = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark Refresh Controller
- (void) onRefresh:(UIRefreshControl *)refresh {
    if (self.tweets.count > 0) {
        Tweet *lasTweet = self.tweets[0];

        [[TwitterClient sharedInstance] userTimelineWithParams:@{@"screen_name": self.user.screenname, @"since_id": lasTweet.tweetId } completion:^
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

-(void) setMenuItem {

}

#pragma mark Actions
- (void) showComposer {
    NSLog(@"Tweet");
    [self presentViewController:[[ComposerController alloc] init] animated:YES completion:nil];
}

- (IBAction)onMenu:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMenunNotification" object:nil];
}


@end
