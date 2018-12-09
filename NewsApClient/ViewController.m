//
//  ViewController.m
//  NewsApClient
//
//  Created by ialexk on 07.12.2018.
//  Copyright © 2018 @ialexk. All rights reserved.
//

#import "ViewController.h"
#import "NewsDataSource.h"
#import "NewsData.h"
#import "CellArticle.h"
#import "ViewControllerDetailed.h"
#import "AppDelegate.h"
            
static NSString *kCellID = @"CellArticleID";
static NSString *kCellArticleNibName = @"CellArticle";
static NSString *kStoryboardName = @"Main";
static NSString *kIDViewControllerDetailed = @"ID_ViewControllerDetailed";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    id __block _tokenObserver1;
    id __block _tokenObserver2;
    //NewsData* _snapshot;
}
@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, strong) NewsDataSource* newsDataSource;
@property (nonatomic, strong) NewsData* _snapshot;
@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        assert(nil == self.newsDataSource);
        //self.newsDataSource = [[NewsDataSource alloc] init];
        self.newsDataSource = [NewsDataSource sharedInstance];
        __weak typeof(self) weakSelf = self;
        void (^onNotification)(NSNotification *) = ^(NSNotification *notification) {
            NSLog(@"Received Notification %@", [notification name]);
            if ([[notification name] isEqualToString:kNotificationNewData]) {
                weakSelf._snapshot = weakSelf.newsDataSource.newsData.copy;
                [weakSelf updateTable];
            }
            else if ([[notification name] isEqualToString:kNotificationRequestFailed]) {
                // TODO: hide hourglass
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:kAlertMessageTheRequestHasFailed preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:kAlertActionTitleClose style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];
                [weakSelf presentViewController:alert animated:YES completion:^{}];
            }
        };
        _tokenObserver1 = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationNewData object:nil queue:[NSOperationQueue mainQueue] usingBlock:onNotification];
        _tokenObserver2 = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationRequestFailed object:nil queue:[NSOperationQueue mainQueue] usingBlock:onNotification];
        if (![AppDelegate isApiKeyEmpty]) {
            [self.newsDataSource subscribe];
        }
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ViewController - dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:_tokenObserver1];
    [[NSNotificationCenter defaultCenter] removeObserver:_tokenObserver2];
    [self.newsDataSource unsubscribe];
    self.newsDataSource = nil;
    self._snapshot = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.table registerNib:[UINib nibWithNibName:kCellArticleNibName bundle:nil] forCellReuseIdentifier:kCellID];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([AppDelegate isApiKeyEmpty]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:kMessageApiKeyIsEmpty preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:kAlertActionTitleClose style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];
        [self presentViewController:alert animated:YES completion:^{}];
    }
}

// not used
/*
-(void)refreshTable:(nonnull NSArray*)indices {
    if (nil == indices) {
        return;
    }
    if (0 == indices.count) {
        return;
    }
    NSMutableArray* indexPaths = [[NSMutableArray alloc] init];
    for (NSNumber* number in indices) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:number.integerValue inSection:0];
        [indexPaths addObject:indexPath];
    }
    [self.table reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}
*/

- (NSInteger)getRowsCount {
    if (nil != self._snapshot) {
        if (nil != self._snapshot.articles) {
            return self._snapshot.articles.count;
        }
    }
    return 0;
}

-(void) updateTable
{
    [self.table reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getRowsCount];
}

- (nullable Article*)getArticle:(NSIndexPath *)indexPath
{
    if (nil != self._snapshot) {
        if (nil != self._snapshot.articles) {
            if (indexPath.row < self._snapshot.articles.count) {
                Article* article = (Article*)[self._snapshot.articles objectAtIndex:indexPath.row];
                return article;
            }
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellArticle *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    cell.title.text = @"";
    cell.text.text = @"";
    Article* article = [self getArticle:indexPath];
    if (nil != article) {
        if (nil != article.title) {
            cell.title.text = article.title;
        }
        if (nil != article.descr) {
            cell.text.text = article.descr;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row has been selected: %li", indexPath.row);
    Article* article = [self getArticle:indexPath];
    if (nil != article) {
        [self showDetailed:article];
    }
}

-(void)showDetailed:(Article*)article {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
    ViewControllerDetailed* vc = (ViewControllerDetailed*)[storyboard instantiateViewControllerWithIdentifier:kIDViewControllerDetailed];
    vc.curArticleKey = [article getKey].copy;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
