//
//  HokutosaiShopsAndExhibitionsViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiShopsAndExhibitionsViewController.h"
#import "HokutosaiSwipeView.h"
#import "HokutosaiShopsTableViewCell.h"
#import "HokutosaiShopDetailViewController.h"
#import "HokutosaiExhibitionsTableViewCell.h"
#import "HokutosaiExhibitionDetailViewController.h"
#import "HokutosaiApiGetRequest.h"
#import "HokutosaiApiRequestDemander.h"
#import "HokutosaiUIColor.h"
#import "HokutosaiUIUtility.h"
#import "HokutosaiURLImageDownloader.h"
#import "HokutosaiURLImagesDictionary.h"

// セル識別子
static NSString* shopsTableViewCellIdentifier = @"shopsCell";
static NSString* exhibitionsTableViewCellIdentifier = @"exhibitionsCell";

// セグエ識別子
static NSString* segueToShopDetailIdentifier = @"toShopDetail";
static NSString* segueToExhibitionDetailIdentifier = @"toExhibitionDetail";
static NSString* segueToMapViewIdentifier = @"toMaps";

// テーブル識別子
static const NSInteger ShopsTableViewTag = 0;
static const NSInteger ExhibitionsTableViewTag = 1;

@interface HokutosaiShopsAndExhibitionsViewController ()
{
    // 模擬店のデータ
    NSArray *shopsDatas;
    // 展示のデータ
    NSArray *exhibitionsDatas;
    
    // イメージキャッシュ
    HokutosaiURLImagesDictionary *imagesCache;
    
    // 模擬店テーブルビュー
    UITableView *shopsTableView;
    // 展示テーブルビュー
    UITableView *exhibitionsTableView;
    // スワイプビューのセクション
    NSArray *swipeViewSections;
}

// ヘッダ
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerSectionLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *headerPageControl;

// スワイプビュー
@property (weak, nonatomic) IBOutlet HokutosaiSwipeView *swipeView;
// Mapボタンがタップされた際
- (IBAction)tappedMap:(UIButton *)sender;

// テーブルを生成する
- (void)createTables;

// 模擬店テーブルビューセルの更新
- (UITableViewCell *)updateShopsTableViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

// 展示テーブルビューセルの更新
- (UITableViewCell *)updateExhibitionsTableViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

// 模擬店データの更新
- (void)updateShopsDatas;

// 展示データの更新
- (void)updateExhibitionsDatas;

@end

@implementation HokutosaiShopsAndExhibitionsViewController

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
    
    // スワイプビューのセクションを設定
    swipeViewSections = @[@"模擬店", @"展示"];
    _headerSectionLabel.text = swipeViewSections[0];
    
    // ヘッダービューの背景を透明にする
    _headerView.backgroundColor = [UIColor clearColor];
    
    // イメージキャッシュ生成
    imagesCache = [[HokutosaiURLImagesDictionary alloc] init];
    
    // テーブル生成
    [self createTables];
    
    // ページコントロールの色を設定
    _headerPageControl.pageIndicatorTintColor = [HokutosaiUIColor hokutosaiColorWithAlpha:80];
    _headerPageControl.currentPageIndicatorTintColor = [HokutosaiUIColor hokutosaiColor];
    
    // スワイプビューにページコントロール設定
    [_swipeView setPageControl:_headerPageControl];
    
    // スワイプビューのデリゲート先を設定
    _swipeView.swipeViewDelegate = self;
    
    // 模擬店データ取得
    [self updateShopsDatas];
}

- (void)viewDidAppear:(BOOL)animated
{
    switch (_swipeView.currentPage) {
        case ShopsTableViewTag:
            if (shopsDatas == nil || shopsDatas.count == 0) {
                [self updateShopsDatas];
            }
            break;
        case ExhibitionsTableViewTag:
            if (exhibitionsDatas == nil || exhibitionsDatas.count == 0) {
                [self updateExhibitionsDatas];
            }
            break;
    }
}

