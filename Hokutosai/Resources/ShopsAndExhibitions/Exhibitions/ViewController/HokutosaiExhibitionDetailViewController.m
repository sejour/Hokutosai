//
//  HokutosaiExhibitionDetailViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/07.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Social/Social.h>
#import "HokutosaiExhibitionDetailViewController.h"
#import "HokutosaiUIUtility.h"
#import "HokutosaiStackPanelView.h"
#import "HokutosaiShopsAndExhibitionsHeadInfoView.h"
#import "HokutosaiApiGetRequest.h"
#import "HokutosaiApiRequestParameters.h"
#import "HokutosaiApiRequestDemander.h"

static NSString *cellIdentifier = @"cell";

static NSString *segueToMapsViewIdentifier = @"toMaps";

static const CGFloat headlineFontSize = 17.0;
static const CGFloat contentFontSize = 15.0;
static const CGFloat contentOffset = 15.0;

@interface HokutosaiExhibitionDetailViewController ()
{
    // 展示データ
    NSDictionary *exhibitionData;
    // イメージキャッシュ
    HokutosaiURLImagesDictionary *imageCache;
    // コンテントがロードされているかどうか
    BOOL contentsLoaded;
    
    // ヘッドインフォメーションビュー
    HokutosaiShopsAndExhibitionsHeadInfoView *headInfoView;
    // コンテンツビュー
    HokutosaiStackPanelView *contentsView;
}

- (void)updateHeadInfoView;
- (void)generateContentsView;
- (void)generateShareButton;
- (IBAction)tappedMap:(UIButton *)sender;
@end

@implementation HokutosaiExhibitionDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // セルを登録
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    // セルを選択不可
    self.tableView.allowsSelection = NO;
    
    // セルのセパレーター非表示
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 共有ボタン生成
    [self generateShareButton];
    
    // ヘッドインフォメーションビューの生成
    CGRect frameOfHeadInfoView = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0.0);
    headInfoView = [[HokutosaiShopsAndExhibitionsHeadInfoView alloc] initWithFrame:frameOfHeadInfoView title:JsonValue(exhibitionData[@"title"]) hostNameHeadline:@"出展者"];
    
    // コンテンツが既にロードされていれば
    if (contentsLoaded) {
        // ヘッドインフォメーションビュー更新
        [self updateHeadInfoView];
        // コンテンツビュー生成
        [self generateContentsView];
    }
    // コンテンツがロードされていなければリクエストを実行
    else {
        HokutosaiApiRequestParameters *requestParams = [[HokutosaiApiRequestParameters alloc] init];
        [requestParams setValueWithInteger:JsonIntValue(exhibitionData[@"exhibition_id"]) forKey:@"exhibition_id"];
        HokutosaiApiGetRequest *request = [HokutosaiApiGetRequest requestWithEndpointPath:@"exhibitions/show" queryParameters:requestParams];
        HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:request];
        
        [requestDemander responseAsync:^(id json) {
            // データ設定
            exhibitionData = json;
            // ヘッドインフォメーションビュー更新
            [self updateHeadInfoView];
            // コンテンツビュー生成
            [self generateContentsView];
            // コンテンツロード完了
            contentsLoaded = YES;
            // テーブルビューに挿入
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
    // タイトルストリーミング開始
    [headInfoView startTitleStreaming];
}

// ヘッドインフォメーションビューを更新する
- (void)updateHeadInfoView
{
    [headInfoView setTitle:JsonValue(exhibitionData[@"title"])];
    [headInfoView setHostName:JsonValue(exhibitionData[@"exhibitors"])];
    
    [imageCache imageWithURL:JsonValue(exhibitionData[@"image_resource"]) receive:^(UIImage* image) {
        [headInfoView setImage:image];
    }];
}

// コンテンツビューを生成する
- (void)generateContentsView
{
    CGRect frameOfContentsView = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0.0);
    contentsView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfContentsView];
    [contentsView setTopPadding:10.0 rightPadding:20.0 bottomPadding:20.0 leftPadding:20.0];
    
    // 場所見出し
    {
        CGRect frame = CGRectMake(0.0, 0.0, contentsView.widthOfStackPanel, 20.0);
        UILabel *placeHeadline = [[UILabel alloc] initWithFrame:frame];
        placeHeadline.textAlignment = NSTextAlignmentLeft;
        placeHeadline.font = [UIFont systemFontOfSize:headlineFontSize];
        placeHeadline.text = @"場所";
        [contentsView addSubview:placeHeadline];
    }
    
    // 場所
    {
        CGRect frame = CGRectMake(contentOffset, 0.0, contentsView.widthOfStackPanel - contentOffset, 15.0);
        UILabel *placeLabel = [[UILabel alloc] initWithFrame:frame];
        placeLabel.textAlignment = NSTextAlignmentLeft;
        placeLabel.numberOfLines = 0;
        placeLabel.font = [UIFont systemFontOfSize:contentFontSize];
        placeLabel.text = JsonValue(exhibitionData[@"place"][@"name"]);
        [placeLabel sizeToFit];
        [contentsView addSubview:placeLabel verticalSpace:3.0];
    }
    
    // 展示内容見出し
    {
        CGRect frame = CGRectMake(0.0, 0.0, contentsView.widthOfStackPanel, 20.0);
        UILabel *placeHeadline = [[UILabel alloc] initWithFrame:frame];
        placeHeadline.textAlignment = NSTextAlignmentLeft;
        placeHeadline.font = [UIFont systemFontOfSize:headlineFontSize];
        placeHeadline.text = @"展示内容";
        [contentsView addSubview:placeHeadline verticalSpace:15.0];
    }
    
    // 展示内容
    {
        CGRect frame = CGRectMake(contentOffset, 0.0, contentsView.widthOfStackPanel - contentOffset, 15.0);
        UILabel *displaysLabel = [[UILabel alloc] initWithFrame:frame];
        displaysLabel.textAlignment = NSTextAlignmentLeft;
        displaysLabel.numberOfLines = 0;
        displaysLabel.font = [UIFont systemFontOfSize:contentFontSize];
        displaysLabel.text = JsonValue(exhibitionData[@"displays"]);
        [displaysLabel sizeToFit];
        [contentsView addSubview:displaysLabel verticalSpace:3.0];
    }
    
    // 詳細見出し
    {
        CGRect frame = CGRectMake(0.0, 0.0, contentsView.widthOfStackPanel, 20.0);
        UILabel *placeHeadline = [[UILabel alloc] initWithFrame:frame];
        placeHeadline.textAlignment = NSTextAlignmentLeft;
        placeHeadline.font = [UIFont systemFontOfSize:headlineFontSize];
        placeHeadline.text = @"詳細";
        [contentsView addSubview:placeHeadline verticalSpace:15.0];
    }
    
    // 詳細
    {
        CGRect frame = CGRectMake(contentOffset, 0.0, contentsView.widthOfStackPanel - contentOffset, 15.0);
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:frame];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.numberOfLines = 0;
        detailLabel.font = [UIFont systemFontOfSize:contentFontSize];
        detailLabel.text = JsonValue(exhibitionData[@"detail"]);
        [detailLabel sizeToFit];
        [contentsView addSubview:detailLabel verticalSpace:3.0];
    }
}

