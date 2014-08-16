//
//  HokutosaiNewsDetailViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/28.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiNewsDetailViewController.h"
#import "HokutosaiApiGetRequest.h"
#import "HokutosaiApiRequestParameters.h"
#import "HokutosaiApiRequestDemander.h"
#import "HokutosaiStackPanelView.h"
#import "HokutosaiUIColor.h"
#import "HokutosaiDateConvert.h"
#import "HokutosaiShopDetailViewController.h"
#import "HokutosaiExhibitionDetailViewController.h"
#import "HokutosaiEventsDetailViewController.h"
#import "HokutosaiUIUtility.h"

// セル識別子
static NSString *cellIdentifier = @"cell";

// セグエ識別子
static NSString *segueToEventDetailIdentifier = @"toEventDetail";
static NSString *segueToShopDetailIdentifier = @"toShopDetail";
static NSString *segueToExhibitionDetailIdentifier = @"toExhibitionDetail";

@interface HokutosaiNewsDetailViewController ()
{
    // ニュースデータ
    NSDictionary *newsData;
    
    // イメージキャッシュ
    HokutosaiURLImagesCache *imageCache;
    
    // タイトルビュー
    HokutosaiStackPanelView *titleView;
    // メタ情報ビュー
    HokutosaiStackPanelView *metaInfoView;
    // 本文・画像ビュー
    HokutosaiStackPanelView *contentView;
    
    // コンテンツが全て読み込まれているかどうか
    BOOL contentsLoaded;
}

- (void)cleateTitleView;
- (void)cleateMetaInfoView;
- (void)cleateContentView;

- (void)tappedLinkButton:(UIButton*)sender;

@end

@implementation HokutosaiNewsDetailViewController

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
    
    // タイトルビュー生成
    [self cleateTitleView];
    
    // コンテンツが既にロードされていれば
    if (contentsLoaded) {
        // メタ情報ビュー生成
        [self cleateMetaInfoView];
        // コンテントビュー生成
        [self cleateContentView];
    }
    // コンテンツがロードされていなければ
    else {
        HokutosaiApiRequestParameters *requestParams = [[HokutosaiApiRequestParameters alloc] init];
        [requestParams setValueWithInteger:JsonIntValue(newsData[@"news_id"]) forKey:@"news_id"];
        HokutosaiApiGetRequest *request = [HokutosaiApiGetRequest requestWithEndpointPath:@"news/show" queryParameters:requestParams];
        HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:request];
        
        [requestDemander responseAsync:^(id json) {
            // ニュースデータ設定
            newsData = json;
            // メタ情報ビュー生成
            [self cleateMetaInfoView];
            // コンテントビュー生成
            [self cleateContentView];
            // コンテンツロード完了
            contentsLoaded = YES;
            // テーブルビューに挿入
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

// タイトルビュー生成
- (void)cleateTitleView
{
    // タイトルビュー生成
    CGRect frameOfTitleView = CGRectMake(0, 0, self.tableView.frame.size.width, 10);
    titleView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfTitleView];
    titleView.subviewFitWidth = YES;
    [titleView setTopPadding:10.0 bottomPadding:10.0];
    
    // タイトルラベル生成
    CGRect frameOfTitleLabel = CGRectMake(0, 0, titleView.widthOfStackPanel, 10);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frameOfTitleLabel];
    titleLabel.text = JsonValue(newsData[@"title"]);
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    [titleView addSubview:titleLabel];
    
    // セパレータ生成
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleView.widthOfStackPanel, 0.5)];
    separator.backgroundColor = [HokutosaiUIColor colorWithRed:200 green:200 blue:200];
    [titleView addSubview:separator verticalSpace:10.0];
}

