package net.niuxiaoer.device_identity

import android.app.Application
import android.content.Context
import com.github.gzuliyujiang.oaid.DeviceID
import com.github.gzuliyujiang.oaid.DeviceIdentifier
class DeviceIdentityUtil(private val context: Context) {

    // 在`Application#onCreate`里初始化，注意APP合规性，若最终用户未同意隐私政策则不要调用
    fun register() {
        DeviceIdentifier.register(context as? Application)
    }

    // 获取安卓ID，可能为空
    fun getAndroidID(): String {
        return DeviceIdentifier.getAndroidID(context)
    }

    // 获取IMEI，只支持Android 10之前的系统，需要READ_PHONE_STATE权限，可能为空
    fun getIMEI(): String {
        return DeviceIdentifier.getIMEI(context)
    }

    // 获取OAID/AAID，同步调用
    fun getOAID(): String {
        if (DeviceID.supportedOAID(context)) {
            return DeviceIdentifier.getOAID(context)
        }

        return ""
    }

    // 获取UA
    fun getUA(): String {
        return System.getProperty("http.agent")
    }

}