
# -*- encoding: utf-8 -*-

require "csv"
require "./gatherer_page_parser"
require "./gatherer_card_parser"
require "./gatherer_url"
require "./card_set_name"
require "../utils/nokogiri_utils"

DEBUG=false

def crawl_set_page(set_name)
    # 指定したカードセットのページをファイルに取得する。
    output_dir = "result"
    set_dir = File.join(output_dir, set_name.gsub("\s", "_"))
    if !Dir.exist?(set_dir)
        Dir.mkdir(set_dir)
    end
    card_list = get_card_url_list(set_name, out_dir=set_dir, save=true)
    rng = Random.new
    if DEBUG 
        card_list = card_list[0..1]
    end
    cookie = { 'CardDatabaseSettings' => '1=ja-JP' }
    oracle_dir = File.join(set_dir, 'oracle')
    print_dir = File.join(set_dir, 'print')
    if !Dir.exist?(oracle_dir)
        Dir.mkdir(oracle_dir)
    end
    if !Dir.exist?(print_dir)
        Dir.mkdir(print_dir)
    end
    for card_path in card_list
        if /multiverseid=(\d+)/ =~ card_path
            multiverseid = $1
            oracle_file = "card_#{multiverseid}_oracle.html"
            print_file = "card_#{multiverseid}_print.html"
            detail_url = get_gatherer_page_url(card_path)
            # print(detail_url)
            download_html(detail_url, out_dir=oracle_dir, file_name=oracle_file, cookie=cookie)
            download_html(printed_url(detail_url), out_dir=print_dir, file_name=print_file, cookie=cookie)
            sleep 1+rng.rand
        else
            puts "unexpected URL: #{card_path}"
        end
    end
end

if __FILE__ == $0
    target_set = $1
    target_set = BFZ
    crawl_set_page(target_set)
    puts "Done"
end

