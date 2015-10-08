module SvgHelper
  def inline_svg(filename, options = {})
    file = File.read(Rails.root.join('app', 'assets', 'images', filename))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    options.each { |key, value| svg["#{key}"] = value }
    if options[:size]
      svg['width'], svg['height'] = options[:size]
      svg.delete 'size'
    end
    doc.to_html.html_safe
  end

  def twitter_icon
    inline_svg 'social-twitter.svg', style: 'fill: #00aced'
  end

  def facebook_icon
    inline_svg 'social-facebook.svg', style: 'fill: #3b5998'
  end

  def pinterest_icon
    inline_svg 'social-pinterest.svg', style: 'fill: #cb2027'
  end

  def buffer_icon
    inline_svg 'social-buffer.svg', style: 'fill: #555'
  end

  def googleplus_icon
    inline_svg 'social-google-plus.svg', style: 'fill: #dc4e41'
  end

  def email_icon
    inline_svg 'social-email.svg', style: 'fill: #0092ff'
  end
end
