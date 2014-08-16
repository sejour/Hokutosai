//
//  HokutosaiCopyrightInformationViewController.m
//  Hokutosai
//
//  Created by Shuka Takakuma on 2014/05/01.
//  Copyright (c) 2014年 Shuka Takakuma. All rights reserved.
//

#import "HokutosaiCopyrightInformationViewController.h"

@interface HokutosaiCopyrightInformationViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation HokutosaiCopyrightInformationViewController

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
    // Do any additional setup after loading the view.
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"copyrights" ofType:@".txt"];
    NSError *error;
    NSString *text = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (error == nil) {
        _textView.text = text;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changedStatusBarHeightFrom:(CGFloat)oldHeight to:(CGFloat)newHeight screenHeight:(CGFloat)screenHeight
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
