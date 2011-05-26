# Copyright (C) 2007, 2008, 2009, 2010, 2011 The Collaborative Software Foundation
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

class DeleteOrphanedEncounterParticipations < ActiveRecord::Migration
  def self.up
    return unless ENV['UPGRADE']
    transaction do
      execute(<<-SQL)
        DELETE FROM participations
        WHERE type IN ('Jurisdiction', 'AssociatedJurisdiction')
        AND event_id IN (SELECT id FROM events WHERE type = 'EncounterEvent')
      SQL

      execute(<<-SQL)
        DELETE FROM disease_events
        WHERE event_id IN (SELECT id FROM events WHERE type = 'EncounterEvent')
      SQL
    end
  end

  def self.down
  end
end
