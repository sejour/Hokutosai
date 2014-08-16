//
//  HokutosaiEventsDetailViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Social/Social.h>
#import "HokutosaiEventsDetailViewController.h"
#import "HokutosaiURLImageDownloader.h"
#import "HokutosaiDateConvert.h"
#import "HokutosaiStreamingLabel.h"
#import "HokutosaiStackPanelView.h"
#import "HokutosaiApiGetRequest.h"
#import "HokutosaiApiRequestParameters.h"
#import "HokutosaiApiRequestDemander.h"
#import "HokutosaiSchedulesViewController.h"
#import "HokutosaiUIUtility.h"
#import "HokutosaiUIColor.h"
#import "HokutosaiEventsNotification.h"

// セル識別子
static NSString *cellIdentifier = @"cell";

// セグエ
static NSString *segueToMapViewIdentifier = @"toMaps";

static const CGFloat headlineFontSize = 17.0;
static const CGFloat contentFontSize = 15.0;
static const CGFloat contentOffset = 15.0;

@interface HokutosaiEventsDetailViewController ()
{
    // イベントデータ
    NSDictionary *eventData;
    // コンテンツのロードが完了しているかどうか
    BOOL contentsLoaded;
    
    // ヘッダビュー
    HokutosaiStackPanelView *headerView;
    // メタ情報
    HokutosaiStackPanelView *metaInfoView;
    // コンテントビュー
    HokutosaiStackPanelView *contentView;
    // 出演者ビュー
    HokutosaiStackPanelView *performerView;
    // 通知登録ビュー
    HokutosaiStackPanelView *notificationRegisterView;
    
    // イメージビュー
    UIImageView *imageView;
    // イメージをダウンロード中であるかどうか
    BOOL downloadingImage;
}

- (void)generateShareButton;

- (void)generateHeaderView;
- (void)generateMetaInfoView;
- (void)generateContentView;
- (void)generatePerformerView;
- (void)generateNotificationRegisterView;
- (IBAction)tappedMap:(UIButton *)sender;

// 通知を登録する
- (void)registerNotofication:(NSTimeInterval)noticeAgoTime;

- (NSString*)stringHeldDatetime;
@end

