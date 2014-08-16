//
//  HokutosaiNewsViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiNewsViewController.h"
#import "HokutosaiSwipeView.h"
#import "HokutosaiSwipeBord.h"
#import "HokutosaiNewsTopicsBordContent.h"
#import "HokutosaiApiGetRequest.h"
#import "HokutosaiApiRequestDemander.h"
#import "HokutosaiURLImageDownloader.h"
#import "HokutosaiTimer.h"
#import "HokutosaiNewsTImelineCell.h"
#import "HokutosaiUIUtility.h"
#import "HokutosaiWebViewController.h"
#import "HokutosaiLoadingView.h"
#import "HokutosaiUIColor.h"
#import "HokutosaiDateConvert.h"
#import "HokutosaiURLImagesCache.h"
#import "HokutosaiNewsDetailViewController.h"
#import "HokutosaiEventsDetailViewController.h"
#import "HokutosaiOthersViewController.h"

// セル識別子
static NSString *newsTimelineCellIdentifier = @"newsCell";

// セグエ識別子
static NSString *segueToNewsDetailIdentifier = @"toNewsDetail";
static NSString *segueToEventsDetailIdentifier = @"toEventDetail";
static NSString *segueToWebViewIdentifier = @"toWebView";

// テーブルビュー識別子
static const NSInteger AllNewsTimelineTag = 0;
static const NSInteger CenterNewsTimelineTag = 1;
static const NSInteger ProjectsNewsTimelineTag = 2;
static const NSInteger ShopsNewsTimelineTag = 3;

// スワイプビュー識別子
static const NSInteger TopicsBordTag = 0;
static const NSInteger NewsTimelineSwipeViewTag = 1;

@interface HokutosaiNewsViewController ()
{
    // トピックスデータ
    NSArray *topicsDatas;
    
    // ニュースデータ
    NSMutableArray *newsDatasAll;
    // 本部からのニュース
    NSMutableArray *newsDatasFromCenter;
    // 企画からのニュース
    NSMutableArray *newsDatasFromProjects;
    // 模擬店からのニュース
    NSMutableArray *newsDatasFromShops;
    
    // イメージキャッシュ
    HokutosaiURLImagesCache *imagesCashe;
    
    // ニュースタイムラインの項目
    NSArray *newsTimelineSections;
    // ニュースタイムラインテーブルビューの配列
    NSMutableArray *newsTimelineTableViews;
    // リフレッシュコントロール
    NSMutableArray *refreshControls;
    
    // トピックスボードのスワイプタイマー
    HokutosaiTimer *topicsBordSwipeTimer;
    // 新たに追加されたニュースの数
    NSMutableArray *newsAdditionalCounts;
}

// トピックボード
@property (weak, nonatomic) IBOutlet HokutosaiSwipeBord *topicsBord;

// ニュースタイムラインのヘッダ
@property (weak, nonatomic) IBOutlet UIView *newsTimelineHeader;

// ニュースタイムラインスワイプビュー
@property (weak, nonatomic) IBOutlet HokutosaiSwipeView *newsTimelineSwipeView;

// ニュースタイムラインスワイプビューのセクションを表示するラベル
@property (weak, nonatomic) IBOutlet UILabel *newsTimelineSwipeViewSectionLabel;

// ニュースタイムラインスワイプビューのページコントロール
@property (weak, nonatomic) IBOutlet UIPageControl *newsTimelineSwipeViewPageControl;

// トピックスボードがタップされた時
- (IBAction)tappedTopicsBord:(id)sender;

// コンテンツの初期化を行う
- (void)initContents;

// リフレッシュコントロールによる更新を行う
- (void)refresh:(UIRefreshControl*)sender;

// 自動スワイプを行う
- (void)autoSwipeTopicsBord;

// ニュースタイムラインテーブルの生成
- (void)createNewsTimelineTables;

// ニュースデータを設定する
- (void)updateNewsDatas:(NSArray*)newsJsonArray;

