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
@property (weak, nonatomic) IBOutlet UILabel *testValues;
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
    [self enterPressed];
    NSString *variable = [sender currentTitle];
    self.display.text = variable;
    [self.brain pushOperand:self.display.text];
    //not completed
}

- (IBAction)floatPointPressed:(id)sender {
    if (self.displayLastPressed==20 ||self.displayLastPressed==21) {     //if (_IsAfterFloatPoint){
        //do nothing
        NSLog(@"Can't type dot twice!");
    }
    else if(self.displayLastPressed==1){      //else if(self.userIsInTheMiddleOfEnteringANumber){
        self.displayLastPressed=20;
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
    else if(self.displayLastPressed==0){
        self.displayLastPressed=20; 
        self.display.text = @"0.";
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:self.display.text];
    self.displayLastPressed=0;
}

- (IBAction)operationPressed:(id)sender {
    NSString *operation = [sender currentTitle];
    if (self.displayLastPressed==20) {
        NSLog(@"Can't use in uncompleted digit!");
        return;
    }
    else {
        if(self.displayLastPressed!=0) [self enterPressed];
        double result = [self.brain performOperation:operation];
        self.display.text = [NSString stringWithFormat:@"%g", result];
        self.description.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    }
}

- (IBAction)clearEverything {
    [self.brain clearStack];
    self.description.text = @"0";
    self.display.text = @"0";
    self.display2LastPressed=0;
    self.displayLastPressed=0;
}

- (NSString *)showTestValues
{
    NSString* shownVariables=@"";
    NSSet *usedVariables = [[self.brain class] variablesUsedInProgram:self.brain.program];
    if ([usedVariables containsObject:@"x"]) {
        [shownVariables stringByAppendingFormat:@"x = %@ ", [self.brain.testVariableValues objectForKey:@"x"]];
    }
    if ([usedVariables containsObject:@"a"]) {
        [shownVariables stringByAppendingFormat:@"a = %@ ", [self.brain.testVariableValues objectForKey:@"a"]];
    }
    if ([usedVariables containsObject:@"b"]) {
        [shownVariables stringByAppendingFormat:@"b = %@ ", [self.brain.testVariableValues objectForKey:@"b"]];
    }
    return shownVariables;
}

- (IBAction)test1Values:(id)sender {
    [self.brain chooseVariablesValue:1];
    self.testValues.text = [self showTestValues];
}

- (IBAction)test2Values:(id)sender {
    [self.brain chooseVariablesValue:2];
    self.testValues.text = [self showTestValues];
}

- (IBAction)test3Values:(id)sender {
    [self.brain chooseVariablesValue:3];
    self.testValues.text = [self showTestValues];
}

- (IBAction)setTestValuesNil:(id)sender {
    [self.brain setTestVariableValues:nil];
}

- (void)viewDidUnload {
    [self setTestValues:nil];
    [self setDescription:nil];
    [super viewDidUnload];
}
@end
