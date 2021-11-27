package com.ttv.attendance;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Point;
import android.graphics.SurfaceTexture;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraCharacteristics;
import android.hardware.camera2.CameraManager;
import android.hardware.camera2.params.StreamConfigurationMap;
import android.media.Image;
import android.os.Build;
import android.os.Looper;
import android.os.Handler;
import android.util.Log;
import android.util.Size;
import java.util.Comparator;
import android.view.Surface;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.LifecycleOwner;


import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.HashMap;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executor;

import io.flutter.plugin.common.MethodChannel;

import static android.content.ContentValues.TAG;

@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
public class CameraViewX implements CameraViewInterface {

//    private static final int MAX_PREVIEW_WIDTH = 1920;
//    private static final int MAX_PREVIEW_HEIGHT = 1080;
//
//    private final Activity activity;
//    private final FlutterMethodListener flutterMethodListener;
//    private ImageCapture imageCapture;
//    private boolean doFaceAnalysis;
//    private char previewFlashMode;
//    private int userCameraSelector;
//    private Point displaySize;
//    private PreviewView previewView;
////    private ListenableFuture<ProcessCameraProvider> cameraProviderFuture;
//    private ImageAnalysis imageAnalyzer;
//    private boolean isCameraVisible = true;
//    private ProcessCameraProvider cameraProvider;
//    private Camera camera;
//    private CameraSelector cameraSelector;
//    private Preview preview;
//    private Size optimalPreviewSize;
//
//
    public CameraViewX(Activity activity, FlutterMethodListener flutterMethodListener) {

//        this.activity = activity;
//        this.flutterMethodListener = flutterMethodListener;

    }

