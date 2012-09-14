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
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) BOOL IsAfterFloatPoint;
@property NSInteger display2LastPressed; //0 be initial, 1 be digit, 20 be dot, 21 be digit after dot 
@end

@implementation CalculatorViewController

/*
@synthesize display;
@synthesize display2;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize IsAfterFloatPoint;
@synthesize display2LastPressed;
@synthesize brain = _brain;
*/
 
- (CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if([self.display.text isEqualToString:@"0"]){ //initial zero
        if ([digit isEqualToString:@"0"]) {
            //do nothing
        }
        else{
            self.display.text = digit;
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
    else if(self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
}

- (IBAction)floatPointPressed:(id)sender {
    if (_IsAfterFloatPoint){
        NSLog(@"Can't type float point twice!");
    }
    else if(self.userIsInTheMiddleOfEnteringANumber){
        _IsAfterFloatPoint = YES;
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
    else{
        _IsAfterFloatPoint = YES;
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.IsAfterFloatPoint = NO;
}

- (IBAction)operationPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)clearEverything {
    self.display2.text = @"0";
    self.display.text = @"0";
    [self.brain clearStack];
    _display2LastPressed=0;
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
    else if ([@"." isEqualToString:input]){
        dot = input;
    }
    else{
        operation = input;
    }
               
    if (digit) {
        if (_display2LastPressed==0) {
            if([@"0" isEqualToString:digit]){
                self.display2.text = @"0";
            }
            else{
                self.display2.text = digit;
                    _display2LastPressed=1;
            }
        }
        else if (_display2LastPressed==1){
            self.display2.text = [self.display2.text stringByAppendingString:digit];
        }
        else if (_display2LastPressed==20 || _display2LastPressed==20){
            self.display2.text = [self.display2.text stringByAppendingString:digit];
            _display2LastPressed=21;
        }
    }
    else if(dot){
        if(_display2LastPressed==20 || _display2LastPressed==21){
            //do nothing
            NSLog(@"can not enter dot twice");
        }
        else if(_display2LastPressed==1){
            self.display2.text = [self.display2.text stringByAppendingString:@"."];
            _display2LastPressed=21;
        }
        else if(_display2LastPressed==0){
            self.display2.text = @"0.";
            _display2LastPressed=21;
        }
    }
    else if(operation){
        self.display2.text = [self.display2.text stringByAppendingString:@" "];
        self.display2.text = [self.display2.text stringByAppendingString:operation];
    }
}

/*
 Bug: can't make space, don't know which event first?
 how to use userIsInTheMiddleOfEnteringANumber?

 
 */


@end
