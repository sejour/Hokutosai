//
//  HokutosaiSchedulesViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/30.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiSchedulesViewController.h"
#import "HokutosaiSwipeView.h"
#import "HokutosaiSchedulesTimeAxis.h"
#import "HokutosaiUIUtility.h"
#import "HokutosaiUIColor.h"
#import "HokutosaiSchedulesTimetableItem.h"
#import "HokutosaiDateConvert.h"
#import "HokutosaiApiGetRequest.h"
#import "HokutosaiApiRequestParameters.h"
#import "HokutosaiApiRequestTasksQueue.h"
#import "HokutosaiApiRequestDemander.h"
#import "HokutosaiTimer.h"
#import "HokutosaiEventsDetailViewController.h"
#import "HokutosaiTaggedTapGestureRecognizer.h"
#import "HokutosaiLoadingView.h"
#import "HokutosaiEventsNotification.h"

// セグエ識別子
static NSString *segueToEventsDetailIdentifier = @"toEventsDetail";

// タイムテーブルのステータスを更新する間隔
static const float IntervalOfUpdateTimetablesStatus = 60.0;

@interface HokutosaiSchedulesViewController ()  <HokutosaiSwipeViewDelegate, UIScrollViewDelegate>
{
    // 日付の項目
    NSArray *dateSections;
    
    // 場所の項目
    NSArray *placesSections;
    
    // ローディングビュー
    NSMutableDictionary *loadingViews;
    
    // タイムテーブル
    NSMutableArray* timetableViews;
    
    // イベントデータ
    NSMutableDictionary *eventsDatas;
    
    // タイムテーブルのアイテムリスト
    NSMutableDictionary *timetablesItems;
    
    // 現在のタイムテーブルのスクロールオフセット
    CGPoint currentTimetableOffset;
    
    // タイムテーブルのステータスを更新するタイマー
    HokutosaiTimer *updateTimetablesStatusTimer;
    
    // APIリクエストタスク
    HokutosaiApiRequestTasksQueue *requestTasks;
}

// 日付の項目
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateSectionsControl;
// ヘッダ
@property (weak, nonatomic) IBOutlet UIView *headerView;
// 場所ラベル
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
// 場所のページコントロール
@property (weak, nonatomic) IBOutlet UIPageControl *placesPageControl;
// スケジュールテーブルのスワイプビュー
@property (weak, nonatomic) IBOutlet HokutosaiSwipeView *timetablesSwipeView;
// 時間軸のスクロールビュー
@property (weak, nonatomic) IBOutlet UIScrollView *timeAxisScrollView;

// タイムテーブルを更新する
- (void)updateTimetables;
// イベントデータを更新する
- (void)updateEventsDatasAtPlaceIndex:(NSInteger)placeIndex;

// 時間軸を生成する
- (void)generateTimeAxis;
// テーブルを生成する
- (void)generateTimetables;
// タイムテーブルをクリアする
- (void)clearTimetables;

// 指定したイベントデータリストでタイムテーブルのアイテムを生成する
- (void)generateItems:(NSArray*)eventsArray forTimetableIndex:(NSInteger)index;

// タイムテーブルのスクロールオフセットを設定する
- (void)setTimetableOffset:(CGPoint)offset animated:(BOOL)animated;

// 日付の項目のが変わったとき
- (IBAction)changedDateSectionsControl:(UISegmentedControl *)sender;
// Nowボタンがタップされた際
- (IBAction)tappedNowButton:(id)sender;
// イベントアイテムがタップされた際
- (void)tappedEventItem:(HokutosaiTaggedTapGestureRecognizer*)gesture;

// 現在時刻に合うタイムテーブルのスクロールオフセットを取得する
- (CGPoint)timetableNowScrollOffset;

// タイムテーブルのステータスを更新する
- (void)updateTimetablesStatus;

// ローディング画面初期化
- (void)initLoadingView;
// ローディング開始
- (void)startLoadingView;
// ローディング終了
- (void)stopLoadingView:(NSInteger)placeIndex;

@end

