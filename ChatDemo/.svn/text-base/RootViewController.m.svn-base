//
//  RootViewController.m
//  ChatDemo
//
//  Created by yang on 7/1/13.
//  Copyright (c) 2013 yang. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    b.frame = CGRectMake(10, 10, 100, 40);
    [b addTarget:self action:@selector(registerToSocket:) forControlEvents:UIControlEventTouchUpInside];
    [b setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:b];
    
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    b2.frame = CGRectMake(10, 60, 100, 40);
    [b2 addTarget:self action:@selector(loginToSocket:) forControlEvents:UIControlEventTouchUpInside];
    [b2 setTitle:@"登陆" forState:UIControlStateNormal];
    [self.view addSubview:b2];
    
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    b3.frame = CGRectMake(10, 110, 100, 40);
    [b3 addTarget:self action:@selector(getProfile:) forControlEvents:UIControlEventTouchUpInside];
    [b3 setTitle:@"获取信息" forState:UIControlStateNormal];
    [self.view addSubview:b3];

    UIButton *b4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    b4.frame = CGRectMake(10, 160, 100, 40);
    [b4 addTarget:self action:@selector(getAllProfile:) forControlEvents:UIControlEventTouchUpInside];
    [b4 setTitle:@"获取所有信息" forState:UIControlStateNormal];
    [self.view addSubview:b4];


    _chatTool = [[ChatTool alloc] init];
    //NSString *host = @"192.168.88.8";
    NSString *host = @"1000phone.cn";
    [_chatTool connectToServer:host];
}


- (void) getAllProfile:(id)sender {
    [_chatTool getAllProfile];
}
- (void) getProfile:(id)sender {
    int userId = 1;
    [_chatTool getProfile:userId];
}

- (void) registerToSocket:(id)sender {
    NSString *name = @"qianfeng";
    NSString *password = @"123456";
    NSString *nickName = @"ios";
    NSString *qmd = @"ios fans";
    
    [_chatTool registerWithName:name withPassword:password withNickName:nickName withQmd:qmd];
}
- (void) loginToSocket:(id)sender {
    NSString *name = @"qianfeng";
    NSString *password = @"123456";
    
    [_chatTool loginWithName:name withPassword:password];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
