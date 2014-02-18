//
//  TFViewController.m
//  BlankDemo
//
//  Created by Terry  on 14-2-17.
//  Copyright (c) 2014年 Terry. All rights reserved.
//
#import "TFCustomBlankInputView.h"

#import "TFBlankFillingView.h"

#import "TFViewController.h"

#pragma mark //strOrEmpty
NSString* strOrEmpty(NSString* str) {
	return (str==nil||[str isKindOfClass:[NSNull class]]?@"":str);
}

@interface TFViewController () <TFBlankFillingViewDelegate, TFBlankFillingViewDataSource
,UITextFieldDelegate> {
    float currentTextFiledPositionY;
    CGSize originContentSize;
}
@end

@implementation TFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerObserver];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    float keyboardHeight = keyboardSize.height;
    float heightWithoutKeyboard = self.view.bounds.size.height - keyboardHeight;
    float gap = heightWithoutKeyboard - currentTextFiledPositionY - 49- 20;
    if (gap < 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        self.container.contentScrollView.contentOffset = CGPointMake(self.container.contentScrollView.contentOffset.x, self.container.contentScrollView.contentOffset.y - gap);
        float offsetY = self.container.contentScrollView.contentOffset.y;
        originContentSize = self.container.contentScrollView.contentSize;
        self.container.contentScrollView.contentSize = CGSizeMake(self.container.contentScrollView.bounds.size.width, self.container.contentScrollView.contentSize.height + offsetY);
        [UIView commitAnimations];
    }
}

- (void)keyboardWasHidden:(NSNotification *)notification {
    if (originContentSize.height > 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        self.container.contentScrollView.contentOffset =CGPointMake(0, 0);
        self.container.contentScrollView.contentSize = originContentSize;
        [UIView commitAnimations];
        originContentSize = CGSizeMake(0, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfBlankInputViewInBlankContainer {
    return 7;
}

- (CGFloat)inputViewHeightAtIndex:(NSInteger)index {
    return 49.f;
}

- (CGFloat)blankFillingViewInputViewGap:(TFBlankFillingView *)blankFillingView {
    return 10.f;
}

- (TFBlankInputView *)TFBlankFillingView:(TFBlankFillingView *)blankContainer blankInputViewAtIndex:(NSInteger)index {
    TFCustomBlankInputView *customBlankInputView = (TFCustomBlankInputView *)[[[NSBundle mainBundle]loadNibNamed:@"TFCustomBlankInputView" owner:self options:nil]lastObject];
    customBlankInputView.inputField.delegate = self;
    customBlankInputView.indexLabel.text = [NSString stringWithFormat:@"填空%d",index + 1];
    return customBlankInputView;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
   CGRect rect = [textField.superview convertRect:textField.frame toView:self.view];
    float postionY = rect.origin.y;
    currentTextFiledPositionY = postionY;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onSubmitButtonTapped:(id)sender {
    NSMutableString *inputString = [[NSMutableString alloc]init];
    for (int i = 0; i < 7; i ++) {
        TFCustomBlankInputView *customBlankInputView = (TFCustomBlankInputView *)[self.container blankInputViewAtIndex:i];
        [inputString appendString:[NSString stringWithFormat:@" %@ ",strOrEmpty(customBlankInputView.inputField.text)]];
    }
    NSLog(@"%@",inputString);
//    UIAlertView *alert = [UIAlertView alloc]initWithTitle:@"提示" message:inputString delegate:nil cancelButtonTitle:@"知道了",nil];
//    [alert show];
}

@end
