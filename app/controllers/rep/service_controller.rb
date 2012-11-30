class Rep::ServiceController < ApplicationController
 layout false,:only => :create


def edit
 @client_id = params[:id]
end

def create
 # @summa = params[:summa]
 # @client = Client.find(params[:client_id]) 

 @client = current_client

 respond_to do |format|
   format.pdf
 end

end
end
