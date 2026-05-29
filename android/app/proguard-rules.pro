# Flutter embedder / plugins — keep classes R8 might otherwise remove or break.
# See: https://docs.flutter.dev/deployment/android#enabling-proguard-r8

-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Gson / reflective models (uncomment if you add Gson and use reflection for JSON)
# -keepattributes Signature
# -keepattributes *Annotation*
# -keep class com.google.gson.** { *; }

# Flutter PlayStoreDeferredComponentManager references legacy play.core.tasks.*; modular
# Play Feature Delivery uses GMS tasks instead. Deferred components are off → AGP/R8 allow missing refs.
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
