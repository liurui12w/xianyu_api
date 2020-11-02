class Api::SmallPro::WaresController < ApplicationController
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    page = params[:page] || 1
    per = params[:per] || 20
    record = Ware.all.ransack(q_params).result(distinct: true).order("created_at desc")
    @record = Kaminari.paginate_array(record).page(page).per(per)
  end

  def get_ware_data
    path = "/home/ubuntu/xianyu/闲鱼商品上架内容.xlsx" || params[:path]
    message = Ware.import(path)
    render_json([200, "#{message}"])
  end


  def update
    if @record.update!(ware_params)
      result = [200, '修改成功']
    else
      result = [400, '修改失败']
    end
    render_json(result)
  end


  private
  def set_record
    @record = Ware.find(params[:id])
  end

  def ware_params
    params.permit(:sku_code, :sku_number, :describe, :price, :is_free, :avatar)
  end

  def q_params
    if params[:q]
      params.require(:q).permit(:sku_number_eq,:sku_code_eq,:describe_cont, :price_gteq, :price_lteq,:is_free_eq)
    end
  end

end
