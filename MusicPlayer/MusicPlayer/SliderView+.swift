//
//  SliderView+.swift
//  MusicPlayer
//
//  Created by 박준하 on 3/25/24.
//

import UIKit

class SliderView: UISlider {
     override func trackRect(forBounds bounds: CGRect) -> CGRect {
          var result = super.trackRect(forBounds: bounds)
          result.origin.x = 0
          result.size.width = bounds.size.width
          result.size.height = 10
          return result
     }
}

