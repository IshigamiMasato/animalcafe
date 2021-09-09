class StaticPagesController < ApplicationController
  def home
    @animal_tags = Tag.where(tag_type: "animal")
    @env_tags = Tag.where(tag_type: "env")
  end

  def about
  end
end
