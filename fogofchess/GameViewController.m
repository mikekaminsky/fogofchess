//
//  GameViewController.m
//  fogofchess
//
//  Created by Case Commons on 1/29/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import "GameViewController.h"
#import "Board.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Game";
        self.tabBarItem.image = [UIImage imageNamed:@"electric"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    Board *imgView = [[Board alloc] initWithWidth:self.view.frame.size.width];
    
    [self.view addSubview:imgView];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