@implementation HokutosaiEventsDetailViewController

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
    
    downloadingImage = NO;
    
    // セルの登録
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    // セルの非表示
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 共有ボタンの作成
    [self generateShareButton];
    // ヘッダビュー生成
    [self generateHeaderView];
    
    // コンテンツがロードされていれば
    if (contentsLoaded) {
        // メタ情報ビュー生成
        [self generateMetaInfoView];
        // コンテントビュー生成
        [self generateContentView];
        // 出演者ビュー生成
        [self generatePerformerView];
        // 通知ビュー生成
        [self generateNotificationRegisterView];
    }
    // ロードされていなければダウンロード
    else {
        HokutosaiApiRequestParameters *requestParams = [[HokutosaiApiRequestParameters alloc] init];
        [requestParams setValueWithInteger:JsonIntValue(eventData[@"event_id"]) forKey:@"event_id"];
        HokutosaiApiGetRequest *request = [HokutosaiApiGetRequest requestWithEndpointPath:@"events/show" queryParameters:requestParams];
        HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:request];
        
        // リクエスト実行
        [requestDemander responseAsync:^(id json) {
            // JSON読み込み
            eventData = json;
            
            // イメージビューが存在し、かつイメージが設定されていない
            if (imageView != nil && imageView.image == nil) {
                // イメージが存在する、かつそのイメージをダウンロード中でなければ
                if (eventData[@"image_resource"] != [NSNull null] && downloadingImage == NO) {
                    // 画像ダウンロード
                    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:eventData[@"image_resource"]]];
                    HokutosaiURLImageDownloader *downloader = [[HokutosaiURLImageDownloader alloc] initWithRequest:imageRequest];
                    // ダウンロード開始
                    downloadingImage = YES;
                    [downloader downloadAsync:^(UIImage* image) {
                        imageView.image = image;
                        downloadingImage = NO;
                    }];
                }
                // イメージが存在しなければ
                else if (eventData[@"image_resource"] == [NSNull null]) {
                    imageView.image = [UIImage imageNamed:@"noimage_1.png"];
                }
            }
            
            // メタ情報ビュー生成
            [self generateMetaInfoView];
            // コンテントビュー生成
            [self generateContentView];
            // 出演者ビュー生成
            [self generatePerformerView];
            // 通知ビュー生成
            [self generateNotificationRegisterView];
            
            // コンテンツロード完了
            contentsLoaded = YES;
            
            // テーブルビューに挿入
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0], [NSIndexPath indexPathForRow:3 inSection:0], [NSIndexPath indexPathForRow:4 inSection:0], [NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

- (void)generateHeaderView
{
    // ヘッダビュー生成
    CGRect frameOfHeaderView = CGRectMake(0, 0, self.tableView.frame.size.width, 0.0);
    headerView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfHeaderView];
    [headerView setTopPadding:10.0 rightPadding:0.0 bottomPadding:0.0 leftPadding:0.0];
    
    // タイトルビュー生成
    CGRect frameOfTitleLabel = CGRectMake(20.0, 0.0, self.tableView.frame.size.width - 40.0, 27.0);
    HokutosaiStreamingLabel *titleLabel = [[HokutosaiStreamingLabel alloc] initWithFrame:frameOfTitleLabel];
    [titleLabel setTextFont:[UIFont boldSystemFontOfSize:22.0]];
    [titleLabel setText:JsonValue(eventData[@"title"])];
    [headerView addSubview:titleLabel];
    
    // イメージビュー生成
    if (eventData[@"image_resource"] != [NSNull null]) {
        CGRect frameOfImageView = CGRectMake(0.0, 0.0, 320.0, 128.0);
        imageView = [[UIImageView alloc] initWithFrame:frameOfImageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [headerView addSubview:imageView verticalSpace:5.0];
        
        // 画像ダウンロード
        NSString *imageResource = JsonValue(eventData[@"image_resource"]);
        if (imageResource != nil) {
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageResource]];
            HokutosaiURLImageDownloader *downloader = [[HokutosaiURLImageDownloader alloc] initWithRequest:imageRequest];
            // ダウンロード開始
            downloadingImage = YES;
            [downloader downloadAsync:^(UIImage* image) {
                imageView.image = image;
                downloadingImage = NO;
            }];
        }
    }
    
    // タイトルラベルのストリーミング開始
    [titleLabel startStreamingInterval:3.0 speed:33.0];
}

