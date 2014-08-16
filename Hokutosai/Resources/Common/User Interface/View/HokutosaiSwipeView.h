//
//  HokutosaiSwipeView.h
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/04/04.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HokutosaiSwipeView;

// HokutosaiSwipeViewのデリゲート
@protocol HokutosaiSwipeViewDelegate

@required

// スワイプしている際に発生するイベント
- (void)swipeViewDidSwipe:(HokutosaiSwipeView *)swipeView;

// スワイプが完了した際に発生するイベント
- (void)swipeViewDidEndDecelerating:(HokutosaiSwipeView *)swipeView;

@end

// スワイプでページ間を移動するUIビュー
@interface HokutosaiSwipeView : UIScrollView <UIScrollViewDelegate>
{
    // ページコントロール
    UIPageControl *_pageControl;
    // ページ数
    NSInteger _pageCount;
    // 現在のページ
    NSInteger _currentPage;
}

// ページ数
@property (nonatomic, readonly, getter = getPageCount) NSInteger pageCount;

// 現在のページ
@property (nonatomic, readonly, getter = getCurrentPage) NSInteger currentPage;

// デリゲート
@property (nonatomic, weak) id <HokutosaiSwipeViewDelegate> swipeViewDelegate;

// イニシャライザ ページコントロールを使用する際はpageControlを指定する
- (id)initWithFrame:(CGRect)frame pageControl:(UIPageControl*)pageControl;

// ページコントロールを設定する
- (void)setPageControl:(UIPageControl*)pageControl;

// 指定したページの矩形領域を取得する
- (CGRect)frameOfPage:(NSInteger)index;

// ジェネレーターでビューを生成してページを設定する
- (void)setPages:(NSInteger) pageCount generator:(UIView*(^)(NSInteger, CGRect))generator;

// ページを設定する
- (void)setPages:(NSArray*)views;

// 全てのページを削除する
- (void)removeAllPages;

// 現在のページを設定する
- (void)setCurrentPage:(NSInteger)index;

// 現在のページを先頭のページに設定する
- (void)setCurrentPageToFirst;

// 現在のページを最後尾のページに設定する
- (void)setCurrentPageToLast;

// 指定のページまでオートスワイプさせる
- (void)swipeToPage:(NSInteger)index animated:(BOOL)animated;

// 右方向へ1ページだけオートスワイプさせる
- (void)swipeToRight:(BOOL)animated;

// 左方向へ1ページだけオートスワイプさせる
- (void)swipeToLeft:(BOOL)animated;

// 先頭のページまでオートスワイプさせる
- (void)swipeToFirst:(BOOL)animated;

// 最後尾のページまでオートスワイプさせる
- (void)swipeToLast:(BOOL)animated;

@end
