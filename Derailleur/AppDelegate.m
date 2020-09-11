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

#import <IOKit/pwr_mgt/IOPMLib.h>

#import "AppDelegate.h"
#import "DerailleurMainView.h"
#import "NSColor+DerailleurColours.h"

@implementation AppDelegate
{
	IOPMAssertionID preventSleepAssertion;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSSize windowSize = NSMakeSize(250, 800);
	NSSize screenSize = NSScreen.mainScreen.frame.size;
	
	NSRect windowRect = NSMakeRect(screenSize.width / 2 - windowSize.width / 2, screenSize.height / 2 - windowSize.height / 2, windowSize.width, windowSize.height);
	
	_window = [[NSWindow alloc] initWithContentRect:windowRect styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskFullSizeContentView backing:NSBackingStoreBuffered defer:NO];
	
	[_window setMovableByWindowBackground:YES];
	[_window setTitleVisibility:NSWindowTitleHidden];
	[_window setTitlebarAppearsTransparent:YES];
	[_window setAppearance:[NSAppearance appearanceNamed: NSAppearanceNameDarkAqua]];
	
	[_window setContentView: [[DerailleurMainView alloc] init]];
	
	[_window makeKeyAndOrderFront:nil];
	
	/* Setup BluetoothManager here rather than in DerailleurMainView */
	_bluetoothManager = [[BluetoothManager alloc] init];
	[_bluetoothManager setDelegate: [_window contentView]];
	
	/* Prevent display from sleeping until the application closes */
	IOPMAssertionCreateWithName(kIOPMAssertionTypeNoIdleSleep, kIOPMAssertionLevelOn, CFSTR("Derailleur displaying data"), &preventSleepAssertion);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	/* Remove IOPMAssertion preventing display from sleeping while idle */
	IOPMAssertionRelease(preventSleepAssertion);
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

- (void)startConnect:(id)sender
{
	[_bluetoothManager startConnectAttempt];
}

- (void)disconnect:(id)sender
{
	[_bluetoothManager disconnectBike];
}

@end