- (void)createTables
{
    // 模擬店一覧テーブル --------------------------
    
    // 模擬店一覧テーブル生成
    shopsTableView = [[UITableView alloc] initWithFrame:[_swipeView frameOfPage:0]];
    
    // xibからセルを読み込む
    [shopsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HokutosaiShopsTableViewCell class]) bundle:nil] forCellReuseIdentifier:shopsTableViewCellIdentifier];
    
    // タグを設定
    shopsTableView.tag = ShopsTableViewTag;

    // セルの高さを設定
    shopsTableView.rowHeight = [HokutosaiShopsTableViewCell height];
    
    // デリゲート・データソースを設定
    shopsTableView.delegate = self;
    shopsTableView.dataSource = self;
    
    // テーブルの境界線を画面左端から描画する
    shopsTableView.separatorInset = UIEdgeInsetsZero;
        
    // インセット設定
    [HokutosaiUIUtility setInsetsOfTableViewForFullScreen:shopsTableView viewController:self];
    
    // ---------------------------------------
    
    // 展示一覧テーブル -------------------------
    
    // 模擬店一覧テーブル生成
    exhibitionsTableView =[[UITableView alloc] initWithFrame:[_swipeView frameOfPage:1]];
    
    // xibからセルを読み込む
    [exhibitionsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HokutosaiExhibitionsTableViewCell class]) bundle:nil] forCellReuseIdentifier:exhibitionsTableViewCellIdentifier];
    
    // タグを設定
    exhibitionsTableView.tag = ExhibitionsTableViewTag;
    
    // セルの高さを設定
    exhibitionsTableView.rowHeight = [HokutosaiExhibitionsTableViewCell height];
    
    // デリゲート・データソースを設定
    exhibitionsTableView.delegate = self;
    exhibitionsTableView.dataSource = self;
    
    // テーブルの境界線を画面左端から描画する
    exhibitionsTableView.separatorInset = UIEdgeInsetsZero;

    // インセット設定
    [HokutosaiUIUtility setInsetsOfTableViewForFullScreen:exhibitionsTableView viewController:self];
    
    // ---------------------------------------
    
    // ニュースタイムラインスワイプビューに設定
    [_swipeView setPages:@[shopsTableView, exhibitionsTableView]];
}

// 模擬店データの更新
- (void)updateShopsDatas
{
    HokutosaiApiGetRequest *shopsListRequest = [HokutosaiApiGetRequest requestWithEndpointPath:@"shops/list"];
    HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:shopsListRequest];
    
    [requestDemander responseAsync:^(id jsonContent) {
        shopsDatas = jsonContent;
        [shopsTableView reloadData];
    }];
}

// 展示データの更新
- (void)updateExhibitionsDatas
{
    HokutosaiApiGetRequest *exhibitionsListRequest = [HokutosaiApiGetRequest requestWithEndpointPath:@"exhibitions/list"];
    HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:exhibitionsListRequest];
    
    [requestDemander responseAsync:^(id jsonContent) {
        exhibitionsDatas = jsonContent;
        [exhibitionsTableView reloadData];
    }];
}

// スワイプビューがスワイプされている時
- (void)swipeViewDidSwipe:(HokutosaiSwipeView *)swipeView
{
    _headerSectionLabel.text = swipeViewSections[swipeView.currentPage];
}

// スワイプビューのスワイプが完了した時
- (void)swipeViewDidEndDecelerating:(HokutosaiSwipeView *)swipeView
{
    switch (swipeView.currentPage) {
        case ShopsTableViewTag:
            if (shopsDatas == nil || shopsDatas.count == 0) {
                [self updateShopsDatas];
            }
            break;
        case ExhibitionsTableViewTag:
            if (exhibitionsDatas == nil || exhibitionsDatas.count == 0) {
                [self updateExhibitionsDatas];
            }
            break;
    }
}

// UITableViewDelegate, UITableViewDataSource implementation ####################

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
        case ShopsTableViewTag:
            return shopsDatas.count;
        case ExhibitionsTableViewTag:
            return exhibitionsDatas.count;
    }
    
    return 0;
}

