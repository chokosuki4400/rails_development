# frozen_string_literal: true

module ApplicationHelper
  require "uri"

  def text_url_to_link text

    URI.extract(text, ['http','https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"

      text.gsub!(url, sub_text)
    end

    return text
  end

  def default_meta_tags
    {
      site: 'なんでだッ!?-Nandeda-',
      title: '',
      reverse: true,
      charset: 'utf-8',
      description: 'なんでだッ!?は、匿名の人からツッコミの一言をもらって、あなたがボケを考えて答えることのできるサービスです。ボケとツッコミのワンセットを完成させてみんなで楽しんで下さい。',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: 'なんでだッ!?-Nandeda-',
        title: 'なんでだッ!?-Nandeda-',
        description: 'なんでだッ!?は、匿名の人からツッコミの一言をもらって、あなたがボケを考えて答えることのできるサービスです。ボケとツッコミのワンセットを完成させてみんなで楽しんで下さい。',
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@Nandeda_com',
      }
    }
  end
end