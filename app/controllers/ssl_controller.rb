class SslController < ApplicationController
  before_action -> { redirect_unless_bolt_on("SSL") }
  
  def index
  end

  def csr

    csr_params = params[:csr]

    cmd = run_appliance_menu_cmd('certCSR', JSON.generate({"cname": csr_params['cname'], "org": csr_params['org'], "country": csr_params['country'] }))

    if cmd[:output]["status"] and !cmd[:output]["csr"].nil?
      send_data cmd[:output]["csr"], filename: 'appliance.csr'
      return
    else
      flash[:danger] = 'Encountered an error whilst generating CSR..'
      redirect_to ssl_path
    end 
  end

  def cert
    cert_content = params[:cert]['content']

    cmd = run_appliance_menu_cmd('certReplace', JSON.generate({"cert": cert_content}))

    if cmd[:output]["status"]
      flash[:success] = 'Replaced SSL certificate.'
    else
      flash[:danger] = 'Encountered an error whilst installing SSL cerificate..'
    end

    redirect_to ssl_path

  end
end