- (void)generateMetaInfoView
{
    // メタ情報ビュー生成
    CGRect frameOfMetaInfoView = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0.0);
    metaInfoView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfMetaInfoView];
    [metaInfoView setTopPadding:10.0 rightPadding:20.0 bottomPadding:0.0 leftPadding:20.0];
    metaInfoView.subviewFitWidth = NO;
    
    // 開催日時見出しラベル
    {
        CGRect frameOfDatetimeHeadline = CGRectMake(0.0, 0.0, metaInfoView.widthOfStackPanel, 20.0);
        UILabel *datetimeHeadline = [[UILabel alloc] initWithFrame:frameOfDatetimeHeadline];
        datetimeHeadline.textAlignment = NSTextAlignmentLeft;
        datetimeHeadline.font = [UIFont systemFontOfSize:headlineFontSize];
        datetimeHeadline.text = @"開催日時";
        [metaInfoView addSubview:datetimeHeadline];
    }
    
    // 日時ラベル
    {
        CGRect frameOfDatetimeLabel = CGRectMake(contentOffset, 0.0, metaInfoView.widthOfStackPanel - contentOffset, 15.0);;
        UILabel *datetimeLabel = [[UILabel alloc] initWithFrame:frameOfDatetimeLabel];
        datetimeLabel.textAlignment = NSTextAlignmentLeft;
        datetimeLabel.font = [UIFont systemFontOfSize:contentFontSize];
        datetimeLabel.text = [self stringHeldDatetime];
        [metaInfoView addSubview:datetimeLabel verticalSpace:3.0];
    }
    
    // 開催中を示すラベル
    if ([HokutosaiSchedulesViewController theEventBeingHeld:eventData at:[NSDate date]]) {
        CGRect frameOfBeingHeld = CGRectMake(contentOffset, 0.0, metaInfoView.widthOfStackPanel - contentOffset, 15.0);
        UILabel *beingHeld = [[UILabel alloc] initWithFrame:frameOfBeingHeld];
        beingHeld.textAlignment = NSTextAlignmentLeft;
        beingHeld.font = [UIFont systemFontOfSize:contentFontSize];
        beingHeld.textColor = [UIColor redColor];
        beingHeld.text = @"現在開催中！";
        [metaInfoView addSubview:beingHeld verticalSpace:5.0];
    }
    
    // 場所見出しラベル
    {
        CGRect frameOfPlaceHeadline = CGRectMake(0.0, 0.0, metaInfoView.widthOfStackPanel, 20.0);;
        UILabel *placeHeadline = [[UILabel alloc] initWithFrame:frameOfPlaceHeadline];
        placeHeadline.textAlignment = NSTextAlignmentLeft;
        placeHeadline.font = [UIFont systemFontOfSize:headlineFontSize];
        placeHeadline.text = @"場所";
        [metaInfoView addSubview:placeHeadline verticalSpace:10.0];
    }
    
    // 場所ラベル
    {
        CGRect frameOfPlaceLabel = CGRectMake(contentOffset, 0.0, metaInfoView.widthOfStackPanel - contentOffset, 15.0);
        UILabel *placeLabel = [[UILabel alloc] initWithFrame:frameOfPlaceLabel];
        placeLabel.textAlignment = NSTextAlignmentLeft;
        placeLabel.numberOfLines = 0;
        placeLabel.font = [UIFont systemFontOfSize:contentFontSize];
        placeLabel.text = JsonValue(eventData[@"place"][@"name"]);
        [placeLabel sizeToFit];
        [metaInfoView addSubview:placeLabel verticalSpace:3.0];
    }
    
    // セパレータ
    {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, metaInfoView.widthOfStackPanel, 0.5)];
        separator.backgroundColor = [HokutosaiUIColor colorWithRed:200 green:200 blue:200];
        [metaInfoView addSubview:separator verticalSpace:10.0];
    }
}

// 開催日時を文字列で得る
- (NSString*)stringHeldDatetime
{
    // 開催日
    NSString *heldDate = [HokutosaiDateConvert stringFromHokutosaiApiDate:JsonValue(eventData[@"date"]) format:@"yyyy/MM/dd"];
    
    // 今日の日付
    NSDate *today = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    // 今日
    if ([[formatter stringFromDate:today] isEqualToString:heldDate]) {
        heldDate = @"今日";
    }
    // 明日
    else if ([[formatter stringFromDate:[NSDate dateWithTimeInterval:86400 sinceDate:today]] isEqualToString:heldDate]) {
        heldDate = @"明日";
    }
    // 明後日
    else if ([[formatter stringFromDate:[NSDate dateWithTimeInterval:172800 sinceDate:today]] isEqualToString:heldDate]) {
        heldDate = @"明後日";
    }
    // 昨日
    else if ([[formatter stringFromDate:[NSDate dateWithTimeInterval:-86400 sinceDate:today]] isEqualToString:heldDate]) {
        heldDate = @"昨日";
    }
    
    // 開催時刻
    NSString *heldTime = [NSString stringWithFormat:@"%@〜%@", [HokutosaiDateConvert stringFromHokutosaiApiTime:JsonValue(eventData[@"start_time"]) format:@"HH:mm"], [HokutosaiDateConvert stringFromHokutosaiApiTime:JsonValue(eventData[@"end_time"]) format:@"HH:mm"]];
    
    return [NSString stringWithFormat:@"%@  %@", heldDate, heldTime];
}