    @Override
    public void initCamera(FrameLayout linearLayout, boolean doFaceAnalysis, char flashMode, boolean isFillScale, int cameraSelector) {
//        this.doFaceAnalysis = doFaceAnalysis;
//        this.previewFlashMode = flashMode;
//
//        userCameraSelector = cameraSelector;
//
//        displaySize = new Point();
//        activity.getWindowManager().getDefaultDisplay().getSize(displaySize);
//        if (isFillScale == true) //fill
//            linearLayout.setLayoutParams(new FrameLayout.LayoutParams(
//                    displaySize.x,
//                    displaySize.y));
//
//        previewView = new PreviewView(activity);
//        previewView.setLayoutParams(new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
//        linearLayout.addView(previewView);
////        startCamera();

        Log.e("ddd", "initCamera");
    }
//
//
//    private int getFlashMode() {
//        switch (previewFlashMode) {
//            case 'O':
//                return ImageCapture.FLASH_MODE_ON;
//            case 'F':
//                return ImageCapture.FLASH_MODE_OFF;
//            case 'A':
//                return ImageCapture.FLASH_MODE_AUTO;
//            default:
//                return ImageCapture.FLASH_MODE_AUTO;
//        }
//    }
//
////    static class CompareSizesByArea implements Comparator<Size> {
////
////        @Override
////        public int compare(Size lhs, Size rhs) {
////            // We cast here to ensure the multiplications won't overflow
////            return Long.signum((long) lhs.getWidth() * lhs.getHeight() -
////                    (long) rhs.getWidth() * rhs.getHeight());
////        }
////    }
//
////    private static Size chooseOptimalSize(Size[] choices, int textureViewWidth,
////                                          int textureViewHeight, int maxWidth, int maxHeight) {
//
////        // Collect the supported resolutions that are at least as big as the preview Surface
////        List<Size> bigEnough = new ArrayList<>();
////        // Collect the supported resolutions that are smaller than the preview Surface
////        List<Size> notBigEnough = new ArrayList<>();
////
////        int w = 16;
////        int h = 9;
////        for (Size option : choices) {
////            if (option.getWidth() <= maxWidth && option.getHeight() <= maxHeight &&
////                    option.getHeight() == option.getWidth() * h / w) {
////                if (option.getWidth() >= textureViewWidth &&
////                        option.getHeight() >= textureViewHeight) {
////                    bigEnough.add(option);
////                } else {
////                    notBigEnough.add(option);
////                }
////            }
////        }
////
////        // Pick the smallest of those big enough. If there is no one big enough, pick the
////        // largest of those not big enough.
////        if (bigEnough.size() > 0) {
////            return Collections.min(bigEnough, new CompareSizesByArea());
////        } else if (notBigEnough.size() > 0) {
////            return Collections.max(notBigEnough, new CompareSizesByArea());
////        } else {
////            Log.e(TAG, "Couldn't find any suitable preview size");
////            return choices[0];
////        }
////    }
//
//
////    private void prepareOptimalSize() {
////        int width = previewView.getWidth();
////        int height = previewView.getHeight();
////        CameraManager manager = (CameraManager) activity.getSystemService(Context.CAMERA_SERVICE);
////        try {
////            for (String cameraId : manager.getCameraIdList()) {
////                CameraCharacteristics characteristics = manager.getCameraCharacteristics(cameraId);
////
////                // We don't use a front facing camera in this sample.
////                Integer facing = characteristics.get(CameraCharacteristics.LENS_FACING);
////                Boolean available = characteristics.get(CameraCharacteristics.FLASH_INFO_AVAILABLE);
////                if (facing != null && facing == CameraCharacteristics.LENS_FACING_FRONT) {
////                    if (userCameraSelector == 0)
////                        continue;
////                } else {
////                    if (userCameraSelector == 1)
////                        continue;
////                }
////                StreamConfigurationMap map = characteristics.get(
////                        CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP);
////                if (map == null) {
////                    continue;
////                }
////
////
////                // Find out if we need to swap dimension to get the preview size relative to sensor
////                // coordinate.
////                int displayRotation = activity.getWindowManager().getDefaultDisplay().getRotation();
////                //noinspection ConstantConditions
////                Integer sensorOrientation = characteristics.get(CameraCharacteristics.SENSOR_ORIENTATION);
////                boolean swappedDimensions = false;
////                switch (displayRotation) {
////                    case Surface.ROTATION_0:
////                    case Surface.ROTATION_180:
////                        if (sensorOrientation == 90 || sensorOrientation == 270) {
////                            swappedDimensions = true;
////                        }
////                        break;
////                    case Surface.ROTATION_90:
////                    case Surface.ROTATION_270:
////                        if (sensorOrientation == 0 || sensorOrientation == 180) {
////                            swappedDimensions = true;
////                        }
////                        break;
////                    default:
////                        Log.e(TAG, "Display rotation is invalid: " + displayRotation);
////                }
////
////
////                int rotatedPreviewWidth = width;
////                int rotatedPreviewHeight = height;
////                int maxPreviewWidth = displaySize.x;
////                int maxPreviewHeight = displaySize.y;
////
////                if (swappedDimensions) {
////                    rotatedPreviewWidth = height;
////                    rotatedPreviewHeight = width;
////                    maxPreviewWidth = displaySize.y;
////                    maxPreviewHeight = displaySize.x;
////                }
////
////                if (maxPreviewWidth > MAX_PREVIEW_WIDTH) {
////                    maxPreviewWidth = MAX_PREVIEW_WIDTH;
////                }
////
////                if (maxPreviewHeight > MAX_PREVIEW_HEIGHT) {
////                    maxPreviewHeight = MAX_PREVIEW_HEIGHT;
////                }
////
////                // Danger, W.R.! Attempting to use too large a preview size could  exceed the camera
////                // bus' bandwidth limitation, resulting in gorgeous previews but the storage of
////                // garbage capture data.
////                Size previewSize = chooseOptimalSize(map.getOutputSizes(SurfaceTexture.class),
////                        rotatedPreviewWidth, rotatedPreviewHeight, maxPreviewWidth,
////                        maxPreviewHeight);
////                int orientation = activity.getResources().getConfiguration().orientation;
////                if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
////                    optimalPreviewSize = new Size(previewSize.getWidth(), previewSize.getHeight());
////                } else {
////                    optimalPreviewSize = new Size(previewSize.getHeight(), previewSize.getWidth());
////                }
////
////                return;
////            }
////        } catch (CameraAccessException e) {
////            e.printStackTrace();
////        } catch (NullPointerException e) {
////            // Currently an NPE is thrown when the Camera2API is used but not supported on the
////            // device this code runs.
////            e.printStackTrace();
////        }
////    }
//
//    private void startCamera() {
//        Log.e("ddd", "startCamrea");
////        cameraProviderFuture = ProcessCameraProvider.getInstance(activity);
////        cameraProviderFuture.addListener(new Runnable() {
////            @Override
////            public void run() {
////                try {
////                    cameraProvider = cameraProviderFuture.get();
////
////                    prepareOptimalSize();
////                    preview = new Preview.Builder()
////                            .setTargetResolution(new Size(optimalPreviewSize.getWidth(), optimalPreviewSize.getHeight()))
////                            .build();
////                    preview.setSurfaceProvider(previewView.createSurfaceProvider());
////
////
////                    imageCapture = new ImageCapture.Builder()
////                            .setFlashMode(getFlashMode())
////                            .setTargetResolution(new Size(optimalPreviewSize.getWidth(), optimalPreviewSize.getHeight()))
////                            .setCaptureMode(ImageCapture.CAPTURE_MODE_MINIMIZE_LATENCY)
////                            .build();
////
////                    if (doFaceAnalysis) {
////
////                    }
////
////
////                    if (userCameraSelector == 0)
////                        cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA;
////                    else cameraSelector = CameraSelector.DEFAULT_FRONT_CAMERA;
////
////                    bindCamera();
////
////
////                } catch (ExecutionException e) {
////                    e.printStackTrace();
////                } catch (InterruptedException e) {
////                    e.printStackTrace();
////                }
////            }
////        }, ContextCompat.getMainExecutor(activity));
//    }
//
//
//    void setFlashBarcodeReader() {
//        Log.e("ddd", "setFlashBarcodeReader");
////        if (camera != null) {
////            if (previewFlashMode == 'O')
////                camera.getCameraControl().enableTorch(true);
////            else camera.getCameraControl().enableTorch(false);
////        }
//    }
//
//    private void bindCamera() {
//        Log.e("ddd", "bindCamera");
////        cameraProvider.unbindAll();
////        if (doFaceAnalysis) {
////            camera = cameraProvider.bindToLifecycle((LifecycleOwner) activity, cameraSelector
////                    , preview, imageCapture, imageAnalyzer);
////            setFlashBarcodeReader();
////        } else {
////            cameraProvider.bindToLifecycle((LifecycleOwner) activity, cameraSelector
////                    , preview, imageCapture);
////        }
//    }
//
//
    @Override
    public void setCameraVisible(boolean isCameraVisible) {
        Log.e("ddd", "setCameraVisible");
//        if (isCameraVisible != this.isCameraVisible) {
//            this.isCameraVisible = isCameraVisible;
//            if (isCameraVisible) resumeCamera2();
//            else pauseCamera2();
//        }
    }

