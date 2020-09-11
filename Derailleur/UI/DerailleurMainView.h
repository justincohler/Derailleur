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

#import <Cocoa/Cocoa.h>
#import "BluetoothManager.h"
#import "StatusDot.h"
#import "BikeSession.h"
#import "StravaClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface DerailleurMainView : NSView <BluetoothManagerDelegate>

@property (nonatomic, strong) BikeSession *bikeSession;
@property (nonatomic, strong) StravaClient *stravaClient;

@property (nonatomic, strong) NSView *cadenceView;
@property (nonatomic, strong) NSTextField *cadenceLabel;

@property (nonatomic, strong) NSView *resistanceView;
@property (nonatomic, strong) NSTextField *resistanceLabel;

@property (nonatomic, strong) NSView *speedView;
@property (nonatomic, strong) NSTextField *speedLabel;

@property (nonatomic, strong) NSView *distanceView;
@property (nonatomic, strong) NSTextField *distanceLabel;

@property (nonatomic, strong) NSView *recordingView;

@property (nonatomic, strong) NSStackView *metricsStack;

@property (nonatomic, strong) NSView *statusBar;
@property (nonatomic, strong) NSTextField *statusLabel;
@property (nonatomic, strong) StatusDot *statusDot;

@property (nonatomic, strong) NSStackView *buttonsStack;
@property (nonatomic, strong) NSButton *startRecordingButton;
@property (nonatomic, strong) NSButton *pauseRecordingButton;
@property (nonatomic, strong) NSButton *resumeRecordingButton;
@property (nonatomic, strong) NSButton *cancelRecordingButton;
@property (nonatomic, strong) NSButton *finishAndSaveRecordingButton;

@end

NS_ASSUME_NONNULL_END
