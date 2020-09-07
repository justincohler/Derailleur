//
//	Derailleur
//	Copyright (c) 2020 Ben Smith
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//

#import "DerailleurMainView.h"
#import "NSColor+DerailleurColours.h"
#import "NSView+LayoutAdditions.h"
#import "StatusDot.h"

@implementation DerailleurMainView

- (void) drawRect: (NSRect) dirtyRect
{
    [super drawRect:dirtyRect];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		[self setupViews];
		[self setupLayout];
	}
	return self;
}

- (void) setupViews
{
	[self setWantsLayer:YES];
	[self.layer setBackgroundColor:[[NSColor darkGrey] CGColor]];
    [self setupMetrics];
    [self setupStatusBar];
    [self setupButtons];
}

- (IBAction) handleStartRecordingEvent : (id) sender  {
   NSLog(@"Starting recording activity");
    _startRecordingButton.hidden = true;
    _pauseRecordingButton.hidden = false;
}

- (IBAction) handlePauseRecordingEvent : (id) sender {
    NSLog(@"Pausing recording activity");
    _pauseRecordingButton.hidden = true;
    _cancelRecordingButton.hidden = false;
    _resumeRecordingButton.hidden = false;
    _finishAndSaveRecordingButton.hidden = false;
}

- (IBAction) handleCancelRecordingEvent : (id) sender {
   NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Continue"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Alert"];
    [alert setInformativeText:@"NSWarningAlertStyle \r Are you sure you want to discard this ride?"];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction) handleResumeRecordingEvent : (id) sender {
    
}

- (IBAction) handleFinishAndSaveRecordingEvent : (id) sender {
    
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
 if (returnCode == NSAlertFirstButtonReturn) {
     NSLog(@"Discarded ride");
 } else {
     NSLog(@"Cancelled discard event");
 }
}

- (void) setupMetrics
{
    
    /* Set up metrics stack view and add subviews */
    _metricsStack = [[NSStackView alloc] init];
    
    [_metricsStack setOrientation:NSUserInterfaceLayoutOrientationHorizontal];
    [_metricsStack setAlignment:NSLayoutAttributeCenterY];
    [_metricsStack setDistribution:NSStackViewDistributionFillEqually];
    [_metricsStack setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_metricsStack setSpacing:15];
    
    [self setupCadenceView];
    [self setupResistanceView];
    
    [_metricsStack addArrangedSubview:_cadenceView];
    [_metricsStack addArrangedSubview:_resistanceView];
    
    [self addSubview:_metricsStack];
}

- (void) setupCadenceView
{
    /* Set up cadence view and associated subviews */
    _cadenceView = [[NSView alloc] init];

    [_cadenceView setWantsLayer:YES];
    [[_cadenceView layer] setCornerRadius:10];
    [[_cadenceView layer] setBackgroundColor: [[NSColor lightGrey] CGColor]];
    [_cadenceView setTranslatesAutoresizingMaskIntoConstraints:NO];
       
    NSTextField *cadenceTitle = [[NSTextField alloc] init];

    [cadenceTitle setEditable:NO];
    [cadenceTitle setBezeled:NO];
    [cadenceTitle setDrawsBackground:NO];
    [cadenceTitle setTextColor:[[NSColor lightGrey] lightenByPercentage:40]];
    [cadenceTitle setAlignment:NSTextAlignmentCenter];
    [cadenceTitle setFont:[NSFont boldSystemFontOfSize:18]];
    [cadenceTitle setStringValue:@"Cadence (RPM)"];

    [_cadenceView addSubview:cadenceTitle];
    [cadenceTitle centerHorizontallyInSuperview];
    [cadenceTitle.bottomAnchor constraintEqualToAnchor:_cadenceView.bottomAnchor constant: -20].active = YES;

    /* Set up cadence label */
    _cadenceLabel = [[NSTextField alloc] init];

    [_cadenceLabel setEditable:NO];
    [_cadenceLabel setBezeled:NO];
    [_cadenceLabel setDrawsBackground:NO];
    [_cadenceLabel setTextColor: [NSColor whiteColor]]; // TODO: change the text colour?
    [_cadenceLabel setStringValue:@"0"];
    [_cadenceLabel setAlignment:NSTextAlignmentCenter];
    [_cadenceLabel setFont: [NSFont boldSystemFontOfSize:75]];

    [_cadenceView addSubview:_cadenceLabel];
}

