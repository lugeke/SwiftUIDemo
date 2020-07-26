//--------------------------------------------------
// The SwiftUI Lab: Advanced SwiftUI Animations
// https://swiftui-lab.com/swiftui-animations-part1
//--------------------------------------------------

import SwiftUI

struct AnimationView: View {
    
    var body: some View {
        NavigationView {
            List {
                
                Section(header: Text("Part 1: Path Animations")) {
                    NavigationLink(destination: Example1(), label: {
                        Text("Example 1 (sides: Double)")
                    })
                    
                    NavigationLink(destination: Example2(), label: {
                        Text("Example 2 (sides: Int)")
                    })
                    
                    NavigationLink(destination: Example3(), label: {
                        Text("Example 3 (sides & scale)")
                    })
                    
                    NavigationLink(destination: Example4(), label: {
                        Text("Example 4 (vertex to vertex)")
                    })
                    
                    NavigationLink(destination: Example5(), label: {
                        Text("Example 5 (clock)")
                    })
                }
                
                Section(header: Text("Part 2: Geometry Effect (coming soon)")) {
                    NavigationLink(destination: Text("COMING SOON"), label: {
                        Text("Example 6 (skew)")
                    })
                    
                    NavigationLink(destination: Text("COMING SOON"), label: {
                        Text("Example 7 (follow path)")
                    })
                }
                
                Section(header: Text("Part 3: Animatable Modifier (coming soon)")) {
                    NavigationLink(destination: Text("COMING SOON"), label: {
                        Text("Example 8 (wave text)")
                    })
                    
                    NavigationLink(destination: Text("COMING SOON"), label: {
                        Text("Example 9 (counter)")
                    })

                    NavigationLink(destination: Text("COMING SOON"), label: {
                        Text("Example 10 (gradient)")
                    })

                    NavigationLink(destination: Text("COMING SOON"), label: {
                        Text("Example 11 (progress circle)")
                    })
                }

            }.navigationBarTitle("SwiftUI Lab")
        }
    }
}

struct MyButton: View {
    let label: String
    var font: Font = .title
    var textColor: Color = .white
    let action: () -> ()
    
    var body: some View {
        Button(action: {
            self.action()
        }, label: {
            Text(label)
                .font(font)
                .padding(10)
                .frame(width: 70)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green).shadow(radius: 2))
                .foregroundColor(textColor)
            
        })
    }
}

// MARK: - Part 1: Path Animations
// MARK: Example 1: Polygon animatable
struct Example1: View {
    @State private var sides: Double = 4
    @State private var duration: Double = 1.0
    
    var body: some View {
        VStack {
            Example1PolygonShape(sides: sides)
                .stroke(Color.blue, lineWidth: 3)
                .padding(20)
                .animation(.easeInOut(duration: duration))
                .layoutPriority(1)
            
            Text("\(Int(sides)) sides").font(.headline)
            
            HStack(spacing: 20) {
                MyButton(label: "1") {
                    self.duration = self.animationTime(before: self.sides, after: 1)
                    self.sides = 1.0
                }
                
                MyButton(label: "3") {
                    self.duration = self.animationTime(before: self.sides, after: 3)
                    self.sides = 3.0
                }
                
                MyButton(label: "7") {
                    self.duration = self.animationTime(before: self.sides, after: 7)
                    self.sides = 7.0
                }
                
                MyButton(label: "30") {
                    self.duration = self.animationTime(before: self.sides, after: 30)
                    self.sides = 30.0
                }
                
            }.navigationBarTitle("Example 1").padding(.bottom, 50)
        }
    }
    
    func animationTime(before: Double, after: Double) -> Double {
        // Calculate an animation time that is
        // adequate to the number of sides to add/remove.
        return abs(before - after) * (1 / abs(before - after))
    }
}

struct Example1PolygonShape: Shape {
    var sides: Double
    
