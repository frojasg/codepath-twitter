//
//  ReplyViewController.m
//  TwitterClient
//
//  Created by Francisco Rojas Gallegos on 11/8/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "User.h"


@interface TweetDetailsViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *tweets;
@property (weak, nonatomic) IBOutlet UITextField *replyTextField;
@property (readonly) Tweet* tweet;

@end

@implementation TweetDetailsViewController

- (id) initWithTweet: (Tweet*) tweet {
    self = [super init];
    if (self) {
        self.tweets = @[tweet];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.replyTextField.text = [[NSString alloc] initWithFormat:@"%@ ", self.tweet.user.screenname];
}

- (Tweet*) tweet {
    return self.tweets[0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Actions
- (IBAction)onReply:(id)sender {
    NSLog(@"on reply!");
    Tweet* tweet = [[Tweet alloc] init];
    tweet.text = self.replyTextField.text;
    tweet.responseTo = self.tweet;
    tweet.user = [User currentUser];
    tweet.createdAt = [NSDate date];

    [self.delegator replyTweet:tweet];

    self.tweets = [self.tweets arrayByAddingObjectsFromArray:@[tweet]];
    [self.tableView reloadData];
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

#pragma mark Tweet Cell Delegate
- (void) retweet: (TweetCell *) cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    [self.delegator retweetTweet:tweet];
}

- (void) like: (TweetCell *) cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    [self.delegator likeTweet:tweet];
}
- (void) reply: (TweetCell *) cell {
    [self.replyTextField becomeFirstResponder];
}


@end
