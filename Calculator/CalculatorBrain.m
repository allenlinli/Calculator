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
@property (nonatomic, strong) NSDictionary *testSet;

+ (NSSet *)variablesUsedInProgram:(id)program;

@end

@implementation CalculatorBrain



- (NSMutableArray *)programStack
{
    if(_programStack==nil) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

//?? class method or instance method?
- (int)differentiateOperation: (NSString*)operation
//return value: 0 for no-operand operation, 1 for single-operand operation, 2 for two-operand operation, and -1 for operand, -2 for dot
{
    if([operation doubleValue])  return -1;
    else if([operation isEqualToString:@"0"]) return -1;
    
    else if([operation isEqualToString:@"."])   return -2;
    
    else if([operation isEqualToString:@"sqrt"] ||
            [operation isEqualToString:@"sin"]  ||
            [operation isEqualToString:@"cos"])  return 1;
    
    else if([operation isEqualToString:@"π"] ||
            [operation isEqualToString:@"x"] ||
            [operation isEqualToString:@"a"] ||
            [operation isEqualToString:@"b"])  return 0;
    
    else if([operation isEqualToString:@"+"] ||
            [operation isEqualToString:@"-"] ||
            [operation isEqualToString:@"*"] ||
            [operation isEqualToString:@"/"])  return 2;
    else{
        NSLog(@"bug!!");
        return -99;
    }
}

- (void) pushOperand:(NSString*)operand{
    [self.programStack addObject:operand];
}

- (void) pushVariableOperand:(NSString *)variableOperand{
    [self.programStack addObject:variableOperand];
}


- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    if ([CalculatorBrain variablesUsedInProgram:self.program]==nil) {
        return [CalculatorBrain runProgram:self.program ];
    }
    else{
        return [CalculatorBrain runProgram:self.program usingVariableValues:nil];//not completed
    }
}

- (id) program
{
    return [self.programStack copy];
}


+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    //provide values
    //!! it may can be improved
    NSUInteger stackLengh = [stack count];
    for (NSUInteger i=0; i<stackLengh; i++) {
        NSString *obj = [stack objectAtIndex:i];
        double doubleValue;
        if ([obj doubleValue]!=0) {
            doubleValue = [obj doubleValue];
        }
        else if([obj isEqualToString:@"0"]){
            doubleValue = 0;
        }
        else{
            doubleValue = [[variableValues objectForKey:obj] doubleValue];
        }
        [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:doubleValue]];
    }
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

//?? can I use const?
+ (NSSet *)variablesUsedInProgram:(id) program
{
    NSSet * variables = nil;
    NSMutableArray *stack;
    NSUInteger stackLengh = [stack count];
    if (stackLengh==0) {
        return nil;
    }
    else{
        for (NSUInteger i=0; i<stackLengh; i++) {
            NSObject *obj = [stack objectAtIndex:i];
            if (![obj isKindOfClass:[NSNumber class]]) {
                [variables setByAddingObject:obj];
                //for debug//
                NSLog(@"%@",obj);
            }
        }
        return variables;
    }
}

- (NSDictionary *)testSet
{
    if (!_testSet) _testSet= [[NSDictionary alloc] initWithObjects:@[@0,@0,@0] forKeys:@[@"x",@"a",@"b"]];
    return _testSet;
}

- (void)setTestSet:(NSDictionary *)testSet withValues:(NSArray *)values
{
    NSArray* keys = @[@"x",@"a",@"b"];
    NSDictionary* testSet2 = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    self.testSet = testSet2;
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
            result = [self popOperandOffStack:stack];  //?? not complete
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
