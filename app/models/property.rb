class Property < ActiveRecord::Base
	enum loan_type: [:commercial, :residential, :cash_out_residential]
	enum stated_residence: [:existing_property, :new_property, :rental_unit]
	enum actual_residence: [:existing_home, :new_home, :rental_home]

	validates :name, :address, :city, :state, :zip, :loan_type, :stated_residence, :actual_residence, presence: true
	validates :purchase_price, :down_payment_pct, :annual_gross_rental_income, :investor_id, 
		numericality: { only_decimal: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100000000}


  	has_attached_file :photo, :styles => { :small => "150x150", :medium => "500x500"  },
                      :url  => "/ttc-properties/projects/photos/000/000/:id/:style/:basename.:extension",
                      :path => "/properties/photos/000/000/:id/:style/:basename.:extension",
                      :s3_host_name => 's3-us-west-1.amazonaws.com',
                      :storage => :s3,
                      :s3_protocol => :https,
                      :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  	if Rails.env.production?
    	validates_attachment :photo, #:presence => true,
                    :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/JPG"] },
                    :size => { :in => 0..2.megabytes }
  	elsif Rails.env.test?
    	do_not_validate_attachment_file_type :photo
  	else
    	do_not_validate_attachment_file_type :photo
  	end


	def s3_credentials
	    {:bucket => Figaro.env.S3_BUCKET, :access_key_id =>  Figaro.env.S3_ACCESS_KEY_ID, :secret_access_key =>  Figaro.env.S3_SECRET_ACCESS_KEY}
	end
end
