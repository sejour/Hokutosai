//
//  HokutosaiShopDetailViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/07.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Social/Social.h>
#import "HokutosaiShopDetailViewController.h"
#import "HokutosaiApiGetRequest.h"
#import "HokutosaiApiPostRequest.h"
#import "HokutosaiApiRequestDemander.h"
#import "HokutosaiApiRequestParameters.h"
#import "HokutosaiUIUtility.h"
#import "HokutosaiShopsMenuItem.h"
#import "HokutosaiShopsAssessByMeView.h"
#import "HokutosaiStreamingLabel.h"
#import "HokutosaiStackPanel.h"
#import "HokutosaiStackPanelView.h"
#import "HokutosaiShopsAndExhibitionsHeadInfoView.h"
#import "HokutosaiShopsAssessView.h"
#import "HokutosaiUIColor.h"

static NSString *userDefaultKeyOfShopsAssessByMe = @"shopsAssessByMe";

static NSString *cellIdentifier = @"cell";

static NSString *segueToMapViewIdentifier = @"toMaps";

static const CGFloat headlineFontSize = 17.0;
static const CGFloat contentFontSize = 15.0;
static const CGFloat contentOffset = 10.0;

@interface HokutosaiShopDetailViewController ()
{
    // 模擬店データ
    NSDictionary *shopData;
    // イメージキャッシュ
    HokutosaiURLImagesDictionary *imageCache;
    
    // コンテントがロードされているかどうか
    BOOL contentsLoaded;
    
    // ヘッドインフォメーションビュー
    HokutosaiShopsAndExhibitionsHeadInfoView *headInfoView;
    // プロフィールビュー
    HokutosaiStackPanelView *profileView;
    // 評価ビュー
    HokutosaiShopsAssessView *assessView;
    // メニュービュー
    HokutosaiStackPanelView *menusView;
}

- (void)updateHeadInfoView;
- (void)generateProfileView;
- (void)generateAssessView;
- (void)generateMenusView;
- (void)generateShareButton;
- (IBAction)tappedMap:(UIButton *)sender;
@end

@implementation HokutosaiShopDetailViewController

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
    
    contentsLoaded = NO;
    
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
    headInfoView = [[HokutosaiShopsAndExhibitionsHeadInfoView alloc] initWithFrame:frameOfHeadInfoView title:JsonValue(shopData[@"name"]) hostNameHeadline:@"出店者"];
    
    // ヘッドインフォメーションビューを更新する
    [self updateHeadInfoView];

    // shops/showリクエスト生成
    HokutosaiApiRequestParameters *params = [[HokutosaiApiRequestParameters alloc] init];
    [params setValueWithInteger:JsonIntValue(shopData[@"shop_id"]) forKey:@"shop_id"];
    HokutosaiApiGetRequest *shopsShowRequest = [HokutosaiApiGetRequest requestWithEndpointPath:@"shops/show" queryParameters:params];
    HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:shopsShowRequest];
    
    // リクエスト実行
    [requestDemander responseAsync:^(id jsonContent) {
        // コンテント更新
        shopData = jsonContent;
        // ヘッドインフォメーションビューを更新
        [self updateHeadInfoView];
        // プロフィールビュー生成
        [self generateProfileView];
        // 評価ビュー生成
        [self generateAssessView];
        // メニュービュー生成
        [self generateMenusView];
        // コンテンツロード完了
        contentsLoaded = YES;
        // テーブルビューに挿入
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0], [NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    // タイトルストリーミング開始
    [headInfoView startTitleStreaming];
}

// ヘッドインフォメーションビューを更新する
- (void)updateHeadInfoView
{
    [headInfoView setTitle:JsonValue(shopData[@"name"])];
    [headInfoView setHostName:JsonValue(shopData[@"tenant"])];
    
    [imageCache imageWithURL:JsonValue(shopData[@"image_resource"]) receive:^(UIImage* image) {
        [headInfoView setImage:image];
    }];
}

// プロフィールビュー生成
- (void)generateProfileView
{
    CGRect frameOfProfileView = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0.0);
    profileView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfProfileView];
    [profileView setTopPadding:10.0 rightPadding:20.0 bottomPadding:5.0 leftPadding:20.0];
    
    // プロフィール見出し
    {
        CGRect frameOfHeadline = CGRectMake(0.0, 0.0, profileView.widthOfStackPanel, 20.0);
        UILabel *headline = [[UILabel alloc] initWithFrame:frameOfHeadline];
        headline.textAlignment = NSTextAlignmentLeft;
        headline.font = [UIFont systemFontOfSize:headlineFontSize];
        headline.text = @"プロフィール";
        [profileView addSubview:headline];
    }
    
    // プロフィール
    {
        CGRect frameOfContent = CGRectMake(contentOffset, 0.0, profileView.widthOfStackPanel - contentOffset, 15.0);
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:frameOfContent];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:contentFontSize];
        contentLabel.text = JsonValue(shopData[@"introduction"]);
        [contentLabel sizeToFit];
        [profileView addSubview:contentLabel verticalSpace:3.0];
    }
    
    // セパレータ
    {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, profileView.widthOfStackPanel, 0.5)];
        separator.backgroundColor = [HokutosaiUIColor colorWithRed:200 green:200 blue:200];
        [profileView addSubview:separator verticalSpace:10.0];
    }
}

