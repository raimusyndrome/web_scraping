# -*- encoding: utf-8 -*-

require "csv"
require "./gatherer_parser"
require "./gatherer_url"
require "../utils/nokogiri_utils"

def get_flavor_file(set_name)
    # フレーバーテキスト一覧を取得する。
    card_list = get_card_url_list(set_name)
    rng = Random.new
    flavor_list = []
    for card_path in card_list
        detail_url = get_gatherer_page_url(card_path)
        oracle_doc = get_html_doc(detail_url)
        print_doc = get_html_doc(detail_url)
        card_data = parse_card(oracle_doc, print_doc)
        output_data = [card_data[:en][:name], card_data[:ja][:name], card_data[:ja][:flavor]]
        flavor_list.push(output_data)
        sleep 1+rng.rand
    end
    CSV.open("#{set_name}_flavor.csv", "wb") do |file|
        file << flavor_list
    end
end

def get_card_url_list(set_name)
    # 指定したカードセットのURLリストを取得する。
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
    return card_list
end

if __FILE__ == $0
    target_set = $1
    target_set = "Dragons of Tarkir"
    get_flavor_file(target_set)
end

