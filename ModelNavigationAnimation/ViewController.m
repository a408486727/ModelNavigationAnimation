//
//  ViewController.m
//  ModelNavigationAnimation
//
//  Created by xuchuanqi on 16/1/11.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)action:(id)sender {
    DetailViewController *detail = [[DetailViewController alloc] init];
    [self presentViewController:detail animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
