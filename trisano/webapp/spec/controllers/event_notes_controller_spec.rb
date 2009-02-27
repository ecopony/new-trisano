# Copyright (C) 2007, 2008, 2009 The Collaborative Software Foundation
#
# This file is part of TriSano.
#
# TriSano is free software: you can redistribute it and/or modify it under the 
# terms of the GNU Affero General Public License as published by the 
# Free Software Foundation, either version 3 of the License, 
# or (at your option) any later version.
#
# TriSano is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License 
# along with TriSano. If not, see http://www.gnu.org/licenses/agpl-3.0.txt.

require File.dirname(__FILE__) + '/../spec_helper'

describe EventNotesController do
  before(:each) do
    mock_user
    @event = mock_event
    Event.stub!(:find).and_return(@event)
  end

  describe "handling GET /events/1/notes with view event entitlement" do

    before(:each) do
      @note_1 = mock_model(Note)
      @note_2 = mock_model(Note)
      Note.stub!(:find).and_return([@note_1, @note_2])
      @user.stub!(:is_entitled_to_in?).and_return(true)
    end
  
    def do_get
      get :index, :event_id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
  
    it "should assign the found notes for the view" do
      do_get
      assigns[:event].should == @event
      assigns[:notes].should == [@note_1, @note_2]
    end
  end

  describe "handling GET /events/1/notes without view event entitlement" do

    before(:each) do
      @user.stub!(:is_entitled_to_in?).and_return(false)
    end

    def do_get
      get :index, :event_id => "1"
    end

    it "should not be successful" do
      do_get
      response.response_code.should == 403
    end

    it "should contain permissions error" do
      do_get
      response.body.include?("Permission denied").should == true
    end
  end

  describe "handling GET /events/1/notes without a valid event" do

    before(:each) do
      @user.stub!(:is_entitled_to_in?).and_return(true)
      Event.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
    end

    def do_get
      get :index, :event_id => "1"
    end

    it "should not be successful" do
      do_get
      response.response_code.should == 404
    end
  end

end
