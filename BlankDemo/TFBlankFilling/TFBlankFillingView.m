//
//  TFBlankFillingView.m
//  BlankDemo
//
//  Created by Terry  on 14-2-17.
//  Copyright (c) 2014年 Terry. All rights reserved.
//



#import "TFBlankFillingView.h"

@interface TFBlankFillingView ()

@property (nonatomic, strong) NSMutableDictionary *itemViews;

@end

#define KDefaultBlankInputViewGap 30

@implementation TFBlankFillingView

@synthesize numberOfItems = _numberOfItems;

@synthesize dataSource = _dataSource;

@synthesize delegate = _delegate;

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _contentScrollView.backgroundColor = [UIColor clearColor];
    }
    return _contentScrollView;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setup];
        [self didMoveToSuperview];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    _itemViews = [[NSMutableDictionary alloc]initWithCapacity:0];
    _itemView = [[UIView alloc]initWithFrame:self.bounds];
    _itemView.backgroundColor = [UIColor clearColor];
}

- (void)setDataSource:(id<TFBlankFillingViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        if (_dataSource) {
            [self reloadData];
        }
    }
}

- (void)setDelegate:(id<TFBlankFillingViewDelegate>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        if (_delegate && _dataSource) {
            [self setNeedsLayout];
        }
    }
}

- (void)reloadData {
    if (!_dataSource) {
        return;
    }
    if (_itemView) {
        for (UIView *v in _itemView.subviews)
            [v removeFromSuperview];
    }
    _numberOfItems = [_dataSource numberOfBlankInputViewInBlankContainer];
    _itemViews = [[NSMutableDictionary alloc]initWithCapacity:_numberOfItems];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    if (_delegate && _dataSource) {
        [self layoutItemViews];
    }
}

- (void)layoutItemViews {
    if (_numberOfItems > 0) {
        for (NSInteger i = 0; i < _numberOfItems; i ++) {
            TFBlankInputView *blankInputView = [_dataSource TFBlankFillingView:self blankInputViewAtIndex:i];
            float inputViewHeight = [_delegate inputViewHeightAtIndex:i];
            float inputViewGap = 0.f;
            if ([_delegate respondsToSelector:@selector(blankFillingViewInputViewGap:)]) {
                inputViewGap = [_delegate blankFillingViewInputViewGap:self];
            }else {
                inputViewGap = KDefaultBlankInputViewGap;
            }
           inputViewGap = inputViewGap > KDefaultBlankInputViewGap?inputViewGap:KDefaultBlankInputViewGap;
            
            if (i > 0) {
                TFBlankInputView *previousBlankInputView = [_itemViews objectForKey:[NSNumber numberWithInt:i -1]];
                blankInputView.frame = CGRectMake(previousBlankInputView.frame.origin.x, CGRectGetMaxY(previousBlankInputView.frame) + inputViewGap, previousBlankInputView.frame.size.width, inputViewHeight);
            }else {
                blankInputView.frame = CGRectMake(0, inputViewGap, self.bounds.size.width,inputViewHeight);
            }
            [_itemViews setObject:blankInputView forKey:[NSNumber numberWithInt:i]];
            [_itemView addSubview:blankInputView];
            float contentHeight = CGRectGetMaxY(blankInputView.frame) + inputViewGap;
            CGRect rect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, _itemView.bounds.size.width, contentHeight);
            if (rect.size.height >= _itemView.frame.size.height) {
                _itemView.frame = rect;
            }
            self.contentScrollView.contentSize = _itemView.frame.size;
        }
        [self.contentScrollView addSubview:_itemView];
        [self addSubview:_contentScrollView];
    }
}

- (TFBlankInputView *)blankInputViewAtIndex:(NSInteger)index {
    return [_itemViews objectForKey:[NSNumber numberWithInteger:index]];
}


@end
