module ApplicationHelpers
  def login_required
    query = {
        'redirect' => request.path_info
    }.map{|key, value| "#{key}=#{value}"}.join("&")

    redirect("/login?#{query}") unless logged_in?
  end


  def admin_required
    query = {
        'redirect' => request.path_info
    }.map{|key, value| "#{key}=#{value}"}.join("&")

    redirect("/login?#{query}") unless is_admin? && logged_in?
  end


  def logged_in?
    return !!session[:user_id]
  end


  def is_admin?
    return if session[:user_id].nil?

    user = User.sessionAuth(session[:user_id])
    return user && user.role == 'admin'
  end


  def html_props(attrs={})
    return '', '' if attrs.empty?

    props = ''
    classes = ''

    if attrs.size > 0
      attrs.each do |attr|
        prop = attr.first
        value = attr.last

        if prop.to_s == 'errors'
          next
        end

        if prop.to_s == 'class'
          classes += " #{value}"
          next
        end

        props += " #{prop}=\"#{value.downcase}\" "
      end
    end

    return props, classes
  end

  def link(path, label, attrs={})
    return nil if path.empty? || label.empty?

    props, classes = html_props(attrs)
    if request.path_info.eql?(path)
      classes += " active"
    end

    "<a href=\"#{path}\" class=\"#{classes.strip}\" #{props}>#{label}</a>"
  end


  def input(name, label, attrs={})
    return nil if name.empty? || label.empty?

    attrs[:type] ||= 'text'
    attrs[:id] ||= name
    attrs[:name] ||= name
    attrs[:value] = request.params[name] ||= ''

    props, classes = html_props(attrs)

    labelClass = ''
    error = attrs[:errors][name] ||= false
    if error
      classes += ' error'
      labelClass += 'error'
    end

    <<-INPUT
    <label for="#{name}" class="#{labelClass}">
      <span>#{label}</span>
      <input class="#{classes.strip}" #{props} />
    </label>
    INPUT
  end
end