require 'spec_helper'
require 'ashikawa-core/database'

describe Ashikawa::Core::Database do
  subject { Ashikawa::Core::Database }
  
  before :each do
    mock(Ashikawa::Core::Collection)
    @connection = double()
  end
  
  it "should initialize with a connection" do
    @connection.stub(:ip) { "http://localhost" }
    @connection.stub(:port) { 8529 }
    
    database = subject.new @connection
    database.ip.should == "http://localhost"
    database.port.should == 8529
  end
  
  describe "initialized database" do
    subject { Ashikawa::Core::Database.new @connection }
    
    it "should fetch all available collections" do
      @connection.stub :send_request do |path|
        server_response("collections/all")
      end
      @connection.should_receive(:send_request).with("/collection")
      
      Ashikawa::Core::Collection.should_receive(:new).with(subject, "example_1", id: 4588)
      Ashikawa::Core::Collection.should_receive(:new).with(subject, "example_2", id: 4589)
      
      subject.collections.length.should == 2
    end
    
    it "should fetch a single collection if it exists" do
      @connection.stub :send_request do |path|
        server_response("collections/4588")
      end
      @connection.should_receive(:send_request).with("/collection/4588")
      
      Ashikawa::Core::Collection.should_receive(:new).with(subject, "example_1", id: 4588)
      
      subject[4588]
    end
    
    it "should create a single collection if it doesn't exist" do
      @connection.stub :send_request do |path, method = {}|
        if method.has_key? :post
          server_response("collections/4590")
        else
          server_response("collections/not_found")
        end
      end
      @connection.should_receive(:send_request).with("/collection/new_collection")
      @connection.should_receive(:send_request).with("/collection/new_collection", post: { name: "new_collection"} )
      
      Ashikawa::Core::Collection.should_receive(:new).with(subject, "new_collection", id: 4590)
      
      subject['new_collection']
    end
    
    it "should send a request via the connection object" do
      @connection.should_receive(:send_request).with("/my/path", post: { data: "mydata" })
      
      subject.send_request "/my/path", post: { data: "mydata" }
    end
  end
end