// セルの生成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (tableView.tag) {
        case ShopsTableViewTag:
            cell = [self updateShopsTableViewCell:tableView cellForRowAtIndexPath:indexPath];
            break;
        case ExhibitionsTableViewTag:
            cell = [self updateExhibitionsTableViewCell:tableView cellForRowAtIndexPath:indexPath];
            break;
    }
    
    return cell;
}

// セルがタップされたとき
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case ShopsTableViewTag:
            [self performSegueWithIdentifier:segueToShopDetailIdentifier sender:tableView];
            break;
        case ExhibitionsTableViewTag:
            [self performSegueWithIdentifier:segueToExhibitionDetailIdentifier sender:tableView];
            break;
    }
    
    // セルの選択を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 詳細ビューへ遷移する際
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableView *tableView = sender;
    
    // 模擬店
    if ([segue.identifier isEqualToString:segueToShopDetailIdentifier]) {
        // 遷移先のビューコントローラーにデータを渡す
        HokutosaiShopDetailViewController* viewController = segue.destinationViewController;
        [viewController setShopData:shopsDatas[tableView.indexPathForSelectedRow.row] imagesCache:imagesCache];
    }
    // 展示
    else if ([segue.identifier isEqualToString:segueToExhibitionDetailIdentifier]) {
        // 遷移先のビューコントローラーにデータを渡す
        HokutosaiExhibitionDetailViewController* viewController = segue.destinationViewController;
        [viewController setExhibitionData:exhibitionsDatas[tableView.indexPathForSelectedRow.row] imageCache:imagesCache requireReload:NO];
    }
}

// 模擬店テーブルビューのセルを更新する
- (UITableViewCell*)updateShopsTableViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HokutosaiShopsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopsTableViewCellIdentifier forIndexPath:indexPath];
    
    // 模擬店情報を取り出す
    NSDictionary* shop = shopsDatas[indexPath.row];
    
    // イラスト
    NSString *imageResource = JsonValue(shop[@"image_resource"]);
    
    // セルに設定
    [cell updateShopDataWithShopName:JsonValue(shop[@"name"]) tenant:JsonValue(shop[@"tenant"]) sales:JsonValue(shop[@"sales"]) imageResource:imageResource];
    
    // イラスト設定
    [imagesCache imageWithURL:imageResource receive:^(UIImage *image) {
        [cell updateShopImage:image url:imageResource];
        [cell layoutSubviews];
    }];
    
    return cell;
}

// 展示テーブルビューのセルを更新する
- (UITableViewCell*)updateExhibitionsTableViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HokutosaiExhibitionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:exhibitionsTableViewCellIdentifier forIndexPath:indexPath];
    
    // 模擬店情報を取り出す
    NSDictionary* exhibition = exhibitionsDatas[indexPath.row];
    
    // イラスト
    NSString *imageResource = JsonValue(exhibition[@"image_resource"]);
    
    // セルに設定
    [cell updateExhibitionDataWithTitle:JsonValue(exhibition[@"title"]) displays:JsonValue(exhibition[@"displays"]) place:JsonValue(exhibition[@"place"][@"name"]) imageResource:imageResource];
    
    // イラスト設定
    [imagesCache imageWithURL:imageResource receive:^(UIImage *image) {
        [cell updateExhibitionImage:image url:imageResource];
        [cell layoutSubviews];
    }];
    
    return cell;
}

// ###################################################################################

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [imagesCache clearCashe];
}

- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight
{
    // スワイプビューのフレームを更新
    if (_swipeView) {
       _swipeView.frame = CGRectMake(_swipeView.frame.origin.x, _swipeView.frame.origin.y, _swipeView.frame.size.width, screenHeight);
    }
    
    // 模擬店テーブルビューのフレームを更新
    if (shopsTableView) {
        shopsTableView.frame = [_swipeView frameOfPage:0];
    }
    
    // 展示テーブルビューのフレームを更新
    if (exhibitionsTableView) {
        exhibitionsTableView.frame = [_swipeView frameOfPage:1];
    }
}

// マップボタン
- (IBAction)tappedMap:(UIButton *)sender
{
    [self performSegueWithIdentifier:segueToMapViewIdentifier sender:nil];
}
@end