// 評価ビュー生成
- (void)generateAssessView
{
    CGRect frameOfAssessView = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0.0);
    assessView = [[HokutosaiShopsAssessView alloc] initWithFrame:frameOfAssessView shopName:JsonValue(shopData[@"name"]) delegate:self];
    
    // みんなの評価を更新
    [self updateAssessByEvery:JsonValue(shopData[@"assess"])];
    
    // 自分の評価を更新
    [self updateAssessByMe];
    
    // セパレータ
    {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, profileView.widthOfStackPanel, 0.5)];
        separator.backgroundColor = [HokutosaiUIColor colorWithRed:200 green:200 blue:200];
        [assessView addSubview:separator verticalSpace:10.0];
    }
}

// メニュービュー生成
- (void)generateMenusView
{
    CGRect frameOfMenusView = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0.0);
    menusView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfMenusView];
    [menusView setTopPadding:5.0 rightPadding:20.0 bottomPadding:20.0 leftPadding:20.0];
    
    // 見出し
    {
        CGRect frameOfHeadline = CGRectMake(0.0, 0.0, profileView.widthOfStackPanel, 20.0);
        UILabel *headline = [[UILabel alloc] initWithFrame:frameOfHeadline];
        headline.textAlignment = NSTextAlignmentLeft;
        headline.font = [UIFont systemFontOfSize:headlineFontSize];
        headline.text = @"メニュー";
        [menusView addSubview:headline];
    }
    
    // メニューリスト
    NSArray *itemDatas = JsonValue(shopData[@"menus"]);
    if (itemDatas) {
        // メニューリスト生成
        CGRect frameOfMenuItemsView = CGRectMake(10.0, 0.0, menusView.widthOfStackPanel - 10.0, 0.0);
        HokutosaiStackPanel *menuItemsView = [[HokutosaiStackPanel alloc] initWithFrame:frameOfMenuItemsView];
        
        HokutosaiShopsMenuItem *itemView;
        CGRect frameOfItem = CGRectMake(0, 0, menuItemsView.frame.size.width, 10);
        // 各アイテムビュー生成
        for (NSDictionary *item in itemDatas) {
            // アイテム生成
            itemView = [[HokutosaiShopsMenuItem alloc] initWithFrame:frameOfItem itemName:JsonValue(item[@"name"]) price:[JsonValue(item[@"price"]) integerValue]];
            // アイテム追加
            [menuItemsView addSubview:itemView verticalSpace:3.0 fitWidth:YES];
        }
        
        // メニューリストを追加
        [menusView addSubview:menuItemsView verticalSpace:3.0];
    }
    
    // メニュー拡張
    if (JsonValue(shopData[@"menus_extension"])) {
        CGRect frameOfMenusExtension = CGRectMake(10.0, 0.0, profileView.widthOfStackPanel - 10.0, 15.0);
        UILabel *menusExtensionLabel = [[UILabel alloc] initWithFrame:frameOfMenusExtension];
        menusExtensionLabel.textAlignment = NSTextAlignmentLeft;
        menusExtensionLabel.numberOfLines = 0;
        menusExtensionLabel.font = [UIFont systemFontOfSize:contentFontSize];
        menusExtensionLabel.text = shopData[@"menus_extension"];
        [menusExtensionLabel sizeToFit];
        [menusView addSubview:menusExtensionLabel verticalSpace:5.0];
    }
}