// メタ情報ビュー生成
- (void)cleateMetaInfoView
{
    // メタ情報ビュー生成
    CGRect frameOfMetaInfo = CGRectMake(0, 0, self.tableView.frame.size.width, 10);
    metaInfoView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfMetaInfo];
    metaInfoView.subviewVerticalSpace = 5.0;
    metaInfoView.subviewFitWidth = NO;
    [metaInfoView setTopPadding:0.0 bottomPadding:10.0];
    
    // 送信者ラベル生成
    CGRect frameOfSenderLabel = CGRectMake(0, 0, metaInfoView.widthOfStackPanel, 10);
    UILabel *senderlabel = [[UILabel alloc] initWithFrame:frameOfSenderLabel];
    senderlabel.text = JsonValue(newsData[@"sender_department"]);
    senderlabel.font = [UIFont systemFontOfSize:17.0];
    senderlabel.textAlignment = NSTextAlignmentLeft;
    senderlabel.textColor = [UIColor blackColor];
    senderlabel.backgroundColor = [UIColor whiteColor];
    senderlabel.numberOfLines = 0;
    [senderlabel sizeToFit];
    [metaInfoView addSubview:senderlabel];
    
    // 関連する各部署を取得
    id relatedEvent = newsData[@"related_event"];
    id relatedShop = newsData[@"related_shop"];
    id relatedExhibition = newsData[@"related_exhibition"];
    
    // 送信者のリンクボタン生成
    if (relatedEvent != [NSNull null] || relatedShop != [NSNull null] || relatedExhibition != [NSNull null]) {
        UIButton *linkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, metaInfoView.widthOfStackPanel, 17)];
        linkButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        linkButton.backgroundColor = [UIColor whiteColor];
        linkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [linkButton setTitleColor:[HokutosaiUIColor tnctBlueColor] forState:UIControlStateNormal];
        [linkButton setTitleColor:[HokutosaiUIColor colorWithRed:0 green:200 blue:255] forState:UIControlStateHighlighted];
        [linkButton addTarget:self action:@selector(tappedLinkButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // テキスト設定
        if (relatedEvent != [NSNull null]) {
            [linkButton setTitle:JsonValue(relatedEvent[@"title"]) forState:UIControlStateNormal];
        } else if (relatedShop != [NSNull null]) {
            [linkButton setTitle:JsonValue(relatedShop[@"name"]) forState:UIControlStateNormal];
        } else if (relatedExhibition != [NSNull null]) {
            [linkButton setTitle:JsonValue(relatedExhibition[@"title"]) forState:UIControlStateNormal];
        }

        // インセット設定
        linkButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        linkButton.contentEdgeInsets = UIEdgeInsetsZero;
        
        [metaInfoView addSubview:linkButton fitWidth:YES];
    }
    
    // 送信日時ラベル生成
    CGRect frameOfSendDatetime = CGRectMake(0, 0, metaInfoView.widthOfStackPanel, 10);
    UILabel *sendDatetimelabel = [[UILabel alloc] initWithFrame:frameOfSendDatetime];
    sendDatetimelabel.text = [HokutosaiDateConvert stringFromHokutosaiApiDatetime:JsonValue(newsData[@"send_datetime"]) format:@"yyyy/MM/dd HH:mm"];
    sendDatetimelabel.font = [UIFont systemFontOfSize:14.0];
    sendDatetimelabel.textAlignment = NSTextAlignmentRight;
    sendDatetimelabel.textColor = [UIColor lightGrayColor];
    sendDatetimelabel.backgroundColor = [UIColor whiteColor];
    sendDatetimelabel.numberOfLines = 0;
    [sendDatetimelabel sizeToFit];
    [metaInfoView addSubview:sendDatetimelabel fitWidth:YES];
    
    // セパレータ生成
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, metaInfoView.widthOfStackPanel, 0.5)];
    separator.backgroundColor = [HokutosaiUIColor colorWithRed:200 green:200 blue:200];
    [metaInfoView addSubview:separator verticalSpace:10.0];
}

