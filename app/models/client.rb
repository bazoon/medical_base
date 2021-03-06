# coding: utf-8
require 'logger'  
class Client < ActiveRecord::Base

  DETACH_REASON_NONE = 0
  DETACH_REASON_OTHER_CLINIC = 1
  DETACH_REASON_DIED_AT_HOME = 2
  DETACH_REASON_DIED_AT_CLINIC = 3

  MALE = 1
  FEMALE = 2

#  belongs_to :client_sex
  belongs_to :ins_company, :class_name => 'Ref::InsCompany'
  belongs_to :mkb_type, :class_name => 'Ref::MkbType',:foreign_key => "death_reason_id"

  belongs_to :death_reason, :class_name => 'Ref::MkbType',:foreign_key => "death_reason_id"

  has_many :lab_tests, :dependent => :delete_all,:order =>"test_date DESC"
  has_many :diagnostic_tests,:dependent => :delete_all,:order =>"test_date DESC"
  has_many :hospitalizations,:dependent => :delete_all,:order =>"period_start DESC"
  has_many :htm_help_notes,:dependent => :delete_all,:order =>"actual_date DESC"
  has_many :sanatorium_notes,:dependent => :delete_all,:order =>"neediness_ref_date DESC"
  has_many :med_diagnostic_tests,:dependent => :delete_all,:order =>"test_date DESC"
  has_many :prof_inspections,:dependent => :delete_all

  has_many :benefits,:dependent => :delete_all,:order => "prim DESC"
  has_many :benefit_categories, :through => :benefits

  has_many :mkbs,:dependent => :delete_all,:order => "actual_date DESC"
  has_many :mses,:dependent => :delete_all,:order => "id DESC"
  has_many :disps,:dependent => :delete_all,:order => "id DESC"

  validates :name,:surname,:birth_date,:ins_company_id,:client_sex_id, :presence => true

  accepts_nested_attributes_for :benefits,:allow_destroy => true

 # validates :birth_date, :format => {:with => /\d{2}\.\d{2}\.\d{4}/, :message => I18n.t(:invalid_date_format)}

  #Инвалиды войны
  #scope :war_invalids,includes(:benefits).where("benefits.benefit_category_id=?",Ref::BenefitCategory.war_invalid_id)
 # scope :war_participants,includes(:benefits).where("benefits.benefit_category_id IN (?)",Ref::BenefitCategory.war_participants_ids)

 # scope :war_invalids,lambda { joins(:benefits).merge(Benefit.war_invalids )  }

  #Возможна ошибка, если ищется id несуществующей льготы
  scope :benefit_category, lambda { |code| includes(:benefits).where("benefits.benefit_category_id = ?",Ref::BenefitCategory.id_by_code(code) ) }

  #Причины смерти
  scope :dr_infections_parasits,joins(:death_reason).merge(Ref::MkbType.infections_parasits)
  scope :dr_neoplasms, joins(:death_reason).merge(Ref::MkbType.neoplasms)
  scope :dr_endocryne_diseases,joins(:death_reason).merge(Ref::MkbType.endocryne_diseases)
  scope :dr_blood_diseases, joins(:death_reason).merge(Ref::MkbType.blood_diseases)
  scope :dr_nervous_diseases,joins(:death_reason).merge(Ref::MkbType.nervous_diseases)
  scope :dr_ear_diseases, joins(:death_reason).merge(Ref::MkbType.ear_diseases)
  scope :dr_eye_diseases, joins(:death_reason).merge(Ref::MkbType.eye_diseases)
  scope :dr_circulatory_diseases, joins(:death_reason).merge(Ref::MkbType.circulatory_diseases)
  scope :dr_respiratory_diseases,joins(:death_reason).merge(Ref::MkbType.respiratory_diseases)
  scope :dr_digestive_diseases, joins(:death_reason).merge(Ref::MkbType.digestive_diseases)
  scope :dr_genitourinary_diseases,joins(:death_reason).merge(Ref::MkbType.genitourinary_diseases)
  scope :dr_skin_diseases, joins(:death_reason).merge(Ref::MkbType.skin_diseases)
  scope :dr_musculskeletal_diseases,joins(:death_reason).merge(Ref::MkbType.musculskeletal_diseases)
  scope :dr_injury_poisons, joins(:death_reason).merge(Ref::MkbType.injury_poisons)


  #Льготники
  scope :war_invalids,joins(:benefits,:benefit_categories).merge(Ref::BenefitCategory.war_invalids).merge(Benefit.primary)
  scope :war_participants,joins(:benefits,:benefit_categories).merge(Ref::BenefitCategory.war_participants).merge(Benefit.primary)
  scope :conflict_participants,joins(:benefits,:benefit_categories).merge(Ref::BenefitCategory.conflict_participants).merge(Benefit.primary)
  scope :widows,joins(:benefits,:benefit_categories).merge(Ref::BenefitCategory.widows).merge(Benefit.primary)
  scope :blokadniks,joins(:benefits,:benefit_categories).merge(Ref::BenefitCategory.blokadniks).merge(Benefit.primary)
  scope :prisoners,joins(:benefits,:benefit_categories).merge(Ref::BenefitCategory.prisoners).merge(Benefit.primary)
  scope :front_workers,joins(:benefits,:benefit_categories).merge(Ref::BenefitCategory.front_workers).merge(Benefit.primary)
  scope :repressed,joins(:benefits,:benefit_categories).merge(Ref::BenefitCategory.repressed).merge(Benefit.primary)
  scope :chernobil,joins(:benefits,:benefit_categories).merge(Ref::BenefitCategory.chernobil).merge(Benefit.primary)

  scope :all_benefits,joins(:benefits,:benefit_categories).merge(Benefit.primary)


  #Участок пациента
  scope :sector,lambda {|sector_num|  where("num_card like ?",sector_num.to_s+"%") }

  #Пациенты не снятые с учета до даты e
  scope :present, lambda {|e| where("attach_date <= ? and (detach_date is null or detach_date > ?) ",e,e)}

  scope :work_veterans,lambda {where("is_work_veteran = true")}
  scope :pensioners,where("pensioner = true")
  scope :disables, where("disabled = true")

  #Hospitalization scopes

  scope :hosp_between, lambda {|s,e| joins(:hospitalizations).merge(Hospitalization.between(s,e))  }
  scope :hosp_planned, joins(:hospitalizations).merge(Hospitalization.planned)
  scope :hosp_extra, joins(:hospitalizations).merge(Hospitalization.extra)

  #Disp scopes
  scope :disp_before, lambda {|d| joins(:disps).merge(Disp.before(d) )}
  scope :disp_between, lambda {|s,e| joins(:disps).merge(Disp.between(s,e) )}

  scope :died, where("detach_reason in (2,3)")
  scope :moved, where("detach_reason = 1")
  scope :died_or_moved,where("detach_reason in (1,2,3)")
  scope :died_between, lambda {|s,e| where("death_date between ? and ?",s,e) }

  scope :full_inspected,lambda { where("prof_inspections_count >= 12") } #Период не выбран ! Использовать только для выборки за определенный год
  scope :rested,lambda { where("sanatorium_notes_count > 0") } #Период не выбран ! Использовать только для выборки за определенный год

  #Mse scopes
  scope :mse_group_increased, lambda {joins(:mses).merge(Mse.group_increase )}
  scope :mse_group_increased_2_1, lambda {joins(:mses).merge(Mse.group_increase_2_1 )}
  scope :mse_group_increased_3_2, lambda {joins(:mses).merge(Mse.group_increase_3_2 )}
  scope :mse_iprs, lambda {joins(:mses).merge(Mse.iprs )}
  scope :mse_first, lambda {joins(:mses).merge(Mse.first )}
  scope :mse_between, lambda {|s,e| joins(:mses).merge(Mse.between(s,e) )}
  scope :mse_re, lambda {joins(:mses).merge(Mse.re )}
  scope :mse_re_2, lambda {joins(:mses).merge(Mse.re_2 )}
  scope :mse_re_3, lambda {joins(:mses).merge(Mse.re_3 )}
  scope :mse_re_3_2, lambda {joins(:mses).merge(Mse.re_3_2 )}


  #Mkbs scopes
  scope :mkbs_before, lambda {|d| joins(:mkbs).merge(Mkb.before(d) )}
  scope :mkbs_between, lambda {|s,e| joins(:mkbs).merge(Mkb.between(s,e) )}
  scope :mkbs_present, lambda {|e| joins(:mkbs).merge(Mkb.present(e) )}
  scope :mkbs_gone, lambda {|s,e| joins(:mkbs).merge(Mkb.gone(s,e) )}


  #birth_date scopes
  scope :born_in, lambda {|year|  where("birth_date between ? and ?","01.01.#{year}","31.10.#{year}")} 
  # scope :born_between, lambda {|sd,ed|  where("birth_date between ? and ?",sd,ed)} 
  scope :years_old, (lambda do |year| 
    born_year = DateTime.now.year - year
    where("birth_date between ? and ?","01.01.#{born_year}","31.12.#{born_year}")
  end)  

  #Sex scopes
  scope :male, lambda {where("client_sex_id = ?",MALE)}
  scope :female, lambda {where("client_sex_id = ?",FEMALE)}


