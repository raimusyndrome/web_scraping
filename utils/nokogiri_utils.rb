# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

def open_url_html(url)
    charset = nil
    html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
    end
    return html, charset
end

def get_html_doc(url)
    html, charset = open_url_html(url)
    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, charset)
    return doc
end

def open_file_html(file_name)
    html = open(file_name, 'r') do |f|
        f.read # htmlを読み込んで変数htmlに渡す
    end
    return html
end

def read_html_doc(file_name)
    html = open_file_html(file_name)
    doc = Nokogiri::HTML(html)
    return doc
end

def write_html_doc(file_name, doc)
    open(file_name, 'w') do |f|
        f.puts doc.to_s
    end
end

def downlaod_html(url)
    doc = get_html_doc(url)
    write_html_doc('web_page_'+url.gsub(/\//, '_')+'.html', doc)
end

