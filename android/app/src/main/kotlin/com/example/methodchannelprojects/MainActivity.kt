package com.example.methodchannelprojects

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channelName = "ShowToast"
    private val batteryChannel = "BatteryChannel"
    private lateinit var channel2 : MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel2 = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,batteryChannel)
        channel2.setMethodCallHandler { call, result ->
            if(call.method == "getBattery"){

                var batteryLevell = getBatteryLevel(context)
                result.success(batteryLevell)
                
            }
        }

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channelName)
        channel.setMethodCallHandler { call, result ->

            if(call.method =="showToast"){

                Toast.makeText(this,"toast",Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun getBatteryLevel(context: Context): Int{
        var batteryLevel = -1 // Default value if battery level cannot be determined
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = context.getSystemService(BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        }
//        else{
//            Intent intent = new ContextWrapper(context).registerReceiver(null,new IntentFilter(Intent.ACTION_BATTERY_CHANGED))
//        }
//        List<int>arr = []
//        arr.add()

        return batteryLevel
    }

//    private fun getBatterLevel(): {
//        int batteryLevel;
//                if(VERSION.SDK_INT>=VERSION_CODES.LOLLIPOP){
//            val batteryManager = getSystemService(Context.BATTERY_SERVICE)as BatteryManager
//                    batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
//        }else{
//
//                }
//return null;
//    }
}