@implementation HokutosaiSchedulesViewController

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
    
    // リクエストタスク初期化
    requestTasks = [[HokutosaiApiRequestTasksQueue alloc] init];
    
    // タイムテーブルのオフセット初期化
    currentTimetableOffset = CGPointZero;
    
    // イベントデータ初期化
    eventsDatas = [NSMutableDictionary dictionaryWithCapacity:4];
    
    // タイムテーブルのアイテムリスト初期化
    timetablesItems = [NSMutableDictionary dictionaryWithCapacity:4];
    
    // 日付の項目を初期化
    dateSections = @[@"2014-05-16", @"2014-05-17", @"2014-05-18"];
    
    // 日付の項目を設定
    NSString *today = [HokutosaiDateConvert stringFromNSDate:[NSDate date] format:@"yyyy-MM-dd"];
    
    for (NSInteger i = 0; i < dateSections.count; ++i) {
        if ([today isEqualToString:dateSections[i]]) {
            // 日付の項目を合わせる
            _dateSectionsControl.selectedSegmentIndex = i;
            // 時刻を合わせる
            currentTimetableOffset = [self timetableNowScrollOffset];
            break;
        }
    }
    
    // 日付の項目の配色設定
    _dateSectionsControl.tintColor = [HokutosaiUIColor hokutosaiColor];
    
    // スワイプビューの背景色設定
    _timetablesSwipeView.backgroundColor = [HokutosaiUIColor colorWithRed:220 green:220 blue:220];
    
    // スワイプビューのデリゲート先設定
    _timetablesSwipeView.swipeViewDelegate = self;
    
    // 場所のページコントロールをスワイプビューに設定
    [_timetablesSwipeView setPageControl:_placesPageControl];
    
    // タイマー作成
    updateTimetablesStatusTimer = [[HokutosaiTimer alloc] initWithTimeInterval:IntervalOfUpdateTimetablesStatus target:self selector:@selector(updateTimetablesStatus) repeats:YES];
    
    // 時間軸生成
    [self generateTimeAxis];
    
    // タイムテーブル更新
    [self updateTimetables];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateTimetablesStatus];
    
    [super viewDidAppear:animated];
}

// タイムテーブルを更新する
- (void)updateTimetables
{
    // ページコントロールを隠す
    _placesPageControl.hidden = YES;
    _placeLabel.hidden = YES;
    
    // 場所リストを取得するリクエストを生成
    HokutosaiApiRequestParameters *paramsOfEventsPlaces = [[HokutosaiApiRequestParameters alloc] init];
    [paramsOfEventsPlaces setValueWithString:dateSections[_dateSectionsControl.selectedSegmentIndex] forKey:@"date"];
    HokutosaiApiGetRequest *requestEventsPlaces = [HokutosaiApiGetRequest requestWithEndpointPath:@"events/places" queryParameters:paramsOfEventsPlaces];
    
    // ローディングビュー初期化
    [self initLoadingView];
    
    // リクエスト実行
    [requestTasks enqueueRequest:requestEventsPlaces receiveData:^(id jsonArray) {
        // 場所データ設定
        placesSections = jsonArray;
        
        if (placesSections.count < 1) {
            return;
        }
        
        // ページコントロール各種設定
        _placesPageControl.numberOfPages = placesSections.count;
        _placesPageControl.hidden = NO;
        _placeLabel.hidden = NO;
        
        // 場所名設定
        _placeLabel.text = JsonValue(placesSections.firstObject[@"name"]);
        
        // タイムテーブル生成
        [self generateTimetables];
        
        // 全てのページのローディングビューを開始
        [self startLoadingView];
        
        // 現在のページのデータ更新
        [self updateEventsDatasAtPlaceIndex:_timetablesSwipeView.currentPage];
    }];
}

// イベントデータを更新する
- (void)updateEventsDatasAtPlaceIndex:(NSInteger)placeIndex
{
    // スケジュールを取得するリクエストを生成
    HokutosaiApiRequestParameters *paramsOfSchedules = [[HokutosaiApiRequestParameters alloc] init];
    [paramsOfSchedules setValueWithString:dateSections[_dateSectionsControl.selectedSegmentIndex] forKey:@"date"];
    [paramsOfSchedules setValueWithNumber:placesSections[placeIndex][@"place_id"] forKey:@"place_id"];
    HokutosaiApiGetRequest *requestSchedules = [HokutosaiApiGetRequest requestWithEndpointPath:@"events/schedule" queryParameters:paramsOfSchedules];
    
    // リクエスト実行
    [requestTasks enqueueRequest:requestSchedules receiveData:^(id jsonArray) {
        // イベントデータ追加
        [eventsDatas setValue:jsonArray forKey:[NSString stringWithFormat:@"%d", (int)placeIndex]];
        // イベントアイテム生成
        [self generateItems:jsonArray forTimetableIndex:placeIndex];
        // オフセット調整
        [self setTimetableOffset:currentTimetableOffset animated:NO];
    } complete:^() {
        // ローディング終了
        [self stopLoadingView:placeIndex];
        // スワイプ解禁
        _timetablesSwipeView.scrollEnabled = YES;
        // タイムテーブルのステータスを更新するタイマーを開始
        [updateTimetablesStatusTimer start];
    }];
}

