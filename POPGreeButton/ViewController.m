//
//  ViewController.m
//  POPGreeButton
//
//  Created by 李言 on 16/3/31.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "ViewController.h"
#import "POPButton.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor yellowColor];
    POPButton *popbutton = [POPButton buttonWithNomalImage:[UIImage imageNamed:@"Like"]
                                               selectImage:[UIImage imageNamed:@"Like-Blue"]
                                                sparkImage:[UIImage imageNamed:@"Sparkle"]
                                            popButtonClick:^(UIButton* _Nullable sender) {
                                                
                                                
                                                NSLog(@"%@",sender.isSelected?@"yes":@"no");
                                                
                                            }];
    popbutton.frame = CGRectMake(0, 0, 100, 100);
    popbutton.center = self.view.center;
    [self.view addSubview:popbutton];
  
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
