json.contacts @contacts do |contact|
    json.partial! 'contacts/contact', contact: contact
end
