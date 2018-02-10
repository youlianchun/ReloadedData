//
//  ViewController.m
//  ReloadedData
//
//  Created by YLCHUN on 2018/2/7.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "ViewController.h"
#import "ReloadedData.h"

static int i = 0;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (IBAction)reloadAction:(id)sender
{
    i++;
    [self.tableView reloadData:^{
        NSLog(@"reload_data %d",i);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%s %d",__func__,i);
    return arc4random() % 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s %d",__func__,i);
    return arc4random() % 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s %d",__func__,i);
    if (indexPath.row%3 == 0) {
        [NSThread sleepForTimeInterval:0.1];//模拟耗时操作
    }
    static NSString * const kIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier];
    }
    return cell;
}

@end
