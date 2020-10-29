json.status 200
json.message '获取成功'
json.size @record.size
json.total_count @record.total_count
json.data do
  json.array! @record do |lp|
    json.id lp.id
    json.sku_code lp.sku_code
    json.sku_number lp.sku_number
    json.describe lp.describe
    json.price lp.price
    json.is_free lp.is_free
    json.img_path lp.img_path
    json.avatar lp.avatar && lp.avatar.url
    # json.avatar_url lp.avatar_url
    json.created_at lp.created_at && lp.created_at.strftime("%Y-%m-%d %H:%M")
    json.updated_at lp.updated_at && lp.updated_at.strftime("%Y-%m-%d %H:%M")
  end
end
