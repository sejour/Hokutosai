//
//  HokutosaiContestsViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiContestsViewController.h"
#import "HokutosaiUIColor.h"
#import "HokutosaiUIUtility.h"
#import "HokutosaiContestsTableViewCell.h"
#import "HokutosaiContestsEntrysTableViewCell.h"
#import "HokutosaiApiGetRequest.h"
#import "HokutosaiApiRequestDemander.h"
#import "HokutosaiURLImagesDictionary.h"
#import "HokutosaiContestsEntrysListViewController.h"
#import "HokutosaiContestsEntryDetailViewController.h"

// セル識別子
static NSString* contestsTableViewCellIdentifier = @"contestsCell";
static NSString* resultsTableViewCellIdentifier = @"resultsCell";

// セグエ識別子
static NSString* segueToEntrysListIdentifier = @"toEntrysList";
static NSString* segueToEntryDetailIdentifier = @"toEntryDetail";

// テーブル識別子
static const NSInteger ContestsTableViewTag = 0;
static const NSInteger ResultsTableViewTag = 1;

@interface HokutosaiContestsViewController ()
{
    // コンテストのデータ
    NSArray *contestsDatas;
    // 結果のデータ
    NSArray *resultsDatas;
    
    // コンテストテーブルビュー
    UITableView *contestsTableView;
    // 結果テーブルビュー
    UITableView *resultsTableView;
    // 結果のリフレッシュコントロール
    UIRefreshControl *resultsTableRefreshControl;

    // スワイプビューの項目
    NSArray *swipeViewSections;
    
    // コンテストの優勝アイコン
    UIImage *championIcon;
    
    // イメージキャッシュ
    HokutosaiURLImagesDictionary *imagesCache;
}

// ナビゲーションバー
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *headerPageControl;

// スワイプビュー
@property (weak, nonatomic) IBOutlet HokutosaiSwipeView *swipeView;

// テーブルを生成する
- (void)createTables;
// コンテスト一覧テーブルのセルを更新する
- (UITableViewCell *)updateContestsTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
// 結果一覧テーブルのセルを更新する
- (UITableViewCell *)updateResultsTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

// リフレッシュコントロールからの更新
- (void)refreshResultsTable:(UIRefreshControl*)sender;

// コンテストデータを更新する
- (void)updateContestsDatas;
// 結果データを更新する
- (void)updateResultsDatas:(void (^)())complete;
@end

@implementation HokutosaiContestsViewController

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
    
    // イメージキャッシュ生成
    imagesCache = [[HokutosaiURLImagesDictionary alloc] init];
    
    // 優勝者用のアイコンロード
    championIcon = [UIImage imageNamed:@"crown_60.png"];
    
    // スワイプビューのセクションを設定
    swipeViewSections = @[@"コンテスト", @"優勝者一覧"];
    _headerLabel.text = swipeViewSections[0];
    
    // ヘッダービューの背景を透明にする
    _headerView.backgroundColor = [UIColor clearColor];
    
    // テーブル生成
    [self createTables];
    
    // ページコントロールの色を設定
    _headerPageControl.pageIndicatorTintColor = [HokutosaiUIColor hokutosaiColorWithAlpha:80];
    _headerPageControl.currentPageIndicatorTintColor = [HokutosaiUIColor hokutosaiColor];
    
    // スワイプビューにページコントロール設定
    [_swipeView setPageControl:_headerPageControl];
    
    // スワイプビューのデリゲート先を設定
    _swipeView.swipeViewDelegate = self;
    
    // コンテスト一覧データ取得
    [self updateContestsDatas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [imagesCache clearCashe];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (contestsDatas == nil || contestsDatas.count == 0) {
        [self updateContestsDatas];
    }
}

//　コンテストデータの更新
- (void)updateContestsDatas
{
    // リクエスト生成
    HokutosaiApiGetRequest *request = [HokutosaiApiGetRequest requestWithEndpointPath:@"contests/list"];
    HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:request];
    
    // リクエスト実行
    [requestDemander responseAsync:^(id json) {
        contestsDatas = json;
        [contestsTableView reloadData];
    }];
}