def primary_benefit_code
  unless benefits.nil? or benefits.empty?
    b = benefits.select {|b| b.prim = true}
    result = b.first unless b.nil?
    result ||= benefits.first
    "0"+result.benefit_category.code.to_s unless result.benefit_category.nil?
  end
end

def primary_benefit_name
  unless benefits.nil? or benefits.empty?
    b = benefits.select {|b| b.prim = true}
    result = b.first unless b.nil?
    result ||= benefits.first
    result.benefit_category.short_name unless result.benefit_category.nil?
      
    
  end
end

def death_reason_info
"#{death_reason.try(:code)}: #{death_reason.try(:name)}" unless death_reason.nil?
end

def death_reason_info=(name)
 unless name.nil? or name.blank?
  code = name[0,name.index(":")]
  self.death_reason = Ref::MkbType.find_by_code(code)
 else
  self.death_reason = nil
 end

end

def mkb_type_name
  mkb_type.name unless mkb_type.nil?
end

def mkb_type_code
  mkb_type.code unless mkb_type.nil?
end

def sex
  if client_sex_id == MALE
    I18n.t(:sex_m)
  else
    I18n.t(:sex_w)
  end
end


def prof_inspection_years
  prof_inspections.prof_only.group_by {|p| p.actual_date.year}
