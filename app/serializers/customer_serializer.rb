class CustomerSerializer < BaseSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :first_name, :last_name
end
