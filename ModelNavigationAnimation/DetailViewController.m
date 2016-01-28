//
//  DetailViewController.m
//  ModelNavigationAnimation
//
//  Created by xuchuanqi on 16/1/11.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "DetailViewController.h"
#import "NavigationAnimation.h"

@interface DetailViewController()
{
    NavigationAnimation *animation;
}

@end

@implementation DetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        animation = [[NavigationAnimation alloc] init];
        self.transitioningDelegate = animation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor yellowColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    button.frame = CGRectMake(0, 0, 100, 100);
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)buttonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
