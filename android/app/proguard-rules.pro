# Fix for WorkManager crash in release mode (used by flutter_downloader)
-keep class androidx.work.impl.** { *; }
-dontwarn androidx.work.impl.**

# Keep Room database classes if affected
-keep class * extends androidx.room.RoomDatabase { *; }