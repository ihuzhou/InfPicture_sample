//
//  ViewController.m
//  InfPicture_sample
//
//  Created by ihuzhou on 15/10/21.
//  Copyright © 2015年 ihuzhou. All rights reserved.
//

#import "ViewController.h"
#import "InfPicture.h"
@interface ViewController ()<InfPictureDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    NSArray * testArray = @[@"1.jpg",@"2.jpg",@"3.jpg"];
    
    
    [_infView setImageArray:[[NSMutableArray alloc]initWithArray:testArray]
              andImageIndex:0
             hasPageControl:YES
         openAutoCycleImage:YES
               timeInterval:5
      InfPictureBeenClicked:nil];
    _infView.delegate=self;
//    [_infView openAutoCycleImage:YES];
}

- (void)InfPicture:(InfPicture *)infPicture andImageIndex:(NSInteger)index{
    NSLog(@"%ld",index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