// 時間軸を生成する
- (void)generateTimeAxis
{
    // フレーム
    CGRect frameOfSchedulesTimeAxis = _timeAxisScrollView.frame;
    frameOfSchedulesTimeAxis.origin = CGPointMake(0.0, 0.0);
    
    // 時間軸生成
    HokutosaiSchedulesTimeAxis *timeAxis = [[HokutosaiSchedulesTimeAxis alloc] initWithFrame:frameOfSchedulesTimeAxis timeLabelColor:[UIColor whiteColor]];
    [_timeAxisScrollView addSubview:timeAxis];
    _timeAxisScrollView.contentSize = timeAxis.frame.size;
    _timeAxisScrollView.backgroundColor = [HokutosaiUIColor tnctBlueColor];
    
    // スクロールインセット調整
    _timeAxisScrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, [HokutosaiUIUtility tabBarHeight:self], 0.0);
    
    // 各種設定
    _timeAxisScrollView.delegate = self;
    _timeAxisScrollView.tag = 0;
}

// タイムテーブルを生成する
- (void)generateTimetables
{
    timetableViews = [NSMutableArray arrayWithCapacity:3];
    
    UIEdgeInsets timetableInset = UIEdgeInsetsMake(0.0, 0.0, [HokutosaiUIUtility tabBarHeight:self], 0.0);
    
    [_timetablesSwipeView setPages:placesSections.count generator:^(NSInteger index, CGRect frame) {
        // フレーム調整
        frame.origin = CGPointMake(frame.origin.x, 0.0);
        // スクロールビュー生成
        UIScrollView *timetable = [[UIScrollView alloc] initWithFrame:frame];
        timetable.backgroundColor = [UIColor clearColor];
        
        // タグを設定
        timetable.tag = index + 1;
        
        // デリゲート先設定
        timetable.delegate = self;
        
        // コンテントサイズ設定
        timetable.contentSize = CGSizeMake(timetable.frame.size.width, [HokutosaiSchedulesTimeAxis height]);
        
        // インセット設定
        timetable.contentInset = timetableInset;
        timetable.scrollIndicatorInsets = timetableInset;
        
        // 時間の指標ライン生成
        [self generateTimeIndicatorLines:timetable];
        
        // 追加
        [timetableViews addObject:timetable];
        
        return timetable;
    }];
}

// 時間の指標ラインを生成する
- (void)generateTimeIndicatorLines:(UIScrollView*)timetable
{
    CGFloat heightOf30Min = [HokutosaiSchedulesTimeAxis heightOf10min] * 3;
    CGFloat margine = [HokutosaiSchedulesTimeAxis topAndBottomMargine];
    
    // 30分毎にラインを追加
    UIView *indicator;
    CGRect frameOfIndicator = CGRectMake(0, 0, timetable.frame.size.width, 0.5);
    int count = [HokutosaiSchedulesTimeAxis numberOfDisplayedTime] * 2;
    for (int i = 0; i <= count ; ++i) {
        frameOfIndicator.origin = CGPointMake(0, margine + (heightOf30Min * i));
        indicator = [[UIView alloc] initWithFrame:frameOfIndicator];
        indicator.backgroundColor = [UIColor lightGrayColor];
        [timetable addSubview:indicator];
    }
}

