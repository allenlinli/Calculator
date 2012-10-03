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
@property (nonatomic, strong) NSDictionary *variablesValue;
@end


#pragma mark -
#pragma mark Getters and Setters

@implementation CalculatorBrain


- (NSMutableArray *)programStack
{
    if(!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (NSDictionary *)variablesValue
{
    if(!_variablesValue)  _variablesValue = [[NSDictionary alloc] initWithObjects:@[@0,@0,@0] forKeys:@[@"x",@"a",@"b"]];
    return _variablesValue;
}

//??
- (void)setVariablesValue:(NSDictionary *)variablesValue withValues:(NSArray *)values
{
    NSArray* keys = @[@"x",@"a",@"b"];
    _variablesValue = [NSDictionary dictionaryWithObject:values forKey:keys];
}

- (id) program
{
    return [self.programStack copy];
}

#pragma mark -
#pragma mark Public Methods

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariablesValue:self.variablesValue];
}

-  (void) clearStack{
    [self.programStack removeAllObjects];
}

//substitude variables with values and then runProgram
+ (double)runProgram:(id)program usingVariablesValue:(NSDictionary *)variablesValue
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    else{
        NSLog(@"don't know why");
        return -99;
    }
    //!! can be improved
    int stackLengh = [stack count];
    for (int i=0; i<stackLengh; i++) {
        NSString *obj = [stack objectAtIndex:i];
        //if obj is NSNumber, do nothing
        if ([obj doubleValue]!=0) {
            //NSLog(@"NSNumber do nothing");
        }
        else if([obj isEqualToString:@"0"]){
            //NSLog(@"0 do nothing");
        }
        else if([obj isEqualToString:@"x"] ||
                [obj isEqualToString:@"a"] ||
                [obj isEqualToString:@"b"])  {
            NSNumber *value = [variablesValue objectForKey:obj];
            [stack replaceObjectAtIndex:i withObject:value];
        }
        else{
            //NSLog(@"operations do nothing");
        }
    }
    return [self popOperandOffStack:stack];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}

#pragma mark -
#pragma mark Private Methods

//?? can I use const?
+ (NSSet *)variablesUsedInProgram:(const id) program
{
    NSSet * variables = nil;
    NSUInteger programLengh = [program count];
    if (programLengh==0) {
        return nil;
    }
    else{
        for (NSUInteger i=0; i<programLengh; i++) {
            NSString *variable = [program objectAtIndex:i];
            if ([variable isEqualToString:@"x"] ||
                [variable isEqualToString:@"a"] ||
                [variable isEqualToString:@"x"]) {
                [variables setByAddingObject:variable];
            }
        }
        return variables;
    }
}


+ (double) popOperandOffStack:(NSMutableArray *) stack
{
    double result = 0 ;
//debugger//
//    NSLog(@"stack content");
//    for (int i=0; i<[stack count]; i++) {
//        NSLog(@"%@",[stack objectAtIndex:i]);
//        NSLog(@"%@",[[stack objectAtIndex:i] class]);
//    }
    
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





@end
