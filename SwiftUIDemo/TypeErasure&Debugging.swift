//
//  TypeErasure&Debugging.swift
//  SwiftUIDemo
//
//  Created by lujiaheng on 2020/7/9.
//  Copyright © 2020 陆嘉恒. All rights reserved.
//

import SwiftUI

extension View {
    public var typeErased: AnyView {
        AnyView(self)
    }
    
    /// Passes-through the view with customizable side effects
    public func passthrough(applying closure: (_ instance: Self) -> ()) -> Self {
        closure(self)
        return self
    }
}


struct TypeErasure_Debugging: View {
    var body: some View {
        [Color.red, .orange, .yellow, .green, .blue, .purple]
            .reduce(Text("👭")
                        .font(.largeTitle)
                        .rotationEffect(Angle(radians: .pi))
                        .typeErased)
            { view, color in
                view.padding()
                    .background(color)
                    .rotationEffect(Angle(radians: .pi / 6))
                    .passthrough { print("\(type(of: $0)), \($0)") }
                    .typeErased
            }
    }
}

struct TypeErasure_Debugging_Previews: PreviewProvider {
    static var previews: some View {
        TypeErasure_Debugging()
    }
}
