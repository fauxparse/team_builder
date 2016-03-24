module UserFromOauth
  class Google < Base
    private

    def user_attributes
      super.merge(avatar_url: auth.info.image)
    end
  end
end
