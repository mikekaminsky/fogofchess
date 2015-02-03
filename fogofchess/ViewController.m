//
//  ViewController.m
//  fogofchess
//
//  Created by Case Commons on 1/16/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    firstButton.frame = CGRectMake(120, 100, 80, 44);
    
    [firstButton setTitle:@"Tap me!" forState:UIControlStateNormal];
    
    [self.view addSubview:firstButton];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   NSLog(@"Stopped touching the screen");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Started touching the screen");
}

@end
