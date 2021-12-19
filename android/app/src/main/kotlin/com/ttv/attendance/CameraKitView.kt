package com.ttv.attendance

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.Rect
import android.icu.util.UniversalTimeScale.toLong
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.util.Log
import android.util.Size
import android.view.View
import android.view.ViewGroup
import android.app.Activity
import android.widget.FrameLayout
import com.ttv.face.*
import com.ttv.attendance.FaceRectView
import com.ttv.attendance.FaceRectTransformer
import com.ttv.face.enums.ExtractType
import io.fotoapparat.Fotoapparat
import io.fotoapparat.parameter.Resolution
import io.fotoapparat.preview.Frame
import io.fotoapparat.selector.front
import io.fotoapparat.view.CameraView
import io.fotoapparat.util.FrameProcessor
import java.util.concurrent.LinkedBlockingQueue
import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.TimeUnit
import java.util.concurrent.ExecutorService
import android.graphics.Point
import io.flutter.plugin.common.MethodChannel

class CameraKitView(activity: Activity, flutterMethodListener: FlutterMethodListener) : CameraViewInterface {

    private var activity: Activity? = null
    private var flutterMethodListener: FlutterMethodListener? = null

    private var permissionsDelegate:PermissionsDelegate? = null
    private var hasPermission = false
    private var appCtx: Context? = null
    private var cameraView: CameraView? = null
    private var rectanglesView: FaceRectView? = null
    private var faceRectTransformer: FaceRectTransformer? = null
    private var frontFotoapparat: Fotoapparat? = null
    private var previewFlashMode = 0
    private var doFaceAnalysis = false
    private var displaySize = Point()

    init {
        this.activity = activity
        this.flutterMethodListener = flutterMethodListener
        this.appCtx = activity
        this.permissionsDelegate = PermissionsDelegate(activity)
    }

    override fun initCamera(
        linearLayout: FrameLayout,
        doFaceAnalysis: Boolean,
        flashMode: Char,
        isFillScale: Boolean,
        cameraSelector: Int
    ) {
        this.doFaceAnalysis = doFaceAnalysis
        this.previewFlashMode = flashMode.toInt()

        activity!!.windowManager?.defaultDisplay?.getSize(displaySize!!)
        if (isFillScale == true) //fill
            linearLayout?.setLayoutParams(
                FrameLayout.LayoutParams(
                    displaySize.x,
                    displaySize.y
                )
            )

        Log.e("ddd", "init camera: " + displaySize!!)
        cameraView = CameraView(this.appCtx!!)
        cameraView!!.setLayoutParams(
            FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT))

