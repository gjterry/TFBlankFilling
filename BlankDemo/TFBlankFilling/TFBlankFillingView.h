//
//  TFBlankFillingView.h
//  BlankDemo
//
//  Created by Terry  on 14-2-17.
//  Copyright (c) 2014年 Terry. All rights reserved.
//

#import "TFBlankInputView.h"

#import <UIKit/UIKit.h>

@protocol TFBlankFillingViewDelegate,TFBlankFillingViewDataSource;

@interface TFBlankFillingView : UIView {
    NSInteger _numberOfItems;
}

@property (nonatomic, strong) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, strong) UIView *itemView;

@property (nonatomic, assign) IBOutlet id <TFBlankFillingViewDelegate> delegate;

@property (nonatomic, assign) IBOutlet id <TFBlankFillingViewDataSource> dataSource;

@property (nonatomic, assign) NSInteger numberOfItems;

- (TFBlankInputView *)blankInputViewAtIndex:(NSInteger)index;

@end


@protocol TFBlankFillingViewDelegate <NSObject>

- (CGFloat)inputViewHeightAtIndex:(NSInteger)index;
@optional
- (CGFloat)blankFillingViewInputViewGap:(TFBlankFillingView *)blankFillingView;

@end

@protocol TFBlankFillingViewDataSource <NSObject>

- (NSInteger)numberOfBlankInputViewInBlankContainer;

- (TFBlankInputView *)TFBlankFillingView:(TFBlankFillingView *)blankFillingView blankInputViewAtIndex:(NSInteger)index;

@end