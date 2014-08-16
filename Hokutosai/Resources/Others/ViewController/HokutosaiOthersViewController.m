//
//  HokutosaiOthersViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/30.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiOthersViewController.h"
#import "HokutosaiWebViewController.h"

// アプリケーションバージョン
static NSString *applicationVersion = @"1.1.0";

// セル識別子
static NSString *cellIdentifier = @"cell";

// セグエ識別子
static NSString *segueToMapsViewIdentifier = @"toMaps";
static NSString *segueToWebViewIdentifier = @"toWebView";
static NSString *segueToCopyrightInformationIdentifier = @"toCopyrightInformation";

@interface HokutosaiOthersViewController ()
{
    NSArray *cells;
    NSArray *sections;
}

- (void)tappedExit:(id)sender;
@end

@implementation HokutosaiOthersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 閉じるボタン
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                   target:self
                                   action:@selector(tappedExit:)];
    
    // ナビゲーションバーに追加
    self.navigationItem.leftBarButtonItem = leftButton;
    
    // セルの登録
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    // セクションの生成
    sections = @[@"", @"北斗祭に関する情報", @"アプリに関する情報"];
    
    // セルの生成
    cells = @[
              /* バージョン情報 */
              @[@{@"title": @"バージョン", @"destination": [NSNull null]}],
              /* 北斗祭に関する情報 */
              @[
                  @{@"title": @"校内マップ", @"destination": @"maps"},
                  @{@"title": @"スクールバス時刻表", @"destination": @"https://www.tnct-hokutosai.info/hokutosai_app/school_bus_timetables.html"},
                  @{@"title": @"北斗祭公式ホームページ", @"destination": @"http://www.nc-toyama.ac.jp/c5/index.php/mcon/ca_life/%E3%82%AD%E3%83%A3%E3%83%B3%E3%83%91%E3%82%B9%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88/%E9%AB%98%E5%B0%82%E7%A5%AD/kousensaih006/"},
                  @{@"title": @"北斗祭公式Twitter", @"destination": @"https://twitter.com/TRY_108restart"}
                ],
              /* アプリに関する情報 */
              @[
                  @{@"title": @"アプリについて", @"destination": @"https://www.tnct-hokutosai.info/hokutosai_app/"},
                  @{@"title": @"北斗祭アプリ公式Twitter", @"destination": @"https://twitter.com/TRY_108app"},
                  @{@"title": @"著作権情報", @"destination": @"copyright"}
                ]
              ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 終了ボタンがタップされた際
- (void)tappedExit:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cells[section] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sections[section];
}

// セルの生成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    // テキスト設定
    cell.textLabel.text = cells[indexPath.section][indexPath.row][@"title"];
    
    // バージョン情報
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.detailTextLabel.text = applicationVersion;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}

// セルがタップされたとき
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id destination = cells[indexPath.section][indexPath.row][@"destination"];
    
    if (destination == nil || destination == [NSNull null]) {
        return;
    }
    
    if ([destination isEqualToString:@"maps"]) {
        [self performSegueWithIdentifier:segueToMapsViewIdentifier sender:nil];
    }
    else if ([destination isEqualToString:@"copyright"]) {
        [self performSegueWithIdentifier:segueToCopyrightInformationIdentifier sender:nil];
    } else {
        [self performSegueWithIdentifier:segueToWebViewIdentifier sender:cells[indexPath.section][indexPath.row]];
    }
}

// 画面遷移の直前
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:segueToWebViewIdentifier]) {
        HokutosaiWebViewController *destination = segue.destinationViewController;
        destination.pageTitle = sender[@"title"];
        destination.pageURL = sender[@"destination"];
    }
}

- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight
{
    
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