// ニュースタイムラインテーブルビューをリロードする
- (void)reloadNewsTimelineTableView:(NSInteger)objectTimelineTag;

// トピックスボードのコンテントを生成する
- (HokutosaiNewsTopicsBordContent*)generateTopicsBordContent:(NSInteger)index frame:(CGRect)frame;

@end

@implementation HokutosaiNewsViewController

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
    
    // ニュースタイムラインのセクションを設定
    newsTimelineSections = @[@"全てのニュース", @"本部", @"企画", @"模擬店"];
    _newsTimelineSwipeViewSectionLabel.text = newsTimelineSections[0];
    
    // タグを設定
    _topicsBord.tag = TopicsBordTag;
    _newsTimelineSwipeView.tag = NewsTimelineSwipeViewTag;
    
    // スワイプビューのデリゲート委譲先を設定
    _topicsBord.swipeViewDelegate = self;
    _newsTimelineSwipeView.swipeViewDelegate = self;
    
    // イメージキャッシュ生成
    imagesCashe = [[HokutosaiURLImagesCache alloc] initWithCountLimit:64];
    
    // ニュースタイムラインテーブル生成
    [self createNewsTimelineTables];
    
    // ニュースタイムラインスワイプビューにページコントロールを設定
    [_newsTimelineSwipeView setPageControl:_newsTimelineSwipeViewPageControl];
    
    // トピックスボードのタイマーを生成
    topicsBordSwipeTimer = [[HokutosaiTimer alloc] initWithTimeInterval:5 target:self selector:@selector(autoSwipeTopicsBord)];
    
    // コンテンツ初期化
    [self initContents];
}

// ビューコンテントの初期化を行う
- (void)initContents
{
    HokutosaiLoadingView *loadingView = [[HokutosaiLoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loadingView];
    
    [loadingView startLoading];
    
    // コンテンツの更新
    [self updateContentsWithComplete:^() {
        [loadingView stopLoading:YES];
    }];
}

// ビューが表示される直前
- (void)viewDidAppear:(BOOL)animated
{
    // トピックスボードのスワイプタイマーを開始
    if (!topicsBordSwipeTimer.isActive) {
        [topicsBordSwipeTimer start];
    }
    
    [super viewDidAppear:animated];
}

// リフレッシュコントロールによる更新を行う
- (void)refresh:(UIRefreshControl *)sender
{
    // コンテンツの更新
    [self updateContentsWithComplete:^() {
        [refreshControls[sender.tag] endRefreshing];
    }];
}

// コンテンツの更新を行う
- (void)updateContents
{
    [self updateContentsWithComplete:nil];
}

// ビューコンテントの更新を行う
- (void)updateContentsWithComplete:(void (^)())complete
{
    // トピックスリクエスト
    HokutosaiApiGetRequest *topicsRequest = [HokutosaiApiGetRequest requestWithEndpointPath:@"news/topics"];
    HokutosaiApiRequestDemander *topicsRequestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:topicsRequest];
    
    // ニュースタイムラインリクエスト
    HokutosaiApiRequestParameters *newsTimelineParameters = [[HokutosaiApiRequestParameters alloc] init];
    if (newsDatasAll != nil || newsDatasAll.count > 0) {
        NSInteger sinceId = [newsDatasAll.firstObject[@"news_id"] integerValue] + 1;
        [newsTimelineParameters setValueWithInteger:sinceId forKey:@"since_id"];
    }
    HokutosaiApiGetRequest *newsTimelineRequest = [HokutosaiApiGetRequest requestWithEndpointPath:@"news/timeline" queryParameters:newsTimelineParameters];
    HokutosaiApiRequestDemander *newsTimelineRequestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:newsTimelineRequest];
    
    // トピックスボードのスワイプタイマー停止
    [topicsBordSwipeTimer stop];
    
    // トピックスリクエスト実行
    [topicsRequestDemander responseAsync:^(id topicsJson) {
        // データ更新
        topicsDatas = topicsJson;
         
        // トピックスボード更新
        [_topicsBord setPages:topicsDatas.count generator:^(NSInteger index, CGRect contentFrame)
        {
              return [self generateTopicsBordContent:index frame:contentFrame];
        }];
    } complete:^() {
        // ニュースタイムラインリクエスト実行
        [newsTimelineRequestDemander responseAsync:^(id newsJson) {
            // データ更新
            [self updateNewsDatas:newsJson];
            // テーブルビュー更新
            [self reloadNewsTimelineTableView:_newsTimelineSwipeView.currentPage];
        } complete:^() {
            if (complete != nil) {
                complete();
            }
        }];
        // トピックスボードのスワイプタイマーを開始
        [topicsBordSwipeTimer start];
    }];
}

