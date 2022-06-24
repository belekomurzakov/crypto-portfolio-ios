import SwiftUI

struct LabelTextField: View {
    var labelName: String
    @Binding var textFileldContent: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(labelName)
                .font(.caption)
            TextField("", text: $textFileldContent)
                .font(.body)
        }
    }
}

struct LabelTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            LabelTextField(labelName: "Asignee", textFileldContent: .constant("Empty"))
        }
        .previewLayout(.fixed(width: 300, height: 70))
        
    }
}
