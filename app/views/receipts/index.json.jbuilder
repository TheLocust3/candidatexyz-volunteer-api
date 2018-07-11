json.receipts @receipts do |receipt|
    json.partial! 'receipts/receipt', receipt: receipt
end
