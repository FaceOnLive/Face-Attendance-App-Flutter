package com.ttv.attendance;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.view.View;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;

@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
public class CameraKitFlutterView implements PlatformView, MethodChannel.MethodCallHandler, FlutterMethodListener {


    private static final int REQUEST_CAMERA_PERMISSION = 10001;
    private final MethodChannel channel;
    private final ActivityPluginBinding activityPluginBinding;
    private CameraBaseView cameraView;


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final MethodChannel.Result result) {
        if (call.method.equals("requestPermission")) {
            if (ActivityCompat.checkSelfPermission(activityPluginBinding.getActivity(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(activityPluginBinding.getActivity(), new String[]{Manifest.permission.CAMERA}, REQUEST_CAMERA_PERMISSION);
                activityPluginBinding.addRequestPermissionsResultListener(new PluginRegistry.RequestPermissionsResultListener() {
                    @Override
                    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
                        for (int i :
                                grantResults) {
                            if (i == PackageManager.PERMISSION_DENIED) {
                                try {
                                    result.success(false);
                                }catch (Exception e){

                                }
                                return false;
                            }
                        }
                        try {
                            result.success(true);
                        } catch (Exception e) {

                        }
                        return false;
                    }
                });
                return;
            } else {
                try {
                    result.success(true);
                } catch (Exception e) {

                }
            }
        } else if (call.method.equals("initCamera")) {

            boolean doFaceAnalysis = call.argument("doFaceAnalysis");
            char flashMode = call.argument("flashMode").toString().charAt(0);
            boolean isFillScale = call.argument("isFillScale");
            int androidCameraMode = call.argument("androidCameraMode");
            int cameraSelector = call.argument("cameraSelector");
            getCameraView().initCamera(doFaceAnalysis, flashMode, isFillScale
                    , androidCameraMode, cameraSelector);

        } else if (call.method.equals("resumeCamera")) {
            getCameraView().resumeCamera();

        } else if (call.method.equals("pauseCamera")) {
            getCameraView().pauseCamera();
        } else if (call.method.equals("takePicture")) {
            String path = call.argument("path").toString();
            getCameraView().takePicture(path, result);
        } else if (call.method.equals("changeFlashMode")) {
            char captureFlashMode = call.argument("flashMode").toString().charAt(0);
            getCameraView().changeFlashMode(captureFlashMode);
        } else if (call.method.equals("dispose")) {
            dispose();
        } else if (call.method.equals("setCameraVisible")) {
            boolean isCameraVisible = call.argument("isCameraVisible");
            getCameraView().setCameraVisible(isCameraVisible);
        } else {
            result.notImplemented();
        }
    }

    private CameraBaseView getCameraView() {
        return cameraView;
    }

    public CameraKitFlutterView(ActivityPluginBinding activityPluginBinding, DartExecutor dartExecutor, int viewId) {
        this.channel = new MethodChannel(dartExecutor, "plugins/camera_kit_" + viewId);
        this.activityPluginBinding = activityPluginBinding;
        this.channel.setMethodCallHandler(this);
        if (getCameraView() == null) {
            cameraView = new CameraBaseView(activityPluginBinding.getActivity(), this);
        }
    }

    @Override
    public View getView() {
        return getCameraView().getView();
    }

    @Override
    public void dispose() {
        if (getCameraView() != null) {
            getCameraView().dispose();
        }
    }

    @Override
    public void onFaceDetected(ArrayList<HashMap<String,Object>> faces) {
        channel.invokeMethod("onFaceDetected", faces);
    }

    @Override
    public void onRecognized(int searchedID) {
        channel.invokeMethod("onRecognized", searchedID);
    }

    @Override
    public void onTakePicture(final MethodChannel.Result result, final String filePath) {
        activityPluginBinding.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                result.success(filePath);
            }
        });
    }

    @Override
    public void onTakePictureFailed(final MethodChannel.Result result, final String errorCode, final String errorMessage) {
        activityPluginBinding.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                result.error(errorCode, errorMessage, null);
            }
        });
    }
}