        rectanglesView = FaceRectView(this.appCtx!!)
        rectanglesView!!.setLayoutParams(
            FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT))

        linearLayout?.addView(cameraView)
        linearLayout?.addView(rectanglesView)

        hasPermission = permissionsDelegate?.hasPermissions()!!
        if (hasPermission) {
            cameraView!!.visibility = View.VISIBLE
        } else {
            permissionsDelegate?.requestPermissions()
        }

        frontFotoapparat = Fotoapparat.with(this.appCtx!!)
            .into(cameraView!!)
            .lensPosition(front())
            .frameProcessor(SampleFrameProcessor())
            .previewResolution { Resolution(1280,720) }
            .build()
    }


    override fun setCameraVisible(isCameraVisible: Boolean) {
        Log.e("ddd", "setCameraVisible " + isCameraVisible)
        if(hasPermission && isCameraVisible) {
            frontFotoapparat!!.start()
        } else {
            try {
                frontFotoapparat!!.stop()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    override fun changeFlashMode(newPreviewFlashMode: Char) {
        Log.e("ddd", "changeFlashMode")
    }

    override fun takePicture(path: String?, result: MethodChannel.Result?) {
        Log.e("ddd", "takePicture ")
    }

    override fun pauseCamera() {
        Log.e("ddd", "pauseCamera")
    }

    override fun resumeCamera() {
        Log.e("ddd", "resumeCamera")
    }

    override fun dispose() {}


    fun adjustPreview(frameWidth: Int, frameHeight: Int, rotation: Int) : Boolean{
        if(faceRectTransformer == null) {
            val frameSize: Size = Size(frameWidth, frameHeight);
            if(cameraView!!.measuredWidth == 0)
                return false;

            adjustPreviewViewSize (cameraView!!, rectanglesView!!);

            faceRectTransformer = FaceRectTransformer (
                frameSize.width, frameSize.height,
                cameraView!!.getLayoutParams().width, cameraView!!.getLayoutParams().height,
                rotation, 0, false,
                false,
                false);

            return true;
        }

        return true;
    }

    private fun adjustPreviewViewSize(
        previewView: View,
        faceRectView: FaceRectView,
    ): ViewGroup.LayoutParams? {
        val layoutParams = previewView.layoutParams
        val measuredWidth = previewView.measuredWidth
        val measuredHeight = previewView.measuredHeight
        layoutParams.width = measuredWidth
        layoutParams.height = measuredHeight

        faceRectView.layoutParams.width = measuredWidth
        faceRectView.layoutParams.height = measuredHeight
        return layoutParams
    }

    /* access modifiers changed from: private */ /* access modifiers changed from: public */
    private fun sendMessage(w: Int, o: Any) {
        val message = Message()
        message.what = w
        message.obj = o
        mHandler.sendMessage(message)
    }

    inner class SampleFrameProcessor : FrameProcessor {
        var frThreadQueue: LinkedBlockingQueue<Runnable>? = null
        var frExecutor: ExecutorService? = null

        init {
            frThreadQueue = LinkedBlockingQueue<Runnable>(1)
            frExecutor = ThreadPoolExecutor(
                1, 1, 0, TimeUnit.MILLISECONDS, frThreadQueue
            ) { r: Runnable? ->
                val t = Thread(r)
                t.name = "frThread-" + t.id
                t
            }
        }

        override fun invoke(frame: Frame) {
            val faceResults:List<FaceResult> = FaceEngine.getInstance(appCtx).detectFace(frame.image, frame.size.width, frame.size.height)

            if(adjustPreview(frame.size.width, frame.size.height, frame.rotation))
                sendMessage(0, faceResults)
//            if(faceResults.count() > 0) {
//                FaceEngine.getInstance(appCtx).livenessProcess(frame.image, frame.size.width, frame.size.height, faceResults)
//                if(frThreadQueue!!.remainingCapacity() > 0) {
//                    frExecutor!!.execute(
//                        FaceRecognizeRunnable(
//                            frame.image,
//                            frame.size.width,
//                            frame.size.height,
//                            faceResults
//                        )
//                    )
//                }
//            }
//            if(adjustPreview(frame.size.width, frame.size.height, frame.rotation))
//                sendMessage(0, faceResults)
        }
    }

    private val mHandler: Handler = object : Handler() {
        override fun handleMessage(msg: Message) {
            val i: Int = msg.what
            if (i == 0) {
                var drawInfoList = ArrayList<FaceRectView.DrawInfo>();
                var detectionResult = msg.obj as ArrayList<FaceResult>

                for(faceResult in detectionResult) {
                    var rect : Rect = faceRectTransformer!!.adjustRect(faceResult.rect);
                    var drawInfo : FaceRectView.DrawInfo;
                    if(faceResult.liveness == 1)
                        drawInfo = FaceRectView.DrawInfo(rect, 0, 0, 1, Color.GREEN, null);
                    else
                        drawInfo = FaceRectView.DrawInfo(rect, 0, 0, 0, Color.GREEN, null);

                    drawInfoList.add(drawInfo);
                }

                rectanglesView!!.clearFaceInfo();
                rectanglesView!!.addFaceInfo(drawInfoList);
            }
        }
    }
}