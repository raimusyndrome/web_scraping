
def get_page_list(doc):
    # 検索結果の全ページのURLリストを取得する
    page_url = []
    doc.css(".paging a").each do |page|
        page_url.push(page["href"])
    end
    return page_url
end

def get_detail_url_list(doc):
    # 検索結果ページのカード詳細URLのリストを取得する
    url_list = []
    doc.search(".cardItem").each do |item|
        detail_url = item.at_css("a")['href']
        url_list.push(detail_url)
    end
    return url_list
end

