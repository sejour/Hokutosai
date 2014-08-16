//
//  HokutosaiContestsEntryDetailViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/11.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiContestsEntryDetailViewController.h"
#import "HokutosaiStreamingLabel.h"
#import "HokutosaiStackPanel.h"
#import "HokutosaiStackPanelView.h"
#import "HokutosaiApiRequestDemander.h"
#import "HokutosaiUIUtility.h"
#import "HokutosaiUIColor.h"

static NSString *cellIdentifier = @"cell";

@interface HokutosaiContestsEntryDetailViewController ()
{
    // エントリーデータ
    NSDictionary *entryData;
    
    // イメージキャッシュ
    HokutosaiURLImagesDictionary *imagesCache;
    
    // 部門名ビュー
    HokutosaiStackPanelView *sectionView;
    // エントリービュー
    HokutosaiStackPanelView *entryView;
    // プロフィールビュー
    HokutosaiStackPanelView *profileView;
}

- (void)generateSectionView;
- (void)generateEntryView;
- (void)generateProfileView;
@end

@implementation HokutosaiContestsEntryDetailViewController

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
    
    // 部門名ビューを生成
    [self generateSectionView];
    // エントリービューを生成
    [self generateEntryView];
    // プロフィールビューを生成
    [self generateProfileView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [imagesCache clearCashe];
}

// 部門名ビュー
- (void)generateSectionView
{
    CGRect frameOfSectionView = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0.0);
    sectionView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfSectionView];
    [sectionView setTopPadding:10.0 rightPadding:20.0 bottomPadding:5.0 leftPadding:20.0];
    
    // 部門名
    CGRect frameOfSectionNameLabel = CGRectMake(0.0, 0.0, sectionView.widthOfStackPanel, 20.0);
    HokutosaiStreamingLabel *sectionNameLabel = [[HokutosaiStreamingLabel alloc] initWithFrame:frameOfSectionNameLabel];
    [sectionNameLabel setTextFont:[UIFont boldSystemFontOfSize:22.0]];
    sectionNameLabel.backgroundColor = [HokutosaiUIColor hokutosaiColor];
    [sectionNameLabel setText:JsonValue(entryData[@"section_name"])];
    [sectionView addSubview:sectionNameLabel];
    
    // ストリーミング開始
    [sectionNameLabel startStreamingInterval:3.0 speed:33.0];
}

// エントリービュー
- (void)generateEntryView
{
    CGRect frameOfEntryView = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0.0);
    entryView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfEntryView];
    
    // チャンピオンシンボル
    if (JsonValueIsNotNull(entryData[@"result"]) && [entryData[@"result"] isEqualToString:@"champion"]) {
        // パディング設定
        [entryView setTopPadding:0.0 rightPadding:20.0 bottomPadding:0.0 leftPadding:20.0];
        
        // ビュー生成
        UIView *championView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, entryView.widthOfStackPanel, 30.0)];
       
        // アイコン
        UIImageView *championIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, championView.frame.size.height, championView.frame.size.height)];
        championIcon.contentMode = UIViewContentModeScaleAspectFill;
        championIcon.image = [UIImage imageNamed:@"crown_60.png"];
        [championView addSubview:championIcon];
        
        // ラベル
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(championIcon.frame.size.width + 5.0, 0.0, championView.frame.size.width - championIcon.frame.size.width - 5.0, championView.frame.size.height)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:20.0];
        label.text = @"Champion";
        [championView addSubview:label];
        
        // コンテントビューに追加
        [entryView addSubview:championView];
    } else {
        [entryView setTopPadding:5.0 rightPadding:20.0 bottomPadding:0.0 leftPadding:20.0];
    }

    // 出場者名
    {
        UILabel *entryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, entryView.widthOfStackPanel, 22.0)];
        entryNameLabel.textAlignment = NSTextAlignmentLeft;
        entryNameLabel.numberOfLines = 0;
        entryNameLabel.font = [UIFont systemFontOfSize:20.0];
        entryNameLabel.text = JsonValue(entryData[@"entry_name"]);
        [entryNameLabel sizeToFit];
        [entryView addSubview:entryNameLabel verticalSpace:3.0];
    }
    
    // セパレータ
    {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, entryView.widthOfStackPanel, 0.5)];
        separator.backgroundColor = [HokutosaiUIColor colorWithRed:200 green:200 blue:200];
        [entryView addSubview:separator verticalSpace:10.0];
    }
}

// プロフィールビュー
- (void)generateProfileView
{
    CGRect frameOfProfileView = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0.0);
    profileView = [[HokutosaiStackPanelView alloc] initWithFrame:frameOfProfileView];
    [profileView setTopPadding:10.0 rightPadding:20.0 bottomPadding:5.0 leftPadding:20.0];
    
    // 所属見出し
    {
        UILabel *belongHeadline = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, profileView.widthOfStackPanel, 20.0)];
        belongHeadline.textAlignment = NSTextAlignmentLeft;
        belongHeadline.font = [UIFont systemFontOfSize:17.0];
        belongHeadline.text = @"所属";
        [profileView addSubview:belongHeadline];
    }
    
    // 所属
    {
        UILabel *belongLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, profileView.widthOfStackPanel - 10.0, 0.0)];
        belongLabel.textAlignment = NSTextAlignmentLeft;
        belongLabel.numberOfLines = 0;
        belongLabel.font = [UIFont systemFontOfSize:15.0];
        belongLabel.text = JsonValue(entryData[@"belong"]);
        [belongLabel sizeToFit];
        [profileView addSubview:belongLabel verticalSpace:3.0];
    }
    
    // プロフィール見出し
    {
        UILabel *profileHeadline = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, profileView.widthOfStackPanel, 20.0)];
        profileHeadline.textAlignment = NSTextAlignmentLeft;
        profileHeadline.font = [UIFont systemFontOfSize:17.0];
        profileHeadline.text = @"プロフィール";
        [profileView addSubview:profileHeadline verticalSpace:15.0];
    }
    
    // プロフィール
    {
        UILabel *profileLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, profileView.widthOfStackPanel - 10.0, 0.0)];
        profileLabel.textAlignment = NSTextAlignmentLeft;
        profileLabel.numberOfLines = 0;
        profileLabel.font = [UIFont systemFontOfSize:15.0];
        profileLabel.text = JsonValue(entryData[@"profile"]);
        [profileLabel sizeToFit];
        [profileView addSubview:profileLabel verticalSpace:3.0];
    }
    
    // 画像
    if (JsonValueIsNotNull(entryData[@"image_resource"])) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, profileView.widthOfStackPanel, profileView.widthOfStackPanel)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [profileView addSubview:imageView verticalSpace:15.0];
        
        [imagesCache imageWithURL:entryData[@"image_resource"] receive:^(UIImage *image) {
            imageView.image = image;
        }];
    }
}

- (void)setEntryData:(NSDictionary *)data imageCache:(HokutosaiURLImagesDictionary *)cache title:(NSString *)title
{
    entryData = data;
    imagesCache = cache;
    self.navigationItem.title = title;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
    switch (indexPath.row) {
        case 0:
            height = sectionView.frame.size.height;
            break;
        case 1:
            height = entryView.frame.size.height;
            break;
        case 2:
            height = profileView.frame.size.height;
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
            [cell.contentView addSubview:sectionView];
            break;
        case 1:
            [cell.contentView addSubview:entryView];
            break;
        case 2:
            [cell.contentView addSubview:profileView];
            break;
    }
    
    return cell;
}

- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight
{
    
}

@end
