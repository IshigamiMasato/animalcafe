module ReviewsHelper
  # 1つのレビューの5点中の割合
  def score_percentage(score)
    score.to_f / 5 * 100
  end
end