end


def blood
 g={1 => "O(I) Rh+",2 => "O(I) Rh-",3 => "A(II) Rh+",4 => "A(II) Rh-",5 => "B(III) Rh+",6 => "B(III) Rh-",7 => "AB(VI) Rh+",8 => "AB(VI) Rh-"}
 g[blood_group]
end

def detach_reason_info
 result=case detach_reason
         when Client::DETACH_REASON_NONE then ""
         when Client::DETACH_REASON_OTHER_CLINIC then I18n.t(:detach_reason_other_clinic)
         when Client::DETACH_REASON_DIED_AT_HOME then I18n.t(:detach_reason_died_at_home)
         when Client::DETACH_REASON_DIED_AT_CLINIC then I18n.t(:detach_reason_died_at_clinic)
        end
 result
end


def have_full_prof_inspection_this_year?
 start_date=Time.now.beginning_of_year
 end_date=Time.now.end_of_year
 result = have_full_prof_inspection_in_year(start_date,end_date)
end

# Функции для получения информации об пройденых врачах, анализах, диагностике
def prof_inspections_info
 prof_inspections.prof_only.this_year.map {|p| p.user.doctor_type.name}.uniq
end

def lab_tests_info
 lab_tests.this_year.prof_inspection_minimum.map {|lt| lt.lab_test_type.lab_test_group_names }.uniq.flatten
end

def diagnostic_tests_info
 diagnostic_tests.this_year.prof_inspection_minimum.map {|dt| dt.diagnostic_test_type.name}.uniq
end

def ungiven_lab_tests_info
 Ref::LabTestType.prof_inspection_minimum.map {|ltt| ltt.lab_test_group_names }.uniq.flatten - lab_tests_info
end

def ungiven_diagnostic_tests_info
 Ref::DiagnosticTestType.prof_inspection_minimum.map {|dtt| dtt.name} - diagnostic_tests_info
end

def ungiven_prof_inspections_info
  (Ref::DoctorType.all.map {|dt| dt.name } - prof_inspections_info)
