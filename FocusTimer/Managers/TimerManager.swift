//
//  TimerManager.swift
//  FocusTimer
//
//  Created by Tarik Nasuhoglu on 25.11.2022.
//

import Foundation
import SwiftUI


enum TimerType: String {
    case focus = "Focus"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"
}


public class TimerManager: ObservableObject {
    @Published var isStarted: Bool = false

    @Published var timerStringValue: String = "00:00"
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 5

    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    @Published var timerType : TimerType = .focus
    @Published var breakCount: Int = 0
    @Published var autoStart: Bool = true
    
    
    init() {
        print("init")
    }
    
    public func nextTimerType() {
        if timerType == .focus {
            if breakCount == 3 {
                timerType = .longBreak
            } else {
                timerType = .shortBreak
            }
        } else {
            timerType = .focus
            breakCount += 1
            if breakCount == 4 {
                breakCount = 0
            }
        }
        
        switch timerType {
        case .focus:
            seconds = 7
        case .shortBreak:
            seconds = 3
        case .longBreak:
            seconds = 5
        }
    }
    
    public func startTimer() {
        withAnimation {
            self.isStarted = true
        }
        timerStringValue = "\(hours == 0 ? "" : "\(hours):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)")\(seconds >= 10 ? ":\(seconds)":":0\(seconds)")"
        totalSeconds = (hours*3600) + (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
    }
    
    public func changeAutoStart() {
        autoStart.toggle()
    }
    
    public func startAutoStart() {
        if autoStart == false {
            return
        }
        nextTimerType()
        startTimer()
    }
    
    public func pauseTimer() {
        withAnimation {
            self.isStarted = false
        }
    }
    
    public func resetTimer() {
        isStarted = false
        hours = 0
        minutes = 0
        seconds = 0
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
    }
    
    public func updateTimer() {
        totalSeconds -= 1
        
        hours = totalSeconds / 3600
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        timerStringValue = "\(hours == 0 ? "" : "\(hours):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)")\(seconds >= 10 ? ":\(seconds)":":0\(seconds)")"
        if hours == 0 && minutes == 0 && seconds == 0 {
            isStarted = false
            print("fin")
            if autoStart {
                startAutoStart()
            }
        }
    }
}