// トピックスを更新する
- (void)updateTopics
{
    // トピックスリクエスト
    HokutosaiApiGetRequest *topicsRequest = [HokutosaiApiGetRequest requestWithEndpointPath:@"news/topics"];
    HokutosaiApiRequestDemander *topicsRequestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:topicsRequest];

    // トピックスボードのスワイプタイマー停止
    [topicsBordSwipeTimer stop];
    
    // トピックスリクエスト実行
    [topicsRequestDemander responseAsync:^(id topicsJson) {
        // データ更新
        topicsDatas = topicsJson;
        
        // トピックスボード更新
        [_topicsBord setPages:topicsDatas.count generator:^(NSInteger index, CGRect contentFrame)
         {
             return [self generateTopicsBordContent:index frame:contentFrame];
         }];
    } complete:^() {
        // トピックスボードのスワイプタイマーを開始
        [topicsBordSwipeTimer start];
    }];
}

// ニュースタイムラインを更新する
- (void)updateNewsTimeline
{
    // ニュースタイムラインリクエスト
    HokutosaiApiRequestParameters *newsTimelineParameters = [[HokutosaiApiRequestParameters alloc] init];
    if (newsDatasAll != nil || newsDatasAll.count > 0) {
        NSInteger sinceId = [newsDatasAll.firstObject[@"news_id"] integerValue] + 1;
        [newsTimelineParameters setValueWithInteger:sinceId forKey:@"since_id"];
    }
    HokutosaiApiGetRequest *newsTimelineRequest = [HokutosaiApiGetRequest requestWithEndpointPath:@"news/timeline" queryParameters:newsTimelineParameters];
    HokutosaiApiRequestDemander *newsTimelineRequestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:newsTimelineRequest];
    
    // ニュースタイムラインリクエスト実行
    [newsTimelineRequestDemander responseAsync:^(id newsJson) {
        // データ更新
        [self updateNewsDatas:newsJson];
        // テーブルビュー更新
        [self reloadNewsTimelineTableView:_newsTimelineSwipeView.currentPage];
    }];
}

// トピックスボードを生成する
- (HokutosaiNewsTopicsBordContent*)generateTopicsBordContent:(NSInteger)index frame:(CGRect)frame
{
    HokutosaiNewsTopicsBordContent *content = [[HokutosaiNewsTopicsBordContent alloc] initWithFrame:frame];
    NSMutableDictionary *topic = topicsDatas[index];
    
    // イラスト
    if (topic[@"image_resource"] != [NSNull null]) {
        // 北斗祭の紹介
        if ([topic[@"image_resource"] isEqualToString:@"_HOKUTOSAI_INTRODUCTION_"]) {
            content.image = [UIImage imageNamed:@"TRY.png"];
            return content;
        }
        // それ以外
        else {
            [imagesCashe imageWithURL:topic[@"image_resource"] receive:^(UIImage* image) {
                content.image = image;
            }];
        }
    }
    
    // テキストは「イラストが用意されているイベント」以外のコンテンツで表示する
    if (topic[@"event_id"] == [NSNull null] || topic[@"image_resource"] == [NSNull null]) {
        if (topic[@"title"] != [NSNull null]) {
            [content setTitle:topic[@"title"]];
        }
    }
    
    return content;
}

