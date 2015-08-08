# -*- encoding: utf-8 -*-

require "test/unit"
require "../nokogiri_utils"


class TestNokogiri < Test::Unit::TestCase
    def sample_template
        # 入力データ
        # 期待結果
        # テスト実行
        # 結果確認
    end

    def test_get_html_doc
        # 入力データ
        url = 'http://www.yahoo.co.jp/'
        # 期待結果
        ex_title = "Yahoo! JAPAN"
        # テスト実行
        doc = get_html_doc(url)
        # 結果確認
        assert_equal(ex_title, doc.title)
    end
end

