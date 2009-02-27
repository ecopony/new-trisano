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

class PlaceEvent < Event
  has_one :interested_place, :foreign_key => "event_id"
  belongs_to :participations_place

  accepts_nested_attributes_for :interested_place
  accepts_nested_attributes_for :participations_place, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  before_create do |contact|
    contact.add_note("Place event created.")
  end

  ### TGRII: Do I still want this?
  # after_save :set_primary_entity_on_secondary_participations

  class << self
    def core_views
      [
        ["Place", "Place"]
      ]
    end
  end
  
  # If you're wondering why calling #destroy on a place event isn't deleting the record, this is why.
  # Override destroy to soft-delete record instead.  This makes it easier to work with :autosave.
  def destroy
   self.soft_delete
  end

  private

  def set_primary_entity_on_secondary_participations
    reload
    self.participations.each do |participation|
      if participation.primary_entity_id.nil?
        participation.update_attribute('primary_entity_id', self.interested_place.place_entity.id)
      end
    end
  end
end