// 指定したイベントデータリストでタイムテーブルのアイテムを生成する
- (void)generateItems:(NSArray *)eventsArray forTimetableIndex:(NSInteger)index
{
    CGRect frameOfItem;
    NSDate *startTime;
    NSDate *endTime;
    CGFloat top;
    CGFloat bottom;
    NSDictionary *event;
    HokutosaiSchedulesTimetableItem *item;
    HokutosaiTaggedTapGestureRecognizer *tapGesture;
    
    // タイムテーブルを取り出す
    UIScrollView *timetable = timetableViews[index];
    
    // アイテム配列を作成
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:eventsArray.count];
    
    // 現在時刻を取得
    NSDate *nowDate = [NSDate date];
    
    for (NSInteger i = 0; i < eventsArray.count; ++i) {
        // イベントデータを取り出す
        event = eventsArray[i];
        
        // 開始時刻
         startTime = [HokutosaiDateConvert dateFromHokutosaiApiTime:JsonValue(event[@"start_time"])];
        // 終了時刻
         endTime = [HokutosaiDateConvert dateFromHokutosaiApiTime:JsonValue(event[@"end_time"])];
        
        // フレーム生成
        top = [HokutosaiSchedulesTimeAxis verticalPositionAtDate:startTime];
        bottom = [HokutosaiSchedulesTimeAxis verticalPositionAtDate:endTime];
        frameOfItem.origin = CGPointMake(5, top);
        frameOfItem.size = CGSizeMake(timetable.frame.size.width - 10, bottom - top);
        
        // アイテム生成
        item = [[HokutosaiSchedulesTimetableItem alloc] initWithFrame:frameOfItem title:JsonValue(event[@"title"]) startTime:startTime endTime:endTime detail:JsonValue(event[@"detail"])];
        
        // ユーザーインタラクティブを許可
        item.userInteractionEnabled = YES;
        
        // タップジェスチャレコグナイザを追加
        tapGesture = [[HokutosaiTaggedTapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedEventItem:)];
        tapGesture.tag = i;
        [item addGestureRecognizer:tapGesture];
        
        // 現在開催中でないか確認
        if ([HokutosaiSchedulesViewController theEventBeingHeld:event at:nowDate]) {
            [item setStatus:HokutosaiSchedulesTimetableItemStatusNow];
        }
        // 通知登録済みでないか確認
        else if ([HokutosaiEventsNotification eventIsRegistered:event[@"event_id"]]) {
            [item setStatus:HokutosaiSchedulesTimetableItemStatusRegisterNotification];
        }
        
        // アイテムリストに追加
        [itemArray addObject:item];
        
        // タイムテーブルに追加
        [timetable addSubview:item];
    }
    
    // アイテムリストに追加
    [timetablesItems setValue:itemArray forKey:[NSString stringWithFormat:@"%d", (int)index]];
}

// タイムテーブルをクリアする
- (void)clearTimetables
{
    // イベントデータの削除
    [eventsDatas removeAllObjects];
    
    // アイテムをアイテムリストから削除
    [timetablesItems removeAllObjects];
    
    // タイムテーブルをスワイプビューから削除
    [_timetablesSwipeView removeAllPages];
    
    // タイムテーブルを配列から削除
    [timetableViews removeAllObjects];
    timetableViews = nil;
}

// スワイプビューがスワイプされている際
- (void)swipeViewDidSwipe:(HokutosaiSwipeView *)swipeView
{
    _placeLabel.text = JsonValue(placesSections[swipeView.currentPage][@"name"]);
}

// スワイプが完了した際
- (void)swipeViewDidEndDecelerating:(HokutosaiSwipeView *)swipeView
{
    // イベントデータが未取得であれば取得する
    if (eventsDatas[[NSString stringWithFormat:@"%d", (int)swipeView.currentPage]] == nil) {
        [self updateEventsDatasAtPlaceIndex:swipeView.currentPage];
    }
}

// 垂直スクロール中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger timetablesCount = timetableViews.count;
    
    if (scrollView.tag == 0) {
        // オフセット取得
        currentTimetableOffset = _timeAxisScrollView.contentOffset;
        
        // オフセットを調整
        for (UIScrollView *timetable in timetableViews) {
            [timetable setContentOffset:currentTimetableOffset];
        }
    }
    else {
        // オフセットを取得
        currentTimetableOffset = [timetableViews[scrollView.tag - 1] contentOffset];
        
        // 時間軸のオフセットを調整
        _timeAxisScrollView.contentOffset = currentTimetableOffset;
        
        // スクロール中のタイムテーブルを除いてオフセットを調整
        NSInteger count = scrollView.tag - 1 + timetablesCount;
        for (NSInteger i = scrollView.tag; i < count; ++i) {
            [timetableViews[(i % timetablesCount)] setContentOffset:currentTimetableOffset];
        }
    }
}

