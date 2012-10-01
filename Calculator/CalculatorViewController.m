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
//@property (nonatomic) BOOL IsAfterFloatPoint;
//@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property NSInteger display2LastPressed; //0 be initial, 1 be digit, 20 be dot, 21 be digit after dot 
@property NSInteger displayLastPressed;  //0 be initial, 1 be digit, 20 be dot, 21 be digit after dot 
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
            self.displayLastPressed = 1;
        }
    }
    else if(self.displayLastPressed>0){  //self.userIsInTheMiddleOfEnteringANumber
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {  //also new digit, but with last typed digits covered
        self.display.text = digit;
        //self.userIsInTheMiddleOfEnteringANumber = YES;
       self.displayLastPressed=1;
    }
}

- (IBAction)floatPointPressed:(id)sender {
    //if (_IsAfterFloatPoint){
    if (self.displayLastPressed==20 ||self.displayLastPressed==21) {
        //do nothing
        NSLog(@"Can't type float point twice!");
    }
    //else if(self.userIsInTheMiddleOfEnteringANumber){
    else if(self.displayLastPressed==1){
        self.displayLastPressed=20; //_IsAfterFloatPoint = YES;
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
    //self.userIsInTheMiddleOfEnteringANumber = NO;
    //self.IsAfterFloatPoint = NO;
    self.displayLastPressed=0;
    self.display2LastPressed=0;
}

- (IBAction)operationPressed:(id)sender {
    if (self.displayLastPressed==20) {
        NSLog(@"Can't use in uncompleted digit!");
        return;
    }
    else if (self.displayLastPressed==0) {
        NSLog(@"Can't push 0 so far");
        //?? need to be improved
        return;
    }else { // inTheMiddleOfEnteringNumber
        [self enterPressed];
        self.displayLastPressed=0;
        NSString *operation = [sender currentTitle];
        double result = [self.brain performOperation:operation];
        self.display.text = [NSString stringWithFormat:@"%g", result];
    }
}

- (IBAction)clearEverything {
    self.display2.text = @"0";
    self.display.text = @"0";
    [self.brain clearStack];
    self.display2LastPressed=0;
    //_IsAfterFloatPoint=NO;
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
