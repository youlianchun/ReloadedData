//
//  ReloadedData.h
//  ReloadedData
//
//  Created by YLCHUN on 2018/2/7.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import <UIKit/UITableView.h>
#import <UIKit/UICollectionView.h>

//前一次 -[ reloadData:] 结束前再次 -[ reloadData:] 将抛弃前次结果
//注：-[ reloadData:]不会产生循环应用

@interface UITableView (reload)
-(void)reloadData:(void(^)(void))complete;
@end

@interface UICollectionView (reload)
-(void)reloadData:(void(^)(void))complete;
@end

