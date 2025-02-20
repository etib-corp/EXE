all:
	keytool -genkey -v -keystore debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "C=US, O=Android, CN=Android Debug"7
	@echo "Building for armv7a"
	@mkdir -p build/assets
	@mkdir -p build/lib/arm64-v8a
	@${CLANG} --target=aarch64-linux-android29 -ffunction-sections -Os -fdata-sections -Wall -fvisibility=hidden -m64 -Os -fPIC -DANDROIDVERSION=29 -DANDROID \
	-Ideps/include -I./src -I${ANDROID_LIBS} -I${ANDROID_LIBS}/android \
	src/main.cpp deps/src/android_native_app_glue.c deps/lib/libopenxr_loader.so \
	-L${ANDROID_LIBS_LINK} -s -lm -lGLESv3 -lEGL -landroid -llog \
	-shared -uANativeActivity_onCreate \
	-o build/lib/arm64-v8a/libquestxrexample.so \

	@cp -r assets/ build/assets
	@cp -r deps/lib/libopenxr_loader.so build/lib/arm64-v8a/

	${AAPT} package -f -F temp.apk -I ${ANDROID_JAR} -M src/AndroidManifest.xml \
  	-S resources -A build/assets -v --target-sdk-version 29 build

	jarsigner -sigalg SHA1withRSA -digestalg SHA1 -verbose -keystore debug.keystore \
  	-storepass android temp.apk androiddebugkey

	${ZIPALIGN} -f -v 4 temp.apk questxrexample.apk


clean:
	rm -f debug.keystore
	rm -rf build
	rm -fr temp.apk
