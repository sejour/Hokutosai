//
//  HokutosaiMapsViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/14.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiMapsViewController.h"
#import "HokutosaiUIUtility.h"

@interface HokutosaiMapsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)changeFloorSelectControl:(UISegmentedControl *)sender;
@end

@implementation HokutosaiMapsViewController

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
    
    // 画像ロード
    _imageView.image = [UIImage imageNamed:@"map1.png"];
    
    // スクロールビューのデリゲート先になる
    _scrollView.delegate = self;
    
    // カラー設定
    _scrollView.backgroundColor = [UIColor whiteColor];
    _imageView.backgroundColor = [UIColor clearColor];
    
    // ズームの最小値・最大値設定
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 7;
    
    // スクローラーの表示
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    // ダブルタップ
    UITapGestureRecognizer *doubleTapGestute = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGestute.numberOfTapsRequired = 2;
    
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:doubleTapGestute];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _imageView.image = nil;
}

// スクロールのズーミングイベント用のデリゲートメソッド
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // ズーム操作の対象となるUIViewを返す
    return _imageView;
}

// 拡大する領域を求める
// scale:拡大倍率
// center:拡大領域の中心点
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    // scale倍拡大する = 表示領域を1/scaleにする
    zoomRect.size.height = _scrollView.frame.size.height / scale;
    zoomRect.size.width = _scrollView.frame.size.width / scale;
    
    // 拡大領域の原点を求める
    zoomRect.origin.x = center.x - (zoomRect.size.width /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height/2.0);
    
    return zoomRect;
}

// ダブルタップ
- (void)doubleTap:(UITapGestureRecognizer*)gesture
{
    // 倍率が最大未満であれば
    if (_scrollView.zoomScale < 3) {
        // 新しく設定する倍率を現在の倍率の3倍にする
        float newScale = _scrollView.zoomScale * 3;
        // 拡大する矩形領域を求める
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
        // 拡大する矩形領域へアニメーション付きでズームする
        [_scrollView zoomToRect:zoomRect animated:YES];
    } else {
        // 倍率が最大であれば元のサイズへ戻す
        [_scrollView setZoomScale:1.0 animated:YES];
    }
}

- (IBAction)changeFloorSelectControl:(UISegmentedControl *)sender
{
    // 元のサイズへ戻す
    [_scrollView setZoomScale:1.0 animated:NO];
    
    // 画像を切り替える
    switch (sender.selectedSegmentIndex) {
        case 0:
            _imageView.image = [UIImage imageNamed:@"map1.png"];
            break;
        case 1:
            _imageView.image = [UIImage imageNamed:@"map2.png"];
            break;
        case 2:
            _imageView.image = [UIImage imageNamed:@"map3.png"];
            break;
    }
}

- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight
{
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, screenHeight);
}
@end