    @Override
    public void changeFlashMode(char newPreviewFlashMode) {
        Log.e("ddd", "changeFlashMode");
//        previewFlashMode = newPreviewFlashMode;
//        imageCapture.setFlashMode(getFlashMode());
//        if (doFaceAnalysis) {
//            setFlashBarcodeReader();
//        }
    }


    @Override
    public void takePicture(String path, final MethodChannel.Result result) {
//        final File file = getPictureFile(path);
//        ImageCapture.OutputFileOptions outputOptions = new ImageCapture.OutputFileOptions.Builder(file).build();
//
//
//        // Set up image capture listener, which is triggered after photo has
//        // been taken
//        imageCapture.takePicture(
//                outputOptions, ContextCompat.getMainExecutor(activity), new ImageCapture.OnImageSavedCallback() {
//                    @Override
//                    public void onImageSaved(@NonNull ImageCapture.OutputFileResults outputFileResults) {
//                        flutterMethodListener.onTakePicture(result, file + "");
//                    }
//
//                    @Override
//                    public void onError(@NonNull ImageCaptureException exception) {
//                        flutterMethodListener.onTakePictureFailed(result, "-1", exception.getMessage());
//                    }
//                });
    }

    @Override
    public void pauseCamera() {
        Log.e("ddd", "pauseCamera");
    }

    @Override
    public void resumeCamera() {
        Log.e("ddd", "resumeCamera");
//        if (doFaceAnalysis && isCameraVisible) {
//            setFlashBarcodeReader();
//        }
    }

    @Override
    public void dispose() {

    }
//
//
//    public void pauseCamera2() {
//        cameraProvider.unbindAll();
////        if (scanner != null) {
////            scanner.close();
////            scanner = null;
////        }
//    }
//
//    public void resumeCamera2() {
//        if (isCameraVisible) {
////            if (scanner == null && doFaceAnalysis) scanner = BarcodeScanning.getClient(options);
//            startCamera();
//        }
//    }
//
//    private File getPictureFile(String path) {
////        if (path.equals(""))
////            return new File(activity.getCacheDir(), "pic.jpg");
////        else return new File(path);
//        return null;
//    }
//
////
////    private class BarcodeAnalyzer implements ImageAnalysis.Analyzer {
////        @Override
////        public void analyze(@NonNull final ImageProxy imageProxy) {
////            @SuppressLint("UnsafeExperimentalUsageError") Image mediaImage = imageProxy.getImage();
////            if (mediaImage != null) {
////                final InputImage image =
////                        InputImage.fromMediaImage(mediaImage, imageProxy.getImageInfo().getRotationDegrees());
////
////                final ArrayList<FaceBox> faces = IPhoenix.Factory.detectFace(BitmapUtils.getBitmap(imageProxy));
////
////                new Handler(Looper.getMainLooper()).post(new Runnable() {
////                    @Override
////                    public void run() {
////                        ArrayList<HashMap<String, Object>> mapList = new ArrayList<>();
////                        if(faces != null) {
////                            for(FaceBox box: faces) {
////                                HashMap<String, Object> e = new HashMap<>();
////                                e.put("x", box.mLeft);
////                                e.put("y", box.mTop);
////                                e.put("w", box.mRight - box.mLeft);
////                                e.put("h", box.mBottom - box.mTop);
////                                e.put("pan", box.mPan);
////                                e.put("pitch", box.mPitch);
////                                e.put("brisque", box.mBrisque);
////                                e.put("eyedist", box.mEyeDist);
////                                e.put("liveness", box.mLiveness);
////                                e.put("eyeClosed", box.mEyeClose);
////                                e.put("mask", box.mMask);
////                                e.put("sunglass", box.mSunglass);
////                                e.put("leftEyeX", box.mLeftEyeX);
////                                e.put("leftEyeY", box.mLeftEyeY);
////                                e.put("rightEyeX", box.mRightEyeX);
////                                e.put("rightEyeY", box.mRightEyeY);
////                                e.put("faceScore", box.mFaceScore);
////                                e.put("image_width", image.getWidth());
////                                e.put("image_height", image.getHeight());
////
////                                mapList.add(e);
////                            }
////                        }
////                        flutterMethodListener.onFaceDetected(mapList);
////                    }
////                });
////                imageProxy.close();
////            }
////        }
////    }
////

}
