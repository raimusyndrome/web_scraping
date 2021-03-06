# -*- encoding: utf-8 -*-

require "test/unit"

require "./gatherer_parser"
require "./gatherer_scraping"
require "./../utils/nokogiri_utils"

base_dir = "./test/"
CARD_LIST_PATH = base_dir + "page_data/CardSearch.html"
CARD_DETAIL_PATH = base_dir + "page_data/legendary_multi_sub_type_flavored_creature.html"

class TestGatherer < Test::Unit::TestCase
    def sample_template
        # 入力データ
        # 期待結果
        # テスト実行
        # 結果確認
    end

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

    def test_read_detail_url_list
        # 入力データ
        doc = read_html_doc(CARD_LIST_PATH)
        # 期待結果
        ex_len = 100
        ex_list = []
        # テスト実行
        ac_list = get_detail_url_list(doc)
        # 結果確認
        assert_equal(ex_len, ac_list.length)
        # assert_equal(ex_list, ac_list)
    end


    def test_get_pt 
        # 入力データ
        pt_value = "2 / 2"
        # 期待結果
        ex_power = 2
        ex_tough = 2
        # テスト実行
        ac_power, ac_tough = get_power_tough(pt_value)
        # 結果確認
        assert_equal(ex_power, ac_power)
        assert_equal(ex_tough, ac_tough)
    end

    def test_get_card_type 
        # 入力データ
        type_text = "クリーチャー ― - ドラゴン"
        # 期待結果
        ex_type = "クリーチャー"
        # テスト実行
        ac_type = get_card_type(type_text)
        # 結果確認
        assert_equal(ex_type, ac_type)
    end

    def test_get_legendary_card_type 
        # 入力データ
        type_text = "伝説のクリーチャー ― - スピリット・兵士"
        # 期待結果
        ex_type = "クリーチャー"
        # テスト実行
        ac_type = get_card_type(type_text)
        # 結果確認
        assert_equal(ex_type, ac_type)
    end

    def test_get_simple_sub_type 
        # 入力データ
        type_text = "クリーチャー ― - ドラゴン"
        # 期待結果
        ex_type = ["ドラゴン"]
        # テスト実行
        ac_type = get_sub_type(type_text)
        # 結果確認
        assert_equal(ex_type, ac_type)
    end

    def test_get_multi_sub_type
        # 入力データ
        type_text = "伝説のクリーチャー ― - スピリット・兵士"
        # 期待結果
        ex_type = ["スピリット", "兵士"]
        # テスト実行
        ac_type = get_sub_type(type_text)
        # 結果確認
        assert_equal(ex_type, ac_type)
    end

    def test_is_legendary
        # 入力データ
        type_text = "伝説のクリーチャー ― - スピリット・兵士"
        # 期待結果
        ex_result = true
        # テスト実行
        ac_result = is_legendary(type_text)
        # 結果確認
        assert_equal(ex_result, ac_result)
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

