GO_EASY_ON_ME = 1

export THEOS_DEVICE_IP = 127.0.0.1
export THEOS_DEVICE_PORT = 2223
export THEOS_BUILD_DIR = build

ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = libTransLock
libTransLock_FILES = Tweak.xm
libTransLock_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
	rm build/*.deb