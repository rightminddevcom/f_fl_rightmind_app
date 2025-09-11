# Keep Conscrypt classes
-keep class org.conscrypt.** { *; }
-dontwarn org.conscrypt.**

# Keep Harmony SSL classes (used internally)
-keep class org.apache.harmony.xnet.provider.jsse.** { *; }
-dontwarn org.apache.harmony.xnet.provider.jsse.**

# Keep Android Conscrypt internal classes
-keep class com.android.org.conscrypt.** { *; }
-dontwarn com.android.org.conscrypt.**

# Prevent stripping platform-dependent SSL socket classes
-keep class **.KitKatPlatformOpenSSLSocketImplAdapter { *; }
-keep class **.PreKitKatPlatformOpenSSLSocketImplAdapter { *; }

# Don't strip SSLParametersImpl
-keep class **.SSLParametersImpl { *; }
