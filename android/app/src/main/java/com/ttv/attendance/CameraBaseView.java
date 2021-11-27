package com.ttv.attendance;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.LinearLayout;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class CameraBaseView implements PlatformView {


    private final Activity activity;
    private final FlutterMethodListener flutterMethodListener;
    private final FrameLayout linearLayout;
    private CameraViewInterface cameraViewInterface;

    public CameraBaseView(Activity activity, FlutterMethodListener flutterMethodListener) {
        this.activity = activity;
        this.flutterMethodListener = flutterMethodListener;
        linearLayout = new FrameLayout(activity);
        linearLayout.setLayoutParams(new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT));
        linearLayout.setBackgroundColor(Color.parseColor("#000000"));

    }

    Context getContext() {return activity;}

    public void initCamera(boolean doFaceAnalysis, char flashMode, boolean isFillScale, int androidCameraMode, int cameraSelector) {
        if (doFaceAnalysis && androidCameraMode == 1) {
            throw new RuntimeException("You cannot use barcode reader for reading barcode in Camera API1");
        }
        cameraViewInterface = new CameraKitView(activity, flutterMethodListener);
        cameraViewInterface.initCamera(linearLayout, doFaceAnalysis, flashMode, isFillScale, cameraSelector);
    }

    public void setCameraVisible(boolean isCameraVisible) {
        if (cameraViewInterface != null)
            cameraViewInterface.setCameraVisible(isCameraVisible);
    }

    public void changeFlashMode(char captureFlashMode) {
        cameraViewInterface.changeFlashMode(captureFlashMode);
    }

    public void takePicture(String path, final MethodChannel.Result result) {
        cameraViewInterface.takePicture(path, result);
    }

    public void pauseCamera() {
        cameraViewInterface.pauseCamera();
    }

    public void resumeCamera() {
        cameraViewInterface.resumeCamera();
    }

    @Override
    public View getView() {
        return linearLayout;
    }

    @Override
    public void dispose() {
        if (cameraViewInterface != null)
            cameraViewInterface.dispose();
    }
}
