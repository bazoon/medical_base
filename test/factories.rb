FactoryGirl.define do 
  factory :benefit_category,:class => Ref::BenefitCategory do
    code  10
  end  
end

FactoryGirl.define do 
  factory :benefit,:class => Benefit do
    association :benefit_category,:factory => :benefit_category
    doc_name "docs"
  end  
end

FactoryGirl.define do 
  factory :client,:class => Client do
    num_card "1234"
    name "Abra123"
    surname "PCodrbr"
    association :ins_company, :factory => :ins_company
    birth_date '01.01.2004'
    client_sex_id  1
  end  
end

FactoryGirl.define do 
  factory :hospitalization do 
    hospitalization_type_id  1
  end  
end

FactoryGirl.define do
  factory :diagnostic_test do  
    diagnostic_test_type_id 1
    test_date '01.01.2011'
    result "ok"
    total DiagnosticTest::NORM
  end  
end


FactoryGirl.define do 
  factory :disp do
    actual_date '01.01.2011'
  end  
end

FactoryGirl.define do
  factory :htm_help_note do  
    actual_date '01.01.2011'
    association :htm_help_type,:factory => :htm_help_type
  end  
end


FactoryGirl.define do 
  factory :lab_test do  
    association :lab_test_type,:factory => :lab_test_type
    test_date '01.01.2011'
    result "ok"
    client_id 1
  end  
end

FactoryGirl.define do
  factory :med_diagnostic_test do  
    association :hospitalization_type, :factory => :hospitalization_type
    test_date '01.01.2011'
    result "ok"
    client_id 1
  end  
end

FactoryGirl.define do
  factory :doctor_type,:class => "Ref::DoctorType" do 
    name "doctor"
  end
end

FactoryGirl.define do
  factory :user do  
    association :doctor_type, :factory => :doctor_type
    name "doctor"
    surname "ivanov"
  end  
end



FactoryGirl.define do
  factory :mkb_type,:class => "Ref::MkbType" do
    sequence(:code) {|n| "A#{n+1}"}
    name "mkbtype"
    association :doctor_type,:factory => :doctor_type
  end  
end

FactoryGirl.define do
  factory :mkb do  
    association :mkb_type, :factory => :mkb_type
    actual_date '01.01.2011'
    association :client, :factory => :client
    association :user,:factory => :user
  end  
end

FactoryGirl.define do
  factory :mse do  
    association :mkb_type, :factory => :mkb_type
    conclusion_date '01.01.2011'
    send_date '01.01.2011'
    association :client, :factory => :client
    association :user,:factory => :user
  end
end

FactoryGirl.define do
  factory :prof_inspection do  
    actual_date "01.01.2011"
    inspection_type 1
    
    association :client, :factory => :client
    association :user,:factory => :user
  end  
end

FactoryGirl.define do
  factory :sanatorium_note do
    neediness_ref_date '01.01.2011'
    sanatorium_card_fill_date '01.01.2011'
    period_start '01.01.2011'
    period_end '01.01.2011'
    association :client, :factory => :client
  end  
end

FactoryGirl.define do
  factory :diagnosis do  
    association :mkb_type, :factory => :mkb_type
    association :prof_inspection, :factory => :prof_inspection
  end 
end


#Ref Factories

FactoryGirl.define do
  factory :death_reason,:class => Ref::DeathReason do
    name "d"
  end  
end


FactoryGirl.define do
  factory :desease_type,:class => Ref::DeseaseType do
    name "d"
  end
end

FactoryGirl.define do
  factory :diagnostic_test_type,:class => Ref::DiagnosticTestType do
    name "d"
  end  
end

FactoryGirl.define do
  factory :hospitalization_type,:class => Ref::HospitalizationType do
    name "d"
  end  
end

FactoryGirl.define do
  factory :htm_help_type,:class => Ref::HtmHelpType do
    name "d"
  end
end

FactoryGirl.define do
  factory :ins_company,:class => Ref::InsCompany do
    name "Ugoria mine gmbx"
  end
end

FactoryGirl.define do
  factory :lab_test_type,:class => Ref::LabTestType do
    name "d"
  end  
end

FactoryGirl.define do
  factory :lab_test_group,:class => Ref::LabTestGroup do
    name "d"
  end  
end

FactoryGirl.define do
  factory :lab_test_type_group,:class => Ref::LabTestTypeGroup do
    association :lab_test_type, :factory => :lab_test_type
    association :lab_test_group, :factory => :lab_test_group
  end  
end

FactoryGirl.define do
  factory :med_diagnostic_test_type,:class => Ref::MedDiagnosticTestType do
    name "d"
  end  
end

FactoryGirl.define do
  factory :sanatorium,:class => Ref::Sanatorium do
    name "d"
  end  
end
