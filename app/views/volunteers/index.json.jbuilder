json.volunteers @volunteers do |volunteer|
    json.partial! 'volunteers/volunteer', volunteer: volunteer
end
