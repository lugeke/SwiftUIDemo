//
//  Clock.swift
//  SwiftUIDemo
//
//  Created by lujiaheng on 2020/7/23.
//  Copyright © 2020 陆嘉恒. All rights reserved.
//

import SwiftUI

struct Clock: View {
    let hours: Double
    let minutes: Double
    let seconds: Double
    
    var digits: some View {
        ForEach(0..<12) {
            Text("\($0+1)")
                .font(.title2)
                .foregroundColor(.white)
                .position(x: 80 * cos(CGFloat($0 * 30 - 60) / 180 * .pi),
                          y: 80 * sin(CGFloat($0 * 30 - 60) / 180 * .pi))
                .offset(x: 100, y: 100)
        }
    }
    
    var secondRadians: Double {
        seconds / 60 * .pi * 2
    }
    
    var miniuteRadians: Double {
        minutes / 60  * .pi * 2
    }
    
    var hourRadians: Double {
        (hours + minutes / 60) / 12 * .pi * 2
    }
    
    init(time: Date) {
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.hour, .minute], from: time)
        
        hours = Double(dateComponents.hour!)
        minutes = Double(dateComponents.minute!)
        seconds = time.timeIntervalSinceReferenceDate
    }
    
    var body: some View {
        ZStack {
            Color.black
            
            digits
            
            Circle().fill(Color.white)
                .frame(width: 10, height: 10)
            
            // hour
            Capsule()
                .fill(Color.white)
                .frame(width: 4, height: 45)
                .rotationEffect(.radians(hourRadians), anchor: .bottom)
                .offset(x: 0, y: -45/2)
                .animation(nil)
            // minute
            Capsule()
                .fill(Color.white)
                .frame(width: 4, height: 80)
                .rotationEffect(.radians(miniuteRadians), anchor: .bottom)
                .offset(x: 0, y: -80/2)
                .animation(nil)
            // second
            Capsule()
                .fill(Color.yellow)
                .frame(width: 2, height: 100)
                .rotationEffect(.radians(secondRadians), anchor: UnitPoint(x: 0.5, y: 1-0.1))
                .offset(x: 0, y: -100/2 + 100*0.1)
                .animation(.linear(duration: 1))
            
            Circle().fill(Color.yellow)
                .frame(width: 5, height: 5)
        }
        .frame(width: 200, height: 200)
        .clipShape(Circle())
    }
}



struct ClockView: View {
    
    @State var time: Date
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    var body: some View {
        Clock(time: time)
            .onReceive(timer, perform: { _ in
                time = Date()
            })
    }
}

struct Clock_Previews: PreviewProvider {
    static var previews: some View {
        ClockView(time: Date())
        
    }
}