// 自動スワイプを行う
- (void)autoSwipeTopicsBord
{
    [_topicsBord swipeToRight:YES];
}

// ニュースタイムラインテーブルの生成
- (void)createNewsTimelineTables
{
    newsTimelineTableViews = [NSMutableArray arrayWithCapacity:4];
    refreshControls = [NSMutableArray arrayWithCapacity:4];
    
    // ニュースタイムラインスワイプビューのコンテンツを設定
    [_newsTimelineSwipeView setPages:4 generator:^(NSInteger index, CGRect frame) {
        // テーブルビュー生成
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
        
        // セルを登録
        [tableView registerClass:[HokutosaiNewsTimelineCell class] forCellReuseIdentifier:newsTimelineCellIdentifier];
        
        // タグを設定
        tableView.tag = index;
        
        // セルの高さを設定
        tableView.rowHeight = [HokutosaiNewsTimelineCell height];
        
        // デリゲート・データソースを設定
        tableView.delegate = self;
        tableView.dataSource = self;
        
        // テーブルの境界線を画面左端から描画する
        tableView.separatorInset = UIEdgeInsetsZero;
        
        // インセット設定
        [HokutosaiUIUtility setInsetsOfTableViewForBottomArrange:tableView viewController:self];
        
        // リフレッシュコントロール生成
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        refreshControl.tag = index;
        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        [refreshControls addObject:refreshControl];
        
        // リフレッシュコントロール設定
        [tableView addSubview:refreshControl];
        [tableView sendSubviewToBack:refreshControl];
        
        // 追加
        [newsTimelineTableViews addObject:tableView];

        return tableView;
    }];
}

// スワイプビューがスワイプされている時
- (void)swipeViewDidSwipe:(HokutosaiSwipeView *)swipeView
{
    // ニュースタイムラインスワイプビューであれば項目名を更新
    if (swipeView.tag == NewsTimelineSwipeViewTag) {
        _newsTimelineSwipeViewSectionLabel.text = newsTimelineSections[swipeView.currentPage];
    }
}

// スワイプビューのスワイプが完了した時
- (void)swipeViewDidEndDecelerating:(HokutosaiSwipeView *)swipeView
{
    switch (swipeView.tag) {
        // トピックスボードであればタイマーを再起動
        case TopicsBordTag:
            [topicsBordSwipeTimer restart];
            break;
        // ニュースタイムラインスワイプビューであればテーブルビューをリロード
        case NewsTimelineSwipeViewTag:
            [self reloadNewsTimelineTableView:swipeView.currentPage];
            break;
    }
}

// ニュースデータを設定する
- (void)updateNewsDatas:(NSArray *)newsJsonArray
{
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(0, newsJsonArray.count)];
    
    // 全てのニュースを設定
    if (newsDatasAll) {
        [newsDatasAll insertObjects:newsJsonArray atIndexes:indexes];
    } else {
        newsDatasAll = [NSMutableArray arrayWithArray:newsJsonArray];
    }
    
    if (newsDatasFromCenter == nil) {
        newsDatasFromCenter = [NSMutableArray arrayWithCapacity:8];
    }
    if (newsDatasFromProjects == nil) {
        newsDatasFromProjects = [NSMutableArray arrayWithCapacity:8];
    }
    if (newsDatasFromShops == nil) {
        newsDatasFromShops = [NSMutableArray arrayWithCapacity:8];
    }
    
    NSDictionary *news;
    NSInteger centerNewsAddCount = 0;
    NSInteger projectsNewsAddCount = 0;
    NSInteger shopsNewsAddCount = 0;
    
    // 項目別に分ける
    for (int i = (int)newsJsonArray.count - 1; i >= 0 ; --i) {
        news = newsJsonArray[i];
        if ([JsonValue(news[@"sender_department"]) isEqualToString:@"本部"]) {
            [newsDatasFromCenter insertObject:news atIndex:0];
            ++centerNewsAddCount;
        } else if ([JsonValue(news[@"sender_department"]) isEqualToString:@"企画"]) {
            [newsDatasFromProjects insertObject:news atIndex:0];
            ++projectsNewsAddCount;
        } else if ([JsonValue(news[@"sender_department"]) isEqualToString:@"模擬店"]) {
            [newsDatasFromShops insertObject:news atIndex:0];
            ++shopsNewsAddCount;
        }
    }
    
    // 追加カウントを更新
    if (newsAdditionalCounts) {
        newsAdditionalCounts[0] = @(newsJsonArray.count);
        newsAdditionalCounts[1] = @(centerNewsAddCount);
        newsAdditionalCounts[2] = @(projectsNewsAddCount);
        newsAdditionalCounts[3] = @(shopsNewsAddCount);
    } else {
        newsAdditionalCounts = [NSMutableArray arrayWithArray:@[@0, @0, @0, @0]];
    }
}