    var animatableData: Double {
        get { return sides }
        set { sides = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        
        // hypotenuse
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0
        
        // center
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        var path = Path()
        
        let extra: Int = Double(sides) != Double(Int(sides)) ? 1 : 0
        
        for i in 0..<Int(sides) + extra {
            let angle = (Double(i) * (360.0 / Double(sides))) * Double.pi / 180
            
            // Calculate vertex
            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
            
            if i == 0 {
                path.move(to: pt) // move to first vertex
            } else {
                path.addLine(to: pt) // draw line to next vertex
            }
        }
        
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Example 2: Polygon with sides as Integer
struct Example2: View {
    @State private var sides: Int = 4
    @State private var duration: Double = 1.0
    
    var body: some View {
        VStack {
            Example2PolygonShape(sides: sides)
                .stroke(Color.red, lineWidth: 3)
                .padding(20)
                .animation(.easeInOut(duration: duration))
                .layoutPriority(1)
            
            Text("\(Int(sides)) sides").font(.headline)
            
            HStack(spacing: 20) {
                MyButton(label: "1") {
                    self.duration = self.animationTime(before: self.sides, after: 1)
                    self.sides = 1
                }
                
                MyButton(label: "3") {
                    self.duration = self.animationTime(before: self.sides, after: 3)
                    self.sides = 3
                }
                
                MyButton(label: "7") {
                    self.duration = self.animationTime(before: self.sides, after: 7)
                    self.sides = 7
                }
                
                MyButton(label: "30") {
                    self.duration = self.animationTime(before: self.sides, after: 30)
                    self.sides = 30
                }
                
            }.navigationBarTitle("Example 2").padding(.bottom, 50)
        }
    }
    
    func animationTime(before: Int, after: Int) -> Double {
        // Calculate an animation time that is
        // adequate to the number of sides to add/remove.
        return Double(abs(before - after)) * (1 / Double(abs(before - after)))
    }
}

struct Example2PolygonShape: Shape {
    var sides: Int
    private var sidesAsDouble: Double
    
    var animatableData: Double {
        get { return sidesAsDouble }
        set { sidesAsDouble = newValue }
    }
    
    init(sides: Int) {
        self.sides = sides
        self.sidesAsDouble = Double(sides)
    }
    
    func path(in rect: CGRect) -> Path {
        
        // hypotenuse
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0
        
        // center
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        var path = Path()
        
        let extra: Int = sidesAsDouble != Double(Int(sidesAsDouble)) ? 1 : 0
        
        for i in 0..<Int(sidesAsDouble) + extra {
            let angle = (Double(i) * (360.0 / sidesAsDouble)) * Double.pi / 180
            
            // Calculate vertex
            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
            
            if i == 0 {
                path.move(to: pt) // move to first vertex
            } else {
                path.addLine(to: pt) // draw line to next vertex
            }
        }
        
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Example 3: Polygon with multiple animatable paramters
struct Example3: View {
    @State private var sides: Double = 4
    @State private var duration: Double = 1.0
    @State private var scale: Double = 1.0
    
    var body: some View {
        VStack {
            Example3PolygonShape(sides: sides, scale: scale)
                .stroke(Color.purple, lineWidth: 5)
                .padding(20)
                .animation(.easeInOut(duration: duration))
                .layoutPriority(1)
            
            Text("\(Int(sides)) sides, \(String(format: "%.2f", scale as Double)) scale")
            
            HStack(spacing: 20) {
                MyButton(label: "1") {
                    self.duration = self.animationTime(before: self.sides, after: 1)
                    self.sides = 1.0
                    self.scale = 1.0
                }
                
                MyButton(label: "3") {
                    self.duration = self.animationTime(before: self.sides, after: 3)
                    self.sides = 3.0
                    self.scale = 0.7
                }
                
                MyButton(label: "7") {
                    self.duration = self.animationTime(before: self.sides, after: 7)
                    self.sides = 7.0
                    self.scale = 0.4
                }
                
                MyButton(label: "30") {
                    self.duration = self.animationTime(before: self.sides, after: 30)
                    self.sides = 30.0
                    self.scale = 1.0
                }
                
            }
        }.navigationBarTitle("Example 3").padding(.bottom, 50)
    }
    
    func animationTime(before: Double, after: Double) -> Double {
        // Calculate an animation time that is
        // adequate to the number of sides to add/remove.
        return abs(before - after) * (1 / abs(before - after))
    }
}


struct Example3PolygonShape: Shape {
    var sides: Double
    var scale: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(sides, scale) }
        set {
            sides = newValue.first
            scale = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        // hypotenuse
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0 * scale
        
        // center
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        var path = Path()
        
        let extra: Int = sides != Double(Int(sides)) ? 1 : 0
        
        for i in 0..<Int(sides) + extra {
            let angle = (Double(i) * (360.0 / sides)) * (Double.pi / 180)
            
            // Calculate vertex
            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
            
            if i == 0 {
                path.move(to: pt) // move to first vertex
            } else {
                path.addLine(to: pt) // draw line to next vertex
            }
        }
        
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Example 4: Polygon with lines vertex-to-vertex
struct Example4: View {
    @State private var sides: Double = 4
    @State private var duration: Double = 1.0
    @State private var scale: Double = 1.0
    
    
    var body: some View {
        VStack {
            Example4PolygonShape(sides: sides, scale: scale)
                .stroke(Color.pink, lineWidth: (sides < 3) ? 10 : ( sides < 7 ? 5 : 2))
                .padding(20)
                .animation(.easeInOut(duration: duration))
                .layoutPriority(1)
            
            
            Text("\(Int(sides)) sides, \(String(format: "%.2f", scale as Double)) scale")
            
            Slider(value: $sides, in: 0...30)
            
            HStack(spacing: 20) {
                MyButton(label: "1") {
                    self.duration = self.animationTime(before: self.sides, after: 1)
                    self.sides = 1.0
                    self.scale = 1.0
                }
                
                MyButton(label: "3") {
                    self.duration = self.animationTime(before: self.sides, after: 3)
                    self.sides = 3.0
                    self.scale = 1.0
                }
                
                MyButton(label: "7") {
                    self.duration = self.animationTime(before: self.sides, after: 7)
                    self.sides = 7.0
                    self.scale = 1.0
                }
                
                MyButton(label: "30") {
                    self.duration = self.animationTime(before: self.sides, after: 30)
                    self.sides = 30.0
                    self.scale = 1.0
                }
                
            }
        }.navigationBarTitle("Example 4").padding(.bottom, 50)
    }
    
    func animationTime(before: Double, after: Double) -> Double {
        // Calculate an animation time that is
        // adequate to the number of sides to add/remove.
        return abs(before - after) * (1 / abs(before - after)) + 3
    }
}


struct Example4PolygonShape: Shape {
    var sides: Double
    var scale: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(sides, scale) }
        set {
            sides = newValue.first
            scale = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        // hypotenuse
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0 * scale
        
        // center
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        var path = Path()
        
        let extra: Int = sides != Double(Int(sides)) ? 1 : 0
        
        var vertex: [CGPoint] = []
        
        for i in 0..<Int(sides) + extra {
            
            let angle = (Double(i) * (360.0 / sides)) * (Double.pi / 180)
            
            // Calculate vertex
            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
            
            vertex.append(pt)
            
            if i == 0 {
                path.move(to: pt) // move to first vertex
            } else {
                path.addLine(to: pt) // draw line to next vertex
            }
        }
        
        path.closeSubpath()
        
        // Draw vertex-to-vertex lines
        drawVertexLines(path: &path, vertex: vertex, n: 0)
        
        return path
    }
    
    func drawVertexLines(path: inout Path, vertex: [CGPoint], n: Int) {
        
        if (vertex.count - n) < 3 { return }
        
        for i in (n+2)..<min(n + (vertex.count-1), vertex.count) {
            path.move(to: vertex[n])
            path.addLine(to: vertex[i])
        }
        
        drawVertexLines(path: &path, vertex: vertex, n: n+1)
    }
}

// MARK: - Example 5: Clock Shape
struct Example5: View {
    @State private var time: ClockTime = ClockTime(9, 50, 5)
    @State private var duration: Double = 1.0
    
    var body: some View {
        VStack {
            ClockShape(clockTime: time)
                .stroke(Color.blue, lineWidth: 3)
                .padding(20)
                .animation(.easeInOut(duration: duration))
                .layoutPriority(1)
            
            
            Text("\(time.asString())")

            HStack(spacing: 20) {
                MyButton(label: "9:51:45", font: .footnote, textColor: .black) {
                    self.duration = 2.0
                    self.time = ClockTime(9, 51, 45)
                }
                
                MyButton(label: "9:51:15", font: .footnote, textColor: .black) {
                    self.duration = 2.0
                    self.time = ClockTime(9, 51, 15)
                }
                
                MyButton(label: "9:52:15", font: .footnote, textColor: .black) {
                    self.duration = 2.0
                    self.time = ClockTime(9, 52, 15)
                }
                
                MyButton(label: "10:01:45", font: .caption, textColor: .black) {
                    self.duration = 10.0
                    self.time = ClockTime(10, 01, 45)
                }
                
            }
        }.navigationBarTitle("Example 5").padding(.bottom, 50)
    }
    
}


struct ClockShape: Shape {
    var clockTime: ClockTime
    
    var animatableData: ClockTime {
        get { clockTime }
        set { clockTime = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let radius = min(rect.size.width / 2.0, rect.size.height / 2.0)
        let center = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        let hHypotenuse = Double(radius) * 0.5 // hour needle length
        let mHypotenuse = Double(radius) * 0.7 // minute needle length
        let sHypotenuse = Double(radius) * 0.9 // second needle length
        
        let hAngle: Angle = .degrees(Double(clockTime.hours) / 12 * 360 - 90)
        let mAngle: Angle = .degrees(Double(clockTime.minutes) / 60 * 360 - 90)
        let sAngle: Angle = .degrees(Double(clockTime.seconds) / 60 * 360 - 90)
        
        let hourNeedle = CGPoint(x: center.x + CGFloat(cos(hAngle.radians) * hHypotenuse), y: center.y + CGFloat(sin(hAngle.radians) * hHypotenuse))
        let minuteNeedle = CGPoint(x: center.x + CGFloat(cos(mAngle.radians) * mHypotenuse), y: center.y + CGFloat(sin(mAngle.radians) * mHypotenuse))
        let secondNeedle = CGPoint(x: center.x + CGFloat(cos(sAngle.radians) * sHypotenuse), y: center.y + CGFloat(sin(sAngle.radians) * sHypotenuse))
        
        path.addArc(center: center, radius: radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)

        path.move(to: center)
        path.addLine(to: hourNeedle)
        path = path.strokedPath(StrokeStyle(lineWidth: 3.0))

        path.move(to: center)
        path.addLine(to: minuteNeedle)
        path = path.strokedPath(StrokeStyle(lineWidth: 3.0))

        path.move(to: center)
        path.addLine(to: secondNeedle)
        path = path.strokedPath(StrokeStyle(lineWidth: 1.0))
        
        return path
    }
}

struct ClockTime {
    var hours: Int      // Hour needle should jump by integer numbers
    var minutes: Int    // Minute needle should jump by integer numbers
    var seconds: Double // Second needle should move smoothly
    
    // Initializer with hour, minute and seconds
    init(_ h: Int, _ m: Int, _ s: Double) {
        self.hours = h
        self.minutes = m
        self.seconds = s
    }
    
    // Initializer with total of seconds
    init(_ seconds: Double) {
        let h = Int(seconds) / 3600
        let m = (Int(seconds) - (h * 3600)) / 60
        let s = seconds - Double((h * 3600) + (m * 60))
        
        self.hours = h
        self.minutes = m
        self.seconds = s
    }
    
    // compute number of seconds
    var asSeconds: Double {
        return Double(self.hours * 3600 + self.minutes * 60) + self.seconds
    }
    
    // show as string
    func asString() -> String {
        return String(format: "%2i", self.hours) + ":" + String(format: "%02i", self.minutes) + ":" + String(format: "%02.0f", self.seconds)
    }
}

extension ClockTime: VectorArithmetic {
    static func -= (lhs: inout ClockTime, rhs: ClockTime) {
        lhs = lhs - rhs
    }
    
    static func - (lhs: ClockTime, rhs: ClockTime) -> ClockTime {
        return ClockTime(lhs.asSeconds - rhs.asSeconds)
    }
    
    static func += (lhs: inout ClockTime, rhs: ClockTime) {
        lhs = lhs + rhs
    }
    
    static func + (lhs: ClockTime, rhs: ClockTime) -> ClockTime {
        return ClockTime(lhs.asSeconds + rhs.asSeconds)
    }
    
    mutating func scale(by rhs: Double) {
        var s = Double(self.asSeconds)
        s.scale(by: rhs)
        
        let ct = ClockTime(s)
        self.hours = ct.hours
        self.minutes = ct.minutes
        self.seconds = ct.seconds
    }
    
    var magnitudeSquared: Double {
        1
    }
    
    static var zero: ClockTime {
        return ClockTime(0, 0, 0)
    }
    
}


struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AnimationView()
        }
        
    }
}
