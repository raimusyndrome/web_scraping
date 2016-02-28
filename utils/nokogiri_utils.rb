# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

def cookie_header(cookie_hash)
    if cookie_hash
        cookie = cookie_hash.map{|x| x.join('=')}.join('; ')
    else
        cookie = ''
    end
    return cookie
end

def open_url_html(url, cookie_hash=nil)
    charset = nil
    cookie = cookie_header(cookie_hash)
    html = open(url, {'Cookie' => cookie}) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
    end
    return html, charset
end

def get_html_doc(url, cookie=nil)
    html, charset = open_url_html(url, cookie)
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
    # html = open_file_html(file_name)
    html = File.open(file_name, 'r')
    doc = Nokogiri::HTML(html)
    html.close
    return doc
end

def write_html_doc(file_name, doc)
    open(file_name, 'w') do |f|
        f.puts doc.to_s
    end
end

def download_html(url, out_dir=".", file_name=nil, cookie=nil)
    doc = get_html_doc(url, cookie)
    if file_name
        out_path = File.join(out_dir, file_name)
    else
        out_path = File.join(out_dir, 'web_page_'+url.gsub(/\//, '_')+'.html')
    end
    write_html_doc(out_path, doc)
    return doc
end

