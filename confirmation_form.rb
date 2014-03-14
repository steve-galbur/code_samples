class ConfirmationForm < Netzke::Basepack::Form
  def configure(c)
    super
    c.data_store = {auto_load: false}
    c.title = "Didn't receive confirmation instructions?"
    c.items = [
        { :xtype => 'fieldset', :title => "Please enter your email to receive confirmation instructions.", :items => [
            {:field_label => "Email", :name => 'user[email]' }
        ]}
    ]
  end

  action :forgot do |c|
    c.text = "Forgot Password"
    c.tooltip = "Forgot password?"
  end

  action :sign_in do |c|
    c.text = "Sign In"
  end

  action :confirmation do |c|
    c.icon = :accept
    c.text = "Submit"
    c.tooltip = "Resend confirmation instructions."
  end


  action :unlock do |c|
    c.text = "Unlock"
    c.tooltip = "Resend unlock instructions."
  end


  def js_configure(c)
    super
    c.bbar = [:confirmation, '->', :sign_in, :forgot, :unlock]
  end

  endpoint :netzke_submit do |params, this|
    this.on_confirmation
  end

  js_configure do |c|
    c.mixin  :confirmation_form
  end

  endpoint :confirmation_success do |params, this|
    this.netzke_feedback "You will receive an email with instructions about how to confirm your account in a few minutes."
  end

  endpoint :confirmation_failure do |params,this|
    error = ''
    begin
      data = ActiveSupport::JSON.decode(params)
      error =  data['errors']
    rescue ActiveSupport::JSON.parse_error
      error = params
    end
    this.netzke_feedback error.is_a?(String) ? error : error.each_pair.map{ |k,v| "#{k.humanize}: #{v}" }.join("<br/>")
  end

end
