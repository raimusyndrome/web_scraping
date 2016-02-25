# -*- encoding: utf-8 -*-

require "csv"
require "./gatherer_page_parser"
require "./gatherer_card_parser"
require "./gatherer_url"
require "../utils/nokogiri_utils"

DEBUG=true

def get_flavor_file(set_name)
    # フレーバーテキスト一覧を取得する。
    set_file = set_name.gsub("\s", "_")
    card_list = get_card_url_list(set_name, out_dir="result/#{set_file}")
    rng = Random.new
    flavor_list = []
    if DEBUG 
        card_list = card_list[0..10]
    end
    print(card_list, "\n")
    cookie = { 'CardDatabaseSettings' => '1=ja-JP' }
    for card_path in card_list
        detail_url = get_gatherer_page_url(card_path)
        oracle_doc = get_html_doc(detail_url, cookie)
        print_doc = get_html_doc(printed_url(detail_url))
        card_data = parse_card(oracle_doc, print_doc)
        output_data = [card_data[:en][:name], card_data[:ja][:name], card_data[:ja][:flavor]]
        flavor_list.push(output_data)
        sleep 1+rng.rand
    end
    output_dir = "flavor"
    set_dir = File.join(output_dir, set_file)
    if !Dir.exist?(set_dir)
        Dir.mkdir(set_dir)
    end
    output_file = File.join(set_dir,"#{set_file}_flavor.csv")
    CSV.open(output_file, "w") do |file|
        file << flavor_list
    end
end

if __FILE__ == $0
    target_set = $1
    target_set = "Dragons of Tarkir"
    get_flavor_file(target_set)
    puts("Done")
end

