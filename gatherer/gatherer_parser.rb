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
    search_url = card_set_url(set_name)
    # print(search_url)
    search_doc = get_html_doc(search_url)
    page_list = get_page_list(search_doc)
    card_list = []
    for page in page_list
        page_url = get_gatherer_page_url(page)
        page_doc = get_html_doc(page_url)
        card_sub_list = get_detail_url_list(page_doc)
        card_list.concat(card_sub_list)
    end
    page_list_file = "card_page_list_#{set_name}.txt"
    if save
        output_file = File.join(out_dir, page_list_file)
        open(output_file, "w") do |f|
            # f.puts card_list.to_s
            f.puts *card_list
        end
    end
    return card_list
end

def parse_card(oracle_doc, print_doc)
    # カードのデータを解析する
    ## カード共通
    id_prefix = "ctl00_ctl00_ctl00_MainContent_SubContent_SubContent"
    name = oracle_doc.css("##{id_prefix}_nameRow").at_css(".value").text
    ja_name = print_doc.css("##{id_prefix}_nameRow").at_css(".value").text
    # カードタイプとサブタイプを分ける
    ja_type_text = print_doc.css("##{id_prefix}_typeRow").at_css(".value").text
    ja_card_type = get_card_type(ja_type_text)
    ja_sub_type = get_sub_type(ja_type_text)
    # TODO imgタグをテキスト表記へ
    ja_text = print_doc.css("##{id_prefix}_textRow").at_css(".cardtextbox").text
    ja_flavor = print_doc.css("##{id_prefix}_flavorRow").at_css(".flavortextbox").text
    # TODO imgタグをテキスト表記へ
    expansion = oracle_doc.css("##{id_prefix}_setRow").at_css(".value").text
    rarity = oracle_doc.css("##{id_prefix}_rarityRow").at_css(".value").text

    ## 呪文共通
    # TODO imgタグからテキスト表記へ
    mana_cost = oracle_doc.css("##{id_prefix}_manaRow").at_css(".value").text
    cmc = oracle_doc.css("##{id_prefix}_cmcRow").at_css(".value").text

    ## タイプ別
    # TODO カードタイプによって処理を分岐
    # パワータフネスを分解
    pt_value = oracle_doc.css("##{id_prefix}_ptRow").at_css(".value").text
    power, toughness = get_power_tough(pt_value)
    # TODO 両面カードを取得可能に
    # TODO 融合カードを取得可能に
    en_data = {:name => name, :expansion => expansion, :rarity => rarity}
    ja_data = {
        :name => ja_name, :type => ja_card_type, :sub_type => ja_sub_type, 
        :text => ja_text, :flavor => ja_flavor,
        :expansion => expansion, :rarity => rarity
    }
    return {:en => en_data, :ja => ja_data}
end

def alternative_img(html_text)
    # imgタグを対応するテキストに変換する
end

def get_power_tough(pt_value)
    # パワー、タフネス値を取得する
    pt_ele = pt_value.split(/[ \/]/)
    return pt_ele[0].to_i, pt_ele[-1].to_i
end

def get_loyarity(loyalty)
    # 忠誠値を取得する
    return loyalty.to_i
end


def get_card_type(type_text)
    # カードタイプを取得
    # 印刷面
    element = type_text.split(" ")
    type_ele = element[0].split("の")
    # TODO チェックを入れるかも
    return type_ele[-1]
    # オラクル面
end

def get_sub_type(type_text)
    # サブタイプを取得
    # 印刷面
    element = type_text.split(" ")
    if element.length < 2 then
        # サブタイプを持たない場合
        return None
    end
    sub_ele = element[-1].split("・")
    return sub_ele
    # オラクル面
end

def is_legendary(type_text)
    # 印刷面
    return type_text.include?("伝説の")
    # オラクル面
end

