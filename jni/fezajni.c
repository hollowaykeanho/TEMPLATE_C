#include <jni.h>

JNIEXPORT jstring JNICALL
Java_fezajni_shim_feza_hello(JNIEnv *env, jclass type) {
    return (*env)->NewStringUTF(env, "Hello World from C");
}
