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
import android.graphics.BitmapFactory

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
        val isThisPersonVerified: Boolean = false;

        val image1 = BitmapFactory.decodeByteArray(personImage!!, 0, personImage!!.size)
        if(image1 != null) {
          val faceResults1:List<FaceResult> = FaceEngine.getInstance(this).detectFace(image1)
          if(faceResults1.count() == 1) {
            FaceEngine.getInstance(this).extractFeature(image1, true, faceResults1)

            val image2 = BitmapFactory.decodeByteArray(capturedImage!!, 0, capturedImage!!.size)
            val faceResults2:List<FaceResult> = FaceEngine.getInstance(this).detectFace(image1)
            if(faceResults2.count() == 1) {
              FaceEngine.getInstance(this).extractFeature(image2, false, faceResults2)
              val score = FaceEngine.getInstance(this).compareFeature(faceResults1.get(0).feature, faceResults1.get(1).feature)
              if(score > 0.82) {
                isThisPersonVerified = true
              }
            }
          }
        }

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
      } else if(call.method == "getFeature") {
        Log.e("ddd", "getFeature!!!!");

        val capturedImage: ByteArray? = call.argument("image");
        val mode:Int = call.argument("mode");
        if(capturedImage != null) {
          val image = BitmapFactory.decodeByteArray(capturedImage!!, 0, capturedImage!!.size)
          val faceResults:List<FaceResult> = FaceEngine.getInstance(this).detectFace(image)
          if(faceResults.count() == 1) {
            FaceEngine.getInstance(this).extractFeature(image, true, faceResults)

            return result.success(faceResults.get(0).feature);
          }

        result.success(null);
      }
      
      else {
        result.notImplemented()
      }
      
    }
  }
}
