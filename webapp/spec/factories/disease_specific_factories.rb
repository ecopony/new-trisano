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

require 'factory_girl'

Factory.define :disease_specific_validation do |dsv|
  dsv.validation_key { Factory.next(:validation_key) }
  dsv.association :disease
end

Factory.define :disease_specific_callback do |dsc|
  dsc.callback_key { Factory.next(:callback_key) }
  dsc.association :disease
end

#
# Sequences
#

Factory.sequence :validation_key do |n|
  "validation_key_#{n}"
end

Factory.sequence :callback_key do |n|
  "callback_key_#{n}"
end