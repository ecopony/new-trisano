# Copyright (C) 2007, 2008, 2009, 2010, 2011, 2012, 2013 The Collaborative Software Foundation
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
class ValidateParticipations < ActiveRecord::Migration
  def self.up
    execute <<-SQL
CREATE OR REPLACE FUNCTION validate_participation() RETURNS TRIGGER AS $validate_participation$
DECLARE
    msg TEXT;
BEGIN
    IF NEW.type = 'Jurisdiction' OR NEW.type = 'AssociatedJurisdiction' THEN
        PERFORM 1
            FROM places
                JOIN places_types ON places_types.place_id = places.id
                JOIN codes ON places_types.type_id = codes.id AND codes.the_code = 'J'
            WHERE places.entity_id = NEW.secondary_entity_id;
        msg := 'Participation types Jurisdiction and AssociatedJurisdiction must have a jurisdiction in their secondary_entity_id';
    ELSIF NEW.type IN ('Lab', 'ActualDeliveryFacility', 'ReportingAgency', 'DiagnosticFacility', 'ExpectedDeliveryFacility', 'InterestedPlace', 'HospitalizationFacility') THEN
        PERFORM 1 FROM places WHERE places.entity_id = NEW.secondary_entity_id;
        msg := 'Participation types Lab, ActualDeliveryFacility, ReportingAgency, DiagnosticFacility, ExpectedDeliveryFacility, InterestedPlace, and HospitalizationFacility must have places in their secondary_entity_id';
    ELSIF NEW.type = 'InterestedParty' THEN
        PERFORM 1 FROM people WHERE people.entity_id = NEW.primary_entity_id;
        msg := 'InterestedParty participations must have a person in their primary_entity_id';
    ELSIF NEW.type = 'Clinician' OR NEW.type = 'HealthCareProvider' OR NEW.type = 'Reporter' THEN
        PERFORM 1 FROM people WHERE people.entity_id = NEW.secondary_entity_id;
        msg := 'Participation types Clinician, HealthCareProvider, and Reporter must have people in their secondary_entity_ids';
    ELSE
        RAISE EXCEPTION 'Participation is invalid -- unknown type %', NEW.type;
    END IF;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Validation error on participation %: %', NEW.id, msg;
    END IF;
    RETURN NEW;
END;
$validate_participation$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS validate_participations ON participations;
CREATE TRIGGER validate_participations BEFORE INSERT OR UPDATE
    ON participations FOR EACH ROW EXECUTE PROCEDURE validate_participation();
    SQL
  end

  def self.down
    execute <<-SQL
      DROP FUNCTION IF EXISTS validate_participation() CASCADE;
    SQL
  end
end