end

###

def have_all_prof_inspections_in_year(sd,ed)
 count = LabTests.prof_inspection_minimum.count + Diagnostic_tests.prof_inspection_minimum.count

 client_count = lab_tests.in_year(sd,ed).prof_inspection_minimum.count
 client_count += diagnostic_tests.in_year(sd,ed).prof_inspection_minimum.count

end



def have_full_prof_inspection_in_year(sd,ed)
 count = prof_inspections.in_year(sd,ed).count

 unless count == 0
   if client_sex_id == MALE
     result = case count
        when ProfInspection::MAX_PROF_INSPECIONS then :prof_all
        when 1..ProfInspection::MAX_PROF_INSPECIONS-1 then :prof_partial
     end
   else
     result = case count
        when ProfInspection::MAX_PROF_INSPECIONS+1 then :prof_all
        when 1..ProfInspection::MAX_PROF_INSPECIONS then :prof_partial
     end
   end
 else
  result = :prof_zero
 end


 result
end

def local_date(field)
 I18n.l(self.send(field)) unless self.send(field).nil?
end

def passport
 "#{pasp_seria} #{pasp_num}"
end

def work_info
 "#{work_place} / #{work_position}"
end

#def client_name=(name)
#  client = Client.find_by_surname(name)
#  if client
#    self.user_id = client.id
#  else
#    errors[:user_name] << "Invalid name entered"
#  end
#end
#
#def client_name
#  Client.find(client_id).name if client_id
#end


 def self.search(search)
  if search
    s=search.scan(/\S+/)
    case s.size
      when 1
         where('surname LIKE ?', "%#{s[0]}%")
      when 2
        where('surname LIKE ? and name LIKE ?',"#{s[0]}","#{s[1]}")
      when 3
        where('surname LIKE ? and name LIKE ? and father_name LIKE ?',"#{s[0]}","#{s[1]}","#{s[2]}")
      else
        scoped.order(:surname)
    end
  else
   scoped.order(:surname)
  end

 end


def has_some_records?(record_class)
 self.send(record_class).count > 0 unless self.send(record_class).nil?
end

def fio
  "#{surname} #{name} #{father_name}"
end


def short_fio
 res=surname
 unless (surname.nil? or name.nil? or father_name.nil?)
  res="#{surname} #{name[0]}. #{father_name[0]}."
 end
 res
end




