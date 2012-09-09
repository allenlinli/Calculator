//
//  CalculatorBrain.h
//  Calculator
//
//  Created by csie on 12/8/8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;
- (void) clearStack;

@property (nonatomic, readonly) id program;
+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

@end
