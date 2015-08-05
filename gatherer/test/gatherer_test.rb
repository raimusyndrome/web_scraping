# -*- encoding: utf-8 -*-

require "test/unit"

require "../gatherer_scraping"
require "../../utils/nokogiri_utils"

CARD_LIST_PATH = "page_data/Card\ Search\ -\ Search:\ \"Dragons\ of\ Tarkir\"\ -\ Gatherer\ -\ Magic:\ The\ Gathering.html"
CARD_DETAIL_PATH = "page_data/族樹の精霊、アナフェンザ\ (Dragons\ of\ Tarkir)\ -\ Gatherer\ -\ Magic:\ The\ Gathering.html"

class TestGatherer < Test::Unit::TestCase
    def test_read_all_page_url
        # 入力データ
        # doc = read_html_doc("page_data/Card\ Search\ -\ Search:\ \"Dragons\ of\ Tarkir\"\ -\ Gatherer\ -\ Magic:\ The\ Gathering.html")
        doc = read_html_doc(CARD_LIST_PATH)
        # 期待結果
        ex_page = [
            "http://gatherer.wizards.com/Pages/Search/Default.aspx?page=0&set=%5B%22Dragons%20of%20Tarkir%22%5D",
            "http://gatherer.wizards.com/Pages/Search/Default.aspx?page=1&set=%5B%22Dragons%20of%20Tarkir%22%5D",
            "http://gatherer.wizards.com/Pages/Search/Default.aspx?page=2&set=%5B%22Dragons%20of%20Tarkir%22%5D",
            # "http://gatherer.wizards.com/Pages/Search/Default.aspx?page=1&set=%5B%22Dragons%20of%20Tarkir%22%5D",
        ]
        # テスト実行
        ac_page = get_page_list(doc)
        # 結果確認
        assert_equal(ex_page, ac_page)
    end

    # TODO sub_test_caseを使う
    # sub_test_case "Set list page test" do
        # setup do
            # # セットのページを読み込む
        # end
    # end

    # sub_test_case "Card detail page test" do
        # setup do
            # # カードのページを読み込む
        # end
    # end
end

