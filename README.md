# lucky_money_assassin

A new way to make money.

## Getting Started

## Developer Guide

### Accessibility Service Develop

#### LifeCycle

+ [AccessibilityService#onServiceConnected()](https://developer.android.com/reference/android/accessibilityservice/AccessibilityService#onServiceConnected()): After the system binds to a service, it calls . This method can be overridden by clients that want to perform post binding setup.
+ [AccessibilityService#disableSelf()](https://developer.android.com/reference/android/accessibilityservice/AccessibilityService#disableSelf()): An accessibility service stops either when the user turns it off in device settings or when it calls .

#### Declaration

~~~xml
<service android:name=".MyAccessibilityService"
         android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE">
     <intent-filter>
         <action android:name="android.accessibilityservice.AccessibilityService" />
     </intent-filter>
     . . .
 </service>
~~~

#### Configuration

~~~xml
 <service android:name=".MyAccessibilityService">
     <intent-filter>
         <action android:name="android.accessibilityservice.AccessibilityService" />
     </intent-filter>
     <meta-data android:name="android.accessibilityservice" android:resource="@xml/accessibilityservice" />
 </service>
~~~

#### Retrieving window content

+ AccessibilityWindowsInfo
+ AccessibilityNodeInfo
