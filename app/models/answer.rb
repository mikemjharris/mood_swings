class Answer < ActiveRecord::Base
  belongs_to :answer_set
  belongs_to :metric
  attr_accessible :comments, :value, :metric_id, :not_applicable

  after_save :nullify_comments_if_necessary
  before_destroy :prevent_destroy
  
  validates :value, inclusion: (1..5)
  validates :metric_id, uniqueness: {scope: :answer_set_id}
  validates :metric_id, presence: true

  attr_reader :not_applicable

  def not_applicable=(value)
    @not_applicable = [true, 1, "1"].include?(value)
  end

  def knob_data
    {
      fgColor: "#66CC66",
      angleOffset: -125,
      angleArc: 250,
      width: 75,
      height: 75,
      min: 1,
      max: 5,
      cursor: true,
      linecap: :round,
    }
  end

  private
  def prevent_destroy
    errors.add :base, "you cannot delete answers"
    return false
  end

  private
  def nullify_comments_if_necessary
    return if comments.blank?
    null_comments = '\A\s*n\/a\s*\Z' # any amount of whitespace at the start and end of the comments with 'n/a' in the middle

    update_attributes(comments: nil) if comments.match(Regexp.new(null_comments, Regexp::IGNORECASE))
  end
end
