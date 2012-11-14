class ClientOperationsPresenter < BasePresenter

def prepare(items,title,notice,client,paginate = true)
 @items = items
 @title = title
 @notice = notice
 @client = client
 @paginate = paginate
end

def client_header(info_message,link)
 content =  index_header + flash_message + info(info_message) + new_record(link)
 content += paginate_items if @paginate
 content
end

def table_or_empty(&block)
 if @items.count > 0 
   content=""
   yield
 else
   content = content_tag(:br,content_tag(:span,I18n.t(:no_records),:class => "alert info"))
 end
 content
end  

def info(message)
	content_tag(:div,message,:class => "alert alert-info")	
end

 
def new_record(link)
	button_to t(:new_record), link,:class => "btn btn-warning",:method => :get
end


private

def flash_message
 unless flash.empty?
#  content = link_to('x','',:class => "close",'data-dissmiss' => "alert") + @notice
  content = @notice
  content_tag(:div,content,:class => "alert alert-success") 
 end
end

def index_header
 content = content_tag(:br) 
 content = content + content_tag(:h2,@title) + content_tag(:br)
end

def client_back_path
 link_to content_tag(:span,"",class: "ui-icon ui-icon-triangle-1-w"), operations_client_path(@client) unless @client.nil?
end

def paginate_items
 paginate @items if @items.respond_to?(:current_page)
end




end
