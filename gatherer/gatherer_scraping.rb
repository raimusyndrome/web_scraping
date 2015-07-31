
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
        detail_url = item.at_css("a")["href"]
        url_list.push(detail_url)
    end
    return url_list
end

def parse_card(oracle_doc, print_doc):
    # カードのデータを解析する
    id_prefix = "ctl00_ctl00_ctl00_MainContent_SubContent_SubContent"
    ja_name = print_doc.css("##{id_prefix}_nameRow").at_css(".value").text
    # TODO imgタグからテキスト表記へ
    mana_cost = print_doc.css("##{id_prefix}_manaRow").at_css(".value").text
    cmc = print_doc.css("##{id_prefix}_cmcRow").at_css(".value").text
    # TODO カードタイプとサブタイプを分ける
    card_type = print_doc.css("##{id_prefix}_typeRow").at_css(".value").text
    # TODO imgタグをテキスト表記へ
    ja_text = print_doc.css("##{id_prefix}_textRow").at_css(".cardtextbox").text
    ja_flavor = print_doc.css("##{id_prefix}_flavorRow").at_css(".flavortextbox").text
    # TODO パワータフネスを分解
    pt_value = print_doc.css("##{id_prefix}_ptRow").at_css(".value").text
    # TODO imgタグをテキスト表記へ
    expansion = print_doc.css("##{id_prefix}_setRow").at_css(".value").text
    rarity = print_doc.css("##{id_prefix}_rarityRow").at_css(".value").text
    # TODO 忠誠度を取得可能に
    # TODO 両面カードを取得可能に
    # TODO 融合カードを取得可能に
end

def alternative_img(html_text):
    # imgタグを対応するテキストに変換する
end

