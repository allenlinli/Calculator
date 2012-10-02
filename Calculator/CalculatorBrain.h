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
- (void)pushVariableOperand:(NSString *)variableOperand;
-(double)performOperation:(NSString *)operation;
- (void) clearStack;

+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;


@end
