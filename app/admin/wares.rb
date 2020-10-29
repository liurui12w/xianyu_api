ActiveAdmin.register Ware do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :sku_code, :sku_number, :describe, :price, :is_free, :img_path
  #
  # or
  #
  # permit_params do
  #   permitted = [:sku_code, :sku_number, :describe, :price, :is_free, :img_path]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :sku_code, :sku_number, :describe, :price, :is_free, :img_path

  form do |f|
    f.semantic_errors

    f.inputs '商品' do
      f.input :sku_code
      f.input :sku_number
      f.input :describe
      f.input :price
      f.input :is_free
      f.input :img_path

      # f.inputs '商品图片', :multipart => true do
      #   f.input :avatar, as: :file, hint: (image_tag(f.object.avatar.url, size: '256x256') if !f.object.new_record? and !f.object.avatar.url.nil?)
      #   f.input :avatar_cache, as: :hidden
      # end

    end
    f.actions
  end

  filter :sku_code
  filter :sku_number
  filter :created_at

  index do
    selectable_column
    id_column
    # column '商品图片' do |buyer|
    #   unless buyer.avatar.url.nil?
    #     link_to image_tag("#{buyer.avatar.url}", size: '128x128'), image_path("#{buyer.avatar.url}"), :target => "_blank"
    #   else
    #     '暂无图片'
    #   end
    # end
    column :sku_code
    column :sku_number
    column :describe
    column :price
    column :is_free
    column :img_path
    column :created_at
    actions
  end
end
