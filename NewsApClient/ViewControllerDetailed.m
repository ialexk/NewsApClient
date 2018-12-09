//
//  ViewControllerDetailed.m
//  NewsApClient
//
//  Created by ialexk on 07.12.2018.
//  Copyright © 2018 @ialexk. All rights reserved.
//

#import "ViewControllerDetailed.h"
#import <WebKit/WebKit.h>
#import "NewsDataSource.h"
#import "NewsData.h"
#import "Article.h"
#import "AppDelegate.h"

@interface ViewControllerDetailed () <WKNavigationDelegate> {
    id __block _tokenObserver1;
    id __block _tokenObserver2;
}
@property (nonatomic, strong) NewsDataSource* newsDataSource;
@property (nonatomic, strong) Article *_article;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation ViewControllerDetailed

- (void)viewDidLoad {
    [super viewDidLoad];
    assert(nil == self.newsDataSource);
    //self.newsDataSource = [[NewsDataSource alloc] init];
    self.newsDataSource = [NewsDataSource sharedInstance];
    __weak typeof(self) weakSelf = self;
    void (^onNotification)(NSNotification *) = ^(NSNotification *notification) {
        NSLog(@"Received Notification %@", [notification name]);
        if ([[notification name] isEqualToString:kNotificationNewData]) {
            Article* a = [weakSelf.newsDataSource.newsData findArticle:weakSelf.curArticleKey];
            if (nil != a) {
                weakSelf._article = a.copy;
                [weakSelf updateView];
                a = nil;
            }
            else {
                // let user to preview the article (which is already not found on the server)
            }
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
    self.webView.navigationDelegate = self;
    [self.newsDataSource subscribe];
}

-(void)dealloc {
    NSLog(@"ViewControllerDetailed - dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:_tokenObserver1];
    [[NSNotificationCenter defaultCenter] removeObserver:_tokenObserver2];
    [self.newsDataSource unsubscribe];
    self.newsDataSource = nil;
    self._article = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateView];
}

-(void)updateView {
    if (nil != self._article) {
        self.labelTitle.text = self._article.title;
        self.textView.text = [NSString stringWithString:self._article.content];
        
        if ((nil != self._article) && (nil != self._article.url)) {
            NSURL *url = [NSURL URLWithString:self._article.url];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSLog(@"Open article url: %@", self._article.url);
            // TODO: previous webview request should be cancelled
            [self.webView loadRequest:request];
        }
        else {
            NSLog(@"No article url");
        }
        NSLog(@"Article has been updated");
    }
    else {
        self.labelTitle.text = @"";
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    // TODO: show progress
    NSLog(@"Did commit navigation");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // TODO: hide progress
    NSLog(@"Did finish navigation");
}

- (IBAction)onButtonDonePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
