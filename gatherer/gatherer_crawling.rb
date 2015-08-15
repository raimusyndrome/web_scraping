
# -*- encoding: utf-8 -*-

require "csv"
require "./gatherer_parser"
require "./gatherer_url"
require "../utils/nokogiri_utils"

DEBUG=true

def crawl_set_page(set_name)
    # 指定したカードセットのページをファイルに取得する。
    output_dir = "result"
    set_dir = File.join(output_dir, set_name.gsub("\s", ""))
    if !Dir.exist?(set_dir)
        Dir.mkdir(set_dir)
    end
    card_list = get_card_url_list(set_name, out_dir=set_dir, save=true)
    rng = Random.new
    if DEBUG 
        card_list = card_list[0..1]
    end
    for card_path in card_list
        if /multiverseid=(\d+)/ =~ card_path
            multiverseid = $1
            oracle_file = "card_#{multiverseid}_oracle.html"
            print_file = "card_#{multiverseid}_print.html"
            detail_url = get_gatherer_page_url(card_path)
            # oracle_doc = get_html_doc(detail_url)
            # print_doc = get_html_doc(printed_url(detail_url))
            # write_html_doc("", oracle_doc)
            # write_html_doc("", print_doc)
            download_html(detail_url, out_dir=set_dir, file_name=oracle_file)
            download_html(printed_url(detail_url), out_dir=set_dir, file_name=print_file)
            sleep 1+rng.rand
        else
            puts "unexpected URL: #{card_path}"
        end
    end
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
        card_list = download_card_page_list(set_name, set_dir, save)
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

if __FILE__ == $0
    target_set = $1
    target_set = "Dragons of Tarkir"
    crawl_set_page(target_set)
    puts "Done"
end

