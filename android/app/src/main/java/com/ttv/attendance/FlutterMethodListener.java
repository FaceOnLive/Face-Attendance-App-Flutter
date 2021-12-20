package com.ttv.attendance;

import io.flutter.plugin.common.MethodChannel;
import java.util.ArrayList;
import java.util.HashMap;

public interface FlutterMethodListener {

    void onFaceDetected(ArrayList<HashMap<String,Object>> faces);

    void onRecognized(int searchedID);

    void onTakePicture(MethodChannel.Result result, String filePath);

    void onTakePictureFailed(MethodChannel.Result result, String errorCode, String errorMessage);
}
