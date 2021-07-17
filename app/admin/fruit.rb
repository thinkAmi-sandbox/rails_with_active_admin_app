ActiveAdmin.register Fruit do
  permit_params :name, :color

  # コントローラのcreate/update/destroyをオーバーライド
  controller do
    def create
      super do |format|
        call_api(:create)
      end
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
  end
end