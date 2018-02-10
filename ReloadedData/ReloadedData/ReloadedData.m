//
//  ReloadedData.m
//  ReloadedData
//
//  Created by YLCHUN on 2018/2/7.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "ReloadedData.h"
#import <objc/runtime.h>


#pragma mark - objc/runtime
@interface _WeakObject : NSObject
@property (nonatomic, weak)id weak;
@end
@implementation _WeakObject
@end

static id get_attribute_strong(id object, const void * key)
{
    return objc_getAssociatedObject(object, key);
}

static void set_attribute_strong(id object, const void * key, id value)
{
    objc_setAssociatedObject(object, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static id get_attribute_weak(id object, const void * key)
{
    _WeakObject *weak = get_attribute_strong(object, key);
    return weak.weak;
}

static void set_attribute_weak(id object, const void * key, id value)
{
    _WeakObject *weak;
    if (value)
    {
        weak = get_attribute_strong(object, key);
        if (!weak) {
            weak = [_WeakObject new];
        }
        weak.weak = value;
    }
    set_attribute_strong(object, key, weak);
}


#pragma mark - _ReloadedData
@interface _ReloadedData : NSObject
@property (nonatomic, strong) UIScrollView *view;
@property (nonatomic, copy) void(^callback)(void);
@end

@implementation _ReloadedData

static _ReloadedData* build_reloadedData(UIScrollView *view, void(^complete)(void))
{
    __block _ReloadedData *reloadedData = [[_ReloadedData alloc] init];
    reloadedData.view = view;
    reloadedData.callback = ^{
        reloadedData = nil;
        complete();
    };
    return reloadedData;
}

-(void)setView:(UIScrollView *)view
{
    static NSString * const kContentSize = @"contentSize";
    [_view removeObserver:self forKeyPath:kContentSize];
    _view = view;
    [_view addObserver:self forKeyPath:kContentSize options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(onTimeOut) withObject:nil afterDelay:0.05];
}

-(void)onTimeOut
{
    void(^callback)(void) = self.callback;
    [self scrap];
    callback();
}

-(void)scrap
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.callback = nil;
    self.view = nil;
}

-(void)dealloc
{
    [self scrap];
}

@end


#pragma mark - UITableView UICollectionView
@interface UIScrollView ()
- (id<UITableViewDataSource>)dataSource;
- (void)reloadData;
@end

@implementation UIScrollView (TableViewOrCollectionView)

-(_ReloadedData *)rdObserver
{
    return get_attribute_weak(self, @selector(rdObserver));
}

-(void)setRdObserver:(_ReloadedData *)rdObserver
{
    set_attribute_weak(self, @selector(rdObserver), rdObserver);
}

-(void)reloadData:(void(^)(void))complete
{
    if (complete && self.delegate && self.dataSource)
    {
        [self.rdObserver scrap];
        self.rdObserver = build_reloadedData(self, complete);
    }
    [self reloadData];
}

@end

