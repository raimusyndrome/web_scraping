
require "uri"

def is_round_dquote(str)
    return str.length >= 2 && str[0] == '"' && str[-1] =='"'
end

def round_dquote(str)
    strip = str.strip()
    if not is_round_dquote(strip) then
        strip = '"' + strip + '"'
    end
    return strip
end

GATHERER_DOMOIN = "http://gatherer.wizards.com"

def card_set_url(set, page=0)
    # return "http://gatherer.wizards.com/Pages/Search/Default.aspx?page=#{page}&set=[#{round_dquote(URI.escape(set))}]"
    return "http://gatherer.wizards.com/Pages/Search/Default.aspx?page=#{page}&set=[#{URI.escape(round_dquote(set))}]"
end

def card_detail_url(name, id, printed=True)
    return "http://gatherer.wizards.com/Pages/Card/Details.aspx?printed=#{printed}&multiverseid=#{id}&part=#{URI.escape(name)}"
end

def get_gatherer_page_url(page)
    return GATHERER_DOMOIN + page
end