- (void)generateContentView
{
    // コンテントビュー生成
    CGRect frameOfContentView = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0.0);
    contentView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfContentView];
    [contentView setTopPadding:10.0 rightPadding:20.0 bottomPadding:0.0 leftPadding:20.0];
    contentView.subviewFitWidth = NO;
    
    // 内容見出しラベル
    {
        CGRect frameOfContentHeadline = CGRectMake(0.0, 0.0, contentView.widthOfStackPanel, 20.0);
        UILabel *contentHeadline = [[UILabel alloc] initWithFrame:frameOfContentHeadline];
        contentHeadline.textAlignment = NSTextAlignmentLeft;
        contentHeadline.font = [UIFont systemFontOfSize:headlineFontSize];
        contentHeadline.text = @"内容";
        [contentView addSubview:contentHeadline];
    }
    
    // 内容ラベル
    {
        CGRect frameOfContentLabel = CGRectMake(contentOffset, 0.0, contentView.widthOfStackPanel - contentOffset, 15.0);
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:frameOfContentLabel];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:contentFontSize];
        contentLabel.text = JsonValue(eventData[@"detail"]);
        [contentLabel sizeToFit];
        [contentView addSubview:contentLabel verticalSpace:3.0];
    }

    // セパレータ
    {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, metaInfoView.widthOfStackPanel, 0.5)];
        separator.backgroundColor = [HokutosaiUIColor colorWithRed:200 green:200 blue:200];
        [contentView addSubview:separator verticalSpace:10.0];
    }
}

- (void)generatePerformerView
{
    // 出演者ビュー生成
    CGRect frameOfPerformerView = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0.0);
    performerView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfPerformerView];
    [performerView setTopPadding:10.0 rightPadding:20.0 bottomPadding:20.0 leftPadding:20.0];
    performerView.subviewFitWidth = NO;
    
    // 出演者見出しラベル
    {
        CGRect frameOfParticipantsHeadline = CGRectMake(0.0, 0.0, performerView.widthOfStackPanel, 30.0);
        UILabel *partcipantsHeadline = [[UILabel alloc] initWithFrame:frameOfParticipantsHeadline];
        partcipantsHeadline.textAlignment = NSTextAlignmentLeft;
        partcipantsHeadline.font = [UIFont systemFontOfSize:headlineFontSize];
        partcipantsHeadline.text = @"出演者";
        [performerView addSubview:partcipantsHeadline];
    }
    
    // 出場者ラベル
    {
        CGRect frameOfParticipantsLabel = CGRectMake(contentOffset, 0.0, performerView.widthOfStackPanel - contentOffset, 15.0);
        UILabel *participantsLabel= [[UILabel alloc] initWithFrame:frameOfParticipantsLabel];
        participantsLabel.textAlignment = NSTextAlignmentLeft;
        participantsLabel.numberOfLines = 0;
        participantsLabel.font = [UIFont systemFontOfSize:contentFontSize];
        participantsLabel.text = JsonValue(eventData[@"participants"]);
        [participantsLabel sizeToFit];
        [performerView addSubview:participantsLabel verticalSpace:3.0];
    }
}

