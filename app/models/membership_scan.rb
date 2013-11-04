class MembershipScan < ActiveRecord::Base
	belongs_to :agency
	belongs_to :membership
	
	attr_accessible :agency_id, :customer_id, :membership_id, :membership_sale_id, :user_stamp
	
	validates :agency_id, :customer_id, :membership_id, :membership_sale_id, :user_stamp, :presence => true
	before_create :no_double_scans
	
	def no_double_scans
		scan_time = Time.now
		@scans = MembershipScan.where("agency_id = ? AND customer_id = ?", agency_id, customer_id).order(:created_at)
		if scan_time - @scans.last.created_at < 10.minutes
			errors[:base] << 'Customer previously scanned in less than 10 minutes ago.'
			return false
		else
			return true
		end
	end
	
end
