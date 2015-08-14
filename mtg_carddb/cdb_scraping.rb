# -*- encoding: utf-8 -*-

require "csv"
require "../utils/nokogiri_utils"

module ColNo
    COST = 2

    NAME = 24
    SPTYPE = 6
    TYPE = 7
    SUBTYPE = 8
    TEXT = 26
    FLAVOR = 28

    COLOR = 5
    POWER = 10
    TOUGHNESS = 11
    LOYALTY = 12

    REV_NAME = 32 
    REV_SPTYPE = 16
    REV_TYPE = 17
    REV_SUBTYPE = 18
    REV_TEXT = 34
    REV_COLOR = 15
    REV_POWER = 20
    REV_TOUGHNESS = 21
    REV_LOYALTY = 22

    EN_NAME = 23
    EN_TEXT = 25
    EN_FLAVOR = 27

    CARDNO = 30
    CARDSET = 40
    RARITY = 41

    PRINTNUM = 44
end

def get_csv_data(doc)
    return doc.css(".solid1 > td").text
end

def parse_flavor(csv_str, set_code)
    card_list = []
    CSV.parse(csv_str) do |row|
        # print(row)
        if row[ColNo::CARDSET] != set_code
            # print(row)
            next
        end
        card = {
            :ja_name => row[ColNo::NAME],
            :en_name => row[ColNo::EN_NAME],
            :flavor => row[ColNo::FLAVOR],
        }
        card_list.push(card)
    end
    return card_list
end

def output_csv(out_file, flavor)
    CSV.open(out_file, "wb") do |csv|
        flavor.each do |item|
            csv << [item[:ja_name], item[:en_name], item[:flavor]]
        end
    end
end

def gen_flavor_list(input_file, output_file, set_code)
    doc = read_html_doc(input_file)
    # print(doc.title)
    csv_str = get_csv_data(doc)
    # print(csv_str)
    # open("csv_str.tmp", "wb") do |f|
        # f << csv_str
    # end
    card_list = parse_flavor(csv_str, set_code)
    output_csv(output_file, card_list)
end


if __FILE__ == $0
    in_file = $1
    out_file = $2
    set_code = "DTK"
    # set_code = "ORI"
    in_file = "page_data/MTG_#{set_code}_CardSearchDatabase.html"
    out_file = "flavor/MTG_#{set_code}_flavor_list.csv"
    gen_flavor_list(in_file, out_file, set_code)
end

