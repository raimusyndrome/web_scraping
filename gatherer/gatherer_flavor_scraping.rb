# -*- encoding: utf-8 -*-

require "csv"
require "./gatherer_page_parser"
require "./gatherer_card_parser"
require "./gatherer_url"
require "../utils/nokogiri_utils"

DEBUG=false


def get_flavor_file(set_name)
    # フレーバーテキスト一覧を取得する。
    set_file = set_name.gsub("\s", "_")
    set_dir = File.join("result", set_file)
    card_list = get_card_url_list(set_name, out_dir=set_dir)
    rng = Random.new
    flavor_list = []
    if DEBUG 
        card_list = card_list[0..10]
    end
    # print(card_list, "\n")
    # cookie = { 'CardDatabaseSettings' => '1=ja-JP' }
    for card_path in card_list
        detail_url = get_gatherer_page_url(card_path)
        # oracle_doc = get_html_doc(detail_url, cookie)
        # print_doc = get_html_doc(printed_url(detail_url))
        # card_data = parse_card(oracle_doc, print_doc)
        doc = get_detail_card_page(detail_url, out_dir=set_dir, save=false)
        card_data = parse_card(doc[:oracle], doc[:print])
        output_data = [card_data[:en][:name], card_data[:ja][:name], card_data[:ja][:flavor]]
        flavor_list.push(output_data)
        # print(card_data[:ja][:name], "\n")
        # print(card_data, "\n")
        # print(output_data, "\n")
        # sleep 1+rng.rand
    end
    output_dir = "flavor"
    result_dir = File.join(output_dir, set_file)
    if !Dir.exist?(result_dir)
        Dir.mkdir(result_dir)
    end
    output_file = File.join(result_dir,"#{set_file}_flavor.csv")
    CSV.open(output_file, "wb:UTF-8") do |file|
        # file << flavor_list
        flavor_list.each do |line|
            file << line
        end
    end
end

if __FILE__ == $0
    target_set = $1
    # target_set = "Dragons of Tarkir"
    target_set = "Magic Origins"
    get_flavor_file(target_set)
    puts("Done")
end

