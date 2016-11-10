class Property < ActiveRecord::Base
  belongs_to :investor
	enum sell_existing: [:sell_23rd_st, :keep_23rd_st]
  enum loan_type: [:commercial, :jumbo_residential, :cash_out_residential, :residential]
	enum stated_residence: [:existing_property, :new_property, :rental_unit]
	enum actual_residence: [:existing_home, :new_home, :rental_home]

	validates :name, :address, :city, :state, :zip, :loan_type, :sell_existing, :stated_residence, :actual_residence, presence: true
	validates :purchase_price, :down_payment_pct, :monthly_gross_rental_income, :investor_id, :omi_unit_rent,
		numericality: { only_decimal: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100000000}


   validates :purchase_price, :numericality => { :less_than => 0}, :if => :no_down_payment?

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

  def no_down_payment?
    down_payment < (self.investor.maximum_cash_out - self.investor.existing_debt)
  end

  def interest_rate
    rates = {"commercial" => 0.04625, "jumbo_residential" => 0.03875, "cash_out_residential" => 0.04625, "residential" => 0.0375}
    rates[self.loan_type]
  end

  def down_payment
    self.purchase_price * self.down_payment_pct
  end

  def total_cash
    if self.sell_23rd_st?
      self.investor.building_equity + self.investor.checking_savings + self.investor.retirement_savings
    else
      self.investor.maximum_cash_out + self.investor.checking_savings + self.investor.retirement_savings
    end
  end

  def cash_reserves
    self.total_cash - self.down_payment
  end

  def existing_unit_rent
    rent = 0
    if self.keep_23rd_st? && self.existing_home?
      rent = 2575.0
    end
    if self.keep_23rd_st? && !self.existing_home?
      rent = 2575.0 + 3500.0
    end
    rent
  end

  def new_unit_monthly_rent
    self.monthly_gross_rental_income 
  end

  def total_monthly_rent
    existing_unit_rent + new_unit_monthly_rent - self.omi_unit_rent
  end

  def qualified_existing_unit_rent
    if self.existing_property?
      existing_unit_rent * 0.43
    else
      existing_unit_rent
    end
  end

  def qualified_new_property_rent
    if self.new_property?
      new_unit_monthly_rent * 0.75 * 0.43
    else
      new_unit_monthly_rent * 0.75
    end
  end

  def qualified_rental_income
    qualified_existing_unit_rent + qualified_new_property_rent
  end

  def total_qualified_income
    self.investor.qualified_personal_income + qualified_rental_income
  end

  def new_property_debt
    self.purchase_price - self.down_payment
  end

  def existing_property_debt
    debt = 0
    if self.keep_23rd_st?
      debt = down_payment + self.investor.existing_debt
    end
    debt
  end

  def total_financed
    new_property_debt + existing_property_debt
  end

  def mortgage_payment
    if self.keep_23rd_st?
      home_mortgage = -pmt(interest_rate/12.0, 30*12, total_financed)
      rental_mortgage = -pmt(interest_rate/12.0, 30*12, new_property_debt)
      payment = home_mortgage + rental_mortgage
    else
      payment = -pmt(interest_rate/12.0, 30*12, new_property_debt)
    end
    payment
  end

  def property_tax
    self.purchase_price * 0.011792
  end

  def property_insurance
    self.purchase_price * 0.0025
  end

  def total_monthly_payment
    mortgage_payment + ((property_tax + property_insurance) / 12.0)
  end

  def monthly_cash_flow
    total_monthly_rent - total_monthly_payment
  end

private
    def pmt(rate, nper, pv, fv=0, type=0)
      ((-pv * pvif(rate, nper) - fv ) / ((1.0 + rate * type) * fvifa(rate, nper)))
    end

    def ipmt(rate, per, nper, pv, fv=0, type=0)
      p = pmt(rate, nper, pv, fv, 0);
      ip = -(pv * pow1p(rate, per - 1) * rate + p * pow1pm1(rate, per - 1))
      (type == 0) ? ip : ip / (1 + rate)
    end
  
    def ppmt(rate, per, nper, pv, fv=0, type=0)
     p = pmt(rate, nper, pv, fv, type)
     ip = ipmt(rate, per, nper, pv, fv, type)
     p - ip
    end
    
protected
    
    def pow1pm1(x, y)
      (x <= -1) ? ((1 + x) ** y) - 1 : Math.exp(y * Math.log(1.0 + x)) - 1
    end
  
    def pow1p(x, y)
      (x.abs > 0.5) ? ((1 + x) ** y) : Math.exp(y * Math.log(1.0 + x))
    end
  
    def pvif(rate, nper)
      pow1p(rate, nper)
    end
  
    def fvifa(rate, nper)
      (rate == 0) ? nper : pow1pm1(rate, nper) / rate
    end
    

end




