- (void) setupResistanceView
{
    /* Set up resistance view and associated subviews */
    _resistanceView = [[NSView alloc] init];

    [_resistanceView setWantsLayer:YES];
    [[_resistanceView layer] setCornerRadius:10];
    [[_resistanceView layer] setBackgroundColor: [[NSColor lightGrey] CGColor]];
    [_resistanceView setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSTextField *resistanceTitle = [[NSTextField alloc] init];

    [resistanceTitle setEditable:NO];
    [resistanceTitle setBezeled:NO];
    [resistanceTitle setDrawsBackground:NO];
    [resistanceTitle setTextColor:[[NSColor lightGrey] lightenByPercentage:40]];
    [resistanceTitle setAlignment:NSTextAlignmentCenter];
    [resistanceTitle setFont:[NSFont boldSystemFontOfSize:18]];
    [resistanceTitle setStringValue:@"Resistance"];

    [_resistanceView addSubview:resistanceTitle];
    [resistanceTitle centerHorizontallyInSuperview];
    [resistanceTitle.bottomAnchor constraintEqualToAnchor:_resistanceView.bottomAnchor constant: -20].active = YES;

    /* Set up resistance label */
    _resistanceLabel = [[NSTextField alloc] init];

    [_resistanceLabel setEditable:NO];
    [_resistanceLabel setBezeled:NO];
    [_resistanceLabel setDrawsBackground:NO];
    [_resistanceLabel setTextColor: [NSColor whiteColor]]; // TODO: change the text colour?
    [_resistanceLabel setStringValue:@"0%"];
    [_resistanceLabel setAlignment:NSTextAlignmentCenter];
    [_resistanceLabel setFont: [NSFont boldSystemFontOfSize:75]];

    [_resistanceView addSubview:_resistanceLabel];
}

- (void) setupStatusBar
{
    /* Set up status bar and associated subviews */
    _statusBar = [[NSView alloc] init];
    
    [_statusBar setWantsLayer:YES];
    [[_statusBar layer] setCornerRadius:5];
    [[_statusBar layer] setBackgroundColor:[[NSColor lightGrey] CGColor]];
    [_statusBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _statusLabel = [[NSTextField alloc] init];
    
    [_statusLabel setEditable:NO];
    [_statusLabel setBezeled:NO];
    [_statusLabel setDrawsBackground:NO];
    [_statusLabel setTextColor:[[NSColor lightGrey] lightenByPercentage:40]];
    [_statusLabel setAlignment:NSTextAlignmentLeft];
    [_statusLabel setFont:[NSFont boldSystemFontOfSize:11]];
    [_statusLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_statusBar addSubview:_statusLabel];
    
    [self addSubview:_statusBar];
    
    _statusDot = [[StatusDot alloc] init];
    
    [_statusBar addSubview:_statusDot];
}

- (void) setupButtons
{
   _startRecordingButton = [[NSButton alloc] init];
   [_startRecordingButton setTitle:@"Start Recording"];
   [_startRecordingButton setAction:@selector(handleStartRecordingEvent:)];
   [_startRecordingButton setTarget:self];
   [_startRecordingButton setHidden:false];
   
   _pauseRecordingButton = [[NSButton alloc] init];
   [_pauseRecordingButton setTitle:@"Pause"];
   [_pauseRecordingButton setAction:@selector(handlePauseRecordingEvent:)];
   [_pauseRecordingButton setTarget:self];
   [_pauseRecordingButton setHidden:true];
   
   _cancelRecordingButton = [[NSButton alloc] init];
   [_cancelRecordingButton setTitle:@"Discard"];
   [_cancelRecordingButton setAction:@selector(handleCancelRecordingEvent:)];
   [_cancelRecordingButton setTarget:self];
   [_cancelRecordingButton setHidden:true];
   
   _resumeRecordingButton = [[NSButton alloc] init];
   [_resumeRecordingButton setTitle:@"Resume"];
   [_resumeRecordingButton setAction:@selector(handleResumeRecordingEvent:)];
   [_resumeRecordingButton setTarget:self];
   [_resumeRecordingButton setHidden:true];
   
   _finishAndSaveRecordingButton = [[NSButton alloc] init];
   [_finishAndSaveRecordingButton setTitle:@"Finish and Save"];
   [_finishAndSaveRecordingButton setAction:@selector(handleFinishAndSaveRecordingEvent:)];
   [_finishAndSaveRecordingButton setTarget:self];
   [_finishAndSaveRecordingButton setHidden:true];
   
   _buttonsStack = [[NSStackView alloc] init];
   
   [_buttonsStack setOrientation:NSUserInterfaceLayoutOrientationHorizontal];
   [_buttonsStack setAlignment:NSLayoutAttributeCenterY];
   [_buttonsStack setDistribution:NSStackViewDistributionFillEqually];
   [_buttonsStack setTranslatesAutoresizingMaskIntoConstraints:NO];
   [_buttonsStack setSpacing:15];
   
   [_buttonsStack addArrangedSubview:_startRecordingButton];
   [_buttonsStack addArrangedSubview:_pauseRecordingButton];
   [_buttonsStack addArrangedSubview:_cancelRecordingButton];
   [_buttonsStack addArrangedSubview:_resumeRecordingButton];
   [_buttonsStack addArrangedSubview:_finishAndSaveRecordingButton];
    
   [self addSubview:_buttonsStack];
}

- (void) setupLayout
{
	[_cadenceLabel centerInSuperviewAdjustedVertically:-15];
	[_resistanceLabel centerInSuperviewAdjustedVertically:-15];
	
	[NSLayoutConstraint activateConstraints:@[
		[_statusBar.heightAnchor constraintEqualToConstant:25],
		[_statusBar.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-20],
		[_statusBar.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20],
		[_statusBar.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20],
		
		[_statusDot.heightAnchor constraintEqualToConstant:10],
		[_statusDot.widthAnchor constraintEqualToConstant:10],
		[_statusDot.centerYAnchor constraintEqualToAnchor:_statusBar.centerYAnchor],
		[_statusDot.rightAnchor constraintEqualToAnchor:_statusBar.rightAnchor constant:-10],
		
		[_statusLabel.leftAnchor constraintEqualToAnchor:_statusBar.leftAnchor constant:10],
		[_statusLabel.centerYAnchor constraintEqualToAnchor:_statusBar.centerYAnchor],
		
		[_metricsStack.topAnchor constraintEqualToAnchor:self.topAnchor constant:30],
		[_metricsStack.bottomAnchor constraintEqualToAnchor:_statusBar.topAnchor constant:-15],
		[_metricsStack.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20],
		[_metricsStack.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20]
	]];
}

- (void)didUpdateStatus:(int)status {
	[_statusLabel setStringValue:[NSString stringWithUTF8String:STATUS_MESSAGES[status]]];
	
	switch (status) {
		case BLUETOOTH_POWERED_ON_SCANNING:
		case BIKE_DISCOVERED:
			[_statusDot setColour: AMBER];
			break;
			
		case BLUETOOTH_POWERED_OFF:
			[_statusDot setColour: RED];
			break;
			
		case BLUETOOTH_UNAUTHORISED:
		case BLUETOOTH_UNSUPPORTED:
		case BIKE_UNABLE_TO_CONNECT:
		case BIKE_UNABLE_TO_DISCOVER:
		case BIKE_ERROR:
			[_statusDot stopFlashing];
			[_statusDot setColour: RED];
			break;
			
		case BIKE_CONNECTED:
		case BIKE_NEEDS_CALIBRATION:
			[_statusDot stopFlashing];
			[_statusDot setColour: GREEN];
			break;
		
		case BIKE_CONNECTED_RECEIVING:
			[_statusDot startFlashing];
			[_statusDot setColour: GREEN];
			break;
	}
}

- (void)didReceiveData:(ICGLiveStreamData *)data
{
	[_cadenceLabel setStringValue: [NSString stringWithFormat:@"%d", data->cadence]];
	[_resistanceLabel setStringValue: [NSString stringWithFormat:@"%d%%", data->brake_level]];
}

@end
