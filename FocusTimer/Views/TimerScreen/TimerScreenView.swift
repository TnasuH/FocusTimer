//
//  TimerScreenView.swift
//  FocusTimer
//
//  Created by Tarik Nasuhoglu on 25.11.2022.
//

import SwiftUI

struct TimerScreenView: View {
//    @State var isPlay = true
    @State var isShowConfig = true
    
    @StateObject var tm: TimerManager = TimerManager()
    
    var body: some View {
        ZStack {
            Color.themeBgPrimary.ignoresSafeArea()
            
            ZStack {
                Color.themeBgSecondary
                    .cornerRadius(50)
                    .padding(.bottom,25)
                VStack {
                    HeaderView()
                        .padding(.top,20)
                    Spacer()
                    TimerView()
                    Spacer()
                    FooterView()
                        .padding(.bottom,5)
                }
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if tm.isStarted {
                tm.updateTimer()
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(alignment: .center, spacing: 50) {
            VStack(spacing:5) {
                Image(systemName: "circlebadge.fill")
                    .font(.title2)
                    .foregroundColor(Color.themeBlue)
                Text("Focused")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text("5")
                    .font(.title2)
            }
            VStack(spacing:5) {
                Image(systemName: "circlebadge.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("S.Break")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text("4")
                    .font(.title2)
            }
            VStack(spacing:5) {
                Image(systemName: "circlebadge.fill")
                    .font(.title2)
                    .foregroundColor(Color.themeGreen)
                Text("L.Break")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text("1")
                    .font(.title2)
            }
        }
    }
    
    @ViewBuilder
    func TimerView() -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(tm.timerType == .focus ? Color.themeBlue2 : (tm.timerType == .longBreak ? Color.themeGreen : Color.gray))
                VStack {
                    HStack {
                        Button(action: {print("ResetClicked")}, label: {
                            Text("💥")
                                .font(.title2)
                                .padding(5)
                                .background(Color.themeWhite.opacity(0.5))
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.themeWhite.opacity(0.5), lineWidth: 0.8)
                                )
                        })
                        Spacer()
                        Text(tm.timerType.rawValue)
                            .font(.title2)
                            .bold()
                        Spacer()
                        Button(action: {
                            tm.nextTimerType()
                            
                        }, label: {
                            Text("⌛️")
                                .font(.title2)
                                .padding(5)
                                .background(Color.themeWhite.opacity(0.5))
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.themeWhite.opacity(0.5), lineWidth: 0.8)
                                )
                        })
                    }
                    .padding(20)
                    Spacer()
                    Text(tm.timerStringValue)
                        .fontDesign(.rounded)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    HStack {
                        Button(action: {
                            withAnimation {
                                tm.changeAutoStart()
                            }
                        }, label: {
                            Text("🔄")
                                .font(.title2)
                                .padding(5)
                                .background(tm.autoStart ? Color.themeOrange.opacity(0.8) : Color.themeWhite.opacity(0.5))
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(tm.autoStart ? Color.themeOrange : Color.themeWhite.opacity(0.5), lineWidth: 0.8)
                                )
                        })
                        Spacer()
                        Button(action: {
                            withAnimation {
                                isShowConfig.toggle()
                            }
                        }, label: {
                            Text("⏱️")
                                .font(.title2)
                                .padding(5)
                                .background(Color.themeWhite.opacity(0.5))
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.themeWhite.opacity(0.5), lineWidth: 0.8)
                                )
                        })
                    }
                    .padding(20)
                }
            }
            .frame(width: 300, height: 300)
            .zIndex(2)
            ZStack {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.white)
                VStack(alignment:.center) {
                    Spacer()
                    VStack {
                        Text("Timer: 55:00")
                        Text("Long Break: 25:00")
                        Text("Short Break: 05:00")
                    }
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.bottom,20)
                }
                .padding(.top,20)
                .multilineTextAlignment(.leading)
            }
            .frame(width: 300, height: 170)
            .scaleEffect(isShowConfig ? 1 : 0.9)
            .transition(.move(edge: .top))
            .padding(.top, isShowConfig ? -50 : -160)
            .zIndex(1)
        }
        .frame(width: 300)
    }
    
    @ViewBuilder
    func FooterView() -> some View {
#if os(iOS)
        let shadowColor: Color = Color(uiColor: UIColor.systemGray6)
#elseif os(macOS)
        let shadowColor: Color = Color.gray
#endif
        HStack(spacing: 40) {
            Button(action: {print("BtnClicked2")}, label: {
                VStack(spacing:0) {
                    Image(systemName: "arrow.clockwise")
                    Text("-5min")
                        .font(.footnote)
                }
                .fontWeight(.bold)
                .font(.subheadline)
                .foregroundColor(.themeOrange2)
                .padding()
                .background(Color.themeBgPrimary)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.themeBgPrimary, lineWidth: 1)
                )
                
            })
            .shadow(color: shadowColor, radius: 10, x:0, y:0)
            Button(action: isPlayClicked, label: {
                Image(systemName: tm.isStarted ? "pause.fill" : "play.fill")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.themeOrange)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.themeBgPrimary, lineWidth: 1)
                    )
                    .frame(width: 70, height: 70)
                    
            })
            Button(action: {print("BtnClicked2")}, label: {
                VStack(spacing: 0) {
                    Image(systemName: "arrow.counterclockwise")
                    Text("+5min")
                        .font(.footnote)
                }
                
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .foregroundColor(.themeGreen2)
                    .padding()
                    .background(Color.themeBgPrimary)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.themeBgPrimary, lineWidth: 1)
                    )
                
            })
            .shadow(color: shadowColor, radius: 10, x:0, y:0)
        }
    }
    
    func isPlayClicked() {
        if tm.isStarted {
            tm.pauseTimer()
        } else {
            tm.startTimer()
        }
    }
    
}

struct TimerScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TimerScreenView()
            .preferredColorScheme(.dark)
        TimerScreenView()
        
    }
}
