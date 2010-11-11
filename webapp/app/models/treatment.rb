# Copyright (C) 2007, 2008, 2009, 2010 The Collaborative Software Foundation
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

class Treatment < ActiveRecord::Base
  belongs_to :treatment_type, :class_name => 'Code', :foreign_key => 'treatment_type_id'
  
  validates_presence_of :treatment_name

  named_scope :active, 
    :conditions => ["active = ?", true],
    :order => "treatment_name ASC"

  class << self

    def all_by_type(type_code)
      raise ArgumentError unless type_code.is_a?(Code)
      self.find(:all, :conditions => ["treatment_type_id = ?", type_code.id], :include => :treatment_type)
    end
    
    def load!(hashes)
      transaction do
        attributes = Treatment.new.attribute_names
        hashes.each do |attrs|
          treatment_type_code = attrs.fetch('treatment_type_code')
          code = Code.find_by_code_name_and_the_code('treatment_type', treatment_type_code)
          raise "Could not find treatment_type code for #{treatment_type_code}" if code.nil?
          unless self.find_by_treatment_type_id_and_treatment_name(code.id, attrs["treatment_name"])
            load_attrs = attrs.reject { |key, value| !attributes.include?(key) }
            load_attrs.merge!(:treatment_type_id => code.id)
            Treatment.create!(load_attrs)
          end
        end
      end
    end

    def treatments_for_event(event)
      treatments = self.active
      event_treatments = event.try(:interested_party).try(:treatments)

      unless event_treatments.nil?
        added_inactive_treatment = false
        
        event_treatments.each do |pt|
          if pt.try(:treatment).try(:id) && !pt.try(:treatment).try(:active?)
            treatments << pt.treatment
            added_inactive_treatment = true
          end
        end

        treatments = treatments.sort_by { |treatment| treatment.treatment_name }.uniq if added_inactive_treatment
      end

      treatments
    end
  end

  def merge(treatment_ids)
    treatment_ids = [treatment_ids].flatten.compact.uniq.collect { |id| id.to_i }
    
    if treatment_ids.empty?
      errors.add(:base, :no_treatments_for_merging)
      return nil
    end

    if treatment_ids.include?(self.id)
      errors.add(:base, :cannot_merge_treatment_into_itself)
      return nil
    end

    begin
      Treatment.transaction do
        treatment_ids.each do |treatment_id|
          ParticipationsTreatment.find_all_by_treatment_id(treatment_id).each do |pt|
            pt.update_attribute(:treatment_id, self.id)
          end

          Treatment.destroy(treatment_id)
        end
      end

      return true
    rescue Exception => ex
      logger.error ex
      errors.add(:base, :failed_treatment_merge, :msg => ex.message)
      return nil
    end
  end

end
