module ThemesHelper
  def hex_to_i(color)
    color_i = color.dup
    color_i[0] = ''
    return color_i
  end

  def update_selected_theme_scss(theme)
    file = File.join(Rails.root, 'app', 'assets', 'stylesheets', 'selected_theme.scss')
    File.open(file, 'w') { |file| file.write(scss_properties(theme)) }
  end

  def scss_properties(theme)
    scss = ".navbar.navbar-default ul {border-top: 6px solid #{theme.navbar} !important; li a {color: #{theme.navbar} !important;}}" +
    ".navbar-default .navbar-nav > .active > a, .navbar-default .navbar-nav > .active > a:hover, .navbar-default .navbar-nav > .active > a:focus {" +
    "background-color: #{theme.navbar} !important;}" +
    ".ink {background: #{theme.navbar} !important;}" +
    ".development{background: #{theme.module} !important ;}.design{background: #{theme.navbar} !important;}" +
    "footer {background-color: #{theme.footer} !important;}.content{background-color: #{theme.content} !important;}"
    return scss
  end
end
