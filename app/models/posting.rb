class Posting < ApplicationRecord

  belongs_to :author,    class_name: 'User', foreign_key: 'user_id'
  belongs_to :editor,    class_name: 'User', foreign_key: 'editor_id'
  

  # should be replaced to Article.
  def article_with_image
    # Not clear logic. Where do you describe aricle attribute. Not clear this case
    return type if type != 'Article'

    figure_start = body.index('<figure')
    figure_end = body.index('</figure>')

    # we need to check figure_start and figure_end. If thea are not present much better to breack any next operation
    # return unless figure_start.present? && figure_end.present?
    # in this case our image will be empty and nor render regarding conditions.
    return "#{figure_start}_#{figure_end}" if figure_start.nil? || figure_end.nil?

    image_tags = body[figure_start...figure_end + 9]
    # Check what you want to return please. In case when we don't have image in block <figure> we need to breack any operation and return.
    # In this case we dont neet to render any images. We can add any information to the loger.
    return 'not include <img' unless image_tags.include?('<img')

    posting_image_params(image_tags)
  end

  private

  def posting_image_params(html)
    tag_parse = -> (image, att) { image.match(/#{att}="(.+?)"/) }
    tag_attributes = {}

    %w[alt src data-image].each do |attribute|
      data = tag_parse.(html, attribute)

      # Much better to change all bloc to one line 
      # tag_attributes[attribute] = data[1] if data && data.size >= 2
      unless data.nil?
        tag_attributes[attribute] = data[1] unless data.size < 2
      end
    end

    # Need to remove commented code 
    # tag_parse
    tag_attributes
  end
end