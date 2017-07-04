//
//  ViewLoadingIndicatorProtocol.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 03.07.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewLoadingIndicatorProtocol: LoadingIndicatorProtocol {
    
    var view: UIView! { get }
    var loadingIndicator: UIActivityIndicatorView { get }
}

//MARK : Loading Indicator
public extension ViewLoadingIndicatorProtocol
{
    func showLoadingIndicator() {
        
        removeCurrentCanvasView()
        loadingIndicator.removeFromSuperview()
        let newCanvas = createLoadingIndicatorCanvas()
        paintLoadingIndicator(onCanvas: newCanvas)
        showCanvas(canvasView: newCanvas)
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        removeCurrentCanvasView()
    }
}

fileprivate extension ViewLoadingIndicatorProtocol {
    
    func createLoadingIndicatorCanvas() -> UIView {
        let canvasView = UIView(frame: .zero)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.backgroundColor = UIColor.init(white: 100, alpha: 0.25)
        canvasView.isUserInteractionEnabled = false
        canvasView.tag = ViewLoadingIndicatorProtocolConstants.canvasViewTag
        return canvasView
    }
    
    func removeCurrentCanvasView() {
        let canvasView = view.viewWithTag(ViewLoadingIndicatorProtocolConstants.canvasViewTag)
        canvasView?.removeFromSuperview()
    }
    
    func paintLoadingIndicator(onCanvas canvas: UIView) {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        canvas.addSubview(loadingIndicator)
        loadingIndicator.centerYAnchor.constraint(equalTo: canvas.centerYAnchor).isActive = true
        loadingIndicator.centerXAnchor.constraint(equalTo: canvas.centerXAnchor).isActive = true
    }
    
    func showCanvas(canvasView canvas: UIView) {

        view.addSubview(canvas)
        
        canvas.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        canvas.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        canvas.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

fileprivate struct ViewLoadingIndicatorProtocolConstants {
    
    static let canvasViewTag: Int = 9999
}
