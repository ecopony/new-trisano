# Copyright (C) 2007, 2008, The Collaborative Software Foundation
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

class ProductionAddSizeToCdcQuestions < ActiveRecord::Migration
  def self.up
    if RAILS_ENV == 'production'
      transaction do
        question_elements = QuestionElement.find(
          :all,
          :conditions => "questions.data_type = 'single_line_text' AND export_column_id IS NOT NULL",
          :include => [:question, :export_column]
        )

        question_elements.each do |element|
          element.question.size = element.export_column.length_to_output
          element.question.save!
        end
      
      end
    end
  end

  def self.down
  end
end