// コンテントビュー生成
- (void)cleateContentView
{
    // コンテントビュー生成
    CGRect frameOfContentView = CGRectMake(0, 0, self.tableView.frame.size.width, 10);
    contentView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfContentView];
    [contentView setTopPadding:5.0 bottomPadding:20.0];
    contentView.subviewVerticalSpace = 5.0;
    contentView.subviewFitWidth = YES;
    
    // テキストビュー生成
    CGRect frameOfTextLabel = CGRectMake(0, 0, contentView.widthOfStackPanel, 10);
    UITextView *textView = [[UITextView alloc] initWithFrame:frameOfTextLabel];
    textView.text = JsonValue(newsData[@"text"]);
    textView.font = [UIFont systemFontOfSize:15.0];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    textView.linkTextAttributes = @{NSForegroundColorAttributeName: [HokutosaiUIColor colorWithRed:0 green:100 blue:200]};
    [textView sizeToFit];
    [contentView addSubview:textView];
    
    // 画像ビュー生成
    if (newsData[@"image_resource"] != [NSNull null]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentView.widthOfStackPanel, 50)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [imageCache imageWithURL:newsData[@"image_resource"] receive:^(UIImage *image) {
            // イメージ設定
            imageView.image = image;
            
            // サイズ調整
            CGRect frameOfImageView;
            frameOfImageView.origin = imageView.frame.origin;
            
            CGFloat widthOfImageView = imageView.frame.size.width;
            CGFloat widthOfImage = image.size.width;
            
            // イメージの幅がイメージビューの幅よりも小さければそのまま表示
            if (widthOfImage <= widthOfImageView) {
                frameOfImageView.size = CGSizeMake(widthOfImage, image.size.height);
            }
            // イメージの幅がイメージビューよりも大きければ縮小して表示
            else {
                frameOfImageView.size = CGSizeMake(widthOfImageView, (widthOfImageView / widthOfImage) * image.size.height);
            }
            
            // フレーム再設定
            imageView.frame = frameOfImageView;
            
            // コンテントビューに追加
            [contentView addSubview:imageView verticalSpace:10.0];
        } asyncComplete:^() {
            [self.tableView reloadData];
        }];
    }
}

// リンクボタンがタップされた際
- (void)tappedLinkButton:(UIButton *)sender
{
    id relatedEvent = newsData[@"related_event"];
    id relatedShop = newsData[@"related_shop"];
    id relatedExhibition = newsData[@"related_exhibition"];
    
    if (relatedEvent != [NSNull null]) {
        [self performSegueWithIdentifier:segueToEventDetailIdentifier sender:relatedEvent];
    } else if (relatedShop != [NSNull null]) {
        [self performSegueWithIdentifier:segueToShopDetailIdentifier sender:relatedShop];
    } else if (relatedExhibition != [NSNull null]) {
        [self performSegueWithIdentifier:segueToExhibitionDetailIdentifier sender:relatedExhibition];
    }
}

// リンクビューへ遷移する際
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // イベント詳細
    if ([segue.identifier isEqualToString:segueToEventDetailIdentifier]) {
        HokutosaiEventsDetailViewController *destination = segue.destinationViewController;
        [destination setEventData:sender requireReload:YES];
    }
    // 模擬店詳細
    else if ([segue.identifier isEqualToString:segueToShopDetailIdentifier]) {
        HokutosaiShopDetailViewController *destination = segue.destinationViewController;
        [destination setShopData:sender imagesCache:nil];
    }
    // 展示詳細ビュー
    else if ([segue.identifier isEqualToString:segueToExhibitionDetailIdentifier]) {
        HokutosaiExhibitionDetailViewController *destination = segue.destinationViewController;
        [destination setExhibitionData:sender imageCache:nil requireReload:YES];
    }
}

// ニュースデータ設定
- (void)setNewsData:(NSDictionary*)data imageCache:(HokutosaiURLImagesCache*)cache
{
    newsData = data;
    imageCache = cache;
    contentsLoaded = YES;
}

- (void)setNewsData:(NSDictionary *)data imageCache:(HokutosaiURLImagesCache *)cache rquireReload:(BOOL)reload
{
    newsData = data;
    imageCache = cache;
    contentsLoaded = !reload;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [imageCache clearCashe];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (contentsLoaded) {
        return 3;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return titleView.frame.size.height;
        case 1:
            return metaInfoView.frame.size.height;
        case 2:
            return contentView.frame.size.height;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [HokutosaiUIUtility removeAllSubviews:cell.contentView];
    
    switch (indexPath.row) {
        case 0:
            [cell.contentView addSubview:titleView];
            break;
        case 1:
            [cell.contentView addSubview:metaInfoView];
            break;
        case 2:
            [cell.contentView addSubview:contentView];
            break;
    }
    
    return cell;
}

- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight
{
    if (self.tableView) {
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, screenHeight - self.tableView.frame.origin.y);
    }
}

@end
