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

    Board *imgView = [[Board alloc] initWithWidth:self.view.frame.size.width controller:self];

    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.winscreen = [[UIImageView alloc] initWithFrame:frame];

    self.winscreen.contentMode = UIViewContentModeScaleAspectFit;
    self.winscreen.hidden = true;

    [self.winscreen setImage:[UIImage imageNamed:@"YouWin"]];

    [self.view addSubview:imgView];
    [self.view addSubview:self.winscreen];
}
- (void)showWinscreen {
    self.winscreen.hidden = false;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
