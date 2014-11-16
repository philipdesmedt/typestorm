class PagesController < ApplicationController

  def landing
  end

  def analyze
    @analytics = Analytics.new(params).analyze
  end
end