- (void)generateNotificationRegisterView
{
    // 通知ビュー生成
    CGRect frame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0.0);
    notificationRegisterView = [[HokutosaiStackPanelView alloc] initWithFrame:frame];
    [notificationRegisterView setTopPadding:0.0 rightPadding:0.0 bottomPadding:0.0 leftPadding:0.0];
    
    // セパレータ
    {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, notificationRegisterView.widthOfStackPanel, 0.5)];
        separator.backgroundColor = [HokutosaiUIColor colorWithRed:200 green:200 blue:200];
        [notificationRegisterView addSubview:separator];
    }
    
    // ラベル
    {
        CGRect frameOfLabel = CGRectMake(20.0, 0.0, notificationRegisterView.widthOfStackPanel - 40.0, 45.0);
        UILabel *label = [[UILabel alloc] initWithFrame:frameOfLabel];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20.0];
        label.textColor = [HokutosaiUIColor hokutosaiColor];
        label.text = @"通知登録する";
        [notificationRegisterView addSubview:label];
    }
    
    // セパレータ
    {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, notificationRegisterView.widthOfStackPanel, 0.5)];
        separator.backgroundColor = [HokutosaiUIColor colorWithRed:200 green:200 blue:200];
        [notificationRegisterView addSubview:separator];
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
    [twitterPostVC setInitialText:[NSString stringWithFormat:@"%@ #北斗祭 ", eventData[@"title"]]];
    [self presentViewController:twitterPostVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// イベントデータを設定する
- (void)setEventData:(NSDictionary*)data requireReload:(BOOL)reload
{
    eventData = data;
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
        return 6;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
    switch (indexPath.row) {
        case 0:
            height = headerView.frame.size.height;
            break;
        case 1:
            height = metaInfoView.frame.size.height;
            break;
        case 2:
            height = contentView.frame.size.height;
            break;
        case 3:
            height = performerView.frame.size.height;
            break;
        case 4:
            height = notificationRegisterView.frame.size.height;
            break;
        case 5:
            height = 30.0;
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
            [cell.contentView addSubview:headerView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 1:
            [cell.contentView addSubview:metaInfoView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 2:
            [cell.contentView addSubview:contentView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 3:
            [cell.contentView addSubview:performerView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 4:
            [cell.contentView addSubview:notificationRegisterView];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        case 5:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
    }
    
    return cell;
}

// セルがタップされたとき
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 通知登録セルのタップ
    if (indexPath.row == 4) {
        UIAlertView *alert;
        
        // 通知が登録されていれば取り消しボタンも表示
        if ([HokutosaiEventsNotification eventIsRegistered:eventData[@"event_id"]]) {
            alert = [[UIAlertView alloc] initWithTitle:@"イベント通知"
                                               message:@"通知する時間を変更します。"
                                              delegate:self
                                     cancelButtonTitle:@"キャンセル"
                                     otherButtonTitles:@"5分前", @"10分前", @"15分前", @"30分前", @"1時間前", @"通知を取り消す", nil];
        }
        // 通知が登録されていない場合
        else {
            alert = [[UIAlertView alloc] initWithTitle:@"イベント通知"
                                               message:@"指定した時間前に通知します。"
                                              delegate:self
                                     cancelButtonTitle:@"キャンセル"
                                     otherButtonTitles:@"5分前", @"10分前", @"15分前", @"30分前", @"1時間前", nil];
        }
        
        // アラートを表示
        [alert show];
        
        // セルの選択を解除
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

// アラートのボタンがタップされた際
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self registerNotofication:(5 * 60)];
            break;
        case 2:
            [self registerNotofication:(10 * 60)];
            break;
        case 3:
            [self registerNotofication:(15 * 60)];
            break;
        case 4:
            [self registerNotofication:(30 * 60)];
            break;
        case 5:
            [self registerNotofication:(60 * 60)];
            break;
        case 6:
            {
                // 通知取り消し
                [HokutosaiEventsNotification cancelNotificationWithEvent:eventData[@"event_id"]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"通知を取り消しました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            break;
        default:
            break;
    }
}

// 通知を登録する
- (void)registerNotofication:(NSTimeInterval)noticeAgoTime
{
    BOOL result = [HokutosaiEventsNotification registerNotificationWithEvent:eventData[@"event_id"] eventName:eventData[@"title"] heldDate:eventData[@"date"] startTime:eventData[@"start_time"] noticeAgoTime:noticeAgoTime];
    
    if (result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知を登録しました" message:[NSString stringWithFormat:@"%d分前に通知されます。", (int)(noticeAgoTime / 60)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知を登録できません" message:@"通知時間が過ぎています。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
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
