//
//  CalculatorViewController.m
//  Calculator
//
//  Created by csie on 12/8/8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic, strong) CalculatorBrain *brain;
@property NSInteger display2LastPressed; //0 be initial, 1 be digit, 20 be dot, 21 be digit after dot 
@property NSInteger displayLastPressed;  //0 be initial, 1 be digit, 20 be dot, 21 be digit after dot 
@end

@implementation CalculatorViewController


 
- (CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    //initial zero, or intial but with digits covered
    if(self.displayLastPressed==0){
        if ([digit isEqualToString:@"0"]) {
            NSLog(@"extra 0, do nothing.");
        }
        else{
            self.display.text = digit;
            self.displayLastPressed = 1;
        }
    }
    //self.userIsInTheMiddleOfEnteringANumber
    else if(self.displayLastPressed==20 || self.displayLastPressed==21){
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.displayLastPressed = 21;
    }
    else{
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.displayLastPressed = 1;
    }
}


- (IBAction)variablesPressed:(UIButton *)sender {
    NSString *variable = [sender currentTitle];
    self.display.text = variable;
    //not completed
}

- (IBAction)floatPointPressed:(id)sender {
    //if (_IsAfterFloatPoint){
    if (self.displayLastPressed==20 ||self.displayLastPressed==21) {
        //do nothing
        NSLog(@"Can't type float point twice!");
    }
    //else if(self.userIsInTheMiddleOfEnteringANumber){
    else if(self.displayLastPressed==1){
        self.displayLastPressed=20;
        //_IsAfterFloatPoint = YES;
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
    else if(self.displayLastPressed==0){
        self.displayLastPressed=20; 
        self.display.text = @"0.";
        //_IsAfterFloatPoint = YES;
        //self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.displayLastPressed=0;
    //[self.brain pushOperand:[self.display.text doubleValue]];
    //self.userIsInTheMiddleOfEnteringANumber = NO;
    //self.IsAfterFloatPoint = NO;
}



- (IBAction)operationPressed:(id)sender {
    NSString *operation = [sender currentTitle];
    if (self.displayLastPressed==20) {
        NSLog(@"Can't use in uncompleted digit!");
        return;
    }
    else if (self.displayLastPressed==0){
        //if it's 0 or 1 operand operation, it can work
        //?? BUG?
        double result = [self.brain performOperation:operation];
        self.display.text = [NSString stringWithFormat:@"%g", result];
    }
    // inTheMiddleOfEnteringNumber, ie, self.displayLastPressed==1 or 21
    else {
        [self enterPressed];
        double result = [self.brain performOperation:operation];
        self.display.text = [NSString stringWithFormat:@"%g", result];
    }
}

- (IBAction)clearEverything {
    [self.brain clearStack];
    self.display2.text = @"0";
    self.display.text = @"0";
    self.display2LastPressed=0;
    self.displayLastPressed=0;
}


- (IBAction)displayAllOperations:(id)sender {
    NSString *digit;
    NSString *dot;
    NSString *operation;
    NSString *input = [sender currentTitle];
    
    NSRange intRange = [@"0123456789" rangeOfString:input];
    if(intRange.location!=NSNotFound){
        digit = input; 
    }
    else if ([input isEqualToString:@"."]){
        dot = input;
    }
    else{
        operation = input;
    }
    
    if (digit) {
        if (self.display2LastPressed==0) {
            if([digit isEqualToString:@"0"]){
                NSLog(@"extra 0, do nothing.");
            }
            else{
                self.display2.text = digit;
                self.display2LastPressed=1;
            }
        }
        else if (self.display2LastPressed==1){
            self.display2.text = [self.display2.text stringByAppendingString:digit];
        }
        else if (self.display2LastPressed==20 || self.display2LastPressed==21){
            self.display2.text = [self.display2.text stringByAppendingString:digit];
            self.display2LastPressed=21;
        }
    }
    else if(dot){
        if(self.display2LastPressed==20 || self.display2LastPressed==21){
            NSLog(@"can not enter dot twice");
        }
        else if(self.display2LastPressed==1){
            self.display2.text = [self.display2.text stringByAppendingString:@"."];
            self.display2LastPressed=20;
        }
        else if(self.display2LastPressed==0){
            self.display2.text = @"0.";
            self.display2LastPressed=21;
        }
    }
    else if(operation && ![operation isEqualToString:@"Enter"]){
        //?? may can be improved
        self.display2.text = [self.display2.text stringByAppendingString:@" "];
        self.display2.text = [self.display2.text stringByAppendingString:operation];
        self.display2.text = [self.display2.text stringByAppendingString:@" "];
    }
    else if([operation isEqualToString:@"Enter"]){
        self.display2LastPressed=1;
        self.display2.text = [self.display2.text stringByAppendingString:@" "];
    }
}



@end