// 結果の更新
- (void)updateResultsDatas:(void (^)())complete
{
    // リクエスト生成
    HokutosaiApiGetRequest *request = [HokutosaiApiGetRequest requestWithEndpointPath:@"contests/champions"];
    HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:request];
    
    // リクエスト実行
    [requestDemander responseAsync:^(id json) {
        resultsDatas = json;
        [resultsTableView reloadData];
    } receiveError:^(NSInteger errorCode) {
        // 非公開のとき
        if ((errorCode/100) == 403) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"現在、結果が公開されていません。" message:@"コンテストの結果は特設ステージでの結果発表後に公開されます。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return YES;
        }
        
        return NO;
    } complete:^() {
        if (complete != nil) {
            complete();
        }
    }];
}

// リフレッシュコントロールによる更新を行う
- (void)refreshResultsTable:(UIRefreshControl *)sender
{
    // コンテンツの更新
    [self updateResultsDatas:^() {
        [resultsTableRefreshControl endRefreshing];
    }];
}

// テーブルを生成する
- (void)createTables
{
    // コンテスト一覧テーブル --------------------------
    
    // コンテスト一覧テーブル生成
    contestsTableView = [[UITableView alloc] initWithFrame:[_swipeView frameOfPage:0]];
    
    // セルの登録
    [contestsTableView registerClass:[HokutosaiContestsTableViewCell class] forCellReuseIdentifier:contestsTableViewCellIdentifier];
    
    // タグを設定
    contestsTableView.tag = ContestsTableViewTag;
    
    // デリゲート・データソースを設定
    contestsTableView.delegate = self;
    contestsTableView.dataSource = self;
    
    // テーブルの境界線を画面左端から描画する
    contestsTableView.separatorInset = UIEdgeInsetsZero;
    
    // インセット設定
    [HokutosaiUIUtility setInsetsOfTableViewForFullScreen:contestsTableView viewController:self];
    
    // ---------------------------------------
    
    // 結果一覧テーブル -------------------------
    
    // 結果一覧テーブル生成
    resultsTableView = [[UITableView alloc] initWithFrame:[_swipeView frameOfPage:1]];
    
    // セルの登録
    [resultsTableView registerClass:[HokutosaiContestsEntrysTableViewCell class] forCellReuseIdentifier:resultsTableViewCellIdentifier];
    
    // タグを設定
    resultsTableView.tag = ResultsTableViewTag;
    
    // セルの高さを設定
    resultsTableView.rowHeight = [HokutosaiContestsEntrysTableViewCell height];
    
    // デリゲート・データソースを設定
    resultsTableView.delegate = self;
    resultsTableView.dataSource = self;
    
    // テーブルの境界線を画面左端から描画する
    resultsTableView.separatorInset = UIEdgeInsetsZero;
    
    // インセット設定
    [HokutosaiUIUtility setInsetsOfTableViewForFullScreen:resultsTableView viewController:self];
    
    // リフレッシュコントロール生成
    resultsTableRefreshControl = [[UIRefreshControl alloc] init];
    [resultsTableRefreshControl addTarget:self action:@selector(refreshResultsTable:) forControlEvents:UIControlEventValueChanged];
    [resultsTableView addSubview:resultsTableRefreshControl];
    [resultsTableView sendSubviewToBack:resultsTableRefreshControl];
    
    // ---------------------------------------
    
    // ニュースタイムラインスワイプビューに設定
    [_swipeView setPages:@[contestsTableView, resultsTableView]];
}

// スワイプされている時
- (void)swipeViewDidSwipe:(HokutosaiSwipeView *)swipeView
{
    _headerLabel.text = swipeViewSections[swipeView.currentPage];
}

// スワイプが完了したとき
- (void)swipeViewDidEndDecelerating:(HokutosaiSwipeView *)swipeView
{
    switch (swipeView.currentPage) {
        case ContestsTableViewTag:
            if (contestsDatas == nil || contestsDatas.count == 0) {
                [self updateContestsDatas];
            }
            break;
        case ResultsTableViewTag:
            if (resultsDatas == nil || resultsDatas.count == 0) {
                [self updateResultsDatas:nil];
            }
            break;
    }
}

