//
//  RMSettingsView.swift
//  RickandMorty
//
//  Created by ezz on 18/02/2023.
//

import SwiftUI

struct RMSettingsView: View {
    
    let viewModel : RMSettingsViewViewModel
    
    init(viewModle : RMSettingsViewViewModel){
        self.viewModel = viewModle
    }
    
    
    var body: some View {
        List(viewModel.cellViewModels){ viewModel in
            HStack{
                if let image = viewModel.image{
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20 , height: 20)
                        .foregroundColor(Color.white)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                        
                }
                Text(viewModel.title)
                    .padding(.leading , 10)
                
                Spacer()
            }
            .padding(.bottom , 3 )
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
            
        }
    }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(viewModle: .init(cellViewModels: RMSettingsOption.allCases.compactMap({return RMSettingsCellViewModel(type: $0) { option in
            
        }})))
    }
}
