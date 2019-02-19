# ReloadedData
reloadData 完成时事件绑定

### 帮助
```
//前一次 -[ reloadData:] 结束前再次 -[ reloadData:] 将抛弃前次结果
//注：-[ reloadData:]不会产生循环应用

@interface UITableView (reload)
-(void)reloadData:(void(^)(void))complete;
@end

@interface UICollectionView (reload)
-(void)reloadData:(void(^)(void))complete;
@end
```

### 示例
```
@property (weak, nonatomic) IBOutlet UITableView *tableView;

...
[self.tableView reloadData:^{
  //code ...
}];
```
