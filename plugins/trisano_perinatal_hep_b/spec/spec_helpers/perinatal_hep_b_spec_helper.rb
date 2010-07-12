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

module PerinatalHepBSpecHelper

  def p_hep_b_path
    File.join(RAILS_ROOT, 'vendor', 'trisano', 'trisano_perinatal_hep_b')
  end

  def add_expected_delivery_facility_to_event(event, facility_name)
    facility_place_entity = create_delivery_facility!(:expected_delivery, facility_name)
    expected_delivery_facility = Factory.create(:expected_delivery_facility,
      :place_entity => facility_place_entity
    )
    event.expected_delivery_facility = expected_delivery_facility
    event.save!
    expected_delivery_facility
  end

  def add_actual_delivery_facility_to_event(event, facility_name, actual_delivery_facilities_participations_attributes={})
    facility_place_entity = create_delivery_facility!(:actual_delivery, facility_name)
    actual_delivery_facilities_participation = Factory.create(:actual_delivery_facilities_participation, actual_delivery_facilities_participations_attributes)
    actual_delivery_facility = Factory.create(:actual_delivery_facility,
      :place_entity => facility_place_entity,
      :actual_delivery_facilities_participation => actual_delivery_facilities_participation
    )
    event.actual_delivery_facility = actual_delivery_facility
    event.save!
    actual_delivery_facility
  end

  def create_delivery_facility!(type, name)
    create_place!(type, name)
  end

  def given_p_hep_b_core_fields_loaded
    CoreField.load!(p_hep_b_core_fields.values)
  end

  def p_hep_b_core_fields
    YAML.load_file(File.join(p_hep_b_path, 'db', 'defaults', 'core_fields.yml'))
  end

  def given_p_hep_b_csv_fields_loaded
    CsvField.load_csv_fields(p_hep_b_csv_fields)
  end

  def p_hep_b_csv_fields
    YAML::load_file(File.join(File.dirname(__FILE__), '../../config/misc/en_csv_fields.yml'))
  end
  
end