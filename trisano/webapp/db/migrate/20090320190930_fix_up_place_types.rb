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

class FixUpPlaceTypes < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      create_table :places_types, :id => false, :primary_key => [:place_id, :type_id]  do |t|
        t.integer :place_id
        t.integer :type_id
      end
    
      if RAILS_ENV == 'production'
        ReportingAgencyType.all.each do |rat|
          execute("INSERT INTO places_types (place_id, type_id) VALUES (#{rat.place_id}, #{rat.code_id})")
        end

        Place.all.each do |place|
          execute("INSERT INTO places_types (place_id, type_id) VALUES (#{place.id}, #{place.place_type_id})") if place.place_type_id
        end

        execute("
          UPDATE core_fields
          SET key = 'place_event[active_place][active_primary_entity][place][place_type_ids]'
          WHERE key = 'place_event[interested_place][place_entity][place][place_type_id]'
        ")

        execute("
          UPDATE form_elements
          SET core_path = 'place_event[active_place][active_primary_entity][place][place_type_ids]'
          WHERE core_path = 'place_event[interested_place][place_entity][place][place_type_id]'
        ")
      end

      remove_column :places, :place_type_id
      drop_table :reporting_agency_types
    end
  end

  def self.down
    drop_table :places_types
    add_column :places, :place_type_id, :integer
    create_table :reporting_agency_types do |t|
      t.integer :place_id
      t.integer :code_id
      t.timestamps
    end
  end
end
