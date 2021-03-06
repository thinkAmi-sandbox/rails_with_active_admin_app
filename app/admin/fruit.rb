ActiveAdmin.register Fruit do
  permit_params :name, :color

  # コントローラのcreate/update/destroyをオーバーライド
  controller do
    def create
      ApplicationRecord.transaction do
        super do |format|
          if @fruit.valid?
            call_api_with_params(permitted_params[:fruit][:name])
            # redirectするので flash
            flash[:notice] = 'success'
          else
            # renderなので flash.now
            flash.now[:alert] = 'wrong!'
          end
        end
      end

    rescue StandardError
      flash.now[:error] = 'exception!'
      render :new
    end

    def update
      super do |format|
        call_api(:update)
      end
    end

    def destroy
      super do |format|
        call_api(:destroy)
      end
    end

    private

    def call_api(method)
      # 外部APIを呼んだつもり
      # (今回はログに出力する)
      logger.info("======> called api by #{method}")
    end

    def call_api_with_params(name)
      logger.info("======> call api with #{name}")
    end

    def permitted_params
      params.permit(:fruit => [:name])

      # 以下の書き方だとエラーになる
      # param is missing or the value is empty: fruit
      # params.require(:fruit).permit(:name)
    end
  end
end