// 共有ボタンを生成する
- (void)generateShareButton
{
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(shareWithTwitter:)];
    
    [self.navigationItem setRightBarButtonItems:@[shareButton, self.navigationItem.rightBarButtonItems.firstObject]];
}

// ツイートする
- (void)shareWithTwitter:(id)sender
{
    SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitterPostVC setInitialText:[NSString stringWithFormat:@"%@ #北斗祭 ", exhibitionData[@"title"]]];
    [self presentViewController:twitterPostVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [imageCache clearCashe];
}

- (void)setExhibitionData:(NSDictionary *)data imageCache:(HokutosaiURLImagesDictionary *)cache requireReload:(BOOL)reload
{
    exhibitionData = data;
    
    if (cache) {
        imageCache = cache;
    } else {
        imageCache = [[HokutosaiURLImagesDictionary alloc] init];
    }
    
    contentsLoaded = !reload;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (contentsLoaded) {
        return 2;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
    switch (indexPath.row) {
        case 0:
            height = headInfoView.frame.size.height;
            break;
        case 1:
            height = contentsView.frame.size.height;
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [HokutosaiUIUtility removeAllSubviews:cell.contentView];
    
    switch (indexPath.row) {
        case 0:
            [cell.contentView addSubview:headInfoView];
            break;
        case 1:
            [cell.contentView addSubview:contentsView];
            break;
    }
    
    return cell;
}

- (IBAction)tappedMap:(UIButton *)sender
{
    [self performSegueWithIdentifier:segueToMapsViewIdentifier sender:nil];
}

- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight
{
    if (self.tableView) {
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, screenHeight - self.tableView.frame.origin.y);
    }
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
