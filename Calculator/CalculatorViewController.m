//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Aguimar Neto on 30/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

// private area
@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display;
@synthesize friendlydisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *) brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle]; 
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingFormat:digit]; // [self.display setText:newDisplayText];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.friendlydisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}


- (IBAction)operationPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation =[sender currentTitle];
    double result = [self.brain performOperation:operation];
    NSLog(@"result",[NSString stringWithFormat:@"%g", result]);
    self.display.text = [NSString stringWithFormat:@"%g", result];
}
- (IBAction)commandC {
    self.display.text = @"0";
    self.friendlydisplay.text=@"0";
    //falta limpar o stack
    [self.brain clearBrain];
}

- (void)viewDidUnload {
    [self setFriendlydisplay:nil];
    [super viewDidUnload];
}
- (IBAction)variablePressed:(UIButton *)sender {
    
    NSString *variable = [sender currentTitle];
    self.display.text = variable;
    [self.brain pushVariables:variable];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
}

@end