// タイムテーブルのスクロールオフセットを設定する
- (void)setTimetableOffset:(CGPoint)offset animated:(BOOL)animated
{
    // 時間軸をのオフセットを調整
    [_timeAxisScrollView setContentOffset:offset animated:animated];
    
    // アニメーションでなければタイムテーブルのオフセットを調整
    if (!animated) {
        for (UIScrollView *timetable in timetableViews) {
            [timetable setContentOffset:offset];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 日付の項目が変更された際
- (IBAction)changedDateSectionsControl:(UISegmentedControl *)sender
{
    // リクエストタスクを全クリ
    [requestTasks removeAllTasks];
    
    // タイムテーブルステータスの更新を停止
    [updateTimetablesStatusTimer stop];
    
    // スワイプ禁止
    _timetablesSwipeView.scrollEnabled = NO;
    
    // タイムテーブルクリア
    [self clearTimetables];
    
    // タイムテーブル更新
    [self updateTimetables];
}

// Nowボタンがタップされた際
- (IBAction)tappedNowButton:(id)sender
{
    CGPoint nowOffset = [self timetableNowScrollOffset];
    
    [self setTimetableOffset:nowOffset animated:YES];
}

// イベントアイテムがタップされた際
- (void)tappedEventItem:(HokutosaiTaggedTapGestureRecognizer*)gesture
{
    NSDictionary *event = eventsDatas[[NSString stringWithFormat:@"%d", (int)_timetablesSwipeView.currentPage]][gesture.tag ];
    [self performSegueWithIdentifier:segueToEventsDetailIdentifier sender:event];
}

// 現在時刻に合うタイムテーブルのスクロールオフセットを取得する
- (CGPoint)timetableNowScrollOffset
{
    CGFloat verticalOffset = [HokutosaiSchedulesTimeAxis verticalPositionAtDate:[NSDate date]];
    
    CGFloat verticalOffsetMax = [HokutosaiSchedulesTimeAxis height] - _timeAxisScrollView.frame.size.height + [HokutosaiUIUtility tabBarHeight:self];
    
    // オフセットが最大値を超えていればオフセットを最大値に設定
    if (verticalOffset > verticalOffsetMax) {
        verticalOffset = verticalOffsetMax;
    }
    
    return  CGPointMake(0, verticalOffset);
}

// タイムテーブルのステータスを更新する
- (void)updateTimetablesStatus
{
    // 現在時刻
    NSDate *nowDate = [NSDate date];
    
    for (NSInteger i = 0; i < eventsDatas.count; ++i) {
        // イベント配列を取り出す
        NSArray *eventsArray = eventsDatas[[NSString stringWithFormat:@"%d", (int)i]];
        // イベント配列が存在すれば
        if (eventsArray) {
            // タイムテーブルアイテム配列を取り出す
            NSArray *itemArray = timetablesItems[[NSString stringWithFormat:@"%d", (int)i]];
            for (NSInteger j = 0; j < eventsArray.count; ++j) {
                // アイテムを取り出す
                HokutosaiSchedulesTimetableItem *item = itemArray[j];
                // 現在開催中
                if ([HokutosaiSchedulesViewController theEventBeingHeld:eventsArray[j] at:nowDate]) {
                    [item setStatus:HokutosaiSchedulesTimetableItemStatusNow];
                }
                // 通知登録済み
                else if ([HokutosaiEventsNotification eventIsRegistered:eventsArray[j][@"event_id"]]) {
                    [item setStatus:HokutosaiSchedulesTimetableItemStatusRegisterNotification];
                }
                // ノーマル
                else {
                    [item setStatus:HokutosaiSchedulesTimetableItemStatusNormal];
                }
            }
        }
    }
}

// 指定したイベントが現在開催中であるかどうかを調べる
+ (BOOL)theEventBeingHeld:(NSDictionary *)event at:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"ja_JP"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
    
    // 開始日時
    NSDate *startDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", JsonValue(event[@"date"]), JsonValue(event[@"start_time"])]];
    // 終了日時
    NSDate *endDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", JsonValue(event[@"date"]), JsonValue(event[@"end_time"])]];
    
    // 指定日時 - 開始日時
    NSComparisonResult startComparison = [date compare:startDate];
    // 指定日時 - 終了日時
    NSComparisonResult endCompararison = [date compare:endDate];
   
    // 判定
    if (startComparison == NSOrderedSame || (startComparison == NSOrderedDescending && endCompararison == NSOrderedAscending)) {
        return YES;
    }
    
    return NO;
}

// スケジュールビューコントローラーを最新の状態にする
- (void)updateSchedulesViewController
{
    if (eventsDatas) {
        [self updateTimetablesStatus];
    }
}

// ローディング初期化
- (void)initLoadingView
{
    // ローディングビューが存在すれば全て削除
    if (loadingViews) {
        for (NSInteger i = 0; i < loadingViews.count; ++i) {
            [self stopLoadingView:i];
        }
    } else {
        // ローディングビューリスト初期化
        loadingViews = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    
    // ローディングビュー生成
    HokutosaiLoadingView *loadingView = [[HokutosaiLoadingView alloc] initWithFrame:[_timetablesSwipeView frameOfPage:0] indicatorVerticalOffset:-[HokutosaiUIUtility tabBarHeight:self]];
    
    // 追加
    [loadingViews setValue:loadingView forKey:@"0"];
    
    // スワイプビューに追加
    [_timetablesSwipeView addSubview:loadingView];
    
    // ローディング開始
    [loadingView startLoading];
}

// ローディング開始
- (void)startLoadingView
{
    // 0番目のローディングビューを最前面に配置
    [_timetablesSwipeView bringSubviewToFront:loadingViews[@"0"]];
    
    HokutosaiLoadingView *loadingView;
    
    for (NSInteger i = 1; i < timetableViews.count; ++i) {
        // ローディングビュー生成
        loadingView = [[HokutosaiLoadingView alloc] initWithFrame:[timetableViews[i] frame] indicatorVerticalOffset:-[HokutosaiUIUtility tabBarHeight:self]];
        // 追加
        [loadingViews setValue:loadingView forKey:[NSString stringWithFormat:@"%d", (int)i]];
        // スワイプビューに追加
        [_timetablesSwipeView addSubview:loadingView];
        // ローディング開始
        [loadingView startLoading];
    }
}

// ローディング終了
- (void)stopLoadingView:(NSInteger)placeIndex
{
    NSString *index = [NSString stringWithFormat:@"%d", (int)placeIndex];
    
    // スワイプビューから削除
    [(HokutosaiLoadingView*)loadingViews[index] stopLoading:YES];
    
    // 削除
    [loadingViews removeObjectForKey:index];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:segueToEventsDetailIdentifier]) {
        HokutosaiEventsDetailViewController *destination = segue.destinationViewController;
        [destination setEventData:sender requireReload:NO];
    }
}

- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight
{
    // 時間軸
    if (_timeAxisScrollView) {
        // フレーム調整
        CGRect frameOfTimeAxisScrollView = _timeAxisScrollView.frame;
        frameOfTimeAxisScrollView.size = CGSizeMake(frameOfTimeAxisScrollView.size.width, screenHeight - frameOfTimeAxisScrollView.origin.y);
        _timeAxisScrollView.frame = frameOfTimeAxisScrollView;
         // Autosizingを削除
        _timeAxisScrollView.autoresizingMask = UIViewAutoresizingNone;
    }
    
    // スワイプビュー
    if (_timetablesSwipeView) {
        // フレーム調整
        CGRect frameOfTimetableSwipeView = _timetablesSwipeView.frame;
        frameOfTimetableSwipeView.size = CGSizeMake(frameOfTimetableSwipeView.size.width, screenHeight - frameOfTimetableSwipeView.origin.y);
        _timetablesSwipeView.frame = frameOfTimetableSwipeView;
        // Autosizingを削除
        _timetablesSwipeView.autoresizingMask =  UIViewAutoresizingNone;
    }
    
    // タイムテーブル
    if (timetableViews) {
        for (NSInteger i = 0; i < timetableViews.count; ++i) {
            [timetableViews[i] setFrame:[_timetablesSwipeView frameOfPage:i]];
        }
    }
}

@end
