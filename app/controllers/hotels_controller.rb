require 'net/http'
require 'uri'
require 'json'

class HotelsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index
	end

	def create
		uri = URI('https://experimentation.getsnaptravel.com/interview/hotels')
		res_snaptravel = Net::HTTP.post_form(uri, 'city' => hotel_params[:city], 'checkin' => hotel_params[:checkin], 'checkout' => hotel_params[:checkout], 'provider' => 'snaptravel')

		uri = URI('https://experimentation.getsnaptravel.com/interview/hotels')
		res_retail = Net::HTTP.post_form(uri, 'city' => hotel_params[:city], 'checkin' => hotel_params[:checkin], 'checkout' => hotel_params[:checkout], 'provider' => 'retail')

		snaptravel_list = JSON.parse(res_snaptravel.body)['hotels']
		retail_list = JSON.parse(res_retail.body)['hotels']

		common_hotels = []
		snaptravel_list.each do |snaptravel_hotel|
			retail_list.each do |retail_hotel|
				if snaptravel_hotel['id'] == retail_hotel['id']
					snaptravel_hotel['retail_price'] = retail_hotel["price"]
					common_hotels << snaptravel_hotel
				end
			end
		end

		display(common_hotels)
	end

	def display(hotels_list)
		@hotels = hotels_list
		render file: 'C:\Sites\snaptravel-app\app\views\hotels\display'
	end

 	private
 	def hotel_params
 		params.permit(:city, :checkin, :checkout)
 	end
end