// ニュースタイムラインテーブルビューをリロードする
- (void)reloadNewsTimelineTableView:(NSInteger)objectTimelineTag
{
    // 表示中のテーブルビューを取得
    UITableView *currentTable = newsTimelineTableViews[objectTimelineTag];
    
    // 現在のスクロールオフセットを取得
    CGPoint currentOffset = currentTable.contentOffset;

    // テーブルビューリロード
    [currentTable reloadData];

    // 追加されたコンテントの数を取得
    NSInteger addCount = [newsAdditionalCounts[objectTimelineTag] integerValue];
    
    // 追加されたコンテントが存在すればオフセットを更新する前の位置に戻す
    if (addCount > 0) {
        UIRefreshControl *refresh = refreshControls[objectTimelineTag];
        CGFloat deltaY = ([HokutosaiNewsTimelineCell height] * (addCount + refresh.refreshing)) - (([HokutosaiNewsTimelineCell height] / 2) * refresh.refreshing);
        currentTable.contentOffset = CGPointMake(currentOffset.x, currentOffset.y + deltaY);
        newsAdditionalCounts[_newsTimelineSwipeView.currentPage] = @0;
    }
    
    // スクロールフラッシュ
    [currentTable flashScrollIndicators];
}

// ニュースタイムライン ###############################################################

// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (tableView.tag) {
        case AllNewsTimelineTag:
            return newsDatasAll.count;
        case CenterNewsTimelineTag:
            return newsDatasFromCenter.count;
        case ProjectsNewsTimelineTag:
            return newsDatasFromProjects.count;
        case ShopsNewsTimelineTag:
            return newsDatasFromShops.count;
    }
    
    return 0;
}

// セルの生成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HokutosaiNewsTimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:newsTimelineCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *news;
    
    // 項目を判別してデータを取得
    switch (tableView.tag) {
        case AllNewsTimelineTag:
            news = newsDatasAll[indexPath.row];
            break;
        case CenterNewsTimelineTag:
            news = newsDatasFromCenter[indexPath.row];
            break;
        case ProjectsNewsTimelineTag:
            news = newsDatasFromProjects[indexPath.row];
            break;
        case ShopsNewsTimelineTag:
            news = newsDatasFromShops[indexPath.row];
            break;
    }
    
    // 送信元
    NSString *sender = JsonValue(news[@"sender_department"]);
    
    if (news[@"related_event"] != [NSNull null]) {
        sender = [NSString stringWithFormat:@"%@  %@", sender, JsonValue(news[@"related_event"][@"title"])];
    }
    else if (news[@"related_shop"] != [NSNull null]) {
        sender = [NSString stringWithFormat:@"%@  %@", sender, JsonValue(news[@"related_shop"][@"name"])];
    }
    else if (news[@"related_exhibition"] != [NSNull null]) {
        sender = [NSString stringWithFormat:@"%@  %@", sender, JsonValue(news[@"related_exhibition"][@"title"])];
    }
    
    // 添付画像
    NSString *imageResource = JsonValue(news[@"image_resource"]);
    
    // セルに属性値を設定
    [cell updateTitle:JsonValue(news[@"title"]) from:sender at:[HokutosaiDateConvert dateFromHokutosaiApiDatetime:JsonValue(news[@"send_datetime"])] important:JsonBoolValue(news[@"is_important"]) attachedImageResource:imageResource];
    
    // 添付画像が存在すればダウンロード
    [imagesCashe imageWithURL:imageResource receive:^(UIImage* image) {
        [cell updateAttachedImage:image url:imageResource];
        [cell layoutSubviews];
    }];
    
    return cell;
}

