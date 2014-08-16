//
//  HokutosaiContestsEntrysListViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/11.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <Social/Social.h>
#import "HokutosaiContestsEntrysListViewController.h"
#import "HokutosaiContestsEntrysTableViewCell.h"
#import "HokutosaiURLImagesDictionary.h"
#import "HokutosaiApiGetRequest.h"
#import "HokutosaiApiRequestParameters.h"
#import "HokutosaiApiRequestDemander.h"
#import "HokutosaiContestsEntryDetailViewController.h"

static NSString *cellIdentifier = @"cell";

static NSString *segueToEntryDetailIdentifier = @"toEntryDetail";

@interface HokutosaiContestsEntrysListViewController ()
{
    // 部門ID
    NSString *_sectionId;
    
    // エントリーデータ
    NSArray *entrysDatas;
    
    // イメージキャッシュ
    HokutosaiURLImagesDictionary *imagesCache;
    
    // 優勝を表すアイコン
    UIImage *championIcon;
}

- (void)updateEntrysDatas;
@end

@implementation HokutosaiContestsEntrysListViewController

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
    
    // イメージキャッシュ生成
    imagesCache = [[HokutosaiURLImagesDictionary alloc] init];
    
    // 優勝アイコンロード
    championIcon = [UIImage imageNamed:@"crown_60.png"];
    
    // 共有ボタンの生成
    [self generateShareButton];
    
    // セルの登録
    [self.tableView registerClass:[HokutosaiContestsEntrysTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    // セルの高さを設定
    self.tableView.rowHeight = [HokutosaiContestsEntrysTableViewCell height];
    
    // テーブルの境界線を画面左端から描画する
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // エントリーデータ更新
    [self updateEntrysDatas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [imagesCache clearCashe];
}

- (void)setSectionId:(NSString *)sectionId sectionName:(NSString *)sectionName
{
    _sectionId = sectionId;
    self.navigationItem.title = sectionName;
}

// エントリーデータを更新する
- (void)updateEntrysDatas
{
    // リクエスト生成
    HokutosaiApiRequestParameters *params = [[HokutosaiApiRequestParameters alloc] init];
    [params setValueWithString:_sectionId forKey:@"section_id"];
    HokutosaiApiGetRequest *request = [HokutosaiApiGetRequest requestWithEndpointPath:@"contests/entrys/list" queryParameters:params];
    HokutosaiApiRequestDemander *requestDemander = [[HokutosaiApiRequestDemander alloc] initWithRequest:request];
    
    // リクエスト実行
    [requestDemander responseAsync:^(id json) {
        entrysDatas = json;
        [self.tableView reloadData];
    } receiveError:^(NSInteger errorCode) {
        // 非公開のとき
        if ((errorCode/100) == 403) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"現在、エントリー一覧は公開されていません。" message:@"公開までしばらくお待ちください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return YES;
        }
        
        return NO;
    }];
}

// 共有ボタンを生成する
- (void)generateShareButton
{
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(shareWithTwitter:)];
    
    self.navigationItem.rightBarButtonItem = shareButton;
}

// ツイートする
- (void)shareWithTwitter:(id)sender
{
    SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitterPostVC setInitialText:[NSString stringWithFormat:@"%@ #北斗祭 ", self.navigationItem.title]];
    [self presentViewController:twitterPostVC animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return entrysDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HokutosaiContestsEntrysTableViewCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HokutosaiContestsEntrysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // エントリーを取り出す
    NSDictionary *entry = entrysDatas[indexPath.row];
    
    // イラスト
    NSString *imageResource = JsonValue(entry[@"image_resource"]);
    
    // 優勝者
    UIImage *champion = nil;
    if (JsonValueIsNotNull(entry[@"result"]) && [entry[@"result"] isEqualToString:@"champion"]) {
        champion = championIcon;
    }

    // セルを更新
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
    [self performSegueWithIdentifier:segueToEntryDetailIdentifier sender:entrysDatas[indexPath.row]];
    
    // セルの選択を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // エントリー詳細
    if ([segue.identifier isEqualToString:segueToEntryDetailIdentifier]) {
        HokutosaiContestsEntryDetailViewController* viewController = segue.destinationViewController;
        [viewController setEntryData:sender imageCache:imagesCache title:@"エントリー"];
    }
}

- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight
{
    
}

@end
