class DispGroupReport < BaseReport
  attr_accessor :rows,:total_male, :total_female
  

def fill
  
  age = 21
  max_age = 99
 
  benefit_clients = Client.all_benefits

  
  @rows = Hash.new

  @total_male = 0
  @total_female = 0

  while age <= max_age
  
    male = Client.years_old(age).male + benefit_clients.years_old(age-1).male + benefit_clients.years_old(age+1).male
    female = Client.years_old(age).female + benefit_clients.years_old(age-1).female + benefit_clients.years_old(age+1).female

    @total_male += male.count
    @total_female += female.count

    @rows[age] = [male,female]
    age += 3
  end


end

end
