//
//  CalculatorBrain.h
//  Calculator
//
//  Created by csie on 12/8/8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (nonatomic, readonly) id program;

-(void)pushOperand:(NSString*)operand;
-(double)performOperation:(NSString *)operation;
- (void)clearStack;
- (void)chooseVariablesValue:(int)testSetNum;
- (NSDictionary *)testVariableValues;

+ (double)runProgram:(id)program usingVariablesValue:(NSDictionary *)testVariableValues;
+ (NSString *)descriptionOfProgram:(id)program;

@end
