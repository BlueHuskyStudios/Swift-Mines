//
//  DisplaySegment.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-20.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import RectangleTools
import TODO



struct DisplaySegment: View {
    
    @State
    var color: Color
    
    @State
    var kind: Kind
    
    
    var body: some View {
        GeometryReader { geometry in
            self.path(in: geometry)
                .fill(self.color)
        }
        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
    }
}



internal extension DisplaySegment {
    enum Kind {
        case vertical
        case horizontal
        case dot
    }
}



private extension DisplaySegment {
    func path(in geometry: GeometryProxy) -> Path {
        let localFrame = geometry.frame(in: .local)
        
        switch kind {
        case .vertical:
            return verticalSegmentPath(in: localFrame)
            
        case .horizontal:
            return horizontalSegmentPath(in: localFrame)
            
        case .dot:
            return dotSegmentPath(in: localFrame)
        }
    }
    
    
    private func verticalSegmentPath(in localFrame: CGRect) -> Path {
        Path { path in
            path.move(to: localFrame.midXmaxY)
            path.addLine(to: localFrame.maxX(yPercentage: 0.9))
            path.addLine(to: localFrame.maxX(yPercentage: 0.1))
            path.addLine(to: localFrame.midXminY)
            path.addLine(to: localFrame.minX(yPercentage: 0.1))
            path.addLine(to: localFrame.minX(yPercentage: 0.9))
            path.closeSubpath()
        }
    }
    
    
    private func horizontalSegmentPath(in localFrame: CGRect) -> Path {
        Path { path in
            path.move(to: localFrame.maxXmidY)
            path.addLine(to: localFrame.maxY(xPercentage: 0.9))
            path.addLine(to: localFrame.maxY(xPercentage: 0.1))
            path.addLine(to: localFrame.minXmidY)
            path.addLine(to: localFrame.minY(xPercentage: 0.1))
            path.addLine(to: localFrame.minY(xPercentage: 0.9))
            path.closeSubpath()
        }
    }
    
    
    private func dotSegmentPath(in localFrame: CGRect) -> Path {
        Path(ellipseIn: localFrame)
    }
}

struct DisplaySegment_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DisplaySegment(color: .red, kind: .vertical)
                .frame(width: 4, height: 16, alignment: .center)
            DisplaySegment(color: .red, kind: .horizontal)
                .frame(width: 16, height: 4, alignment: .center)
            DisplaySegment(color: .red, kind: .dot)
                .frame(width: 4, height: 4, alignment: .center)
        }
    }
}