// 評価を実行する
- (void)assesse:(NSInteger)score previousScore:(NSInteger)previousScore
{
    // shops/assessリクエスト生成
    HokutosaiApiRequestParameters *params = [[HokutosaiApiRequestParameters alloc] init];
    [params setValueWithInteger:JsonIntValue(shopData[@"shop_id"]) forKey:@"shop_id"];
    [params setValueWithInteger:score forKey:@"score"];
    
    if (previousScore != 0) {
        [params setValueWithInteger:previousScore forKey:@"previous_score"];
    }
    
    HokutosaiApiPostRequest *shopsAssessRequest = [HokutosaiApiPostRequest requestWithEndpointPath:@"shops/assess" queryParameters:params];
    HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:shopsAssessRequest];
    
    // リクエスト実行
    [requestDemander responseAsync:^(id jsonContent) {
        
        // ビューのスコア更新
        [assessView setAssessByMe:score];
        
        // みんなの評価を更新
        [self updateAssessByEvery:jsonContent];
        
        // ローカルに保存 ---------------------------------------
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *shopsAssessByMe = [NSMutableDictionary dictionaryWithDictionary:[userDefault dictionaryForKey:userDefaultKeyOfShopsAssessByMe]];
        
        // 存在しなければ生成
        if (shopsAssessByMe == nil) {
            shopsAssessByMe = [NSMutableDictionary dictionaryWithCapacity:2];
        }
        
        // スコア更新
        shopsAssessByMe[JsonStringValue(shopData[@"shop_id"])] = @(score);
        
        // ユーザーデフォルト更新
        [userDefault setObject:shopsAssessByMe forKey:userDefaultKeyOfShopsAssessByMe];
        [userDefault synchronize];
        // ---------------------------------------------------
        
    } receiveError:^(NSInteger errorCode) {
        if (errorCode == 40304) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"現在、評価できません。" message:@"模擬店の評価は北斗祭当日のみ可能です。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return YES;
        }
        
        return NO;
    }];
}

// みんなの評価を更新する
- (void)updateAssessByEvery:(NSDictionary *)assessData
{
    NSInteger assessedCountByEvery = JsonIntValue(assessData[@"assessed_count"]);
    NSInteger scoreOfEvery = 0;
    
    if (assessedCountByEvery > 0) {
        scoreOfEvery = round(JsonIntValue(assessData[@"total_score"])/(double)assessedCountByEvery);
    }
    
    [assessView setAssessByEvery:scoreOfEvery assessedCount:assessedCountByEvery];
}

// 自分の評価を更新する
- (void)updateAssessByMe
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *shopsAssessByMe = [userDefault dictionaryForKey:userDefaultKeyOfShopsAssessByMe];
    if (shopsAssessByMe) {
        NSNumber *myAssessScore = shopsAssessByMe[JsonStringValue(shopData[@"shop_id"])];
        if (myAssessScore) {
            NSInteger score = [myAssessScore integerValue];
            [assessView setAssessByMe:score];
        }
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
    [twitterPostVC setInitialText:[NSString stringWithFormat:@"%@ #北斗祭 ", shopData[@"name"]]];
    [self presentViewController:twitterPostVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [imageCache clearCashe];
}

// 模擬店データを設定する
- (void)setShopData:(NSDictionary *)data imagesCache:(HokutosaiURLImagesDictionary *)cache
{
    shopData = data;
    
    if (cache) {
        imageCache = cache;
    } else {
        imageCache = [[HokutosaiURLImagesDictionary alloc] init];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (contentsLoaded) {
        return 4;
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
            height = profileView.frame.size.height;
            break;
        case 2:
            height = assessView.frame.size.height;
            break;
        case 3:
            height = menusView.frame.size.height;
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
            [cell.contentView addSubview:profileView];
            break;
        case 2:
            [cell.contentView addSubview:assessView];
            break;
        case 3:
            [cell.contentView addSubview:menusView];
            break;
    }
    
    return cell;
}

- (IBAction)tappedMap:(UIButton *)sender
{
    [self performSegueWithIdentifier:segueToMapViewIdentifier sender:nil];
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
