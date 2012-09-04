class Employee < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :position, :position_title, :report_to
  
  #validates :reportto, :uniqueness => true
  #validates :last_name, :presence => true
  #validates :first_name, :presence => true
	before_save :default_first_name, :default_last_name, :default_position_title 

  def self.build_from_csv(row)
  	#raise row[1].inspect 
  	@error = nil  	
  	#if row[1] == '6'
  	#	@error = 'Maisa Pride'  		
  	#end 	
	
  	cust = Employee.find_or_initialize_by_position(row[0])  	
    cust.attributes ={:position => row[0],
     :report_to => row[1],
     :first_name => row[2],
     :last_name => row[3],
     :position_title => row[4]}
    return cust,@error
  end
  
  def self.EmployeeHeader  	
  	"Position,ReportTo,First Name,Last Name,Position title".split(',')
  end
  
  protected
  
  def default_first_name
    self.first_name ||= 'Vacant'
  end
  
  def default_last_name
    self.last_name ||= 'Position'
  end
  
  def default_position_title
  	self.position_title ||= 'Position title'
  end
end
