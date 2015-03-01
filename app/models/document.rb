# == Schema Information
#
# Table name: documents
#
#  id         :integer          not null, primary key
#  title      :string           default(""), not null
#  markdown   :text             default(""), not null
#  draft_flag :boolean          default("false"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Document < ActiveRecord::Base
  validates_presence_of :title, :markdown

  has_many :user_documents
  has_many :users, through: :user_documents

  scope :draft, -> { where(draft_flag: true) }
  scope :publish, -> { where(draft_flag: false) }

  def self.id_is(id)
    Document.where(id: id.to_i).first
  end

  def self.search_created_at(date)
    from = Time.strptime(date, '%y / %m / %d')
    to = from + 1.day
    where(created_at: from...to)
  end

  def self.search_title(keyword)
    where 'title LIKE ?', "%#{escape_like keyword}%"
  end

  def self.search_markdown(keyword)
    where 'markdown LIKE ?', "%#{escape_like keyword}%"
  end

  def draft?
    draft_flag
  end

  def publish?
    !draft_flag
  end
end
