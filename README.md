# lucky_money_assassin

A new way to make money.

## Getting Started

### Notice

Use of this software is subject to the risk of being blocked, please use it with caution.

### Support platform now

- [x] Android, your could [download here](https://github.com/hencejacki/RedPacketAssassin/releases/tag/1.0-beta)
- [ ] IOS
- [ ] Windows
- [ ] Linux

### The principle of this software

+ Monitor window state and content change through `accessibility service`.
+ Identify red packet by finding the specific node of widget tree.You could do that by `AirTest IDE` tools.
+ Click red packet and return to chat list.
+ Use `state machine` to manage different phase of opening red packet action.

### Task todo

- [ ] Monitor notification of red packet
- [ ] Monitor chat list
- [ ] Open red packet has a delay
- [ ] Shield specific text
...

## Developer Guide

1. Ensure your pc support flutter framework

~~~bash
flutter doctor -v
~~~

You need install flutter when you saw something didn't work.

2. Pull this repo into your local directory

~~~bash
git clone https://github.com/hencejacki/RedPacketAssassin.git
~~~

3. change directory and get some dependencies

~~~bash
cd RedPacketAssassin
flutter pub get
~~~

4. Run on your phone or simulators you created

~~~bash
flutter run -d android
~~~

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
