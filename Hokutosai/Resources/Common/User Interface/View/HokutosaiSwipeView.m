//
//  HokutosaiSwipeView.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiSwipeView.h"

@interface HokutosaiSwipeView ()

// 共通の初期化処理
- (void)commonInit:(UIPageControl*)pageControl;

@end

@implementation HokutosaiSwipeView

// イニシャライザ For InterfaceBuilder
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // 共通の初期化処理
        [self commonInit:nil];
    }
    
    return self;
}

// イニシャライザ 領域指定
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // 共通の初期化処理
        [self commonInit:nil];
    }
    
    return self;
    
}

// イニシャライザ 領域指定/ページコントロール指定
- (id)initWithFrame:(CGRect)frame pageControl:(UIPageControl *)pageControl
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // 共通の初期化処理
        [self commonInit:pageControl];
    }
    
    return self;
}

// 共通の初期化処理
- (void)commonInit:(UIPageControl*)pageControl
{
    // フィールド初期化
    _pageCount = 0;
    _pageControl = pageControl;
    
    // スクロールビューのデリゲート設定
    self.delegate = self;
    
    // スクロール可能
    self.scrollEnabled = YES;
    
    // ページ(スワイプ)でスクロールする
    self.pagingEnabled = YES;
    
    // スクローラーの非表示
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    // ページコントロールのページ数設定
    if (_pageControl != nil) {
        _pageControl.numberOfPages = _pageCount;
    }
    
    // 現在のコンテンツのページを先頭にする
    [self setCurrentPageToFirst];
}

// ページ数を取得する
- (NSInteger)getPageCount
{
    return _pageCount;
}

// 現在のページを取得する
- (NSInteger)getCurrentPage
{
    return _currentPage;
}

// ページコントロールを設定する
- (void)setPageControl:(UIPageControl *)pageControl
{
    _pageControl = pageControl;
    
    _pageControl.numberOfPages = _pageCount;
    _pageControl.currentPage = _currentPage;
}

// 指定したページの矩形領域を取得する
- (CGRect)frameOfPage:(NSInteger)index
{
    CGRect pageFrame;
    pageFrame.origin = CGPointMake(self.frame.size.width * index, 0);
    pageFrame.size = self.frame.size;
    
    return pageFrame;
}

// ジェネレーターでビューを生成してページを設定する
- (void)setPages:(NSInteger)pageCount generator:(UIView *(^)(NSInteger, CGRect))generator
{
    // 全てのページを削除する
    if (_pageCount > 0) {
        [self removeAllPages];
    }
    
    // ページ数設定
    _pageCount = pageCount;
    
    // ページコントロールのページ数設定
    if (_pageControl != nil) {
        _pageControl.numberOfPages = _pageCount;
    }
    
    // ビューの領域
    CGRect viewFrame = self.frame;
    
    // スクロールするコンテンツの縦横のサイズ
    self.contentSize = CGSizeMake(viewFrame.size.width * _pageCount, 0.0);
    
    CGRect pageFrame;
    
    // ページ生成
    for (int i=0; i < _pageCount ; ++i)
    {
        // 現在のページの矩形領域を設定
        pageFrame.origin = CGPointMake(viewFrame.size.width * i, 0);
        pageFrame.size = viewFrame.size;
        
        // ページをジェネレートしてサブビューに追加
        [self addSubview:generator(i, pageFrame)];
    }
    
    // 現在のページを先頭にする
    [self setCurrentPageToFirst];
}

// ページを設定する
- (void)setPages:(NSArray *)views
{
    // 全てのページを削除する
    if (_pageCount > 0) {
        [self removeAllPages];
    }
    
    // ページ数設定
    _pageCount = views.count;
    
    // ページコントロールのページ数設定
    if (_pageControl != nil) {
        _pageControl.numberOfPages = _pageCount;
    }
    
    // スクロールするコンテンツの縦横のサイズ
    self.contentSize = CGSizeMake(self.frame.size.width * _pageCount, 0.0);

    // 現在のページ
    UIView *currentPageView;
    
    // ページ生成
    for (int i=0; i < _pageCount ; ++i)
    {
        currentPageView = views[i];
        
        // 現在のページの矩形領域を設定
        currentPageView.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
        
        // ページをサブビューに追加
        [self addSubview:currentPageView];
    }
    
    // 現在のページを先頭にする
    [self setCurrentPageToFirst];
}

// 全てのページを削除する
- (void)removeAllPages
{
    _pageCount = 0;
    
    if (_pageControl != nil) {
        _pageControl.numberOfPages = _pageCount;
    }
    
    for (UIView *page in self.subviews) {
        [page removeFromSuperview];
    }
}

// 現在のコンテンツのページを設定する
- (void)setCurrentPage:(NSInteger)index
{
    // 現在のページを更新
    if (index < 0) {
        _currentPage = 0;
    } else if (index >= _pageCount) {
        _currentPage = _pageCount - 1;
    } else {
        _currentPage = index;
    }
    
    // ページコントロールの現在のページを更新
    if (_pageControl != nil) {
        _pageControl.currentPage = _currentPage;
    }
    
    // スクロールビューのオフセット更新
    self.contentOffset = CGPointMake(self.frame.size.width * _currentPage, 0);
}

// 現在のコンテンツのページを先頭に設定する
- (void)setCurrentPageToFirst
{
    [self setCurrentPage:0];
}

// 現在のコンテンツのページを最後尾に設定する
- (void)setCurrentPageToLast
{
    [self setCurrentPage:(_pageCount - 1)];
}

// 指定のページまでオートスワイプさせる
- (void)swipeToPage:(NSInteger)index animated:(BOOL)animated
{
    if (index < 0) {
        [self setContentOffset:CGPointMake(0, 0) animated:animated];
    } else if (index >= _pageCount) {
        [self setContentOffset:CGPointMake(self.frame.size.width * (_pageCount - 1), 0) animated:animated];
    } else {
        [self setContentOffset:CGPointMake(self.frame.size.width * index, 0) animated:animated];
    }
}

// 右方向へ1ページだけオートスワイプさせる
- (void)swipeToRight:(BOOL)animated
{
    [self swipeToPage:(_currentPage + 1) animated:animated];
}

// 左方向へ1ページだけオートスワイプさせる
- (void)swipeToLeft:(BOOL)animated
{
    [self swipeToPage:(_currentPage - 1) animated:animated];
}

// 先頭のページまでオートスワイプさせる
- (void)swipeToFirst:(BOOL)animated
{
    [self swipeToPage:0 animated:animated];
}

// 最後尾のページまでオートスワイプさせる
- (void)swipeToLast:(BOOL)animated
{
    [self swipeToPage:(_pageCount - 1) animated:animated];
}

// スワイプしている際
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidht = self.frame.size.width;
    
    // 現在のページを計算
    NSInteger currentPage = floor((self.contentOffset.x - pageWidht/2) / pageWidht) + 1;
    
    // 補正
    if (currentPage < 0) {
        currentPage = 0;
    } else if (currentPage >= _pageCount) {
        currentPage = _pageCount - 1;
    }
    
    // 現在のページを更新
    _currentPage = currentPage;
    
    // ページコントロールの現在のページを更新
    if (_pageControl != nil) {
        _pageControl.currentPage = _currentPage;
    }
    
    // デリゲート呼び出し
    if (_swipeViewDelegate != nil) {
        [_swipeViewDelegate swipeViewDidSwipe:self];
    }
}

// スクロールが完了した際
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // デリゲート呼び出し
    if (_swipeViewDelegate != nil) {
        [_swipeViewDelegate swipeViewDidEndDecelerating:self];
    }
}

@end
