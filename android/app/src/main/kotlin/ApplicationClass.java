//import android.app.Application;
//import com.onesignal.OneSignal;
//import com.onesignal.debug.LogLevel;
//import com.onesignal.Continue;
//
//public class ApplicationClass extends Application {
//
//    // NOTE: Replace the below with your own ONESIGNAL_APP_ID
//    private static final String ONESIGNAL_APP_ID = "657673a8-a3d2-47b6-8147-0053769da5bb";
//
//    @Override
//    public void onCreate() {
//        super.onCreate();
//
//        // Verbose Logging set to help debug issues, remove before releasing your app.
//        OneSignal.getDebug().setLogLevel(LogLevel.VERBOSE);
//
//        // OneSignal Initialization
//        OneSignal.initWithContext(this, ONESIGNAL_APP_ID);
//
//        // requestPermission will show the native Android notification permission prompt.
//        // NOTE: It's recommended to use a OneSignal In-App Message to prompt instead.
//        OneSignal.getNotifications().requestPermission(false, Continue.none());
//
//    }
//}
