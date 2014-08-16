//
//  HokutosaiSwipeBord.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiSwipeBord.h"

@implementation HokutosaiSwipeBord

// ダミーの先頭ページの矩形領域を取得する
- (CGRect)frameOfDummyFirst
{
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

// ダミーの最後尾ページの矩形領域を取得する
- (CGRect)frameOfDummyLast
{
    return CGRectMake(self.frame.size.width * (_pageCount + 1), 0, self.frame.size.width, self.frame.size.height);
}

// 指定したページの矩形領域を取得する
- (CGRect)frameOfPage:(NSInteger)index
{
    CGRect pageFrame;
    pageFrame.origin = CGPointMake(self.frame.size.width * (index + 1), 0);
    pageFrame.size = self.frame.size;
    
    return pageFrame;
}

// ジェネレーターでビューを生成してページを設定する
- (void)setPages:(NSInteger)pageCount generator:(UIView *(^)(NSInteger, CGRect))generator
{
    // ページ数が1以下のとき
    if (pageCount <= 1) {
        [super setPages:pageCount generator:generator];
        return;
    }
    
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
    self.contentSize = CGSizeMake(viewFrame.size.width * (_pageCount + 2), viewFrame.size.height);
    
    // ダミーのコンテンツ(ループ最後尾に相当)を先頭に配置
    CGRect firstFrame = CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height);
    UIView* dummyFirst = generator((_pageCount - 1), firstFrame);
    [self addSubview:dummyFirst];
    
    // ページ生成
    CGRect pageFrame;
    for (int i=0; i < _pageCount ; ++i)
    {
        // 現在のページの矩形領域を設定
        pageFrame.origin = CGPointMake(viewFrame.size.width * (i + 1), 0);
        pageFrame.size = viewFrame.size;
        
        // ページをジェネレートしてサブビューに追加
        [self addSubview:generator(i, pageFrame)];
    }
    
    // ダミーのコンテンツ(ループ先頭に相当)を最後尾に配置
    CGRect lastFrame = CGRectMake(viewFrame.size.width * (_pageCount + 1), 0, viewFrame.size.width, viewFrame.size.height);
    UIView* dummyLast = generator(0, lastFrame);
    [self addSubview:dummyLast];
        
    // 現在のページを先頭へ
    [self setCurrentPageToFirst];
}

// ページを設定する
- (void)setPages:(NSArray*)views
{
    [NSException raise:@"InvalidMethodException" format:@"%s is not implemented.", __FUNCTION__];
}

// 現在のコンテンツのページを設定する
- (void)setCurrentPage:(NSInteger)index
{
    // ページ数が1以下の時
    if (_pageCount <= 1) {
        [super setCurrentPage:index];
        return;
    }
    
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
    self.contentOffset = CGPointMake(self.frame.size.width * (_currentPage + 1), 0);
}

// 指定のページまでオートスワイプさせる
- (void)swipeToPage:(NSInteger)index animated:(BOOL)animated
{
    // ページ数が1以下の時
    if (_pageCount <= 1) {
        return;
    }
    
    // 先頭から左(最後尾)にスワイプ
    if (index < 0) {
        // オフセットをダミーの最後尾に移動
        self.contentOffset = CGPointMake(self.frame.size.width * (_pageCount + 1), 0);
        // 最後尾へアニメーションで移動
        [self setContentOffset:CGPointMake(self.frame.size.width * _pageCount, 0) animated:animated];
    }
    // 最後尾から右(先頭)にスワイプ
    else if (index >= _pageCount) {
        // オフセットをダミーの先頭に移動
        self.contentOffset = CGPointMake(0, 0);
        // 先頭へアニメーションで移動
        [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:animated];
    }
    // 通常のスワイプ
    else {
        [self setContentOffset:CGPointMake(self.frame.size.width * (index + 1), 0) animated:animated];
    }
}

// スワイプしている際
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidht = self.frame.size.width;
    
    int pureCurrentPage = floor((self.contentOffset.x - pageWidht/2) / pageWidht) + 1;
    
    if (pureCurrentPage <= 0) {
        // スワイプ中のページがダミーの先頭であれば現在のページを最後尾にする
        _currentPage = _pageCount - 1;
    } else if (pureCurrentPage >= (_pageCount + 1)) {
        // スワイプ中のページがダミーの最後尾であれば現在のページを先頭にする
        _currentPage = 0;
    } else {
        _currentPage = pureCurrentPage - 1;
    }
    
    // ページコントロールの現在のページを更新
    if (_pageControl != nil) {
        _pageControl.currentPage = _currentPage;
    }
    
    // デリゲート呼び出し
    if (self.swipeViewDelegate != nil) {
        [self.swipeViewDelegate swipeViewDidSwipe:self];
    }
}

// スクロールが完了した際
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidht = self.frame.size.width;
    
    int pureCurrentPage = floor((self.contentOffset.x - pageWidht/2) / pageWidht) + 1;
    
    // スワイプされたページがダミーの先頭であれば最後尾に移動
    if (pureCurrentPage <= 0) {
        self.contentOffset = CGPointMake(self.frame.size.width * _pageCount, 0);
    }
    // スワイプされたページがダミーの最後尾であれば先頭に移動
    else if (pureCurrentPage >= _pageCount + 1) {
        self.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
    
    // デリゲート呼び出し
    if (self.swipeViewDelegate != nil) {
        [self.swipeViewDelegate swipeViewDidEndDecelerating:self];
    }
}

@end
