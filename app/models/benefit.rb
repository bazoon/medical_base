class Benefit < ActiveRecord::Base
  belongs_to :client, :counter_cache => true  
  belongs_to :benefit_category, :class_name => 'Ref::BenefitCategory'
  belongs_to :ref_benefit_category, :class_name => 'Ref::BenefitCategory',:foreign_key => "benefit_category_id"
  
  # validates :benefit_category_id,:doc_name,:presence => true

  before_save :check_primary_field

 # before_save :add_to_client
 # after_destroy :remove_from_client 

  #scope :lids, includes(:benefit_category).where("ref_benefit_categories.code=?","010")   
 

#  scope :first_group_invalids, includes(:benefit_category).where("ref_benefit_categories=?","081")

  scope :wars,joins(:benefit_categories).merge(Ref::BenefitCategory.war_invalids)


  scope :war_invalids,joins(:benefit_category).merge(Ref::BenefitCategory.war_invalids)

  scope :war_participants,joins(:benefit_category).merge(Ref::BenefitCategory.war_participants)
  scope :conflict_participants,joins(:benefit_category).merge(Ref::BenefitCategory.conflict_participants)
  scope :widows,joins(:benefit_category).merge(Ref::BenefitCategory.widows)
  scope :blokadniks,joins(:benefit_category).merge(Ref::BenefitCategory.blokadniks)
  scope :prisoners,joins(:benefit_category).merge(Ref::BenefitCategory.prisoners)
  scope :front_workers,joins(:benefit_category).merge(Ref::BenefitCategory.front_workers)
  scope :repressed,joins(:benefit_category).merge(Ref::BenefitCategory.repressed)
  scope :chernobil,joins(:benefit_category).merge(Ref::BenefitCategory.chernobil)
  scope :veterans,joins(:benefit_category).merge(Ref::BenefitCategory.veterans)


  scope :primary,lambda {where("benefits.prim = true")}
  scope :client_present,lambda {|e| joins(:client).merge(Client.present(e))}
  scope :client_sector,lambda {|n| joins(:client).merge(Client.sector(n))}



def check_primary_field
  client_benefits = Benefit.where(:client_id => client_id)
  n = client_benefits.count

  if self.prim
    client_benefits.each do |b|
      b.prim = false
      b.save!
    end

  end

 #Если других льгот нет, то единственная будет основной
 if n == 0
   self.prim = true
 end
end


#def add_to_client
#end
#
#def remove_from_client
#
#
#
#end

def document
 res = ""
 res = "#{I18n.t(:document)} #{doc_name}" if doc_name
 res += "#{I18n.t(:seria)} #{doc_seria}" if doc_seria
 res += "#{I18n.t(:num)} #{doc_num}" if doc_num
 res += "#{I18n.t(:given_by)} #{doc_given_by}" if doc_given_by
 res += "#{I18n.l(doc_date)}" if doc_date
 res
end  

def primary_benefit?
 if prim
   I18n.t(:y)
 else  
   I18n.t(:n)
 end
end  

def short_name
  benefit_category.short_name unless benefit_category.nil?
end


def code
  benefit_category.code unless benefit_category.nil?
end  

end

# == Schema Information
#
# Table name: benefits
#
#  id                  :integer         not null, primary key
#  client_id           :integer
#  doc_name            :string(255)
#  doc_seria           :string(255)
#  doc_num             :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  doc_date            :date
#  benefit_category_id :integer
#  doc_given_by        :string(255)
#  prim                :boolean
#