# Temp  functions for import only !

  def convert_d(b)
   res=b[0,2]+'.'+b[2,2]+'.'+b[4,4] unless (b.nil? or b.length < 8)
   res=' ' if res.nil?
   res
  end

  def sexc(s)
    res=2
    if (s==I18n.t(:sex_m))
     res=1
    end
    res
  end

  def woman_surname?(surname)
    not (['я','а','ь'].index(surname[surname.length-1])).nil?
  end

  def import_csv
    @clients=[]
    


    CSV.foreach("/home/bazoon/projects/fio.csv")  do |row|

       unless (row[1].nil? or row[2].nil? or row[3].nil?)
         @client=Client.new
         @client.num_card=row[0]
         @client.surname=row[1].mb_chars.downcase.capitalize unless row[1].nil?
         @client.name=row[2].mb_chars.downcase.capitalize unless row[2].nil?
         @client.father_name=row[3].downcase.mb_chars.capitalize unless row[3].nil?
         @client.client_sex_id=woman_surname?(@client.surname) ? 2:1
         
         @client.pasp_seria=row[4]
         @client.pasp_num=row[5]

         @client.birth_date=convert_d(row[6])
         
         @client.ins_seria=row[7]
         @client.ins_num=row[8]

          
         @client.ins_company_id = Ref::InsCompany.find_or_create_by_name(row[9].mb_chars.capitalize.to_s).id unless row[9].nil? or row[9].blank?
         @client.ins_company_id = 9999 if @client.ins_company_id.nil?

          
         @client.reg_address=row[10]
         @client.real_address=@client.reg_address
         @client.snils=row[12]

        


            unless row[11].nil?
              benefits = row[11].split
            
              benefits.each do |b|
                bc = Ref::BenefitCategory.find_by_code(b.to_i)
                unless bc.nil?
                  @client.benefits.new(:benefit_category_id => bc.id, :doc_name => 'не указан')
                end  
              end 

            end  

            # log.debug(@client.surname)

            # if @client.surname=="Астраханцева"
            #   binding.pry
            # end  

            


          @client.save! unless (@client.name.nil? or @client.birth_date.nil? or @client.client_sex_id.nil?)

        


       end

        # log.debug "I: #{@i}"
  end

   # render :text => @client.num_card
   # @clients
  end


 def update_from_csv

    log= Logger.new('/Users/vith/Desktop/projects/logfile.log')
    CSV.foreach("/Users/vith/Desktop/projects/cl.csv")  do |row|

       unless (row[1].nil? or row[2].nil? or row[3].nil?)

         @client = Client.find_by_num_card(row[0])

         @client = Client.new if @client.nil?
        
         @client.num_card ||= row[0]  
         @client.surname ||=row[1].mb_chars.downcase.capitalize unless row[1].nil?
         @client.name ||= row[2].mb_chars.downcase.capitalize unless row[2].nil?
         @client.father_name ||= row[3].downcase.mb_chars.capitalize unless row[3].nil?
         @client.client_sex_id ||= woman_surname?(@client.surname) ? 2:1
         
         @client.pasp_seria ||= row[4]
         @client.pasp_num ||= row[5]

         @client.birth_date ||= convert_d(row[6])
         
         @client.ins_seria ||= row[7]
         @client.ins_num ||= row[8]

          
         @client.ins_company_id ||= Ref::InsCompany.find_or_create_by_name(row[9].mb_chars.capitalize.to_s).id unless row[9].nil? or row[9].blank?
         @client.ins_company_id ||= 9999 if @client.ins_company_id.nil?

          
         @client.reg_address ||= row[10]
         @client.real_address ||= @client.reg_address
         @client.snils ||= row[12]





          unless row[11].nil?
              benefits = row[11].split
              benefits.each do |b|
                bc = Ref::BenefitCategory.find_by_code(b.to_i)
                unless bc.nil?

                  if @client.benefits.index {|benefit| benefit.code == bc.code}.nil?
                    @client.benefits.new(:benefit_category_id => bc.id, :doc_name => 'не указан')
                  end  
         
                end  
              end 

          end  

         @client.save! unless (@client.name.nil? or @client.surname.nil? or @client.birth_date.nil? or @client.client_sex_id.nil?)

        end

        # log.debug "I: #{@i}"
  end

   # render :text => @client.num_card
   # @clients
  end


end
# == Schema Information
#
# Table name: clients
#
#  id                         :integer         not null, primary key
#  num_card                   :string(255)
#  name                       :string(255)
#  surname                    :string(255)
#  father_name                :string(255)
#  birth_date                 :date
#  pasp_num                   :string(255)
#  pasp_seria                 :string(255)
#  snils                      :string(255)
#  work_place                 :string(255)
#  work_position              :string(255)
#  attach_date                :date
#  special_note               :string(255)
#  detach_date                :date
#  notes                      :string(255)
#  ins_company_id             :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  client_sex_id              :integer
#  lab_tests_count            :integer         default(0)
#  diagnostic_tests_count     :integer         default(0)
#  htm_help_notes_count       :integer         default(0)
#  med_diagnostic_tests_count :integer         default(0)
#  hospitalizations_count     :integer         default(0)
#  prof_inspections_count     :integer         default(0)
#  sanatorium_notes_count     :integer         default(0)
#  mobile_phone               :string(255)
#  home_phone                 :string(255)
#  work_phone                 :string(255)
#  relative_phone             :string(255)
#  pensioner                  :boolean         default(FALSE)
#  blood_group                :integer
#  benefit_refuse             :boolean         default(FALSE)
#  drug_intolerance           :text
#  ins_seria                  :string(255)
#  ins_num                    :string(255)
#  real_address               :string(255)
#  reg_address                :string(255)
#  benefits_count             :integer         default(0)
#  mkbs_count                 :integer         default(0)
#  disabled                   :boolean         default(FALSE)
#  detach_reason              :integer         default(0)
#  death_date                 :date
#  death_reason_id            :integer
#  is_uov                     :boolean
#  is_ivov                    :boolean
#  is_ubd                     :boolean
#

