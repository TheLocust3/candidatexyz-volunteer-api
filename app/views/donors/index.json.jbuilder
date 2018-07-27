json.donors @donors do |donor|
    json.partial! 'donors/donor', donor: donor
end
