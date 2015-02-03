//
//  GameViewController.m
//  fogofchess
//
//  Created by Case Commons on 1/29/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import "GameViewController.h"
#import "BoardView.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Game";
        self.tabBarItem.image = [UIImage imageNamed:@"electric-7"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    BoardView *imgView = [[BoardView alloc] initWithImage: [UIImage imageNamed:@"chessboard.jpg"]];
    int ycoord = (590 - self.view.frame.size.width)/2 + 20;
    imgView.frame = CGRectMake(0, ycoord, self.view.frame.size.width, self.view.frame.size.width);

    //imgView.frame = self.view.frame;

    
    [self.view addSubview:imgView];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint location = [touch locationInView:touch.view];
//    NSLog(@"Whereami x:%f,y:%f",location.x, location.y);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
