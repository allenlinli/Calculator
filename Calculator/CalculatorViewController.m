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
@property NSInteger displayLastPressed;
typedef enum DisplayState {
    INITIAL,
    ONLY_DIGIT,
    DOT,
    DIGIT_AFTER_DOT
}DisplayState;

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
    if(self.displayLastPressed==INITIAL){
        if ([digit isEqualToString:@"0"]) {
            NSLog(@"extra 0, do nothing.");
        }
        else{
            self.display.text = digit;
            self.displayLastPressed = ONLY_DIGIT;
        }
    }
    //self.userIsInTheMiddleOfEnteringANumber
    else if(self.displayLastPressed==DOT || self.displayLastPressed==DIGIT_AFTER_DOT){
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.displayLastPressed = DIGIT_AFTER_DOT;
    }
    else{
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.displayLastPressed = ONLY_DIGIT;
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
    if (self.displayLastPressed==DOT ||self.displayLastPressed==DIGIT_AFTER_DOT) {    
        NSLog(@"Can't type dot twice!");
    }
    else if(self.displayLastPressed==ONLY_DIGIT){
        self.displayLastPressed=DOT;
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
    else if(self.displayLastPressed==INITIAL){
        self.displayLastPressed=DOT; 
        self.display.text = @"0.";
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:self.display.text];
    self.displayLastPressed=INITIAL;
}

- (IBAction)operationPressed:(id)sender {
    NSString *operation = [sender currentTitle];
    if (self.displayLastPressed==DOT) {
        NSLog(@"Can't use in uncompleted digit!");
        return;
    }
    else {
        if(self.displayLastPressed!=INITIAL) [self enterPressed];
        double result = [self.brain performOperation:operation];
        self.display.text = [NSString stringWithFormat:@"%g", result];
        self.description.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    }
}

- (IBAction)clearEverything {
    [self.brain clearStack];
    self.description.text = @"0";
    self.display.text = @"0";
    self.displayLastPressed=INITIAL;
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
