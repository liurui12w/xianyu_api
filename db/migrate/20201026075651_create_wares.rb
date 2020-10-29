class CreateWares < ActiveRecord::Migration[5.2]
  def change
    create_table :wares do |t|
      t.string :sku_code, comment: "sku编号"
      t.string :sku_number, comment: "账户"
      t.string :describe, comment: "描述"
      t.decimal :price, precision: 30, scale: 2, default: 0, comment: "价格"
      t.string :is_free, comment: "是否包邮"
      t.string :img_path, comment: "图片地址"
      t.timestamps

    end
  end
end
