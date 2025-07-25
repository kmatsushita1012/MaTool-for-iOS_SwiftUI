//
//  AdminRouteExportView.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/05/08.
//

import SwiftUI
import ComposableArchitecture
import MapKit
import UniformTypeIdentifiers
import NavigationSwipeControl

struct AdminRouteExportView: View{
    @Bindable var store: StoreOf<AdminRouteExport>
    
    @State private var partialSnapshot: UIImage? = nil
    @State private var wholeSnapshot: UIImage? = nil
    
    var body: some View{
        // 背景のMap
        ZStack {
            AdminRouteExportMapView(
                points: store.points,
                segments: store.segments,
                region: $store.region,
                wholeSnapshot: $wholeSnapshot,
                partialSnapshot: $partialSnapshot
            )
                .ignoresSafeArea(edges: .bottom)
        }
        .navigationTitle(store.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let partialSnapshot = partialSnapshot,
               let partialPdf = createPDF(with: partialSnapshot, path: store.partialPath){
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(
                        item: partialPdf,
                        preview: SharePreview(
                            "行動図",
                            image: Image(systemName: "camera")
                        )
                    ){
                        Image(systemName: "camera")
                    }
                }
            }
            if let wholeSnapshot = wholeSnapshot,
               let wholePdf = createPDF(with: wholeSnapshot, path: store.wholePath){
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(
                       item: wholePdf,
                       preview: SharePreview(
                            "行動図（全体）",
                            image: Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath")
                       )
                    ){
                        Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath")
                    }
                }
            }
        }
    }
    
    private func createPDF(with image: UIImage,path: String) -> URL? {
       let pdfData = NSMutableData()
       let pdfRect = CGRect(origin: .zero, size: image.size)
       UIGraphicsBeginPDFContextToData(pdfData, pdfRect, nil)
       UIGraphicsBeginPDFPage()
       image.draw(in: pdfRect)
       UIGraphicsEndPDFContext()

       let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(path)
       do {
           try pdfData.write(to: tempURL, options: .atomic)
           return tempURL
       } catch {
           return nil
       }
    }
}

