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
@property (nonatomic, strong) NSDictionary* testVariableValues;
//@property int lastOperationPrecedence;
typedef enum OperandType {
    ZERO,
    ONE,
    TWO,
    STRING
}OperandType;
@end


#pragma mark -
#pragma mark Getters and Setters

@implementation CalculatorBrain

-(NSDictionary *)variablesValue
{
    if(!_testVariableValues){
        _testVariableValues = [[NSDictionary alloc] initWithObjects:@[@0,@0,@0] forKeys:@[@"x",@"a",@"b"]];
    }
    return _testVariableValues;
}

- (void)chooseVariablesValue:(int)testSetNum
{
    NSArray *KEYS = @[@"x",@"a",@"b"];
    switch (testSetNum) {
        case 1:
            _testVariableValues = [[NSDictionary alloc] initWithObjects:@[@5,@4.8,@0] forKeys:KEYS];
            break;
        case 2:
            _testVariableValues = [[NSDictionary alloc] initWithObjects:@[@3.3,@3.3,@3.3] forKeys:KEYS];
            break;
        case 3:
            _testVariableValues = [[NSDictionary alloc] initWithObjects:@[@1,@1,@1] forKeys:KEYS];break;
        default:
            break;
    }
}

- (NSMutableArray *)programStack
{
    if(!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id) program
{
    return [self.programStack copy];
}

#pragma mark - Public Methods

- (void)pushOperand:(NSString*)operand
{
    /*----  check operand is doubleValue ----*/
    //!! can be imperoved
    if ([operand doubleValue]!=0.0) {
        [self.programStack addObject:@([operand doubleValue])];
        //add in NSNumber type
    }
    else if([operand isEqualToString:@"0"]){
        [self.programStack addObject:@([operand doubleValue])];
    }
    else{ //if it's variable
        [self.programStack addObject:operand];
    }
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariablesValue:self.testVariableValues];
}

-  (void) clearStack{
    [self.programStack removeAllObjects];
}

//substitude variables with values and then runProgram
+ (double)runProgram:(id)program usingVariablesValue:(NSDictionary *)testVariableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    else abort();
    
    /*------   variable substitude (without replacing origin program) -------*/
    //!! can be improved
    int stackLengh = [stack count];
    for (int i=0; i<stackLengh; i++) {
        NSString *obj = stack[i];
        if ([obj doubleValue]!=0) {//NSLog(@"NSNumber do nothing");
        }
        else if([obj isEqualToString:@"0"]){//NSLog(@"0 do nothing");
        }
        else if([obj isEqualToString:@"x"] ||
                [obj isEqualToString:@"a"] ||
                [obj isEqualToString:@"b"])  {
            NSNumber *value = testVariableValues[obj];
            [stack replaceObjectAtIndex:i withObject:value];
        }
        else{
            //NSLog(@"for operations, do nothing");
        }
    }
    return [self popOperandOffStack:stack];
}

+ (NSString *)descriptionOfProgram:(NSString *)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    else abort();
    return [[self class] descriptionOfTopOfStack:stack];
}

#pragma mark - Private Methods

//?? can I use const?
+ (NSSet *)variablesUsedInProgram:(const id) program
{
    NSSet * variables = nil;
    NSSet * xab = [NSSet setWithArray:@[@"x",@"a",@"b"]];
    NSUInteger programLengh = [program count];
    if (programLengh==0) {
        return nil;
    }
    else{
        for (NSUInteger i=0; i<programLengh; i++) {
            NSString *variable = program[i];
            if ([xab containsObject:variable]){
               [variables setByAddingObject:variable];
            }
        }
        return variables;
    }
}

+ (NSString*)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",topOfStack];
    }
    else{
        NSString *operation = topOfStack;
        switch ([[self class] differentiateOperation:operation]) {
            case ZERO:
                if([topOfStack isEqualToString:@"π"]){
                    
                }
                return nil;
                break;
            case ONE:
                return [NSString stringWithFormat:@"%@(%@)",operation,[self descriptionOfTopOfStack:stack]];
                break;
            case TWO:
                {
                    NSString *latterOne = [self descriptionOfTopOfStack:stack];
                    NSString *formmerOne = [self descriptionOfTopOfStack:stack];
                    return [NSString stringWithFormat:@"%@ %@ %@", formmerOne, operation, latterOne];
                }
                break;
            case STRING:
                    return operation;
                break;
            default:
                abort();
                break;
        }
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
+ (int)differentiateOperation: (NSString*)operation
{
    NSSet *oneOperandsOperaion = [NSSet setWithArray:@[@"sqrt",@"cos",@"sin"]];
    NSSet *twoOperandsOperaion = [NSSet setWithArray:@[@"+",@"-",@"*",@"/"]];
    NSSet *zeroOperandsOperaion = [NSSet setWithArray:@[@"π",@"x",@"a",@"b"]];
    
    if([oneOperandsOperaion containsObject:operation]) return ONE;
    else if ([twoOperandsOperaion containsObject:operation]) return TWO;
    else if([zeroOperandsOperaion containsObject:operation]) return ZERO;
    else if([operation isKindOfClass:[NSString class]]) return STRING;
    else abort();
}






@end
