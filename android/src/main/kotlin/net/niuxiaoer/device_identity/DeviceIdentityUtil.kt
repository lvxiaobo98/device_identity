package net.niuxiaoer.device_identity

import android.app.Application
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.github.gzuliyujiang.oaid.DeviceID
import com.github.gzuliyujiang.oaid.DeviceIdentifier
import com.github.gzuliyujiang.oaid.IGetter

class DeviceIdentityUtil(private val context: Context) {

    companion object {
        private const val TAG = "DeviceIdentityUtil"
    }

    // 在`Application#onCreate`里初始化，注意APP合规性，若最终用户未同意隐私政策则不要调用
    fun register() {
        try {
            val app = context.applicationContext as? Application
            if (app != null) {
                DeviceIdentifier.register(app)
            } else {
                Log.w(TAG, "register: context is not an Application instance")
            }
        } catch (e: Exception) {
            Log.e(TAG, "register failed", e)
        }
    }

    // 获取安卓ID，可能为空
    fun getAndroidID(): String {
        return try {
            DeviceIdentifier.getAndroidID(context) ?: ""
        } catch (e: Exception) {
            Log.e(TAG, "getAndroidID failed", e)
            ""
        }
    }

    // 获取IMEI，只支持Android 10之前的系统，需要READ_PHONE_STATE权限，可能为空
    fun getIMEI(): String {
        return try {
            DeviceIdentifier.getIMEI(context) ?: ""
        } catch (e: Exception) {
            Log.e(TAG, "getIMEI failed", e)
            ""
        }
    }

    // 异步获取 OAID/AAID，通过回调返回结果
    // 使用回调版接口可避免 register() 尚未完成时同步读缓存返回空字符串的竞态问题
    fun getOAID(callback: (String) -> Unit) {
        if (!DeviceID.supportedOAID(context)) {
            callback("")
            return
        }
        try {
            DeviceID.getOAID(context, object : IGetter {
                override fun onSuccessful(oaid: String?) {
                    mainThread { callback(oaid ?: "") }
                }

                override fun onError(e: Exception?) {
                    Log.e(TAG, "getOAID error", e)
                    mainThread { callback("") }
                }
            })
        } catch (e: Exception) {
            Log.e(TAG, "getOAID failed", e)
            callback("")
        }
    }

    private fun mainThread(block: () -> Unit) {
        Handler(Looper.getMainLooper()).post(block)
    }

    // 获取UA
    fun getUA(): String {
        return try {
            System.getProperty("http.agent") ?: ""
        } catch (e: Exception) {
            Log.e(TAG, "getUA failed", e)
            ""
        }
    }
}