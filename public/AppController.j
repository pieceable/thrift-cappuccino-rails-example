/*
 * AppController.j
 * blah
 *
 * Created by You on June 7, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@import <Thrift/Thrift.j>
@import "gen-cappuccino/shared.j"
@import "gen-cappuccino/tutorial.j"

@implementation AppController : CPObject
{
    // For add()
    CPTextField addNum1Field;
    CPTextField addNum2Field;
    CPTextField addSumField;
    
    // For calculate()
    CPPopUpButton calculateOperation;
    CPTextField calculateNum1Field;
    CPTextField calculateNum2Field;
    CPTextField calculateResultField;
    
    CPInteger calculateLastLogId;
}

- (id)thriftClient
{
    var transport = [[THTTPTransport alloc] initWithURL:"/thrift"];
    var protocol = [[TBinaryProtocol alloc] initWithTransport:transport]; 
    var client = [[CalculatorClient alloc] initWithProtocol:protocol];
    
    return client;
}

/////////////////////////////////////////////////////////////
// Ping

- (void)thriftClientPingSucceeded:(CalculatorClient)thriftClient
{
    var alert = [[CPAlert alloc] init];
    [alert setMessageText:"ping() succeeded!"];
    [alert addButtonWithTitle:@"OK"];
    [alert setAlertStyle:CPInformationalAlertStyle];
    [alert runModal];
}

- (void)thriftClient:(CalculatorClient)thriftClient pingFailed:(id)error
{
    var alert = [[CPAlert alloc] init];
    [alert setMessageText:"ping() failed with error: " + error];
    [alert addButtonWithTitle:@"OK"];
    [alert setAlertStyle:CPCriticalAlertStyle];
    [alert runModal];
}

- (void)didPressPing
{
    [[self thriftClient] pingWithTarget:self 
                          successAction:@selector(thriftClientPingSucceeded:) 
                          failureAction:@selector(thriftClient:pingFailed:)];
}

/////////////////////////////////////////////////////////////
// Add

- (void)thriftClient:(CalculatorClient)thriftClient addSucceeded:(int)sum
{
    [addSumField setStringValue:sum];
}

- (void)thriftClient:(CalculatorClient)thriftClient addFailed:(id)error
{
    var alert = [[CPAlert alloc] init];
    [alert setMessageText:"add() failed with error: " + error];
    [alert addButtonWithTitle:@"OK"];
    [alert setAlertStyle:CPCriticalAlertStyle];
    [alert runModal];
}


- (void)didPressAdd
{
    var num1 = parseInt([addNum1Field stringValue]);
    var num2 = parseInt([addNum2Field stringValue]);

    [[self thriftClient] addWithNum1:num1
                                num2:num2
                              target:self
                       successAction:@selector(thriftClient:addSucceeded:)
                       failureAction:@selector(thriftClient:addFailed:)];
}

///////////////////////////////////////////////////////////////
// Calculate

- (void)thriftClient:(CalculatorClient)thriftClient calculateSucceeded:(int)result
{
    [calculateResultField setStringValue:result];
}

- (void)thriftClient:(CalculatorClient)thriftClient calculateFailed:(id)error
{
    var alert = [[CPAlert alloc] init];
    [alert setMessageText:"calculate() failed with error: " + error];
    [alert addButtonWithTitle:@"OK"];
    [alert setAlertStyle:CPCriticalAlertStyle];
    [alert runModal];
}


- (void)didPressCalculate
{
    var operation = nil;    
    var selectedTitle = [calculateOperation titleOfSelectedItem];
    
    if (selectedTitle == 'Add')
        operation = Operation_ADD;
    else if (selectedTitle == 'Subtract')
        operation = Operation_SUBTRACT;
    else if (selectedTitle == 'Multiply')
        operation = Operation_MULTIPLY;
    else if (selectedTitle == 'Divide')
        operation = Operation_DIVIDE;
    
    
    var num1 = parseInt([calculateNum1Field stringValue]);
    var num2 = parseInt([calculateNum2Field stringValue]);
    
    var work = [[Work alloc] initWithNum1:num1 num2:num2 op:operation comment:nil];
    
    calculateLastLogId = Math.floor(Math.random() * 10000);

    [[self thriftClient] calculateWithLogid:calculateLastLogId
                                          w:work
                                     target:self
                              successAction:@selector(thriftClient:calculateSucceeded:)
                              failureAction:@selector(thriftClient:calculateFailed:)];
}

/////////////////////////////////////////////////////////////////

- (CPView)viewWithControls
{
    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 380, 140)];
    
    var pingButton = [CPButton buttonWithTitle:"Ping"];
    [pingButton setTarget:self];
    [pingButton setAction:@selector(didPressPing)];
    [view addSubview:pingButton];
    
    addNum1Field = [CPTextField textFieldWithStringValue:"1" placeholder:"" width:50];
    [view addSubview:addNum1Field];
    [addNum1Field setFrameOrigin:CGPointMake(0, 50)];
    
    var plusSign = [CPTextField labelWithTitle:"+"];
    [view addSubview:plusSign];
    [plusSign setFrameOrigin:CGPointMake(55, 56)];
    
    addNum2Field = [CPTextField textFieldWithStringValue:"2" placeholder:"" width:50];
    [view addSubview:addNum2Field];
    [addNum2Field setFrameOrigin:CGPointMake(70, 50)];

    var equalsSign = [CPTextField labelWithTitle:"="];
    [view addSubview:equalsSign];
    [equalsSign setFrameOrigin:CGPointMake(125, 56)];
    
    addSumField = [CPTextField textFieldWithStringValue:"" placeholder:"" width:50];
    [view addSubview:addSumField];
    [addSumField setFrameOrigin:CGPointMake(140, 50)];
    
    var addButton = [CPButton buttonWithTitle:"Add"];
    [addButton setTarget:self];
    [addButton setAction:@selector(didPressAdd)];
    [view addSubview:addButton];    
    [addButton setFrameOrigin:CGPointMake(210, 52)];
    
    calculateOperation = [[CPPopUpButton alloc] initWithFrame:CGRectMakeZero() pullsDown:NO];
    [calculateOperation setTag:"postWithImage"]
    [calculateOperation addItemsWithTitles:[ "Add", "Subtract", "Multiply", "Divide" ]];
    [calculateOperation sizeToFit];
    [calculateOperation setFrameSize:CGSizeMake(100, [calculateOperation frameSize].height)];
    [view addSubview:calculateOperation];
    [calculateOperation setFrameOrigin:CGPointMake(0, 102)];
    
    calculateNum1Field = [CPTextField textFieldWithStringValue:"" placeholder:"num1" width:50];
    [view addSubview:calculateNum1Field];
    [calculateNum1Field setFrameOrigin:CGPointMake(110, 100)];
    
    calculateNum2Field = [CPTextField textFieldWithStringValue:"" placeholder:"num2" width:50];
    [view addSubview:calculateNum2Field];
    [calculateNum2Field setFrameOrigin:CGPointMake(170, 100)];
    
    calculateResultField = [CPTextField textFieldWithStringValue:"" placeholder:"result" width:50];
    [view addSubview:calculateResultField];
    [calculateResultField setFrameOrigin:CGPointMake(230, 100)];
        
    var calculateButton = [CPButton buttonWithTitle:"Calculate"];
    [calculateButton setTarget:self];
    [calculateButton setAction:@selector(didPressCalculate)];
    [view addSubview:calculateButton];    
    [calculateButton setFrameOrigin:CGPointMake(290, 102)];
    
    return view;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    var viewWithControls = [self viewWithControls];

    [viewWithControls setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    [viewWithControls setCenter:[contentView center]];

    [contentView addSubview:viewWithControls];

    [theWindow orderFront:self];
}

@end
