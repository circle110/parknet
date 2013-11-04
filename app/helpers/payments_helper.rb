module PaymentsHelper

	def create_payment_arrays
		@total_balance = 0
		@fund_balances = {}
		@customer_account_balance_funds.each do |gl|
			credits = @credits[gl.id].nil? ? 0:@credits[gl.id]
			debits = @debits[gl.id].nil? ? 0:@debits[gl.id]
			fund_balance = (credits - debits).round(2)
			@total_balance += fund_balance
			@fund_balances[gl.fund_id] = fund_balance
		end

		@purchase_amount_per_fund = {}
		@registrations.each do |r|
			fund_id = r.class_session.gl_account.fund_id
			if @purchase_amount_per_fund.has_key? fund_id
				@purchase_amount_per_fund[fund_id] += r.unpaid_balance
			else
				@purchase_amount_per_fund[fund_id] = r.unpaid_balance
			end
		end
		
		@memberships.each do |m|
			fund_id = m.membership.gl_account.fund_id
			if @purchase_amount_per_fund.has_key? fund_id
				@purchase_amount_per_fund[fund_id] += m.unpaid_balance
			else
				@purchase_amount_per_fund[fund_id] = m.unpaid_balance
			end
		end

		@fund_balances.each do |k,v|
			if @purchase_amount_per_fund.has_key? k
				amount_this_fund = @purchase_amount_per_fund[k]
				@fund_balances[k] +=  amount_this_fund
			end
		end

		@payment_from_cab = []
		@unpaid_balances = {}

		@fund_balances = @fund_balances.select {|k,v| v > 0}

		@registrations.each do |r|
			@unpaid_balances[r.id] = r.unpaid_balance
			fund_id = r.class_session.gl_account.fund_id
			if @fund_balances.has_key? fund_id
				if @fund_balances[fund_id] <= r.unpaid_balance
					@payment_from_cab << {'type' => 'r', 'id' => r.id, 'fund_id' => fund_id, 'payment_amount' => @fund_balances[fund_id]}
					@unpaid_balances["r" + r.id.to_s] -= @fund_balances[fund_id]
					@fund_balances[fund_id] -= r.unpaid_balance
				else
					@payment_from_cab << {'type' => 'r', 'id' => r.id, 'fund_id' => fund_id, 'payment_amount' => r.unpaid_balance}
					@unpaid_balances["r" + r.id.to_s] -= r.unpaid_balance
					@fund_balances[fund_id] -= r.unpaid_balance
				end
			end
		end
		
		@memberships.each do |m|
			@unpaid_balances[m.id] = m.unpaid_balance
			fund_id = m.membership.gl_account.fund_id
			if @fund_balances.has_key? fund_id
				if @fund_balances[fund_id] <= m.unpaid_balance
					@payment_from_cab << {'type' => 'm', 'id' => m.id, 'fund_id' => fund_id, 'payment_amount' => @fund_balances[fund_id]}
					@unpaid_balances["m" + m.id.to_s] -= @fund_balances[fund_id]
					@fund_balances[fund_id] -=  m.unpaid_balance
				else
					@payment_from_cab << {'type' => 'm', 'id' => m.id, 'fund_id' => fund_id, 'payment_amount' => m.unpaid_balance}
					@unpaid_balances["m" + m.id.to_s] -= m.unpaid_balance
					@fund_balances[fund_id] -= m.unpaid_balance
				end
			end
		end
		
		@fund_balances = @fund_balances.select {|k,v| v > 0}
		@unpaid_balances = @unpaid_balances.select {|k,v| v > 0}
		
		while !@unpaid_balances.empty? && !@fund_balances.empty? do 
			@unpaid_balances.each do |k,v|
				@fund_balances.each do |key,value|
					if value <= v
						type = k[0]
						@payment_from_cab << {'type' => "#{type}", 'id' => k, 'fund_id' => key, 'payment_amount' => value}
						@unpaid_balances[k] -= value
						@fund_balances[key] = 0
					else
						@payment_from_cab << {'type' => "#{type}", 'id' => k, 'fund_id' => key, 'payment_amount' => v}
						@unpaid_balances[k] = 0
						@fund_balances[key] -= v
					end
				end
			end
			@fund_balances = @fund_balances.select {|k,v| v > 0}
			@unpaid_balances = @unpaid_balances.select {|k,v| v > 0}
		end
		@payment_from_cab.sort_by!{|p| p[:type]}
	end

end
