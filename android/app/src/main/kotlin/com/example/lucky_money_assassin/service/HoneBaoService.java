package com.example.lucky_money_assassin.service;

import android.accessibilityservice.AccessibilityService;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;

import com.example.lucky_money_assassin.constant.PhaseStatus;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * 主要业务逻辑
 */
public class HoneBaoService extends AccessibilityService {

    private static final String TARGET_PACKAGE_NAME = "com.tencent.mm";
    // TODO: 优化
    private static final String TARGET_VIEW_ID = "com.tencent.mm:id/a3u";

    // 开红包按钮view_id
    private static final String HONGBAO_BTN_VIEW_ID = "com.tencent.mm:id/j6g";

    // 红包状态view_id
    private static final String HONGBAO_STATUS_VIEW_ID = "com.tencent.mm:id/a3m";

    // 红包详情view_id
    private static final String HONGBAO_DETAIL_VIEW_ID = "com.tencent.mm:id/j6c";

    // 红包内部详情
    private static final String INTER_DETAIL_VIEW_ID = "com.tencent.mm:id/j0m";

    // 拉取到的红包列表
    private final List<AccessibilityNodeInfo> _hongBaoFetched = new ArrayList<>();

    // 最大重试次数
    private static final int MAX_RETRY = 24;

    // 重试次数
    private int retry = 0;

    ///// TODO: 防封号选项实现: 1.自动拆红包; 2.延时拆红包; 3.拆自己红包; 4.屏蔽红包文字

    ///// TODO: 实验功能实现: 1.息屏抢红包

    // 最大延时时长
    private static final int MAX_DELAY = 5;

    // 延时时长: s
    private int delay = 0;

    ///// TODO: 监视选项实现: 1.监视系统通知; 2.监视聊天列表

    // 广播接收器
    private final BroadcastReceiver receiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                disableSelf();
                Log.d("BroadcastReceiver", "service deleted.");
            }
        }
    };

    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        Log.d("onServiceConnected", "connected!");
        // 注册广播
        IntentFilter intentFilter = new IntentFilter("com.example.lucky_money_assassin.ACTION_DISABLE_ACCESSIBILITY_SERVICE");
        registerReceiver(receiver, intentFilter);
        Log.d("onServiceConnected", "broadcast registered successfully");
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        if (event.getPackageName() != null && event.getPackageName().equals(TARGET_PACKAGE_NAME)) {
            // 获取窗口根节点
            AccessibilityNodeInfo info = event.getSource();
            if (info != null) {
                handleEvent(info);
            }
        }
    }

    // 处理监听事件
    private void handleEvent(AccessibilityNodeInfo root) {
        switch (Phase.getInstance().get_status()) {
            case FETCHED: {
                // 红包拉取完毕 开拆
                if (!_hongBaoFetched.isEmpty()) {
                    AccessibilityNodeInfo redPacket = _hongBaoFetched.remove(_hongBaoFetched.size() - 1);
                    if (null != redPacket && redPacket.getParent() != null) {
                        // 点击红包进入拆红包阶段
                        redPacket.getParent().performAction(AccessibilityNodeInfo.ACTION_CLICK);
                        Phase.getInstance().updateStatus(PhaseStatus.OPENING);
                        return;
                    }
                }
                // 拉取的红包为空 进入拉取阶段
                Phase.getInstance().updateStatus(PhaseStatus.FETCHING);
                fetchHongBao(root);
                Phase.getInstance().updateStatus(PhaseStatus.FETCHED);
                break;
            }
            case OPENING: {
                // 已经打开: 如自己私聊发的红包
                List<AccessibilityNodeInfo> isOpened = root.findAccessibilityNodeInfosByViewId(INTER_DETAIL_VIEW_ID);
                if (!isOpened.isEmpty()) {
                    Phase.getInstance().updateStatus(PhaseStatus.OPENED);
                    return;
                }
                int ret = openHongBao(root);
                if (ret == 1) {
                    // 打开成功 进入OPENED阶段
                    retry = 0;
                    Phase.getInstance().updateStatus(PhaseStatus.OPENED);
                }else if (ret == -1 && retry < MAX_RETRY){
                    // 网络延迟/空指针 重试
                    return;
                }else {
                    // 无效红包/达到最大重试次数 丢弃这个红包|执行返回操作进入FETCHED阶段
                    retry = 0;
                    Phase.getInstance().updateStatus(PhaseStatus.FETCHED);
                    performGlobalAction(GLOBAL_ACTION_BACK);
                }
                break;
            }
            case OPENED: {
                List<AccessibilityNodeInfo> openedDetail = root.findAccessibilityNodeInfosByViewId(INTER_DETAIL_VIEW_ID);
                // 未加载出来 重试
                if (openedDetail.isEmpty() && retry < MAX_RETRY) {
                    retry += 1;
                    return;
                }
                retry = 0;
                Phase.getInstance().updateStatus(PhaseStatus.FETCHED);
                performGlobalAction(GLOBAL_ACTION_BACK);
                break;
            }
        }
    }

    // 拉取当前聊天界面红包
    private void fetchHongBao(AccessibilityNodeInfo root) {
        if (null == root) return;

        for (AccessibilityNodeInfo node : root.findAccessibilityNodeInfosByViewId(TARGET_VIEW_ID)) {
            AccessibilityNodeInfo parent = node.getParent();
            if (parent != null) {
                List<AccessibilityNodeInfo> captured = parent.findAccessibilityNodeInfosByViewId(HONGBAO_STATUS_VIEW_ID);
                // 已被领取的将不再计入
                if (captured.isEmpty()) {
                    _hongBaoFetched.add(node);
                }
            }
        }
        Log.d("fetchHongBao", Arrays.toString(_hongBaoFetched.toArray()));
    }

    // 打开当前队列的某一红包
    private int openHongBao(AccessibilityNodeInfo root) {
        if (null == root) return -1;

        List<AccessibilityNodeInfo> detailArea = root.findAccessibilityNodeInfosByViewId(HONGBAO_DETAIL_VIEW_ID);

        // 网络延迟未加载出来 此时应当重试
        if (detailArea.isEmpty()) {
            Phase.getInstance().updateStatus(PhaseStatus.OPENING);
            retry += 1;
            return -1;
        }

        List<AccessibilityNodeInfo> hongBaoBtn = root.findAccessibilityNodeInfosByViewId(HONGBAO_BTN_VIEW_ID);

        // 按钮为空说明红包过期/抢完，此时应当返回聊天界面
        if (hongBaoBtn.isEmpty()) {
            return 0;
        }

        assert hongBaoBtn.size() == 1;
        // 按键有，则点击抢红包
        hongBaoBtn.get(0).performAction(AccessibilityNodeInfo.ACTION_CLICK);
        return 1;
    }

    @Override
    public void onInterrupt() {}

    @Override
    public void onDestroy() {
        super.onDestroy();
        // 注销广播接收器
        unregisterReceiver(receiver);
    }
}
