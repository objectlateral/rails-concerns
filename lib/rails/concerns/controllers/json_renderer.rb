module JsonRenderer
  # success methods
  def created object = nil, options = {}
    if object
      render_success :created, object, options
    else
      head :created
    end
  end

  def no_content
    head :no_content
  end

  def ok object = nil, options = {}
    if object
      render_success :ok, object, options
    else
      head :ok
    end
  end

  # failure methods
  def forbidden message = ""
    render_failure :forbidden, message
  end

  def not_found message = ""
    render_failure :not_found, message
  end

  def unauthorized message = ""
    render_failure :unauthorized, message
  end

  def unprocessable message = ""
    render_failure :unprocessable_entity, message
  end

  private

  def render_success status, object, options
    if options.has_key?(:serializer) && object.is_a?(Array)
      options[:each_serializer] = options.delete :serializer
    end

    args = {json: object, status: status}.merge! options
    render args
  end

  def render_failure status, message
    render json: {message: message}, status: status
  end
end
