# -*- encoding: utf-8 -*-

def get_page_list(doc)
    # 検索結果の全ページのURLリストを取得する
    page_url = []
    doc.css(".paging > a").each do |page|
        page_url.push(page["href"])
    end
    # 末尾は次のページなので、除外する
    return page_url[0..-2]
end

def get_detail_url_list(doc)
    # 検索結果ページのカード詳細URLのリストを取得する
    url_list = []
    doc.search(".cardItem").each do |item|
        detail_url = item.at_css("a")["href"]
        detail_url = detail_url.split("/")[1..detail_url.length].join("/")
        url_list.push(detail_url)
    end
    return url_list
end

def get_card_url_list(set_name, out_dir=".", save=false)
    # 指定したカードセットのURLリストを取得する。
    page_list_file = "card_page_list_#{set_name}.txt"
    save_path = File.join(out_dir, page_list_file)
    if File.exist?(save_path)
        card_list = []
        open(save_path, "r") do |f|
            f.each do |line|
                card_list.push(line)
            end
        end
    else
        card_list = download_card_page_list(set_name, out_dir, save)
    end
    return card_list
end

def download_card_page_list(set_name, out_dir, save)
    # カードのURLリストをダウンロードする。
    search_url = card_set_url(set_name)
    # print(search_url)
    cookie = { 'CardDatabaseSettings' => '1=ja-JP' }
    search_doc = get_html_doc(search_url, cookie=cookie)
    # write_html_doc(File.join(out_dir, "search.html"), search_doc)
    page_list = get_page_list(search_doc)
    # print(page_list)
    card_list = []
    for page in page_list
        page_url = get_gatherer_domain_url(page)
        # print(page_url)
        page_doc = get_html_doc(page_url, cookie=cookie)
        card_sub_list = get_detail_url_list(page_doc)
        card_list.concat(card_sub_list)
    end
    set_file = set_name.gsub("\s", "_")
    page_list_file = "card_page_list_#{set_file}.txt"
    if save
        output_file = File.join(out_dir, page_list_file)
        open(output_file, "w") do |f|
            # f.puts card_list.to_s
            f.puts *card_list
        end
    end
    return card_list
end

