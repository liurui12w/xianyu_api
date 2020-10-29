class Ware < ApplicationRecord

  mount_uploader :avatar, AvatarUploader

  def add_data

  end

  def self.import(path)
    # spreadsheet =  Roo::Spreadsheet.open("/Users/admin/work/xianyu/闲鱼商品上架内容.xlsx")
    spreadsheet = Roo::Spreadsheet.open("#{path}")
    order_head = spreadsheet.sheet(0).row(1)
    order_count = 0
    error_count = 0
    import_message = []

    (2..spreadsheet.sheet(0).last_row).each do |i|
      row = Hash[[order_head, spreadsheet.sheet(0).row(i)].transpose]
      @new_ware = Ware.create!(sku_code: row["sku序列号"],sku_number: row["上架账号"],
           describe: row["内容"],price: row["sku价格"],is_free: row["是否包邮"],img_path: row["sku图片"])

      new_path = row["sku图片"]
      new_path = new_path.gsub('\\', '/')
      path= "/Users/admin/work/xianyu"

      file = []
      Dir["#{path}#{new_path}"+("/*.jpeg" || "/*.jpg" || "/*.png")].each do |f|
        file << f
      end
      @new_ware.update(avatar: File.open(file.first)) if file.first.present? && file.length > 0

      # @ware = Ware.find_by(number: row["sku序列号"])
      # unless @ware.present?
      #   @new_ware = Ware.create!(sku_code: row["sku序列号"],sku_number: row["上架账号"],
      #        describe: row["内容"],price: row["sku价格"],is_free: row["是否包邮"],img_path: row["sku图片"])
      #    order_count += 1
      # end
      order_count += 1
      import_message = ["导入成功:#{order_count}"]
    end if error_count == 0

    import_message
  end
  private
  def self.open_spreadsheet(file)
    case File.extname(file)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{File.basename(file)}"
    end
  end
end