// セルがタップされたとき
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *news;
    
    switch (tableView.tag) {
        case AllNewsTimelineTag:
            news = newsDatasAll[indexPath.row];
            break;
        case CenterNewsTimelineTag:
            news = newsDatasFromCenter[indexPath.row];
            break;
        case ProjectsNewsTimelineTag:
            news = newsDatasFromProjects[indexPath.row];
            break;
        case ShopsNewsTimelineTag:
            news = newsDatasFromShops[indexPath.row];
            break;
    }
    
    [self performSegueWithIdentifier:segueToNewsDetailIdentifier sender:@{@"newsData": news, @"requireReload": @NO}];
    
    // セルの選択を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 詳細ビューへ遷移する際
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // トピックスボードのスワイプタイマーを停止
    [topicsBordSwipeTimer stop];
    
    // ニュース詳細
    if ([segue.identifier isEqualToString:segueToNewsDetailIdentifier]) {
        HokutosaiNewsDetailViewController *destination = segue.destinationViewController;
        [destination setNewsData:sender[@"newsData"] imageCache:imagesCashe rquireReload:[sender[@"requireReload"] boolValue]];
    }
    // イベント詳細ビュー
    else if ([segue.identifier isEqualToString:segueToEventsDetailIdentifier]) {
        HokutosaiEventsDetailViewController *destination = segue.destinationViewController;
        [destination setEventData:sender requireReload:YES];
    }
    // Webビュー
    else if ([segue.identifier isEqualToString:segueToWebViewIdentifier]) {
        NSDictionary *topic = sender;
        HokutosaiWebViewController *destination = segue.destinationViewController;
        destination.pageTitle = JsonValue(topic[@"title"]);
        destination.pageURL = JsonValue(sender[@"link"]);
    }
}

// ################################################################################

// トピックスボードがタップされた際
- (IBAction)tappedTopicsBord:(id)sender
{
    // トピックスボードのスワイプタイマーを停止
    [topicsBordSwipeTimer stop];
    
    NSDictionary *topic = topicsDatas[_topicsBord.currentPage];
    
    // リンク
    if (topic[@"link"] != [NSNull null]) {
        [self performSegueWithIdentifier:segueToWebViewIdentifier sender:topic];
    }
    // 現在開催中のイベント
    else if (topic[@"event_id"] != [NSNull null]) {
        [self performSegueWithIdentifier:segueToEventsDetailIdentifier sender:topic];
    }
    // トピック
    else if (topic[@"news_id"] != [NSNull null]) {
        [self performSegueWithIdentifier:segueToNewsDetailIdentifier sender:@{@"newsData": topic, @"requireReload": @YES}];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [imagesCashe clearCashe];
}

- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight
{
    // ニュースタイムラインスワイプビューのフレームを調整
    if (_newsTimelineSwipeView) {
        CGRect frameOfNewsTimelineSwipeView = _newsTimelineSwipeView.frame;
        frameOfNewsTimelineSwipeView.size = CGSizeMake(frameOfNewsTimelineSwipeView.size.width, screenHeight - (_newsTimelineHeader.frame.origin.y + _newsTimelineHeader.frame.size.height));
        _newsTimelineSwipeView.frame = frameOfNewsTimelineSwipeView;
    }
    
    // テーブルビューのフレームを調整
    if (newsTimelineTableViews) {
        for (NSInteger i = 0; i < newsTimelineTableViews.count; ++i) {
            [newsTimelineTableViews[i] setFrame:[_newsTimelineSwipeView frameOfPage:i]];
        }
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
