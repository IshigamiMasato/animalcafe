class StaticPagesController < ApplicationController
  def home
    @animal_tags = Tag.where(tag_type: "animal").limit(15)
    @env_tags = Tag.where(tag_type: "env").limit(10)
  end

  def about
  end
end
