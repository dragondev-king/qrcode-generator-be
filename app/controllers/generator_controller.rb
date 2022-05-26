class GeneratorController < ApplicationController
  def index
    type = params[:type]
    color = params[:color]
    qrcode = RQRCode::QRCode.new(params[:content])
    image = ''
    if type == 'png'
      image = qrcode.as_png(
        # bit_depth: 1,
        border_modules: 0,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: color,
        file: nil,
        fill: "white",
        module_px_size: 6,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 250
      )
    elsif type == 'svg'
      image = qrcode.as_svg(
        color: color.delete('#'),
        shape_rendering: "crispEdges",
        module_size: 8,
        standalone: true,
        use_path: true
      )
    end

    uri = URI.parse(params[:content])
    file_name = uri.host.delete('.') + '-' + color.delete('#') +  '.' + type
    route = 'public/images/' + file_name
    IO.binwrite(route, image.to_s)
    # send_data(png.to_s, :type => "image/png", :deposition => "inline")
    render json: {url: 'http://localhost:3001/images/' + file_name}
  end
end
