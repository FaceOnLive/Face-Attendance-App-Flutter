package com.abdulmomin.face_attendance
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import java.io.FileOutputStream
import com.ttv.face.*
import java.util.concurrent.LinkedBlockingQueue
import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.TimeUnit
import java.util.concurrent.ExecutorService
import android.content.Context

class MainActivity: FlutterActivity() {

  private val CHANNEL = "turingtech"
  private var appCtx: Context?= null

  init {
    appCtx = this
  }

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->

      // <--- METHOD: Verify Against All Picture --->
      if(call.method == "verify"){
        val memberList : HashMap<String, ByteArray>? = call.argument("membersList");
        val memberToBeVerified: ByteArray? = call.argument("memberToBeVerified");
        // <-- IMPORTANT -->
        // Compare and verify if the user is in the list, if he is then return the  
        //  user id associated with the map
        //  something like this "0prLJklAKJdbQgb7FNyAxEor0Zs1"
        // if there  is nothing you can return null
        
        // Do verification and
        // Put the verified user id in this variable 
        val verifiedUserID :String? = "NcGJQ2QPQ1UqgsqeJVzSmGAHXga2";
        result.success(verifiedUserID);
      } 

      // <--- METHOD: Verify Single Person --->
      else if(call.method == "verifySinglePerson"){
        val personImage : ByteArray? = call.argument("personImage");
        val capturedImage: ByteArray? = call.argument("capturedImage");
        
        // You can verify this 1to1 and put your result in this
        val isThisPersonVerified: Boolean = true;
        result.success(isThisPersonVerified);
      

      /// <--- METHOD: If a photo has face in it --->
      } else if(call.method == "detectFace"){

        // Do the verification here
        val isFaceDetecedInPhoto: Boolean = true;
        result.success(isFaceDetecedInPhoto);
      } else if(call.method == "initSDK") {
        Log.e("ddd", "init SDK!!!!");

        FaceEngine.getInstance(this).setActivation("")
        FaceEngine.getInstance(this).init(1)

        Log.e("ddd", "init ok!!!");

        result.success(true);
      }
      
      else {
        result.notImplemented()
      }
      
    }
  }
}
