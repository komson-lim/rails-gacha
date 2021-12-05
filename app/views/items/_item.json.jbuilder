json.extract! item, :id, :name, :rarity, :url, :created_at, :updated_at
json.url item_url(item, format: :json)
