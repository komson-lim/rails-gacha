json.extract! redeem_code, :id, :code, :amount, :status, :created_at, :updated_at
json.url redeem_code_url(redeem_code, format: :json)