// UITableViewDelegate, UITableViewDataSource Implemantation ########################################

// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    
    // Return the number of rows in the section.
    switch (tableView.tag) {
        case ContestsTableViewTag:
            count = contestsDatas.count;
            break;
        case ResultsTableViewTag:
            count = resultsDatas.count;
            break;
    }
    
    return count;
}

// セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
    switch (tableView.tag) {
        case ContestsTableViewTag:
            height = [HokutosaiContestsTableViewCell heightWithDetail:contestsDatas[indexPath.row][@"detail"]];
            break;
        case ResultsTableViewTag:
            height = [HokutosaiContestsEntrysTableViewCell height];
            break;
    }
    
    return height;
}

// セルの生成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (tableView.tag) {
        case ContestsTableViewTag:
            cell = [self updateContestsTableView:tableView cellForRowAtIndexPath:indexPath];
            break;
        case ResultsTableViewTag:
            cell = [self updateResultsTableView:tableView cellForRowAtIndexPath:indexPath];
            break;
    }
    
    return cell;
}

// コンテスト一覧テーブルのセルを更新する
- (UITableViewCell *)updateContestsTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HokutosaiContestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contestsTableViewCellIdentifier forIndexPath:indexPath];
    
    // コンテストデータを取り出す
    NSDictionary *contest = contestsDatas[indexPath.row];
    
    // セルに設定
    [cell updateContestName:contest[@"section_name"] detail:contest[@"detail"]];
    
    return cell;
}

// 結果一覧テーブルのセルを更新する
- (UITableViewCell *)updateResultsTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HokutosaiContestsEntrysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resultsTableViewCellIdentifier forIndexPath:indexPath];
    
    // 優勝者情報を取り出す
    NSDictionary* entry = resultsDatas[indexPath.row];
    
    // イラスト
    NSString *imageResource = JsonValue(entry[@"image_resource"]);
    
    // 優勝者
    UIImage *champion = nil;
    if (JsonValueIsNotNull(entry[@"result"]) && [entry[@"result"] isEqualToString:@"champion"]) {
        champion = championIcon;
    }
    
    // セルに設定
    [cell updateSection:entry[@"section_name"] entryName:entry[@"entry_name"] belong:entry[@"belong"] championIcon:champion illustrationImageResource:imageResource];
    
    // イラスト設定
    [imagesCache imageWithURL:imageResource receive:^(UIImage *image) {
        [cell updateIllustrationImage:image url:imageResource];
        [cell layoutSubviews];
    }];
    
    return cell;
}

// セルがタップされたとき
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case ContestsTableViewTag:
            [self performSegueWithIdentifier:segueToEntrysListIdentifier sender:contestsDatas[indexPath.row]];
            break;
        case ResultsTableViewTag:
            [self performSegueWithIdentifier:segueToEntryDetailIdentifier sender:resultsDatas[indexPath.row]];
            break;
    }
    
    // セルの選択を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// ####################################################################################################

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // エントリー一覧
    if ([segue.identifier isEqualToString:segueToEntrysListIdentifier]) {
        HokutosaiContestsEntrysListViewController* viewController = segue.destinationViewController;
        [viewController setSectionId:sender[@"section_id"] sectionName:sender[@"section_name"]];
    }
    // エントリー詳細
    else if ([segue.identifier isEqualToString:segueToEntryDetailIdentifier]) {
        HokutosaiContestsEntryDetailViewController* viewController = segue.destinationViewController;
        [viewController setEntryData:sender imageCache:imagesCache title:@"優勝おめでとう"];
    }
}

// ステータスバーの高さが変わったとき
- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight
{
    // スワイプビューのフレームを更新
    if (_swipeView) {
        _swipeView.frame = CGRectMake(_swipeView.frame.origin.x, _swipeView.frame.origin.y, _swipeView.frame.size.width, screenHeight);
    }
    
    // コンテストテーブルビューのフレームを更新
    if (contestsTableView) {
        contestsTableView.frame = [_swipeView frameOfPage:0];
    }
    
    // 結果テーブルビューのフレームを更新
    if (resultsTableView) {
        resultsTableView.frame = [_swipeView frameOfPage:1];
    }
}

@end
