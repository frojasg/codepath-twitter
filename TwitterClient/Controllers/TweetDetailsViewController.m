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
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;

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
    [self onChange:self];
}

- (Tweet*) tweet {
    return self.tweets[0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Actions
- (IBAction)onReply:(id)sender {
    Tweet* tweet = [[Tweet alloc] init];
    tweet.text = self.replyTextField.text;
    tweet.responseTo = self.tweet;
    tweet.user = [User currentUser];
    tweet.createdAt = [NSDate date];

    [self.delegator replyTweet:tweet];

    self.tweets = [self.tweets arrayByAddingObjectsFromArray:@[tweet]];
    [self.tableView reloadData];
}
- (IBAction)onChange:(id)sender {
    self.limitLabel.text = [[NSString alloc] initWithFormat:@"%ld", 140 - self.replyTextField.text.length];
    if (self.replyTextField.text.length < 130) {
        self.limitLabel.textColor = [UIColor colorWithRed:204/255.0f green:214/255.0f blue:221/255.0f alpha:1];
    } else if(self.replyTextField.text.length < 140) {
        self.limitLabel.textColor = [UIColor colorWithRed:255/255.0f green:204/255.0f blue:0/255.0f alpha:1];
    } else {
        self.limitLabel.textColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    }

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
