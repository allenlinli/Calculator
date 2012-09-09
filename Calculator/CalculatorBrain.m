//
//  CalculatorBrain.m
//  Calculator
//
//  Created by csie on 12/8/8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#import <math.h>

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;



- (NSMutableArray *)programStack{
    if(_programStack==nil) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void) pushOperand:(double)operand{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void) pushVariableOperand:(NSString *)variableOperand{
    [self.programStack addObject:variableOperand];
}

- (double) performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (id) program
{
    return [self.programStack copy];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double) popOperandOffStack:(NSMutableArray *) stack
{
    double result = 0 ;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if([@"*" isEqualToString:operation]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]){
            double subtrashend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrashend;
        } else if ([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack]/divisor;
        } else if([@"sin" isEqualToString:operation]){
            result = sin([self popOperandOffStack:stack]);
        } else if([@"cos" isEqualToString:operation]){
            result = cos([self popOperandOffStack:stack]);
        } else if([@"sqrt" isEqualToString:operation]){
            result = sqrt([self popOperandOffStack:stack]);
        } else if([@"π" isEqualToString:operation]){
            result = [self popOperandOffStack:stack];  // not complete
        } else if([@"x" isEqualToString:operation]){
            //result = []
        }
    }
   
    return result;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}

-  (void) clearStack{
    [self.programStack removeAllObjects];
}



@end
