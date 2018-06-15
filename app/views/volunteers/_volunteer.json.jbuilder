json.id volunteer.id
json.email volunteer.email
json.phoneNumber volunteer.phone_number

json.firstName volunteer.first_name
json.lastName volunteer.last_name

json.address volunteer.address
json.zipcode volunteer.zipcode
json.city volunteer.city
json.state volunteer.state
json.helpBlurb volunteer.help_blurb

json.contact do
    json.partial! 'contacts/contact', contact: volunteer.contact 
end
