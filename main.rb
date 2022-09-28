require 'net/http'
require 'sinatra'
require 'json'


get '/' do
	send_file 'static/index.html'
end

get '/login' do
	# 初始化极验参数
	captcha_id='647f5ed2ed8acb4be36784e01556bb71'
	captcha_key='b09a7aafbfd83f73b35a9b530d0337bf'
	api_server='http://gcaptcha4.geetest.com'

	# 获取前端验证参数
	lot_number = params[:lot_number] || ''
	captcha_output = params[:captcha_output] || ''
	pass_token = params[:pass_token] || ''
	gen_time = params[:gen_time] || ''

	# 生成签名
	sign_token = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), captcha_key, lot_number)

	# 发送二次验证请求
	uri = URI(api_server + '/validate?captcha_id=' + captcha_id)
	data = {"lot_number" => lot_number,
	 		"captcha_output" => captcha_output,
			"pass_token" => pass_token,
	   		"gen_time" => gen_time,
	   		"sign_token" => sign_token}

	res = Net::HTTP.post_form(uri, data)
	
	obj = JSON.parse(res.body)
	# puts obj

	# 根据请求结果处理业务流程
	if obj['result'] == 'success'
		'success'
	else 
		'fail'
	end #if
end