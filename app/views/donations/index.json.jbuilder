json.donations @donations do |donation|
    json.partial! 'donations/donation', donation: donation
end
