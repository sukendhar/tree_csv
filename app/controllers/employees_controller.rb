require 'csv'
class EmployeesController < ApplicationController
	
	layout "application"
	
	before_filter :authenticate_user!
  # GET /employees
  # GET /employees.json
  def index    
    @employees = Employee.all
    #raise @employees.inspect
    @root_node = Employee.all.first
		#Employee.report(@employees)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @employees }
    end
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    @employee = Employee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employee }
    end
  end

  # GET /employees/new
  # GET /employees/new.json
  def new
    @employee = Employee.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @employee }
    end
  end

  # GET /employees/1/edit
  def edit
    @employee = Employee.find(params[:id])
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(params[:employee])

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render json: @employee, status: :created, location: @employee }
      else
        format.html { render action: "new" }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /employees/1
  # PUT /employees/1.json
  def update
    @employee = Employee.find(params[:id])

    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to employees_url }
      format.json { head :no_content }
    end
  end
  
  def importCsv
  	if request.post? && params[:file].present?
  		infile = params[:file].read 		  		
      n, errs = 0, []
			parentRows = 0
      CSV.parse(infile) do |row|
        n += 1               
        next if n == 1 or row.join.blank? # SKIP: header i.e. first row OR blank row
        @importproduct, @custError = Employee.build_from_csv(row) # build_from_csv method will map customer attributes & build new customer record         
        if @importproduct.valid? # Save upon valid otherwise collect error records to export         
          @importproduct.save          
        else        	     	
        	row.push @importproduct.errors.full_messages.join(',')
        	row.push @custError if !@custError.blank?
          errs << row
        end
      end
      
      if errs.any?      	
        errFile ="errors_#{Date.today.strftime('%d%b%y')}.csv"
        errs.insert(0, Employee.importHeader)
        errCSV = CSV.generate do |csv|
          errs.each {|row| csv << row}
        end
        
        send_data errCSV, :type => 'text/csv; charset=iso-8859-1; header=present',:disposition => "attachment; filename=#{errFile}.csv"
        if @importproduct.errors == true
        	redirect_to employees_path, :notice=>"Errors: #{@importproduct.errors}" and return
        end
      else
        redirect_to employees_path, :notice=>'Import successful'
      end
    end
  end
  
  def get_child
  	@childs	= Employee.where(:report_to => params[:position]) 
  	render :layout => false 	
  end
end
