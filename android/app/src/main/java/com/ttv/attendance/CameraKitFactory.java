package com.ttv.attendance;

import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;

import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class CameraKitFactory extends PlatformViewFactory {
    private ActivityPluginBinding pluginBinding;
    private BinaryMessenger binaryMessenger;

    public CameraKitFactory(ActivityPluginBinding pluginBinding, BinaryMessenger binaryMessenger) {
        super(StandardMessageCodec.INSTANCE);

        this.pluginBinding = pluginBinding;
        this.binaryMessenger = binaryMessenger;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new CameraKitFlutterView(pluginBinding, binaryMessenger, viewId);
    }
}
