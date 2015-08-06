# -*- encoding: utf-8 -*-

require "csv"
require "gatherer_parser"
require "../utils/nokogiri_utils"

def get_flavour_file(set_name)
    # フレーバーテキスト一覧を取得する。
    page_url = get_page_list(set_name)
    card_list = []
    for page in page_url
        card_url = get_detail_url_list(page)
        card_list.concat(card_url)
    end
    flavor_list = []
    for detail_url in card_list
        oracle_doc = get_html_doc(detail_url)
        print_doc = get_html_doc(detail_url)
        card_data = parse_card(oracle_doc, print_doc)
        flavor_list.push(card_data)
    end
    CSV.open("#{set_name}_flavor.csv", "wb") do |file|
        file << flavor_list
    end
end

if __FILE__ == $0
    get_flavour_file($1)
end

