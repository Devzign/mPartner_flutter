# Add project specific ProGuard rules here.

# Flutter-specific ProGuard rules

# Flutter uses reflection; keep classes and members required by Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }

# Keep platform-specific implementation classes
-keep class com.yourcompany.myapp.platform.* { *; }

# Keep native methods
-keepclasseswithmembers class * {
    native <methods>;
}

# Preserve annotations
-keepattributes *Annotation*

#-assumenosideeffects class android.util.Log {
#    public static *** d(...);
#    public static *** v(...);
#    public static *** i(...);
#    public static *** w(...);
#    public static *** e(...);
#    public static *** wtf(...);
#}

#-assumenosideeffects class io.flutter.Log {
#    public static *** d(...);
#    public static *** v(...);
#    public static *** w(...);
#    public static *** e(...);
#}

#-assumenosideeffects class java.util.logging.Level {
#    public static *** w(...);
#    public static *** d(...);
#    public static *** v(...);
#}

#-assumenosideeffects class java.util.logging.Logger {
#    public static *** w(...);
#    public static *** d(...);
#    public static *** v(...);
#}

# Removes third parties logging
#-assumenosideeffects class org.slf4j.Logger {
#    public *** trace(...);
#    public *** debug(...);
#    public *** info(...);
#    public *** warn(...);
#    public *** error(...);
#}

# Keep classes that are referenced in the Dart code
#-keep class com.luminous.mpartner.MyDartPlugin { *; }

# Keep the FlutterApplication class
#-keep class io.flutter.app.FlutterApplication { *; }

# Keep the default Application class
#-keep class com.luminous.mpartner.Application { *; }

# Keep the native methods in the default Application class
#-keepclasseswithmembers class com.luminous.mpartner.Application {
#    native <methods>;
#}

# Keep all generated class names that are used in the Flutter app
#-keep class io.flutter.plugins.GeneratedPluginRegistrant {
#    *;
#}

# Keep all classes with the FlutterActivity annotation
#-keep @io.flutter.embedding.engine.FlutterActivity class * {
#    *;
#}

# Keep all classes with the FlutterActivityAndFragment annotation
#-keep @io.flutter.embedding.android.FlutterActivityAndFragment class * {
#    *;
#}

