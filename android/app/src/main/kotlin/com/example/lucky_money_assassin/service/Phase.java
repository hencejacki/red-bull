package com.example.lucky_money_assassin.service;

import com.example.lucky_money_assassin.constant.PhaseStatus;

/**
 * 抢红包行为阶段
 */
public class Phase {
    private Phase() {}

    private PhaseStatus _status = PhaseStatus.FETCHED;

    private static final class PhaseHolder {
        static final Phase phase = new Phase();
    }

    public void updateStatus(PhaseStatus v) {
        _status = v;
    }

    public static Phase getInstance() {
        return PhaseHolder.phase;
    }

    public PhaseStatus get_status() {
        return _status;
    }
}
