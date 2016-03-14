# -*- encoding: utf-8 -*-

NORMAL_PREFIX = "ctl00_ctl00_ctl00_MainContent_SubContent_SubContent"
FACE_PREFIX = "ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_ctl02"
BACK_PREFIX = "ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_ctl03"

def parse_card(oracle_doc, print_doc)
    if is_double_face(oracle_doc)
        return parse_double_face_card(oracle_doc, print_doc)
    else
        return parse_simple_card(oracle_doc, print_doc, NORMAL_PREFIX)
    end
end

def parse_double_face_card(oracle_doc, print_doc)
    return parse_simple_card(oracle_doc, print_doc, FACE_PREFIX)
end

def parse_simple_card(oracle_doc, print_doc, id_prefix)
    # カードのデータを解析する
    ## カード共通
    # id_prefix = "ctl00_ctl00_ctl00_MainContent_SubContent_SubContent"
    name = get_text(oracle_doc.css("##{id_prefix}_nameRow").at_css(".value"))
    ja_name = get_text(print_doc.css("##{id_prefix}_nameRow").at_css(".value"))
    # カードタイプとサブタイプを分ける
    ja_type_text = get_text(print_doc.css("##{id_prefix}_typeRow").at_css(".value"))
    ja_card_type = get_card_type(ja_type_text)
    ja_sub_type = get_sub_type(ja_type_text)
    # TODO imgタグをテキスト表記へ
    ja_text = get_long_text(print_doc.css("##{id_prefix}_textRow").css(".cardtextbox"))
    ja_flavor = get_long_text(print_doc.css("##{id_prefix}_flavorRow").css(".flavortextbox"))
    ja_flavor_html = get_html(print_doc.css("##{id_prefix}_flavorRow").at_css(".flavortextbox"))
    # TODO imgタグをテキスト表記へ
    expansion = get_text(oracle_doc.css("##{id_prefix}_setRow").at_css(".value"))
    rarity = get_text(oracle_doc.css("##{id_prefix}_rarityRow").at_css(".value"))

    ## 呪文共通
    # TODO imgタグからテキスト表記へ
    mana_cost = get_text(oracle_doc.css("##{id_prefix}_manaRow").at_css(".value"))
    cmc = get_text(oracle_doc.css("##{id_prefix}_cmcRow").at_css(".value"))

    ## タイプ別
    # TODO カードタイプによって処理を分岐
    # パワータフネスを分解
    power, toughness = get_power_tough(oracle_doc.css("##{id_prefix}_ptRow").at_css(".value"))
    # TODO 両面カードを取得可能に
    # TODO 融合カードを取得可能に
    en_data = {:name => name, :expansion => expansion, :rarity => rarity}
    ja_data = {
        :name => ja_name, :type => ja_card_type, :sub_type => ja_sub_type, 
        :text => ja_text, :flavor => ja_flavor, :flavor_html => ja_flavor_html,
        :expansion => expansion, :rarity => rarity
    }
    return {:en => en_data, :ja => ja_data}
end

def alternative_img(html_text)
    # imgタグを対応するテキストに変換する
end

def get_long_text(div)
    result = ""
    if div
        div.each do |node|
            result += get_text(node)
        end
    end
    return result
end

def get_text(div)
    if div
        # print(div.text.strip, "\n")
        return div.text.strip
    else
        return ""
    end
end

def get_html(div)
    if div
        return div.inner_html.strip
    else
        return ""
    end
end

def get_power_tough(pt_value)
    # パワー、タフネス値を取得する
    if pt_value
        pt_text = get_text(pt_value)
        pt_ele = pt_text.split(/[ \/]/)
        return pt_ele[0].to_i, pt_ele[-1].to_i
    else
        return 0, 0
    end
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
        return nil
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

def is_double_face(doc)
    if doc.css("##{FACE_PREFIX}_nameRow").empty?
        return false
    else
        return true
    end
end

