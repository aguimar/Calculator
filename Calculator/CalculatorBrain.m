//
//  CalculatorBrain.m
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSDictionary *programDictionary;
@property (nonatomic, strong) NSSet *operations;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize programDictionary = _programDictionary;
@synthesize operations = _operations;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (NSDictionary *)programDictionary
{
    if (_programDictionary == nil) _programDictionary = [[NSDictionary alloc] init];
    _programDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:-4], @"x", [NSNumber numberWithDouble: 3], @"a", nil];
    return _programDictionary;
}

- (NSSet *) operations {
    if (_operations == nil) _operations = [[NSSet alloc] init];
    _operations = [NSSet setWithObjects:@"+",@"-",@"*",@"/", nil];
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    //return @"Implement this in Homework #2";
    return [self descriptionOfTopOfStack:stack];
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void) pushVariables:(NSString *)variable {
    
    [self.programStack addObject:variable];
    NSLog(@"Here is the variable added to the end: %@", variable);
    NSLog(@"Complete Stack");
    
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    NSSet *variablesUsedInProgram = [[self class] variablesUsedInProgram:self.programStack];
    
    // tem variaveis ?
    if ([variablesUsedInProgram count]) {
        NSDictionary *temp = self.programDictionary;
        return [[self class] runProgram:self.program usingVariableValues:temp];
    } else {
        return [[self class] runProgram:self.program];
    }
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;

    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
                     [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            //double um = [self popOperandOffProgramStack:stack] ;
            //double dois = [self popOperandOffProgramStack:stack];
            //NSLog(@"Um --> %g", um);
            //NSLog(@"Dois --> %g", dois);
            
            result = [self popOperandOffProgramStack:stack] *
                     [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"π"]){
            //[stack addObject:[NSNumber numberWithDouble:M_PI]];
            result = M_PI;
        } else if ([operation isEqualToString:@"√"]){
            double divisor = [self popOperandOffProgramStack:stack];
            result = sqrt(divisor);
        } else if ([operation isEqualToString:@"sin"]){
            double divisor = [self popOperandOffProgramStack:stack];
            result = M_PI*divisor;
        } else if ([operation isEqualToString:@"cos"]){
            double divisor = [self popOperandOffProgramStack:stack];
            result = M_PI*divisor;
        }
    
    }

    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    //NSSet *variablesUsedInProgram = [[self class] variablesUsedInProgram:stack];
    
    // percorrer o stack
    for (int i=0; i < [stack count]; i++) {
        //pego a variavel que precisa ser substituida
        //TODO: arrumar essa linha de baixo 
        id key = [ stack objectAtIndex:i];
        
        // if nao for uma operation
        if (![[self class] isOperation:key]) {
            id replacewith = [ variableValues objectForKey:key ];
            [stack replaceObjectAtIndex:i withObject:replacewith];
        }
        
    } 
    
    return [self popOperandOffProgramStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet *variablesInProgram = [[NSMutableSet alloc]init];
    
// instrospection no stack
    for (id object in program) {
        NSLog(@"Objeto no array %@", object);
        // se eh string
        if ([object isKindOfClass:[NSString class]]) {
            NSString *variable = object;
            if ([variable isEqualToString:@"x"] || [variable isEqualToString:@"a"] || [variable isEqualToString:@"b"]) {
                [variablesInProgram addObject:object];
            }
            
        }
    }
    
    if ( variablesInProgram.count ) {
        return variablesInProgram;
    } else {
        return nil;
    };
}

+ (BOOL)isOperation:(NSString *)operation {
    NSSet *operations = [NSSet setWithObjects:@"+",@"-",@"*",@"/", nil];
    // testar em um NSSet
    if ( [operations containsObject:operation ]) {
        return TRUE; 
    }
    
    return FALSE;
}

-(void)clearBrain {
    [self.programStack removeAllObjects]; 
}

+(NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack {
    
    NSString *result = @"Implement this in Homework #2";
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    //se for operacao
    if ([topOfStack isKindOfClass:[NSString class]])
    {
        id operand1 = [self descriptionOfTopOfStack:stack];
        id operand2 = [self descriptionOfTopOfStack:stack];
        result = [result stringByAppendingFormat:@"%g + %g",operand1,operand2];
                  
    }
    // senao eh operando
    else {
        NSString *operand = topOfStack; 
        //return operand;   
    }
    return @"Implement this in Homework #2";
}

@end
