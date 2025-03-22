import SwiftUI

struct BasicButton: View {
    var text: LocalizedStringKey
    var textColor: Color
    var colors: [Color]
    var shadow: Color
    
    var body: some View {
        HStack(alignment: .center) {
            
            ZStack {
                GradientView(colors: colors,
                             cornerRadius: 6.0,
                             direction: .topLeading).overlay(
                    
                    GraniteText(text,
                                textColor,
                                .subheadline,
                                .bold,
                                .center)
                )
                .frame(width: 120, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .shadow(color: shadow, radius: 1.0, x: 0.5, y: 0.5)
                
            }
        }
    }
}
