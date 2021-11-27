package com.ttv.attendance;

import android.widget.FrameLayout;

import io.flutter.plugin.common.MethodChannel;

public interface CameraViewInterface {

    void initCamera(FrameLayout frameLayout, boolean doFaceAnalysis, char flashMode, boolean isFillScale, int cameraSelector);
    void setCameraVisible(boolean isCameraVisible);
    void changeFlashMode(char captureFlashMode);
    void takePicture(String path, final MethodChannel.Result result);
    void pauseCamera();
    void resumeCamera();
    void dispose();

}
