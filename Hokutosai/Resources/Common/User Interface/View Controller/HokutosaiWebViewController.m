//
//  HokutosaiWebViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/25.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiWebViewController.h"

@interface HokutosaiWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation HokutosaiWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // デリゲート登録
    _webView.delegate = self;
    
    // タイトル
    self.navigationItem.title = _pageTitle;
    
    // リクエスト
    NSURL *url = [NSURL URLWithString:_pageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // webページロード
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // スクロールインセット設定
    /*
    UIEdgeInsets currentContentInset = _webView.scrollView.contentInset;
    _webView.scrollView.contentInset = UIEdgeInsetsMake(0, currentContentInset.left, currentContentInset.bottom, currentContentInset.right);
    UIEdgeInsets currentIndicatorInset = _webView.scrollView.scrollIndicatorInsets;
    _webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, currentIndicatorInset.left, currentIndicatorInset.bottom, currentIndicatorInset.right);
     */
}

- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight
{
    NSLog(@"WebView changedStatusBarHeight");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
